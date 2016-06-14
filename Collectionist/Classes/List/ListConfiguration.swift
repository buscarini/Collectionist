//
//  ListConfiguration.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 11/5/16.
//
//

import Foundation

public protocol ListConfiguration {
	// MARK: Pull To Refresh
	var onRefresh : (() -> ())? { get set }
	var lastUpdated: NSDate? { get set }
	var minimumRefreshInterval: NSTimeInterval? { get set }
	
	// MARK: Infinite Scrolling
	var onLoadMore : (() -> ())? { get set }
	var loadMoreEnabled : Bool { get set }
}

