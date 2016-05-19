//
//  ListSection.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 11/5/16.
//
//

import Foundation


public struct ListSection<T: Equatable>: Equatable {
	public let items: [ListItem<T>]
	
	public init(items: [ListItem<T>]) {
		self.items = items
	}
}

public func ==<T>(lhs: ListSection<T>, rhs: ListSection<T>) -> Bool {
	guard lhs.items == rhs.items else { return false }
	return true
}

