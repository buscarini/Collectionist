//
//  TableViewCell.swift
//  OnePodcast
//
//  Created by Jose Manuel Sánchez Peñarroja on 23/10/15.
//  Copyright © 2015 vitaminew. All rights reserved.
//

import UIKit

import Layitout

public class TableViewCell<T : Equatable>: UITableViewCell, Fillable {

	public var view : UIView?
	var nibName : String?
	
	public init(reuseId: String) {
		super.init(style: .default, reuseIdentifier: reuseId)
	}
	
	public func fill(_ value: Any?) {
		guard let listItem = value as? ListItem<T> else {
			return
		}
		defer {
			self.nibName = listItem.nibName
		}
		
		let subview : UIView?
		
		if nibName == listItem.nibName && view != nil {
			subview = view
		}
		else {
			subview = viewFor(listItem.nibName)
			if let subview = subview {
				view?.removeFromSuperview()
				view = subview
				self.contentView.addSubview(subview)
				subview.translatesAutoresizingMaskIntoConstraints = false
				Layout.fill(container: self.contentView,view: subview)
			}
		}
		
		if let fillable = subview as? Fillable {
			fillable.fill(listItem.value)
		}
		
		self.update(listItem.configuration as? TableListItemConfiguration<T>)
	}
	
	func update(_ config: TableListItemConfiguration<T>?) {
		guard let config = config else { return }
		self.accessoryType = config.accessoryType
		self.separatorInset = config.separatorInset ?? UIEdgeInsetsZero
		_ = config.indentationLevel.map { self.indentationLevel = $0 }
		_ = config.indentationWidth.map { self.indentationWidth = $0 }
	}
	
	func viewFor(_ nibName : String?) -> UIView? {
		guard let nibName = nibName else {
			return nil
		}
		
		let views = Bundle.main().loadNibNamed(nibName, owner: self, options: nil)
		return views.first as? UIView
	}	
}
