//
//  CollectionViewDataSource.swift
//  cibo
//
//  Created by Jose Manuel Sánchez Peñarroja on 15/10/15.
//  Copyright © 2015 treenovum. All rights reserved.
//

import UIKit

public class CollectionViewDataSource<T: Equatable>: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {

	public var view : UICollectionView? {
		didSet {
			view?.dataSource = self
			view?.delegate = self
			
			CollectionViewDataSource.registerViews(self.view)
		}
	}
	
	public var list : List<T>? {
		didSet {
			self.update(oldValue, newList: list)
		}
	}
	
	public override init() {
		super.init()
	}
	
	private func update<T>(oldList: List<T>?, newList: List<T>?) {
		self.updateView(oldList, newList: newList)
		
		if let list = newList, let scrollInfo = self.list?.scrollInfo, let indexPath = scrollInfo.indexPath where List<T>.indexPathInsideBounds(list, indexPath: indexPath) {
			self.view?.scrollToItemAtIndexPath(indexPath, atScrollPosition:  CollectionViewDataSource.scrollPositionWithPosition(scrollInfo.position, collectionView: self.view), animated: scrollInfo.animated)
		}
	}
	
	private func updateView<T>(oldList: List<T>?, newList: List<T>?) {
		guard let view = self.view else {
			return
		}
		
		if	let oldList = oldList, let newList = newList where List<T>.sameItemsCount(oldList,list2: newList) {
			
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
			self.view?.reloadData()
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
			case (.Top,.Horizontal):
				return .Left
			case (.Top,.Vertical):
				return .Top
			case (.Middle,.Vertical):
				return .CenteredVertically
			case (.Middle,.Horizontal):
				return .CenteredHorizontally
			case (.Bottom, .Vertical):
				return .Bottom
			case (.Bottom, .Horizontal):
					return .Right
		}
	}
	
	static func registerViews(collectionView : UICollectionView?) {
		collectionView?.registerClass(CollectionViewCell<T>.self, forCellWithReuseIdentifier: "cell")
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
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
		
		if let fillableCell = cell as? Fillable {
			fillableCell.fill(listItem)
		}
		
		return cell
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
