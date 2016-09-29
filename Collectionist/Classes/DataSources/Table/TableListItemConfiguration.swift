//
//  TableListItemConfiguration.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 14/6/16.
//
//

import UIKit

public struct TableListItemConfiguration<T: Equatable> : ListItemConfiguration, Equatable {
	public var accessoryType : UITableViewCellAccessoryType
	public var onAccessoryTap : ((ListItem<T>)->())? = nil
	public var swipeActions : [ListItemAction<T>]
	public var indentationLevel : Int?
	public var indentationWidth : CGFloat?
	public var separatorInset: UIEdgeInsets?
	
	public init(accessoryType: UITableViewCellAccessoryType = .none,
				onAccessoryTap: ((ListItem<T>)->())? = nil,
				swipeActions : [ListItemAction<T>] = [],
				indentationLevel: Int? = nil,
				indentationWidth: CGFloat? = nil,
				separatorInset: UIEdgeInsets? = nil) {
		self.accessoryType = accessoryType
		self.onAccessoryTap = onAccessoryTap
		self.swipeActions = swipeActions
		self.indentationLevel = indentationLevel
		self.indentationWidth = indentationWidth
		self.separatorInset = separatorInset
	}
	
	public static func defaultConfiguration() -> TableListItemConfiguration {
		return TableListItemConfiguration(
			accessoryType : .none,
			onAccessoryTap: nil,
			swipeActions: [],
			indentationLevel: 0,
			indentationWidth : 10.0,
			separatorInset: nil
		)
	}
}

public func ==<T>(lhs : TableListItemConfiguration<T>, rhs: TableListItemConfiguration<T>) -> Bool {
	guard lhs.accessoryType == rhs.accessoryType else { return false }
	guard (lhs.onAccessoryTap != nil && rhs.onAccessoryTap != nil) || (lhs.onAccessoryTap == nil && rhs.onAccessoryTap == nil) else { return false }
	guard lhs.swipeActions == rhs.swipeActions else { return false }
	guard lhs.indentationLevel == rhs.indentationLevel else { return false }
	guard lhs.indentationWidth == rhs.indentationWidth else { return false }
	guard lhs.separatorInset == rhs.separatorInset else { return false }
	
	return true
}

