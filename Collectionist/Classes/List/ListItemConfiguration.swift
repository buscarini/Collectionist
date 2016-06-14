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

//public struct TableListItemConfiguration<T: Equatable>: ListItemConfiguration, Equatable {
//	public let accessoryType: UITableViewCellAccessoryType
//	public var onAccessoryTap: ((ListItem<T>)->())? = nil
//	public let indentationLevel: Int
//	public let indentationWidth: CGFloat?
//	public let separatorInset: UIEdgeInsets?
//	
//	public init(accessoryType: UITableViewCellAccessoryType, 
//				onAccessoryTap: ((ListItem<T>)->())? = nil, 
//				indentationLevel: Int = 0, 
//				indentationWidth: CGFloat? = nil, 
//				separatorInset: UIEdgeInsets? = nil) {
//
//		self.accessoryType = accessoryType
//		self.onAccessoryTap = onAccessoryTap
//		self.indentationLevel = indentationLevel
//		self.indentationWidth = indentationWidth
//		self.separatorInset = separatorInset
//	}
//	
//	static func pure() -> TableListItemConfiguration {
//		return TableListItemConfiguration(
//			accessoryType: .None,
//			onAccessoryTap: nil,
//			indentationLevel: 0,
//			indentationWidth: 10.0,
//			separatorInset: nil
//		)
//	}
//}

//public func ==<T>(lhs: TableListItemConfiguration<T>, rhs: TableListItemConfiguration<T>) -> Bool {
//	guard lhs.accessoryType == rhs.accessoryType else { return false }
//	guard (lhs.onAccessoryTap != nil && rhs.onAccessoryTap != nil) || (lhs.onAccessoryTap == nil && rhs.onAccessoryTap == nil) else { return false }
//	guard lhs.indentationLevel == rhs.indentationLevel else { return false }
//	guard lhs.indentationWidth == rhs.indentationWidth else { return false }
//	guard lhs.separatorInset == rhs.separatorInset else { return false }
//	
//	return true
//}
//
