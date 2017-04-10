//
//  UIView+Utils.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 18/5/16.
//
//

import UIKit

public extension UIView {
	public static func fill(_ container: UIView, subview: UIView, margins: UIEdgeInsets = UIEdgeInsets.zero) {
		container.addSubview(subview)
		subview.translatesAutoresizingMaskIntoConstraints = false
		Layout.fill(container: container, view: subview, priority: UILayoutPriorityRequired, margins: margins)
	}
	
	func fill(subview: UIView, margins: UIEdgeInsets = UIEdgeInsets.zero) {
		UIView.fill(self, subview: subview, margins: margins)
	}
}
