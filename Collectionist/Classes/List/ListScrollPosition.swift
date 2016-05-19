//
//  ListScrollPosition.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 19/5/16.
//
//

import Foundation

public enum ListScrollPosition : Equatable {
	case Begin
	case Middle
	case End
}

public func ==(lhs : ListScrollPosition, rhs: ListScrollPosition) -> Bool {
	switch (lhs, rhs) {
		case (.Begin, .Begin):
			return true
		case (.Middle, .Middle):
			return true
		case (.End, .End):
			return true

		default:
			return false
	}
}

