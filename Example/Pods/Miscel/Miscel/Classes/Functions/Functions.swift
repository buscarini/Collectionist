//
//  Base.swift
//  Miscel
//
//  Created by Jose Manuel Sánchez Peñarroja on 1/11/15.
//  Copyright © 2015 vitaminew. All rights reserved.
//

import Foundation

public func with<T>(constant: T, update: @noescape(inout T) throws ->() ) rethrows -> T {
	var variable = constant
	try update(&variable)
	return variable
}

public func delay(time: TimeInterval, closure: () -> ()) {
	var dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
	DispatchQueue.main.after(when: dispatchTime, execute: closure)
}
