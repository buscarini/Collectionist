//
//  UIView.swift
//  Miscel
//
//  Created by Jose Manuel Sánchez Peñarroja on 10/11/15.
//  Copyright © 2015 vitaminew. All rights reserved.
//

import UIKit

import Layitout

// MARK: Subviews
public extension UIView {
	public static func removeAllSubviews(_ view: UIView) {
		view.removeSubviews(view.subviews)
	}
	
	public func removeAllSubviews() {
		UIView.removeAllSubviews(self)
	}
	
	public func removeSubviews(_ views: [UIView]) {
		for subview in views {
			subview.removeFromSuperview()
		}
	}
	
	public static func addSubviews(_ view: UIView, subviews: [UIView]) {
		for subview in subviews {
			view.addSubview(subview)
		}
	}
	
	public func addSubviews(_ subviews: [UIView]) {
		UIView.addSubviews(self, subviews: subviews)
	}
	
	public static func replaceSubviews(_ view: UIView, subviews: [UIView]) {
		UIView.removeAllSubviews(view)
		UIView.addSubviews(view, subviews: subviews)
	}
	
	public func replaceSubviews(_ subviews: [UIView]) {
		UIView.replaceSubviews(self, subviews: subviews)
	}
	
	public func size(forWidth: CGFloat) -> CGSize {
		return self.systemLayoutSizeFitting(CGSize(width: forWidth, height: UILayoutFittingCompressedSize.height))
	}
}

// MARK: Properties
public extension UIView {
	public var x: CGFloat {
		return self.frame.x
	}
	
	public var y: CGFloat {
		return self.frame.y
	}
	
	public var width: CGFloat {
		return self.frame.width
	}
	
	public var height: CGFloat {
		return self.frame.height
	}
}

// MARK: Corners
public extension UIView {
	public func roundCorners(_ radius: CGFloat? = nil) {
		self.layer.cornerRadius = radius ?? min(self.width/4.0, self.height/4.0)
		self.layer.masksToBounds = true
	}
}
