//
//  ListScrollInfo.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 19/5/16.
//
//

import Foundation

public struct ListScrollInfo: Equatable {
	public let indexPath: IndexPath
	public let position: ListScrollPosition
	public let animated: Bool
	
	public init(indexPath: IndexPath, position: ListScrollPosition, animated: Bool = true) {
		self.indexPath = indexPath
		self.position = position
		self.animated = animated
	}
}

public func ==(lhs: ListScrollInfo, rhs: ListScrollInfo) -> Bool {
	guard lhs.indexPath == rhs.indexPath else { return false }
	guard lhs.position == rhs.position else { return false }
	guard lhs.animated == rhs.animated else { return false }
	
	return true	
}
