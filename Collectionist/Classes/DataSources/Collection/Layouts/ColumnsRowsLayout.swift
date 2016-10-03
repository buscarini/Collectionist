//
//  ColumnsRowsLayout.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 30/5/16.
//
//

import UIKit

open class ColumnsRowsLayout: UICollectionViewFlowLayout {
	public typealias Value = DeviceValue<CGFloat>

	open var columns: Value
	open var rows: Value
	
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
	
	override open func prepare() {
		if let viewSize = collectionView?.bounds.size {
			self.updateItemSize(viewSize)
		}
		
		super.prepare()
	}
	
	fileprivate func enableOrientationInfo() {
		UIDevice.current.beginGeneratingDeviceOrientationNotifications()
	}

	override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		updateItemSize(newBounds.size)
		return true
	}

	fileprivate func updateItemSize(_ viewSize: CGSize) {
		let deviceOrientation = UIDevice.current.orientation
		
		self.itemSize = self.itemSize(viewSize,
										columns: self.columns.value(deviceOrientation),
										rows: self.rows.value(deviceOrientation))
	}
	
	fileprivate func itemSize(_ viewSize: CGSize, columns: CGFloat, rows: CGFloat) -> CGSize {
	
		let outerMarginH = self.sectionInset.left + self.sectionInset.right
		let outerMarginV = self.sectionInset.top + self.sectionInset.bottom
		
		let width = itemLength(viewSize.width, numItems: columns, outerMargin: outerMarginH, innerMargin: self.minimumInteritemSpacing)
		let height = itemLength(viewSize.height, numItems: rows, outerMargin: outerMarginV, innerMargin: self.minimumLineSpacing)
		
		return CGSize(width: width, height: height)
	
	}
	
	fileprivate func itemLength(_ viewLength: CGFloat, numItems: CGFloat, outerMargin: CGFloat, innerMargin: CGFloat) -> CGFloat {
		let numOuterMargins: CGFloat = 2.0;
		let numInnerMargins = numItems-1;
	
		return floor((viewLength-(numOuterMargins*outerMargin+numInnerMargins*innerMargin))/numItems)
	}
	
}

