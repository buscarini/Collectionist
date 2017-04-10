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

	private var estimatedHeights : [IndexPath: CGFloat] = [:]
	private var heights : [IndexPath: CGFloat] = [:]
	
	fileprivate var refreshControl: UIRefreshControl?

	public var viewDidScroll : (() -> ())? = nil
	
	private lazy var updateQueue: DispatchQueue = DispatchQueue(label: "TableDataSource update queue")
	
	public init(view: UITableView) {
		self.view = view
		
		self.refreshControl = UIRefreshControl()
	
		super.init()
		
		self.refreshControl?.addTarget(self, action: #selector(TableViewDataSource.refresh), for: .valueChanged)
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
	
	private func update(_ oldList: ListType?, newList: ListType?) {
		self.updateSections(oldList, newList: newList) {
			self.updateHeaderFooter(newList)
			self.updateScroll(newList)
			self.updatePullToRefresh(newList)
		}
	}
	
	private func updateSections(_ oldList: ListType?, newList: ListType?, completion: (() -> ())?) {
		view.rowHeight = UITableViewAutomaticDimension
	
		self.updateQueue.async {
//		dispatch_async(self.updateQueue) {
			if	let oldList = oldList, let newList = newList , ListType.sameItemsCount(oldList, newList) {
				
				let visibleIndexPaths = self.view.indexPathsForVisibleRows
				let changedIndexPaths = ListType.itemsChangedPaths(oldList, newList).filter {
					indexPath in
					return visibleIndexPaths?.contains(indexPath as IndexPath) ?? true
				}
				
				DispatchQueue.main.async {
					defer { completion?() }
					
					if changedIndexPaths.count>0 {
						self.heights = TableViewDataSource.updateIndexPathsWithFill(newList, view: self.view, indexPaths: changedIndexPaths, cellHeights: self.heights)

						if let currentList = self.list , currentList == newList {
							if #available(iOS 10.0, *) {
								self.view.beginUpdates()
								self.view.reloadRows(at: changedIndexPaths, with: .none)
								self.view.endUpdates()
							}
							else {
								self.view.reloadData()
							}
						}
						else {
							self.view.reloadData()
						}
					
					}
					else if List.headersChanged(oldList, newList) {
						self.view.reloadData()
					}
					else {
					}
				}
			}
			else {
				DispatchQueue.main.async {
					self.view.reloadData()
					self.heights.removeAll()
					completion?()
				}
			}
		}
	}
	
	private func updateHeaderFooter(_ newList: ListType?) {
		let headerView = newList?.header?.createView(self)
		headerView?.frame.size = headerView?.size(forWidth: self.view.bounds.size.width) ?? CGSize.zero
		self.view.tableHeaderView = headerView
		
		let footerView = newList?.footer?.createView(self)
		footerView?.frame.size = footerView?.size(forWidth: self.view.bounds.size.width) ?? CGSize(width: 1, height: 1)
		self.view.tableFooterView = footerView ?? UIView()
	}
	
	private func updateScroll(_ newList: ListType?) {
		if let scrollInfo = newList?.scrollInfo {
			let indexPath = scrollInfo.indexPath
			self.view.scrollToRow(at: indexPath, at: TableViewDataSource.scrollPositionWithPosition(scrollInfo.position), animated: scrollInfo.animated)
		}
	}
	
	private func updatePullToRefresh(_ newList: ListType?) {
		self.refreshControl?.endRefreshing()
		if let refreshControl = self.refreshControl , newList?.configuration?.onRefresh != nil {
			self.view.addSubview(refreshControl)
		}
		else {
			self.refreshControl?.removeFromSuperview()
		}
	}
	
	public static func readCellHeights(_ view: UITableView, heights: [IndexPath : CGFloat]) -> [IndexPath : CGFloat]? {
		
		guard let visibleIndexPaths = view.indexPathsForVisibleRows else { return nil }
		
		var result = heights
		for indexPath in visibleIndexPaths {
			if let cell = view.cellForRow(at: indexPath) {
				result[indexPath] = cell.frame.size.height
			}
		}
		
		return result
	}
	
	public static func updateIndexPathsWithFill(_ newList: ListType,view : UITableView, indexPaths: [IndexPath], cellHeights : [IndexPath: CGFloat]) -> [IndexPath: CGFloat] {
		var finalCellHeights = cellHeights
		for indexPath in indexPaths {
			guard let tableCell = view.cellForRow(at: indexPath as IndexPath) else {
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
	
	public static func updateIndexPathsWithFillAndReload(_ newList: ListType, view : UITableView, indexPaths: [IndexPath], cellHeights : [IndexPath: CGFloat]) -> [IndexPath: CGFloat] {
		let (editingPaths, nonEditingPaths) = self.editingIndexPaths(newList, view: view, indexPaths: indexPaths)
		for (indexPath, cell) in editingPaths {
			if let cell = cell as? Fillable {
				if let item = ListType.itemAt(newList, indexPath: indexPath) {
					cell.fill(item)
				}
			}
		}

		view.reloadRows(at: nonEditingPaths, with: .none)
		
		return cellHeights
	}

	
	public static func editingIndexPaths(_ newList: ListType,view : UITableView, indexPaths: [IndexPath]) -> (editing: [(IndexPath,UITableViewCell?)], nonEditing: [IndexPath]) {
	
		let editingPaths = indexPaths.map {
							indexPath -> (IndexPath, UITableViewCell?) in
							let cell = view.cellForRow(at: indexPath)
							return (indexPath,cell)
						}.filter {
							(indexPath, cell) in
							return cell?.isEditing ?? false
						}
						
		let nonEditingPaths = indexPaths.filter {
			indexPath in
			let cell = view.cellForRow(at: indexPath)
			return !(cell?.isEditing ?? false)
		}

		return (editing: editingPaths, nonEditing: nonEditingPaths)
	}
	
	static func scrollPositionWithPosition(_ position: ListScrollPosition) -> UITableViewScrollPosition {
		switch (position) {
		case (.begin):
			return .top
		case (.middle):
			return .middle
		case (.end):
			return .bottom
		}
	}
	
	
	public static func registerViews(_ list: ListType?, tableView : UITableView?) {
		guard let list = list else { return }
		guard let tableView = tableView else { return }
		
		let allReusableIds = List.allReusableIds(list)
		for reusableId in allReusableIds {
			tableView.register(TableViewCell<T>.self, forCellReuseIdentifier: reusableId)
		}
	}
	
	// MARK: Pull to Refresh
	@objc func refresh(_ sender: AnyObject?) {
		guard let list = self.list else { return }
		guard let configuration = list.configuration else { return }
		
		configuration.onRefresh?()
	}
	
	// MARK: UITableViewDataSource
	public func numberOfSections(in tableView: UITableView) -> Int {
		return list?.sections.count ?? 0
	}
	
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let list = self.list else {
			return 0
		}
		
		return list.sections[section].items.count
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let list = self.list else {
			fatalError("List is required. We shouldn't be here")
		}

		guard let listItem = ListType.itemAt(list, indexPath: indexPath) else {
			fatalError("Index out of bounds. This shouldn't happen")
		}
		
		let reusableId = listItem.reusableId ?? listItem.nibName
		let cell = tableView.dequeueReusableCell(withIdentifier: reusableId, for: indexPath)
		
		self.configureCell(cell, listItem: listItem, indexPath: indexPath)
		
		return cell
	}
	
	public func configureCell(_ cell: UITableViewCell,listItem: ListItemType, indexPath : IndexPath) {
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
	
	public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let list = self.list else { return nil }
		guard ListType.sectionInsideBounds(list, section: section) else { return nil }
		
		return list.sections[section].header?.createView(self)
	}
	
	public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		guard let list = self.list else { return nil }
		guard ListType.sectionInsideBounds(list, section: section) else { return nil }

		return list.sections[section].footer?.createView(self)
	}
	
	// MARK: UITableViewDelegate
	public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		if let tableConfiguration = self.list?.configuration as? TableListConfiguration, let fixedHeight = tableConfiguration.fixedRowHeight {
			return fixedHeight
		}
		return self.estimatedHeights[indexPath] ?? tableView.estimatedRowHeight
	}
	
	public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if let tableConfiguration = self.list?.configuration as? TableListConfiguration, let fixedHeight = tableConfiguration.fixedRowHeight {
			return fixedHeight
		}
		return self.heights[indexPath] ?? UITableViewAutomaticDimension
	}
	
	public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		guard let list = self.list else { return 0 }
		guard ListType.sectionInsideBounds(list, section: section) else { return 0 }

		guard list.sections[section].header != nil else { return 0 }

		return UITableViewAutomaticDimension
	}
	
	public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		guard let list = self.list else { return 0 }
		guard ListType.sectionInsideBounds(list, section: section) else { return 0 }

		guard list.sections[section].footer != nil else { return 0 }

		return UITableViewAutomaticDimension
	}
	
	public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		self.estimatedHeights[indexPath] = cell.frame.size.height
		self.heights[indexPath] = cell.frame.size.height
	}
	
	@available(iOS 9.0, *)
	public func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
		guard let list = self.list else { return }
		guard let indexPath = context.nextFocusedIndexPath else { return }
		
		let listItem = ListType.itemAt(list, indexPath: indexPath)
		_ = listItem.map { $0.onFocus?($0) }
	}
	
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// TODO: Move this to a different place
		tableView.deselectRow(at: indexPath, animated: true)
		
		guard let list = self.list else {
			return
		}
		
		let listItem = list.sections[indexPath.section].items[indexPath.row]
		if let onSelect = listItem.onSelect {
			onSelect(listItem)
		}
	}

	
	public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
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
	
	public func scrollViewDidScroll(_ scrollView: UIScrollView) {
		self.viewDidScroll?()
	}
	
	#if os(iOS)
	public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
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
	
	static func rowAction(_ tableView: UITableView, item: ListItemType, action: ListItemAction<T>) -> UITableViewRowAction {
		let rowAction = UITableViewRowAction(style: self.rowStyle(action.style), title: action.title) { _,_ in
			action.action(item)
			tableView.setEditing(false, animated: true)
		}
		rowAction.backgroundColor = action.tintColor
		return rowAction
	}
	
	static func rowStyle(_ style : ListItemActionStyle) -> UITableViewRowActionStyle {
		switch style {
		case .default:
			return .default
		case .normal:
			return .normal
		}
	}
	#endif
}

