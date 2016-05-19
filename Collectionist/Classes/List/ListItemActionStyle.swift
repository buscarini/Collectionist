//
//  ListItemActionStyle.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 19/5/16.
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
