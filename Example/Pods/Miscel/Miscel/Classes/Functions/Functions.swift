//
//  Base.swift
//  Miscel
//
//  Created by Jose Manuel Sánchez Peñarroja on 1/11/15.
//  Copyright © 2015 vitaminew. All rights reserved.
//

import Foundation

public func with<T>(_ constant: T, update: (inout T) throws ->() ) rethrows -> T {
	var variable = constant
	try update(&variable)
	return variable
}

public func delay(_ time: TimeInterval, closure: @escaping () -> ()) {
	let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
	DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: closure)
}
