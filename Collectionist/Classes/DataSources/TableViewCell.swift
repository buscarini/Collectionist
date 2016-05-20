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
		super.init(style: .Default, reuseIdentifier: reuseId)
	}
	
	public func fill(value: Any?) {
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
				Layout.fill(self.contentView,view: subview)
			}
		}
		
		if let fillable = subview as? Fillable {
			fillable.fill(listItem.value)
		}	
	}
	
	func viewFor(nibName : String?) -> UIView? {
		guard let nibName = nibName else {
			return nil
		}
		
		if let views = NSBundle.mainBundle().loadNibNamed(nibName, owner: self, options: nil) {
			return views.first as? UIView
		}
		
		return nil
	}	
}
