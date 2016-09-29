//
//  ColumnsRowsLayout.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 30/5/16.
//
//

import UIKit

public class ColumnsRowsLayout: UICollectionViewFlowLayout {
	public typealias Value = DeviceValue<CGFloat>

	public var columns: Value
	public var rows: Value
	
	public init(columns: Value, rows: Value) {
		self.columns = columns
		self.rows = rows
		
		super.init()
		
		self.enableOrientationInfo()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		self.columns = Value(defaultValue: 2.0)
		self.rows = Value(defaultValue: 2.0)
		
		super.init(coder: aDecoder)
		
		self.enableOrientationInfo()
	}
	
	override public func prepareLayout() {
		if let viewSize = collectionView?.bounds.size {
			self.updateItemSize(viewSize)
		}
		
		super.prepareLayout()
	}
	
	private func enableOrientationInfo() {
		UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
	}

	override public func shouldInvalidateLayoutForBoundsChange(_ newBounds: CGRect) -> Bool {
		updateItemSize(newBounds.size)
		return true
	}

	private func updateItemSize(viewSize: CGSize) {
		let deviceOrientation = UIDevice.currentDevice().orientation
		
		self.itemSize = self.itemSize(viewSize,
										columns: self.columns.value(deviceOrientation),
										rows: self.rows.value(deviceOrientation))
	}
	
	private func itemSize(viewSize: CGSize, columns: CGFloat, rows: CGFloat) -> CGSize {
	
		let outerMarginH = self.sectionInset.left + self.sectionInset.right
		let outerMarginV = self.sectionInset.top + self.sectionInset.bottom
		
		let width = itemLength(viewSize.width, numItems: columns, outerMargin: outerMarginH, innerMargin: self.minimumInteritemSpacing)
		let height = itemLength(viewSize.height, numItems: rows, outerMargin: outerMarginV, innerMargin: self.minimumLineSpacing)
		
		return CGSizeMake(width, height)
	
	}
	
	private func itemLength(viewLength: CGFloat, numItems: CGFloat, outerMargin: CGFloat, innerMargin: CGFloat) -> CGFloat {
		let numOuterMargins: CGFloat = 2.0;
		let numInnerMargins = numItems-1;
	
		return floor((viewLength-(numOuterMargins*outerMargin+numInnerMargins*innerMargin))/numItems)
	}
	
}

