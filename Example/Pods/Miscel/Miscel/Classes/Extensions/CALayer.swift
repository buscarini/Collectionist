//
//  CALayer.swift
//  Miscel
//
//  Created by Jose Manuel Sánchez Peñarroja on 17/11/15.
//  Copyright © 2015 vitaminew. All rights reserved.
//

import UIKit

open class NullAction: CAAction {
	public func run(forKey event: String, object anObject: Any, arguments dict: [AnyHashable : Any]?) {
		
	}
}

public extension CALayer {
	public static func disableAnimations(_ layer: CALayer) {
		layer.actions = [
			"frame" : NullAction(),
			"bounds" : NullAction(),
			"position" : NullAction(),
			"backgroundColor" : NullAction(),
			"opacity" : NullAction()
		]
	}
	
	public static func performWithoutAnimation(_ block: ()->()) {
		CATransaction.begin()
		CATransaction.disableActions()
		block()
		CATransaction.commit()
	}
}
