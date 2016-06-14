//
//  TableDataSource.swift
//  OnePodcast
//
//  Created by Jose Manuel Sánchez Peñarroja on 23/10/15.
//  Copyright © 2015 vitaminew. All rights reserved.
//

import UIKit

import Miscel

public class TableViewDataSource<T:Equatable,HeaderT : Equatable, FooterT : Equatable> : NSObject, UITableViewDataSource, UITableViewDelegate
	{
	
	public typealias ListType = List<T,HeaderT, FooterT>
	public typealias ListSectionType = ListSection<T,HeaderT, FooterT>
	public typealias ListItemType = ListItem<T>

	private var estimatedHeights : [NSIndexPath: CGFloat] = [:]
	private var heights : [NSIndexPath: CGFloat] = [:]
	
	private var refreshControl: UIRefreshControl?

	public var viewDidScroll : (() -> ())? = nil
	
	private lazy var updateQueue: dispatch_queue_t = dispatch_queue_create("TableDataSource update queue", DISPATCH_QUEUE_SERIAL)
	
	public init(view: UITableView) {
		self.view = view
		
		self.refreshControl = UIRefreshControl()
	
		super.init()
		
		self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
		self.viewChanged()
	}
	
	public var view : UITableView {
		didSet {
			self.viewChanged()
		}
	}
	
	public var list : ListType? {
		didSet {
			TableViewDataSource.registerViews(self.list,tableView: self.view)
			self.update(oldValue, newList: list)
		}
	}
	
	private func viewChanged() {
		TableViewDataSource.registerViews(self.list,tableView: self.view)
			
		self.view.dataSource = self
		self.view.delegate = self
			
		self.view.rowHeight = UITableViewAutomaticDimension
		self.view.estimatedRowHeight = 44
		
		self.view.sectionHeaderHeight = UITableViewAutomaticDimension
		self.view.estimatedSectionHeaderHeight = 44
		self.view.sectionFooterHeight = UITableViewAutomaticDimension
		self.view.estimatedSectionFooterHeight = 44
	}
	
	// Call this when the table view frame changes
	public func invalidateLayout() {
		self.estimatedHeights = [:]
		self.heights = [:]
		self.view.reloadData()
	}
	
//	 Reload the view without refreshing the data. This should only be used if the data hasn't changed
	private func reloadViewLayout() {
		self.view.beginUpdates()
		self.view.endUpdates()
//		self.view?.reloadData()
	}
	
	private func update(oldList: ListType?, newList: ListType?) {
		self.updateSections(oldList, newList: newList) {
			self.updateHeaderFooter(newList)
			self.updateScroll(newList)
			self.updatePullToRefresh(newList)
		}
	}
	
	private func updateSections(oldList: ListType?, newList: ListType?, completion: (() -> ())?) {
		view.rowHeight = UITableViewAutomaticDimension
	
		dispatch_async(self.updateQueue) {
			if	let oldList = oldList, let newList = newList where ListType.sameItemsCount(oldList,list2: newList) {
				
				let visibleIndexPaths = self.view.indexPathsForVisibleRows
				let changedIndexPaths = ListType.itemsChangedPaths(oldList,list2: newList).filter {
					indexPath in
					return visibleIndexPaths?.contains(indexPath) ?? true
				}
				
				if changedIndexPaths.count>0 {
					dispatch_async(dispatch_get_main_queue()) {

						self.heights = TableViewDataSource.updateIndexPathsWithFill(newList, view: self.view, indexPaths: changedIndexPaths, cellHeights: self.heights)


						if let currentList = self.list where currentList == newList {
							self.view.beginUpdates()
							self.view.endUpdates()
							completion?()
						}
						else {
							self.view.reloadData()
							completion?()
						}
					}
				}
				else {
					dispatch_async(dispatch_get_main_queue()) {
						completion?()
					}
				}
			}
			else {
				dispatch_async(dispatch_get_main_queue()) {
					self.view.reloadData()
					self.heights.removeAll()
					completion?()
				}
			}
		}
	}
	
	private func updateHeaderFooter(newList: ListType?) {
		let headerView = newList?.header?.createView(self)
		headerView?.frame.size = headerView?.size(self.view.bounds.size.width) ?? CGSizeZero
		self.view.tableHeaderView = headerView
		
		let footerView = newList?.footer?.createView(self)
		footerView?.frame.size = footerView?.size(self.view.bounds.size.width) ?? CGSize(width: 1, height: 1)
		self.view.tableFooterView = footerView ?? UIView()
	}
	
	private func updateScroll(newList: ListType?) {
		if let scrollInfo = newList?.scrollInfo, let indexPath = scrollInfo.indexPath {
			self.view.scrollToRowAtIndexPath(indexPath, atScrollPosition: TableViewDataSource.scrollPositionWithPosition(scrollInfo.position), animated: scrollInfo.animated)
		}
	}
	
	private func updatePullToRefresh(newList: ListType?) {
		self.refreshControl?.endRefreshing()
		if let refreshControl = self.refreshControl where newList?.configuration?.onRefresh != nil {
			self.view.addSubview(refreshControl)
		}
		else {
			self.refreshControl?.removeFromSuperview()
		}
	}
	
	public static func readCellHeights(view: UITableView, heights: [NSIndexPath : CGFloat]) -> [NSIndexPath : CGFloat]? {
		
		guard let visibleIndexPaths = view.indexPathsForVisibleRows else { return nil }
		
		var result = heights
		for indexPath in visibleIndexPaths {
			if let cell = view.cellForRowAtIndexPath(indexPath) {
				result[indexPath] = cell.frame.size.height
			}
		}
		
		return result
	}
	
	public static func updateIndexPathsWithFill(newList: ListType,view : UITableView, indexPaths: [NSIndexPath], cellHeights : [NSIndexPath: CGFloat]) -> [NSIndexPath: CGFloat] {
		var finalCellHeights = cellHeights
		for indexPath in indexPaths {
			guard let tableCell = view.cellForRowAtIndexPath(indexPath) else {
				continue
			}
			
			guard let cell = tableCell as? Fillable else {
				continue
			}

			if let item = ListType.itemAt(newList, indexPath: indexPath) {
				cell.fill(item)
			}

			finalCellHeights[indexPath] = nil
		}
		
		return finalCellHeights
	}
	
	public static func updateIndexPathsWithFillAndReload(newList: ListType, view : UITableView, indexPaths: [NSIndexPath], cellHeights : [NSIndexPath: CGFloat]) -> [NSIndexPath: CGFloat] {
		let (editingPaths, nonEditingPaths) = self.editingIndexPaths(newList, view: view, indexPaths: indexPaths)
		for (indexPath, cell) in editingPaths {
			if let cell = cell as? Fillable {
				if let item = ListType.itemAt(newList, indexPath: indexPath) {
					cell.fill(item)
				}
			}
		}

		view.reloadRowsAtIndexPaths(nonEditingPaths, withRowAnimation: .None)
		
		return cellHeights
	}

	
	public static func editingIndexPaths(newList: ListType,view : UITableView, indexPaths: [NSIndexPath]) -> (editing: [(NSIndexPath,UITableViewCell?)], nonEditing: [NSIndexPath]) {
	
		let editingPaths = indexPaths.map {
							indexPath -> (NSIndexPath, UITableViewCell?) in
							let cell = view.cellForRowAtIndexPath(indexPath)
							return (indexPath,cell)
						}.filter {
							(indexPath, cell) in
							return cell?.editing ?? false
						}
						
		let nonEditingPaths = indexPaths.filter {
			indexPath in
			let cell = view.cellForRowAtIndexPath(indexPath)
			return !(cell?.editing ?? false)
		}

		return (editing: editingPaths, nonEditing: nonEditingPaths)
	}
	
	static func scrollPositionWithPosition(position: ListScrollPosition) -> UITableViewScrollPosition {
		switch (position) {
		case (.Begin):
			return .Top
		case (.Middle):
			return .Middle
		case (.End):
			return .Bottom
		}
	}
	
	
	public static func registerViews(list: ListType?, tableView : UITableView?) {
		guard let list = list else { return }
		guard let tableView = tableView else { return }
		
		let allReusableIds = List.allReusableIds(list)
		for reusableId in allReusableIds {
			tableView.registerClass(TableViewCell<T>.self, forCellReuseIdentifier: reusableId)
		}
	}
	
	// MARK: Pull to Refresh
	func refresh(sender: AnyObject?) {
		guard let list = self.list else { return }
		guard let configuration = list.configuration else { return }
		
		configuration.onRefresh?()
	}
	
	// MARK: UITableViewDataSource
	public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return list?.sections.count ?? 0
	}
	
	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let list = self.list else {
			return 0
		}
		
		return list.sections[section].items.count
	}
	
	public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		guard let list = self.list else {
			fatalError("List is required. We shouldn't be here")
		}

		guard let listItem = ListType.itemAt(list, indexPath: indexPath) else {
			fatalError("Index out of bounds. This shouldn't happen")
		}
		
		let reusableId = listItem.reusableId ?? listItem.nibName
		let cell = tableView.dequeueReusableCellWithIdentifier(reusableId, forIndexPath: indexPath)
		
		self.configureCell(cell, listItem: listItem, indexPath: indexPath)
		
		return cell
	}
	
	public func configureCell(cell: UITableViewCell,listItem: ListItemType, indexPath : NSIndexPath) {
		if let fillableCell = cell as? Fillable {
			fillableCell.fill(listItem)
		}
		
		if let configuration = listItem.configuration as? TableListItemConfiguration<T> {
			cell.accessoryType = configuration.accessoryType
			
			cell.indentationLevel ?= configuration.indentationLevel
			cell.indentationWidth ?= configuration.indentationWidth

			#if os(iOS)
			cell.separatorInset ?= configuration.separatorInset
			#endif
		}
	}
	
	public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let list = self.list else { return nil }
		guard ListType.sectionInsideBounds(list, section: section) else { return nil }
		
		return list.sections[section].header?.createView(self)
	}
	
	public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		guard let list = self.list else { return nil }
		guard ListType.sectionInsideBounds(list, section: section) else { return nil }

		return list.sections[section].footer?.createView(self)
	}
	
	// MARK: UITableViewDelegate
	public func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if let tableConfiguration = self.list?.configuration as? TableListConfiguration, fixedHeight = tableConfiguration.fixedRowHeight {
			return fixedHeight
		}
		return self.estimatedHeights[indexPath] ?? tableView.estimatedRowHeight
	}
	
	public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if let tableConfiguration = self.list?.configuration as? TableListConfiguration, fixedHeight = tableConfiguration.fixedRowHeight {
			return fixedHeight
		}
		return self.heights[indexPath] ?? UITableViewAutomaticDimension
	}
	
	public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		guard let list = self.list else { return 0 }
		guard ListType.sectionInsideBounds(list, section: section) else { return 0 }

		guard let footer = list.sections[section].header else { return 0 }

		return UITableViewAutomaticDimension
	}
	
	public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		guard let list = self.list else { return 0 }
		guard ListType.sectionInsideBounds(list, section: section) else { return 0 }

		guard let footer = list.sections[section].footer else { return 0 }

		return UITableViewAutomaticDimension
	}
	
	public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		self.estimatedHeights[indexPath] = cell.frame.size.height
		self.heights[indexPath] = cell.frame.size.height
	}
	
	@available(iOS 9.0, *)
	public func tableView(tableView: UITableView, didUpdateFocusInContext context: UITableViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
		guard let list = self.list else { return }
		guard let indexPath = context.nextFocusedIndexPath else { return }
		
		let listItem = ListType.itemAt(list, indexPath: indexPath)
		_ = listItem.map { $0.onFocus?($0) }
	}
	
	public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		// TODO: Move this to a different place
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		
		guard let list = self.list else {
			return
		}
		
		let listItem = list.sections[indexPath.section].items[indexPath.row]
		if let onSelect = listItem.onSelect {
			onSelect(listItem)
		}
	}

	
	public func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
		guard let list = self.list else {
			return
		}
		
		let listItem = ListType.itemAt(list, indexPath: indexPath)
		if let configuration = listItem?.configuration as? TableListItemConfiguration<T>,
			let onAccessoryTap = configuration.onAccessoryTap {
			if let listItem = listItem {
				onAccessoryTap(listItem)
			}
		}
	}
	
	public func scrollViewDidScroll(scrollView: UIScrollView) {
		self.viewDidScroll?()
	}
	
	#if os(iOS)
	public func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
		guard let list = self.list else {
			return []
		}
		
		guard ListType.indexPathInsideBounds(list, indexPath: indexPath) else {
			defer {
				self.view.reloadData()
			}
			
			return []
		}
		
		let listItem = list.sections[indexPath.section].items[indexPath.row]
		
		return listItem.swipeActions.map {
			action in
			return TableViewDataSource.rowAction(tableView,item: listItem, action: action)
		}
	}
	
	static func rowAction(tableView: UITableView, item: ListItemType, action: ListItemAction<T>) -> UITableViewRowAction {
		let rowAction = UITableViewRowAction(style: self.rowStyle(action.style), title: action.title) { _,_ in
			action.action(item)
			tableView.setEditing(false, animated: true)
		}
		rowAction.backgroundColor = action.tintColor
		return rowAction
	}
	
	static func rowStyle(style : ListItemActionStyle) -> UITableViewRowActionStyle {
		switch style {
		case .Default:
			return .Default
		case .Normal:
			return .Normal
		}
	}
	#endif
}

