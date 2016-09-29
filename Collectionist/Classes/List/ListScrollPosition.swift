//
//  ListScrollPosition.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 19/5/16.
//
//

import Foundation

public enum ListScrollPosition : Equatable {
	case begin
	case middle
	case end
}

public func ==(lhs : ListScrollPosition, rhs: ListScrollPosition) -> Bool {
	switch (lhs, rhs) {
		case (.begin, .begin):
			return true
		case (.middle, .middle):
			return true
		case (.end, .end):
			return true

		default:
			return false
	}
}

