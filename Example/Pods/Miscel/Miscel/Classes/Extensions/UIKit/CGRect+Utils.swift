//
//  CGRect+Utils.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 8/6/16.
//
//

import UIKit

public extension CGRect {
	public var x: CGFloat {
		return self.origin.x
	}
	
	public var y: CGFloat {
		return self.origin.y
	}
	
	public var width: CGFloat {
		return self.size.width
	}
	
	public var height: CGFloat {
		return self.size.height
	}
}
