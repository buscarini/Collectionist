//
//  ListSection.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 11/5/16.
//
//

import Foundation


public struct ListSection<T : Equatable> : Equatable {
	let items : [ListItem<T>]
}

public func ==<T>(lhs : ListSection<T>, rhs: ListSection<T>) -> Bool {
	guard lhs.items == rhs.items else { return false }
	return true
}
