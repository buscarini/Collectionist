//
//  ListItem.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 11/5/16.
//
//

import Foundation

public struct ListItem<T: Equatable>: Equatable {
	public let nibName: String
	public let reusableId: String?
	public let value: T?
	public let configuration: ListItemConfiguration?
	public var swipeActions: [ListItemAction<T>]
	public var onSelect: ((ListItem<T>)->())? = nil
	public var onFocus: ((ListItem<T>)->())? = nil
	
	public init(nibName: String,
				reusableId: String?,
				value: T?,
				configuration: ListItemConfiguration? = nil,
				swipeActions: [ListItemAction<T>] = [],
				onSelect: ((ListItem<T>)->())? = nil,
				onFocus: ((ListItem<T>)->())? = nil) {
		self.nibName = nibName
		self.reusableId = reusableId
		self.value = value
		self.configuration = configuration
		self.swipeActions = swipeActions
		self.onSelect = onSelect
		self.onFocus = onFocus
	}
	
	var cellId: String {
		return reusableId ?? nibName
	}
}

public func ==<T>(lhs: ListItem<T>, rhs: ListItem<T>) -> Bool {
	guard lhs.nibName == rhs.nibName else { return false }
	guard lhs.reusableId == rhs.reusableId else { return false }
	guard lhs.value == rhs.value else { return false }
//	guard lhs.configuration == rhs.configuration else { print("configuration different"); return false }
	guard lhs.swipeActions == rhs.swipeActions else { return false }
	guard (lhs.onSelect == nil) == (rhs.onSelect == nil) else { return false }
	guard (lhs.onFocus == nil) == (rhs.onFocus == nil) else { return false }
	
	return true
}

