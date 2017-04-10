//
//  CGRect+Utils.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 8/6/16.
//
//

import UIKit

public enum CGRectFitMode {
	case scaleToFill
	case aspectFit
	case aspectFill
}

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
	
	static func from(_ size: CGSize) -> CGRect {
		var rect = CGRect.zero
		rect.size = size
		return rect
	}
	
	static public func rect(toFit rect: CGRect, toContainer container: CGRect, mode: CGRectFitMode = .aspectFit, allowScaleUp: Bool = true) -> CGRect {
	
		var x: CGFloat = 0
		var y: CGFloat = 0
		var width = rect.width
		var height = rect.height
		
		let aspectRatio = rect.width/rect.height
		
		switch mode {
			case .aspectFill:
				height = container.height
				width = height*aspectRatio
				if width<container.width {
					width = container.width
					height = rect.height/rect.width
					x = 0
					y = (container.height - height)/2
				}
				else {
					y = 0
					x = (container.width - width)/2
				}
			
			case .aspectFit:
				height = container.height
				width = height*aspectRatio
				if width>container.width {
					width = container.width
					height = width/aspectRatio
					x = 0
					y = (container.height - height)/2
				}
				else {
					y = 0
					x = (container.width - width)/2
				}
			case .scaleToFill:
				return container

		}
		
		if (width > rect.width || height > rect.height) && !allowScaleUp {
			x = (container.width - width)/2;
			y = (container.height - height)/2;
			width = rect.width
			height = rect.height
		}
	
		return CGRect(x: x, y: y, width: width, height: height)
	}
}
