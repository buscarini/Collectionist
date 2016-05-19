//
//  List.swift
//  cibo
//
//  Created by Jose Manuel Sánchez Peñarroja on 15/10/15.
//  Copyright © 2015 treenovum. All rights reserved.
//

import UIKit

public struct List<T: Equatable>: Equatable {
	public let sections: [ListSection<T>]
	public let scrollInfo: ListScrollInfo?
	public let configuration: ListConfiguration?
	
	public init(sections: [ListSection<T>], scrollInfo: ListScrollInfo? = nil, configuration: ListConfiguration? = nil) {
		self.sections = sections
		self.scrollInfo = scrollInfo
		self.configuration = configuration
	}
}

public func ==<T>(lhs: List<T>, rhs: List<T>) -> Bool {
	guard lhs.sections == rhs.sections else { return false }
	guard lhs.scrollInfo == rhs.scrollInfo else { return false }
	return true
}

