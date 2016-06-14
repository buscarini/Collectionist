//
//  ListHeaderFooter+Utils.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 14/6/16.
//
//

import UIKit

import Miscel

public extension ListHeaderFooter {
	public func createView(owner: NSObject) -> UIView? {
		let view = NSBundle.loadView(self.nibName, owner: owner)
		
		if let fillable = view as? Fillable {
			fillable.fill(self.value)
		}
		
		return view
	}
}
