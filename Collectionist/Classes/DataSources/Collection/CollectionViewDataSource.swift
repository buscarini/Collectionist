//
//  CollectionViewDataSource.swift
//  cibo
//
//  Created by Jose Manuel Sánchez Peñarroja on 15/10/15.
//  Copyright © 2015 treenovum. All rights reserved.
//

import UIKit

public class CollectionViewDataSource<T: Equatable, HeaderT: Equatable, FooterT: Equatable>: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {

	public typealias ListType = List<T,HeaderT, FooterT>
	public typealias ListSectionType = ListSection<T,HeaderT, FooterT>
	public typealias ListItemType = ListItem<T>

	private var refreshControl: UIRefreshControl?

	public init(view: UICollectionView) {
		self.view = view
		
		self.refreshControl = UIRefreshControl()

		super.init()
		
		self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)

		self.viewChanged()
	}
	
	public var view : UICollectionView {
		didSet {
			self.viewChanged()
		}
	}
	
	public var list : ListType? {
		didSet {
			CollectionViewDataSource.registerViews(self.list, collectionView: self.view)
			self.update(oldValue, newList: list)
		}
	}
	
	private func viewChanged() {
		CollectionViewDataSource.registerViews(self.list, collectionView: self.view)
			
		self.view.dataSource = self
		self.view.delegate = self			
	}
	
	private func update(oldList: ListType?, newList: ListType?) {
		self.updateView(oldList, newList: newList)
		
		self.refreshControl?.endRefreshing()
		if let refreshControl = self.refreshControl where newList?.configuration?.onRefresh != nil {
			self.view.addSubview(refreshControl)
			self.view.alwaysBounceVertical = true
		}
		else {
			self.refreshControl?.removeFromSuperview()
		}

		if let list = newList, let scrollInfo = self.list?.scrollInfo, let indexPath = scrollInfo.indexPath where ListType.indexPathInsideBounds(list, indexPath: indexPath) {
			self.view.scrollToItemAtIndexPath(indexPath, atScrollPosition:  CollectionViewDataSource.scrollPositionWithPosition(scrollInfo.position, collectionView: self.view), animated: scrollInfo.animated)
		}
	}
	
	private func updateView(oldList: ListType?, newList: ListType?) {
		if	let oldList = oldList, let newList = newList where ListType.sameItemsCount(oldList,list2: newList) {
			
			let visibleIndexPaths = view.indexPathsForVisibleItems()
			
			for indexPath in visibleIndexPaths {
				let cell = view.cellForItemAtIndexPath(indexPath)
				let listItem = newList.sections[indexPath.section].items[indexPath.item]
				if let fillableCell = cell as? Fillable {
					fillableCell.fill(listItem)
				}
			}
		}
		else {
			self.view.reloadData()
		}
	}
	
	static func scrollPositionWithPosition(position: ListScrollPosition, collectionView: UICollectionView?) -> UICollectionViewScrollPosition {
		guard let collectionView = collectionView else {
			return .None
		}
		
		let scrollDirection : UICollectionViewScrollDirection
		if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
			scrollDirection = flowLayout.scrollDirection
		}
		else {
			scrollDirection = .Vertical
		}
		
		switch (position,scrollDirection) {
			case (.Begin,.Horizontal):
				return .Left
			case (.Begin,.Vertical):
				return .Top
			case (.Middle,.Vertical):
				return .CenteredVertically
			case (.Middle,.Horizontal):
				return .CenteredHorizontally
			case (.End, .Vertical):
				return .Bottom
			case (.End, .Horizontal):
					return .Right
		}
	}
	
	public static func registerViews(list: ListType?, collectionView : UICollectionView?) {
		guard let list = list else { return }
		
		let allReusableIds = List.allReusableIds(list)
		for reusableId in allReusableIds {
			collectionView?.registerClass(CollectionViewCell<T>.self, forCellWithReuseIdentifier: reusableId)
		}
	}
	
	// MARK: Pull to Refresh
	func refresh(sender: AnyObject?) {
		guard let list = self.list else { return }
		guard let configuration = list.configuration else { return }
		
		configuration.onRefresh?()
	}
	
	// MARK: UICollectionViewDataSource
	public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return self.list?.sections.count ?? 0
	}
	
	public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		guard let list = self.list else {
			return 0
		}
		
		return list.sections[section].items.count
	}

	public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		guard let list = self.list else {
			fatalError("List is required. We shouldn't be here")
		}
		
		let listItem = list.sections[indexPath.section].items[indexPath.row]
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(listItem.cellId, forIndexPath: indexPath)
		
		if let fillableCell = cell as? Fillable {
			fillableCell.fill(listItem)
		}
		
		return cell
	}
	
	public func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
		guard let list = self.list else {
			return
		}

		let listItem = list.sections[indexPath.section].items[indexPath.row]
		
		if let fillableCell = cell as? Fillable {
			fillableCell.fill(listItem)
		}
	}
	
	// MARK : UICollectionViewDelegate
	public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		guard let list = self.list else {
			return
		}
		
		let listItem = list.sections[indexPath.section].items[indexPath.row]
		if let onSelect = listItem.onSelect {
			onSelect(listItem)
		}
	}
	
}
