//
//  ListConfiguration.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 11/5/16.
//
//

import Foundation

public protocol ListConfiguration {
	
}

public struct TableConfiguration: ListConfiguration, Equatable {
	let fixedRowHeight: CGFloat?
}

public func ==(lhs: TableConfiguration, rhs: TableConfiguration) -> Bool {
	guard lhs.fixedRowHeight == rhs.fixedRowHeight else { return false }
	return true
}

