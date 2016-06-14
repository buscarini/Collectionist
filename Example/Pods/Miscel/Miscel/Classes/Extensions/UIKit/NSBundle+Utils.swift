//
//  NSBundle+Utils.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 14/6/16.
//
//

import UIKit

extension NSBundle {

	public static func loadView(nibName: String?, owner: AnyObject) -> UIView? {
		return NSBundle.mainBundle().loadView(nibName, owner: owner)
	}

	public func loadView(nibName : String?, owner: AnyObject) -> UIView? {
		guard let nibName = nibName else {
			return nil
		}
		
		if let views = NSBundle.mainBundle().loadNibNamed(nibName, owner: owner, options: nil) {
			return views.first as? UIView
		}
		
		return nil
	}
}

