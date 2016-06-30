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
		
		self.refreshControl?.addTarget(self, action: "refresh:", for: .valueChanged)

		self.viewChanged()
	}
	
	public var view : UICollectionView {
		didSet {
			self.viewChanged()
		}
	}
	
	public var list : ListType? {
		didSet {
			CollectionViewDataSource.registerViews(list: self.list, collectionView: self.view)
			self.update(oldList: oldValue, newList: list)
		}
	}
	
	private func viewChanged() {
		CollectionViewDataSource.registerViews(list: self.list, collectionView: self.view)
			
		self.view.dataSource = self
		self.view.delegate = self			
	}
	
	private func update(oldList: ListType?, newList: ListType?) {
		self.updateView(oldList: oldList, newList: newList)
		
		self.refreshControl?.endRefreshing()
		if let refreshControl = self.refreshControl where newList?.configuration?.onRefresh != nil {
			self.view.addSubview(refreshControl)
			self.view.alwaysBounceVertical = true
		}
		else {
			self.refreshControl?.removeFromSuperview()
		}

		if let list = newList, let scrollInfo = self.list?.scrollInfo, let indexPath = scrollInfo.indexPath where ListType.indexPathInsideBounds(list, indexPath: indexPath) {
		
			self.view.scrollToItem(at: indexPath, at: CollectionViewDataSource.scrollPositionWithPosition(position: scrollInfo.position, collectionView: self.view), animated: scrollInfo.animated)
		}
	}
	
	private func updateView(oldList: ListType?, newList: ListType?) {
		if	let oldList = oldList, let newList = newList where ListType.sameItemsCount(oldList, newList) {
			
			let visibleIndexPaths = view.indexPathsForVisibleItems()
			
//			let listItems: [ListItem<T>?] = visibleIndexPaths.map { indexPath -> ListItem<T>? in
//				guard let item = indexPath.item else { return nil }
//				return newList.sections[indexPath.section].items[item]
//			}
//			
//			let cells = visibleIndexPaths.map {
//				return view.cellForItem(at: $0)
//			}
//			
//			Zip2Sequence(_sequence1: listItems, _sequence2: cells).map { listItem, cell in
//				if let fillableCell = cell as? Fillable, let listItem = listItem {
//					fillableCell.fill(listItem)
//				}
//				return nil
//			}
			
			for indexPath in visibleIndexPaths {
				guard let item = indexPath.item else { continue }
			
				let cell = view.cellForItem(at: indexPath)
				let listItem = newList.sections[indexPath.section].items[item]
				if let fillableCell = cell as? Fillable {
					fillableCell.fill(value: listItem)
				}
			}
		}
		else {
			self.view.reloadData()
		}
	}
	
	static func scrollPositionWithPosition(position: ListScrollPosition, collectionView: UICollectionView?) -> UICollectionViewScrollPosition {
		guard let collectionView = collectionView else {
			return []
		}
		
		let scrollDirection : UICollectionViewScrollDirection
		if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
			scrollDirection = flowLayout.scrollDirection
		}
		else {
			scrollDirection = .vertical
		}
		
		switch (position,scrollDirection) {
			case (.Begin,.horizontal):
				return .left
			case (.Begin,.vertical):
				return .top
			case (.Middle,.vertical):
				return .centeredVertically
			case (.Middle,.horizontal):
				return .centeredHorizontally
			case (.End, .vertical):
				return .bottom
			case (.End, .horizontal):
					return .right
		}
	}
	
	public static func registerViews(list: ListType?, collectionView : UICollectionView?) {
		guard let list = list else { return }
		
		let allReusableIds = List.allReusableIds(list: list)
		for reusableId in allReusableIds {
			collectionView?.register(CollectionViewCell<T>.self, forCellWithReuseIdentifier: reusableId)
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
	
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		guard let list = self.list else {
			return 0
		}
		
		return list.sections[section].items.count
	}

	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let list = self.list else {
			fatalError("List is required. We shouldn't be here")
		}
		
		let listItem = list.sections[indexPath.section].items[indexPath.row]
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listItem.cellId, for: indexPath)
		
		if let fillableCell = cell as? Fillable {
			fillableCell.fill(value: listItem)
		}
		
		return cell
	}
	
	public func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
		guard let list = self.list else {
			return
		}

		let listItem = list.sections[indexPath.section].items[indexPath.row]
		
		if let fillableCell = cell as? Fillable {
			fillableCell.fill(value: listItem)
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
