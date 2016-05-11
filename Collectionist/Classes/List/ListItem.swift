//
//  ListItem.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 11/5/16.
//
//

import Foundation

public enum ListItemActionStyle : Equatable {
	case Default
	case Normal
}

public func ==(lhs : ListItemActionStyle, rhs: ListItemActionStyle) -> Bool {
	switch (lhs,rhs) {
		case (.Default, .Default):
			return true
		case (.Normal, .Normal):
			return true
		default:
		return false			
	}
}

public struct ListItemAction<T: Equatable> : Equatable {
	let title : String
	let style : ListItemActionStyle
	let tintColor: UIColor
	let action : (ListItem<T>) -> ()
}

public func ==<T>(lhs : ListItemAction<T>, rhs: ListItemAction<T>) -> Bool {
	guard lhs.title == rhs.title else { return false }
	guard lhs.style == rhs.style else { return false }
	guard lhs.tintColor == rhs.tintColor else { return false }
	
	return true
}

public struct ListItem<T: Equatable> : Equatable {
	public let nibName : String
	public let cellId : String?
	public let value : T?
	public let configuration : ListItemConfiguration?
	public var swipeActions : [ListItemAction<T>]
	public var onSelect : ((ListItem<T>)->())? = nil
	public var onFocus : ((ListItem<T>)->())? = nil
}

public func ==<T>(lhs : ListItem<T>, rhs: ListItem<T>) -> Bool {
	guard lhs.nibName == rhs.nibName else { return false }
	guard lhs.value == rhs.value else { return false }
//	guard lhs.configuration == rhs.configuration else { print("configuration different"); return false }
	guard lhs.swipeActions == rhs.swipeActions else { return false }
	guard (lhs.onSelect == nil) == (rhs.onSelect == nil) else { return false }
	guard (lhs.onFocus == nil) == (rhs.onFocus == nil) else { return false }
	
	return true
}

