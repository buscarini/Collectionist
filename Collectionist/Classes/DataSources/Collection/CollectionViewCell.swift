//
//  CollectionViewCell.swift
//  Collectionist
//
//  Created by Jose Manuel Sánchez Peñarroja on 15/10/15.
//  Copyright © 2015 vitaminew. All rights reserved.
//

import UIKit

import Layitout

public class CollectionViewCell<T : Equatable>: UICollectionViewCell, Fillable {
	var view : UIView?
	var nibName : String?
	
	public func fill(_ value: Any?) {
		guard let listItem = value as? ListItem<T> else {
			return
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
		
		self.nibName = listItem.nibName
	}
	
	func viewFor(_ nibName : String?) -> UIView? {
		guard let nibName = nibName else {
			return nil
		}
		
		let views = Bundle.main().loadNibNamed(nibName, owner: self, options: nil)
		return views.first as? UIView
	}
}

