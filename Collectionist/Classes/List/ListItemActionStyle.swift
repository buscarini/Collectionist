//
//  ListItemActionStyle.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 19/5/16.
//
//

import Foundation

public enum ListItemActionStyle : Equatable {
	case `default`
	case normal
}

public func ==(lhs : ListItemActionStyle, rhs: ListItemActionStyle) -> Bool {
	switch (lhs,rhs) {
		case (.default, .default):
			return true
		case (.normal, .normal):
			return true
		default:
		return false			
	}
}
