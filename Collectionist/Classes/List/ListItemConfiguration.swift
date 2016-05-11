//
//  ListItemConfiguration.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 11/5/16.
//
//

import Foundation

public protocol ListItemConfiguration {
	
}

public struct TableListItemConfiguration<T: Equatable> : ListItemConfiguration, Equatable {
	let accessoryType : UITableViewCellAccessoryType
	var onAccessoryTap : ((ListItem<T>)->())? = nil
	let indentationLevel : Int
	let indentationWidth : CGFloat
	let separatorInset: UIEdgeInsets?
	
	static func pure() -> TableListItemConfiguration {
		return TableListItemConfiguration(
			accessoryType : .None,
			onAccessoryTap: nil,
			indentationLevel: 0,
			indentationWidth : 10.0,
			separatorInset: nil
		)
	}
}

public func ==<T>(lhs : TableListItemConfiguration<T>, rhs: TableListItemConfiguration<T>) -> Bool {
//	guard lhs.swipeActions == rhs.swipeActions else { return false }
	guard lhs.accessoryType == rhs.accessoryType else { return false }
	guard (lhs.onAccessoryTap != nil && rhs.onAccessoryTap != nil) || (lhs.onAccessoryTap == nil && rhs.onAccessoryTap == nil) else { return false }
	guard lhs.indentationLevel == rhs.indentationLevel else { return false }
	guard lhs.indentationWidth == rhs.indentationWidth else { return false }
	guard lhs.separatorInset == rhs.separatorInset else { return false }
	
	return true
}

