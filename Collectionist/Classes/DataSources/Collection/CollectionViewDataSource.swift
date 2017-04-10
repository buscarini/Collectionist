//
//  CollectionViewDataSource.swift
//  Collectionist
//
//  Created by Jose Manuel Sánchez Peñarroja on 15/10/15.
//  Copyright © 2015 vitaminew. All rights reserved.
//

import UIKit

open class CollectionViewDataSource<T: Equatable, HeaderT: Equatable, FooterT: Equatable>: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {

	public typealias ListType = List<T,HeaderT, FooterT>
	public typealias ListSectionType = ListSection<T,HeaderT, FooterT>
	public typealias ListItemType = ListItem<T>

	fileprivate var refreshControl: UIRefreshControl?

	public init(view: UICollectionView) {
		self.view = view
		
		self.refreshControl = UIRefreshControl()

		super.init()
		
		self.refreshControl?.addTarget(self, action: #selector(CollectionViewDataSource.refresh(_:)), for: .valueChanged)

		self.viewChanged()
	}
	
	open var view : UICollectionView {
		didSet {
			self.viewChanged()
		}
	}
	
	open var list : ListType? {
		didSet {
			CollectionViewDataSource.registerViews(self.list, collectionView: self.view)
			self.update(oldValue, newList: list)
		}
	}
	
	fileprivate func viewChanged() {
		CollectionViewDataSource.registerViews(self.list, collectionView: self.view)
			
		self.view.dataSource = self
		self.view.delegate = self			
	}
	
	fileprivate func update(_ oldList: ListType?, newList: ListType?) {
		self.updateView(oldList, newList: newList)
		
		self.refreshControl?.endRefreshing()
		if let refreshControl = self.refreshControl , newList?.configuration?.onRefresh != nil {
			self.view.addSubview(refreshControl)
			self.view.alwaysBounceVertical = true
		}
		else {
			self.refreshControl?.removeFromSuperview()
		}

		if let list = newList, let scrollInfo = self.list?.scrollInfo, ListType.indexPathInsideBounds(list, indexPath: scrollInfo.indexPath) {
		
			let indexPath = scrollInfo.indexPath
			self.view.scrollToItem(at: indexPath, at: CollectionViewDataSource.scrollPositionWithPosition(scrollInfo.position, collectionView: self.view), animated: scrollInfo.animated)
		}
	}
	
	fileprivate func updateView(_ oldList: ListType?, newList: ListType?) {
		if	let oldList = oldList, let newList = newList, ListType.sameItemsCount(oldList, newList), !List.headersChanged(oldList, newList) {
			
			let visibleIndexPaths = view.indexPathsForVisibleItems
			
			for indexPath in visibleIndexPaths {
				let item = indexPath.item
				let cell = view.cellForItem(at: indexPath)
				let listItem = newList.sections[indexPath.section].items[item]
				if let fillableCell = cell as? Fillable {
					fillableCell.fill(listItem)
				}
			}
		}
		else {
			self.view.reloadData()
		}
	}
	
	static func scrollPositionWithPosition(_ position: ListScrollPosition, collectionView: UICollectionView?) -> UICollectionViewScrollPosition {
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
			case (.begin,.horizontal):
				return .left
			case (.begin,.vertical):
				return .top
			case (.middle,.vertical):
				return .centeredVertically
			case (.middle,.horizontal):
				return .centeredHorizontally
			case (.end, .vertical):
				return .bottom
			case (.end, .horizontal):
					return .right
		}
	}
	
	open static func registerViews(_ list: ListType?, collectionView : UICollectionView?) {
		guard let list = list else { return }
		
		let allReusableIds = List.allReusableIds(list)
		for reusableId in allReusableIds {
			collectionView?.register(CollectionViewCell<T>.self, forCellWithReuseIdentifier: reusableId)
		}
	}
	
	// MARK: Pull to Refresh
	func refresh(_ sender: AnyObject?) {
		guard let list = self.list else { return }
		guard let configuration = list.configuration else { return }
		
		configuration.onRefresh?()
	}
	
	// MARK: UICollectionViewDataSource
	open func numberOfSections(in collectionView: UICollectionView) -> Int {
		return self.list?.sections.count ?? 0
	}
	
	open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		guard let list = self.list else {
			return 0
		}
		
		return list.sections[section].items.count
	}

	open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let list = self.list else {
			fatalError("List is required. We shouldn't be here")
		}
		
		let listItem = list.sections[indexPath.section].items[indexPath.row]
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listItem.cellId, for: indexPath)
		
		if let fillableCell = cell as? Fillable {
			fillableCell.fill(listItem)
		}
		
		return cell
	}
	
	open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		guard let list = self.list else {
			return
		}

		let listItem = list.sections[(indexPath as NSIndexPath).section].items[(indexPath as NSIndexPath).row]
		
		if let fillableCell = cell as? Fillable {
			fillableCell.fill(listItem)
		}
	}
	
	// MARK : UICollectionViewDelegate
	open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let list = self.list else {
			return
		}
		
		let listItem = list.sections[(indexPath as NSIndexPath).section].items[(indexPath as NSIndexPath).row]
		if let onSelect = listItem.onSelect {
			onSelect(listItem)
		}
	}
	
}
