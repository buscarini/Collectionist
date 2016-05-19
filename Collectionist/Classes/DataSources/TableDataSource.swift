//
//  TableDataSource.swift
//  OnePodcast
//
//  Created by Jose Manuel Sánchez Peñarroja on 23/10/15.
//  Copyright © 2015 vitaminew. All rights reserved.
//

import UIKit

import Miscel

public class TableDataSource<T:Equatable> : NSObject, UITableViewDataSource, UITableViewDelegate
	{
	
	public typealias ListType = List<T>
	public typealias ListSectionType = ListSection<T>
	public typealias ListItemType = ListItem<T>

	private var estimatedHeights : [NSIndexPath: CGFloat] = [:]
	private var heights : [NSIndexPath: CGFloat] = [:]
	
	public var viewDidScroll : (() -> ())? = nil
	
	private lazy var updateQueue: dispatch_queue_t = dispatch_queue_create("TableDataSource update queue", DISPATCH_QUEUE_SERIAL)
	
	public override init() {
		super.init()
	}
	
	public var view : UITableView? {
		didSet {
			view?.dataSource = self
			view?.delegate = self
			
			view?.rowHeight = UITableViewAutomaticDimension
			view?.estimatedRowHeight = 44
			
			TableDataSource.registerViews(self.list,tableView: self.view)
		}
	}
	
	public var list : ListType? {
		didSet {
			TableDataSource.registerViews(self.list,tableView: self.view)
			self.update(oldValue, newList: list)
		}
	}
	
	// Call this when the table view frame changes
	public func invalidateLayout() {
		self.estimatedHeights = [:]
		self.heights = [:]
		self.view?.reloadData()
	}
	
//	 Reload the view without refreshing the data. This should only be used if the data hasn't changed
	private func reloadViewLayout() {
		self.view?.beginUpdates()
		self.view?.endUpdates()
//		self.view?.reloadData()
	}
	
	private func update(oldList: ListType?, newList: ListType?) {
//		self.view?.reloadData()
		self.updateView(oldList, newList: newList)
		
		dispatch_async(dispatch_get_main_queue()) {
			if let scrollInfo = newList?.scrollInfo, let indexPath = scrollInfo.indexPath {
				self.view?.scrollToRowAtIndexPath(indexPath, atScrollPosition: TableDataSource.scrollPositionWithPosition(scrollInfo.position), animated: scrollInfo.animated)
			}
		}
	}
	
	private func updateView(oldList: List<T>?, newList: List<T>?) {
		guard let view = self.view else {
			return
		}

//		view.reloadData()
//		return
		
//		dispatch_async(dispatch_get_main_queue()) {
//			view.reloadData()
//			self.heights.removeAll()
//		}
//		return
		
//		dispatch_async(dispatch_get_main_queue()) {
			if let tableConfig = newList?.configuration as? TableConfiguration, let fixedHeight = tableConfig.fixedRowHeight {
				view.rowHeight = fixedHeight
			}
			else {
				view.rowHeight = UITableViewAutomaticDimension
			}
//		}

		let visibleIndexPaths = view.indexPathsForVisibleRows
		
		dispatch_async(self.updateQueue) {
			if	let oldList = oldList, let newList = newList where List<T>.sameItemsCount(oldList,list2: newList) {
				
				let changedIndexPaths = List<T>.itemsChangedPaths(oldList,list2: newList).filter {
					indexPath in
					return visibleIndexPaths?.contains(indexPath) ?? true
				}
				
				if changedIndexPaths.count>0 {
					dispatch_async(dispatch_get_main_queue()) {

						self.heights = TableDataSource.updateIndexPathsWithFill(newList, view: view, indexPaths: changedIndexPaths, cellHeights: self.heights)
						
//						if let currentList = self.list where currentList == newList {
						if self.list == newList {
							self.reloadViewLayout()
						}
//						else {
//							self.heights.removeAll()
//							view.reloadData()
//						}
					}
				}
			}
			else {
				dispatch_async(dispatch_get_main_queue()) {
					self.heights.removeAll()
					view.reloadData()
				}
			}
		}
	}
	
	static func readCellHeights(view: UITableView, heights: [NSIndexPath : CGFloat]) -> [NSIndexPath : CGFloat]? {
		
		guard let visibleIndexPaths = view.indexPathsForVisibleRows else { return nil }
		
		var result = heights
		for indexPath in visibleIndexPaths {
			if let cell = view.cellForRowAtIndexPath(indexPath) {
				result[indexPath] = cell.frame.size.height
			}
		}
		
		return result
	}
	
	static func updateIndexPathsWithFill(newList: List<T>,view : UITableView, indexPaths: [NSIndexPath], cellHeights : [NSIndexPath: CGFloat]) -> [NSIndexPath: CGFloat] {
		var finalCellHeights = cellHeights
		for indexPath in indexPaths {
			guard let tableCell = view.cellForRowAtIndexPath(indexPath) else {
				continue
			}
			
			guard let cell = tableCell as? Fillable else {
				continue
			}

			if let item = List<T>.itemAt(newList, indexPath: indexPath) {
				cell.fill(item)
			}

			finalCellHeights[indexPath] = nil
		}
		
		return finalCellHeights
	}
	
	static func updateIndexPathsWithFillAndReload(newList: List<T>, view : UITableView, indexPaths: [NSIndexPath], cellHeights : [NSIndexPath: CGFloat]) -> [NSIndexPath: CGFloat] {
		let (editingPaths, nonEditingPaths) = self.editingIndexPaths(newList, view: view, indexPaths: indexPaths)
		for (indexPath, cell) in editingPaths {
			if let cell = cell as? Fillable {
				if let item = List<T>.itemAt(newList, indexPath: indexPath) {
					cell.fill(item)
				}
			}
		}

		view.reloadRowsAtIndexPaths(nonEditingPaths, withRowAnimation: .None)
		
		return cellHeights
	}
	
	static func editingIndexPaths(newList: List<T>,view : UITableView, indexPaths: [NSIndexPath]) -> (editing: [(NSIndexPath,UITableViewCell?)], nonEditing: [NSIndexPath]) {
	
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
	
	static func registerViews(list: ListType?, tableView : UITableView?) {
		guard let list = list else { return }
		guard let tableView = tableView else { return }
		
		let allCellIds = List.allCellIds(list)
		
		for cellId in allCellIds {
			tableView.registerClass(TableViewCell<T>.self, forCellReuseIdentifier: cellId)
		}
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

		guard let listItem = List<T>.itemAt(list, indexPath: indexPath) else {
			fatalError("Index out of bounds. This shouldn't happen")
		}
		
		return tableView.dequeueReusableCellWithIdentifier(listItem.cellId ?? listItem.nibName, forIndexPath: indexPath)
	}
	
	
	func configureCell(cell: UITableViewCell,listItem: ListItemType, indexPath : NSIndexPath) {
		if let fillableCell = cell as? Fillable {
			fillableCell.fill(listItem)
		}
		
		if let configuration = listItem.configuration as? TableListItemConfiguration<T> {
			cell.accessoryType = configuration.accessoryType
			
			cell.indentationLevel = configuration.indentationLevel
			cell.indentationWidth ?= configuration.indentationWidth
			
			#if os(iOS)
			if let inset = configuration.separatorInset {
				cell.separatorInset = inset
			}
			#endif
		}
	}
	
	// MARK: UITableViewDelegate
	public func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return self.estimatedHeights[indexPath] ?? tableView.estimatedRowHeight
	}
	
	public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return self.heights[indexPath] ?? UITableViewAutomaticDimension
	}
	
	public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
	
		guard let list = self.list else {
			return
		}

		guard let listItem = List<T>.itemAt(list, indexPath: indexPath) else {
			return
		}
		
		self.configureCell(cell, listItem: listItem, indexPath: indexPath)
		
		self.estimatedHeights[indexPath] = cell.frame.size.height
		self.heights[indexPath] = cell.frame.size.height
	}
	
	@available(iOS 9.0, *)
	public func tableView(tableView: UITableView, didUpdateFocusInContext context: UITableViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
		guard let list = self.list else { return }
		guard let indexPath = context.nextFocusedIndexPath else { return }
		
		let listItem = ListType.itemAt(list, indexPath: indexPath)
//		context.nextFocusedIndexPath
		_ = listItem.map { $0.onFocus?($0) }
	}
	
	public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		// TODO: Move this to a different place
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		
		guard let list = self.list else {
			return
		}
		
		let listItem = ListType.itemAt(list, indexPath: indexPath)
		_ = listItem.map { $0.onSelect?($0) }
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
		
		guard List<T>.indexPathInsideBounds(list, indexPath: indexPath) else {
			defer {
				self.view?.reloadData()
			}
			
			return []
		}
		
		let listItem = list.sections[indexPath.section].items[indexPath.row]
		
		return listItem.swipeActions.map {
			action in
			return TableDataSource.rowAction(tableView,item: listItem, action: action)
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

