//
//  DeviceValue.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 14/6/16.
//
//

import Foundation


public struct DeviceValue<T> {
	public var defaultValue: T
	public var defaultLandscape: T?
	
	public var iPhone: T?
	public var iPad: T?
	
	public var iPhoneLandscape: T?
	public var iPadLandscape: T?
	
	public func value(orientation: UIDeviceOrientation) -> T {
		let idiom = UIDevice.currentDevice().userInterfaceIdiom
		switch (idiom, orientation.isPortrait, orientation.isLandscape) {
			case (.Pad, true, false):
				return self.iPad ?? self.defaultValue
			case (.Pad, false, true):
				return self.iPadLandscape ?? self.defaultLandscape ?? self.defaultValue
			case (.Phone, true, false):
				return self.iPhone ?? self.defaultValue
			case (.Phone, false, true):
				return self.iPhoneLandscape ?? self.defaultLandscape ?? self.defaultValue
			case (_, false, true):
				return self.defaultLandscape ?? self.defaultValue
			default:
				return self.defaultValue
		}
	}
	
	public init(defaultValue: T) {
		self.defaultValue = defaultValue
	}
}
