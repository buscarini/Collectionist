//
//  LayoutUtils.swift
//  cibo
//
//  Created by Jose Manuel Sánchez Peñarroja on 15/10/15.
//  Copyright © 2015 treenovum. All rights reserved.
//

import UIKit

struct Layout {
	static func fill(container: UIView, view : UIView, priority: UILayoutPriority = UILayoutPriorityRequired) {
		Layout.fillH(container, view: view, priority: priority)
		Layout.fillV(container, view: view, priority: priority)
	}
	
	static func fillV(container: UIView, view : UIView, priority: UILayoutPriority = UILayoutPriorityRequired) {
		let constraints : [NSLayoutConstraint]
		
		constraints = [
			container.topAnchor.constraintEqualToAnchor(view.topAnchor),
			container.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)
		]
		
		for constraint in constraints {
			constraint.priority = priority
		}
		
		container.addConstraints(constraints)
	}

	static func fillH(container: UIView, view : UIView, priority: UILayoutPriority = UILayoutPriorityRequired) {
		let constraints : [NSLayoutConstraint]
		
		constraints = [
			container.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
			container.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor)
		]
	
		for constraint in constraints {
			constraint.priority = priority
		}
		
		container.addConstraints(constraints)

	}
		
	static func equal(view1: UIView,view2 : UIView, attribute: NSLayoutAttribute, multiplier : CGFloat = 1, constant : CGFloat = 0, priority : UILayoutPriority = UILayoutPriorityRequired) -> NSLayoutConstraint {
		let constraint = NSLayoutConstraint(item: view1, attribute: attribute, relatedBy: .Equal, toItem: view2, attribute: attribute, multiplier: multiplier, constant: constant)
		constraint.priority = priority
		return constraint
	}

	static func equal(view : UIView, attribute: NSLayoutAttribute, constant : CGFloat, priority : UILayoutPriority = UILayoutPriorityRequired) -> NSLayoutConstraint {
		let constraint = NSLayoutConstraint(item: view, attribute: attribute, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: constant)
		constraint.priority = priority
		return constraint
	}
}