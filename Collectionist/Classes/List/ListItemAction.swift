//
//  ListItemAction.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 19/5/16.
//
//

import Foundation

public struct ListItemAction<T: Equatable>: Equatable {
	let title: String
	let style: ListItemActionStyle
	let tintColor: UIColor
	let action: (ListItem<T>) -> ()
	
	public init(title: String, style: ListItemActionStyle, tintColor: UIColor, action: (ListItem<T>) -> ()) {
		self.title = title
		self.style = style
		self.tintColor = tintColor
		self.action = action
	}
}

public func ==<T>(lhs : ListItemAction<T>, rhs: ListItemAction<T>) -> Bool {
	guard lhs.title == rhs.title else { return false }
	guard lhs.style == rhs.style else { return false }
	guard lhs.tintColor == rhs.tintColor else { return false }
	
	return true
}

