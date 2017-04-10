//
//  List.swift
//  Collectionist
//
//  Created by Jose Manuel Sánchez Peñarroja on 15/10/15.
//  Copyright © 2015 vitaminew. All rights reserved.
//

import UIKit

public struct List<T: Equatable, HeaderT: Equatable, FooterT: Equatable>: Equatable {
	public let sections: [ListSection<T, HeaderT, FooterT>]
	public var header : ListHeaderFooter<HeaderT>?
	public var footer : ListHeaderFooter<FooterT>?

	public let scrollInfo: ListScrollInfo?
	public let configuration: ListConfiguration?
	
	public init(sections: [ListSection<T, HeaderT, FooterT>],
				header : ListHeaderFooter<HeaderT>? = nil,
				footer : ListHeaderFooter<FooterT>? = nil,
				scrollInfo: ListScrollInfo? = nil,
				configuration: ListConfiguration? = nil) {
		
		self.sections = sections
		self.header = header
		self.footer = footer
		self.scrollInfo = scrollInfo
		self.configuration = configuration
	}
}

public func ==<T : Equatable, HeaderT : Equatable, FooterT: Equatable>(lhs : List<T,HeaderT,FooterT>, rhs: List<T,HeaderT,FooterT>) -> Bool {
	guard lhs.sections == rhs.sections else { return false }
	guard lhs.header == rhs.header else { return false }
	guard lhs.footer == rhs.footer else { return false }

	guard lhs.scrollInfo == rhs.scrollInfo else { return false }
	return true
}
