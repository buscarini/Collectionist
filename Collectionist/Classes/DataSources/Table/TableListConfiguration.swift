//
//  TableListConfiguration.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 14/6/16.
//
//

import Foundation

public struct TableListConfiguration : ListConfiguration, Equatable {
	public var fixedRowHeight: CGFloat?
	
	// MARK: Pull To Refresh
	public var onRefresh : (() -> ())?
	public var lastUpdated: NSDate?
	public var minimumRefreshInterval: TimeInterval?
	
	// MARK: Infinite Scrolling
	public var onLoadMore : (() -> ())?
	public var loadMoreEnabled : Bool = false
	
	public init() {	}
	
	public init(fixedRowHeight: CGFloat? = nil,
				onRefresh : (() -> ())? = nil,
				lastUpdated: NSDate? = nil,
				minimumRefreshInterval: TimeInterval? = nil,
				onLoadMore : (() -> ())? = nil,
				loadMoreEnabled : Bool = false)
	{
		self.fixedRowHeight = fixedRowHeight
		self.onRefresh = onRefresh
		self.lastUpdated = lastUpdated
		self.minimumRefreshInterval = minimumRefreshInterval
		self.onLoadMore = onLoadMore
		self.loadMoreEnabled = loadMoreEnabled
	}
}

public func ==(lhs : TableListConfiguration, rhs: TableListConfiguration) -> Bool {
	guard lhs.fixedRowHeight == rhs.fixedRowHeight else { return false }
	
	guard lhs.lastUpdated == rhs.lastUpdated else { return false }
	guard lhs.minimumRefreshInterval == rhs.minimumRefreshInterval else { return false }
	
	guard lhs.loadMoreEnabled == rhs.loadMoreEnabled else { return false }
	
	return true
}
