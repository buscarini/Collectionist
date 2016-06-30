//
//  CollectionListConfiguration.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 14/6/16.
//
//

import UIKit

public struct CollectionListConfiguration<T: Equatable>: ListConfiguration, Equatable {
	// MARK: Pull To Refresh
	public var onRefresh: (() -> ())?
	public var lastUpdated: Date?
	public var minimumRefreshInterval: TimeInterval?
	
	// MARK: Infinite Scrolling
	public var onLoadMore: (() -> ())?
	public var loadMoreEnabled : Bool = false
	
	public init() {	}
	
	public init(onRefresh : (() -> ())? = nil,
				lastUpdated: Date? = nil,
				minimumRefreshInterval: TimeInterval? = nil,
				onLoadMore : (() -> ())? = nil,
				loadMoreEnabled : Bool = false)
	{
		self.onRefresh = onRefresh
		self.lastUpdated = lastUpdated
		self.minimumRefreshInterval = minimumRefreshInterval
		self.onLoadMore = onLoadMore
		self.loadMoreEnabled = loadMoreEnabled
	}
}

public func ==<T>(lhs : CollectionListConfiguration<T>, rhs: CollectionListConfiguration<T>) -> Bool {
	guard (lhs.onRefresh == nil) == (rhs.onRefresh == nil) else { return false }
	guard lhs.lastUpdated == rhs.lastUpdated else { return false }
	guard lhs.minimumRefreshInterval == rhs.minimumRefreshInterval else { return false }
	
	guard lhs.loadMoreEnabled == rhs.loadMoreEnabled else { return false }

	return true
}

