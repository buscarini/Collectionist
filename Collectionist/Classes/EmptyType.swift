//
//  EmptyType.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 14/6/16.
//
//

import Foundation

public struct EmptyType: Equatable {
	public init() {}
}

public func ==(left: EmptyType, right: EmptyType) -> Bool {
	return true
}
