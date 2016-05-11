//
//  List.swift
//  cibo
//
//  Created by Jose Manuel Sánchez Peñarroja on 15/10/15.
//  Copyright © 2015 treenovum. All rights reserved.
//

import UIKit

public protocol ListItemConfiguration {
	
}

public struct TableListItemConfiguration<T: Equatable> : ListItemConfiguration, Equatable {
	let accessoryType : UITableViewCellAccessoryType
	var onAccessoryTap : ((ListItem<T>)->())? = nil
	let indentationLevel : Int
	let indentationWidth : CGFloat
	let separatorInset: UIEdgeInsets?
	
	static func pure() -> TableListItemConfiguration {
		return TableListItemConfiguration(
			accessoryType : .None,
			onAccessoryTap: nil,
			indentationLevel: 0,
			indentationWidth : 10.0,
			separatorInset: nil
		)
	}
}

public func ==<T>(lhs : TableListItemConfiguration<T>, rhs: TableListItemConfiguration<T>) -> Bool {
//	guard lhs.swipeActions == rhs.swipeActions else { return false }
	guard lhs.accessoryType == rhs.accessoryType else { return false }
	guard (lhs.onAccessoryTap != nil && rhs.onAccessoryTap != nil) || (lhs.onAccessoryTap == nil && rhs.onAccessoryTap == nil) else { return false }
	guard lhs.indentationLevel == rhs.indentationLevel else { return false }
	guard lhs.indentationWidth == rhs.indentationWidth else { return false }
	guard lhs.separatorInset == rhs.separatorInset else { return false }
	
	return true
}

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

public enum ListItemActionStyle : Equatable {
	case Default
	case Normal
}

public func ==(lhs : ListItemActionStyle, rhs: ListItemActionStyle) -> Bool {
	switch (lhs,rhs) {
		case (.Default, .Default):
			return true
		case (.Normal, .Normal):
			return true
		default:
		return false			
	}
}

public struct ListItemAction<T: Equatable> : Equatable {
	let title : String
	let style : ListItemActionStyle
	let tintColor: UIColor
	let action : (ListItem<T>) -> ()
}

public func ==<T>(lhs : ListItemAction<T>, rhs: ListItemAction<T>) -> Bool {
	guard lhs.title == rhs.title else { return false }
	guard lhs.style == rhs.style else { return false }
	guard lhs.tintColor == rhs.tintColor else { return false }
	
	return true
}

public struct ListItem<T: Equatable> : Equatable {
	let nibName : String
	let cellId : String?
	let value : T?
	let configuration : ListItemConfiguration?
	var swipeActions : [ListItemAction<T>]
	var onSelect : ((ListItem<T>)->())? = nil
	var onFocus : ((ListItem<T>)->())? = nil
}

public func ==<T>(lhs : ListItem<T>, rhs: ListItem<T>) -> Bool {
	guard lhs.nibName == rhs.nibName else { return false }
	guard lhs.value == rhs.value else { return false }
//	guard lhs.configuration == rhs.configuration else { print("configuration different"); return false }
	guard lhs.swipeActions == rhs.swipeActions else { return false }
	guard (lhs.onSelect == nil) == (rhs.onSelect == nil) else { return false }
	guard (lhs.onFocus == nil) == (rhs.onFocus == nil) else { return false }
	
	return true
}

public struct ListSection<T : Equatable> : Equatable {
	let items : [ListItem<T>]
}

public func ==<T>(lhs : ListSection<T>, rhs: ListSection<T>) -> Bool {
	guard lhs.items == rhs.items else { return false }
	return true
}

public protocol ListConfiguration {
	
}

public struct TableConfiguration : ListConfiguration, Equatable {
	let fixedRowHeight: CGFloat?
}

public func ==(lhs : TableConfiguration, rhs: TableConfiguration) -> Bool {
	guard lhs.fixedRowHeight == rhs.fixedRowHeight else { return false }
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
