//
//  List.swift
//  cibo
//
//  Created by Jose Manuel Sánchez Peñarroja on 15/10/15.
//  Copyright © 2015 treenovum. All rights reserved.
//

import UIKit


public enum ListScrollPosition : Equatable {
	case Top
	case Middle
	case Bottom
}

public func ==(lhs : ListScrollPosition, rhs: ListScrollPosition) -> Bool {
	switch (lhs, rhs) {
		case (.Top, .Top):
			return true
		case (.Middle, .Middle):
			return true
		case (.Bottom, .Bottom):
			return true

		default:
			return false
	}
}


public struct ListScrollInfo : Equatable {
	let indexPath : NSIndexPath?
	let position : ListScrollPosition
	let animated: Bool = true
}

public func ==(lhs : ListScrollInfo, rhs: ListScrollInfo) -> Bool {
	guard lhs.indexPath == rhs.indexPath else { return false }
	guard lhs.position == rhs.position else { return false }
	guard lhs.animated == rhs.animated else { return false }
	
	return true	
}

public struct List<T : Equatable> : Equatable {
	let sections : [ListSection<T>]
	let scrollInfo : ListScrollInfo?
	let configuration : ListConfiguration?
}

public func ==<T>(lhs : List<T>, rhs: List<T>) -> Bool {
	guard lhs.sections == rhs.sections else { return false }
	guard lhs.scrollInfo == rhs.scrollInfo else { return false }
	return true
}

public extension List {
	
	public static func listFrom<T>(items : [T], nibName : String, scrollInfo: ListScrollInfo? = nil, configuration: ListConfiguration? = nil,itemConfiguration : ListItemConfiguration? = nil, onSelect : ((ListItem<T>)->())? = nil, onFocus : ((ListItem<T>)->())? = nil) -> List<T> {
		let listItems = items.map {
			ListItem(nibName: nibName, cellId: nil,value: $0, configuration: itemConfiguration, swipeActions: [], onSelect: onSelect, onFocus: onFocus)
		}
		
		let section = ListSection(items : listItems)
		return List<T>(sections: [section], scrollInfo: scrollInfo, configuration: configuration)
	}
	
	public static func isEmpty<T>(list: List<T>) -> Bool {
		return list.sections.map { $0.items.count }.reduce(0, combine: +)==0
	}
	
	public static func itemIndexPath(list: List<T>, item: T) -> NSIndexPath? {
		for (sectionIndex, section) in list.sections.enumerate() {
			for (itemIndex, listItem) in section.items.enumerate() {
				if listItem.value == item {
					return NSIndexPath(forRow: itemIndex, inSection: sectionIndex)
				}
			}
		}
		
		return nil
	}
	
	public static func itemAt<T>(list: List<T>, indexPath: NSIndexPath) -> ListItem<T>? {
		guard List<T>.indexPathInsideBounds(list, indexPath: indexPath) else { return nil }
		return list.sections[indexPath.section].items[indexPath.row]
	}
	
	public static func indexPathInsideBounds(list: List,indexPath : NSIndexPath) -> Bool {
		switch (indexPath.section,indexPath.row) {
		case (let section, _) where section>=list.sections.count:
			return false
		case (let section,_) where section<0:
			return false
		case (let section, let row) where row>=list.sections[section].items.count:
			return false
		default:
			return true
		}
	}
	
	public static func sameItemsCount<T>(list1: List<T>, list2: List<T>) -> Bool {
		guard (list1.sections.count == list2.sections.count) else { return false }
		
		return Zip2Sequence(list1.sections,list2.sections).filter {
			(section1, section2) in
			return section1.items.count != section2.items.count
			}.count==0
	}
	
	public static func itemsChangedPaths<T>(list1: List<T>, list2: List<T>) -> [NSIndexPath] {
		assert(sameItemsCount(list1, list2: list2))
		
		let processed = Zip2Sequence(list1.sections,list2.sections).map {
			(section1, section2) in
			return Zip2Sequence(section1.items,section2.items).map(compareItems)
		}
		
		return Zip2Sequence(processed,Array(0..<processed.count)).map {
			(items, sectionIndex) -> [NSIndexPath] in
			let numItems = items.count
			let indexes = Zip2Sequence(items,Array(0..<numItems))
				.map { // Convert non nil items to their indexes
					(item, index) -> Int? in
					return item.map { _ in index }
				}
				.flatMap{$0} // Removed nil items
				
			return indexes.map { NSIndexPath(forRow: $0, inSection: sectionIndex) } // Convert indexes to nsindexpath
			
		}.flatMap{$0} // Flatten [[NSIndexPath]]
	}
	
	public static func compareItems<T>(item1: ListItem<T>,item2 : ListItem<T>) -> ListItem<T>? {
		return item1 == item2 ? nil : item2
	}
	
	public static func allCellIds(list: List) -> [String] {
		return removeDups(list.sections.flatMap {
			section in
			return section.items.map {
				item in
				return item.cellId ?? item.nibName
			}
		})
	}
}
