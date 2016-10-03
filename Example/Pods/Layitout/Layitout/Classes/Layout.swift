//
//  LayoutUtils.swift
//  Miscel
//
//  Created by Jose Manuel Sánchez Peñarroja on 15/10/15.
//  Copyright © 2015 vitaminew. All rights reserved.
//

import UIKit

public struct Layout {
	public static func fill(container: UIView, view : UIView, priority: UILayoutPriority = UILayoutPriorityRequired, margins: UIEdgeInsets = UIEdgeInsets.zero) {
		Layout.fillH(container: container, view: view, priority: priority, margins: margins)
		Layout.fillV(container: container, view: view, priority: priority, margins: margins)
	}
	
	public static func fillV(container: UIView, view : UIView, priority: UILayoutPriority = UILayoutPriorityRequired, margins: UIEdgeInsets = UIEdgeInsets.zero) {
		let constraints : [NSLayoutConstraint]
		
		if #available(iOS 9.0, *) {
			constraints = [
				container.topAnchor.constraint(equalTo: view.topAnchor, constant: margins.top),
				container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: margins.bottom)
			]
		} else {
			constraints = [
				NSLayoutConstraint(item: container, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: margins.top),
				NSLayoutConstraint(item: container, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: margins.bottom)
			]
		}
		
		for constraint in constraints {
			constraint.priority = priority
		}
		
		container.addConstraints(constraints)
	}

	public static func fillH(container: UIView, view : UIView, priority: UILayoutPriority = UILayoutPriorityRequired, margins: UIEdgeInsets = UIEdgeInsets.zero) {
		let constraints : [NSLayoutConstraint]
		
		if #available(iOS 9.0, *) {
			constraints = [
				container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margins.left),
				container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: margins.right)
			]
		} else {
			constraints = [
				NSLayoutConstraint(item: container, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: margins.left),
				NSLayoutConstraint(item: container, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: margins.right),
			]
		}
		
		for constraint in constraints {
			constraint.priority = priority
		}
		
		container.addConstraints(constraints)

	}
		
	public static func equal(_ view1: UIView,view2 : UIView, attribute: NSLayoutAttribute, multiplier : CGFloat = 1, constant : CGFloat = 0, priority : UILayoutPriority = UILayoutPriorityRequired) -> NSLayoutConstraint {
		let constraint = NSLayoutConstraint(item: view1, attribute: attribute, relatedBy: .equal, toItem: view2, attribute: attribute, multiplier: multiplier, constant: constant)
		constraint.priority = priority
		return constraint
	}

	public static func equal(_ view : UIView, attribute: NSLayoutAttribute, constant : CGFloat, priority : UILayoutPriority = UILayoutPriorityRequired) -> NSLayoutConstraint {
		let constraint = NSLayoutConstraint(item: view, attribute: attribute, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: constant)
		constraint.priority = priority
		return constraint
	}
}
