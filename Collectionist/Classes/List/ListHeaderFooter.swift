//
//  ListHeaderFooter.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 14/6/16.
//
//

import Foundation

public struct ListHeaderFooter<T : Equatable> : Equatable {
	public var nibName : String
	public var value : T?
	public var onSelect : ((ListHeaderFooter)->())? = nil
	
	public init(nibName : String,value : T? = nil,onSelect : ((ListHeaderFooter)->())? = nil) {
		self.nibName = nibName
		self.value = value
		self.onSelect = onSelect
	}
}

public func ==<T: Equatable>(lhs : ListHeaderFooter<T>, rhs: ListHeaderFooter<T>) -> Bool {
	guard lhs.nibName == rhs.nibName else { return false }
	guard lhs.value == rhs.value else { return false }
	
	return true
}

