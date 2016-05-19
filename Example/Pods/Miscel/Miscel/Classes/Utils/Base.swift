//
//  Base.swift
//  OnePodcast
//
//  Created by Jose Manuel Sánchez Peñarroja on 1/11/15.
//  Copyright © 2015 vitaminew. All rights reserved.
//

import Foundation

public func compose<a,b,c>(f: (b) -> (c), _ g: (a) -> (b) ) -> (a) -> (c) {
	return { f(g($0)) }
}

public func negate<a>(f: (a)->(Bool)) -> (a) -> Bool {
	return { !f($0) }
}

public func and<a>(f: (a) -> (Bool), g: (a) -> (Bool) ) -> (a) -> (Bool) {
	return { f($0) && g($0) }
}

public func and<a>(fs: [(a) -> (Bool)] ) -> (a) -> (Bool) {
	return { (input: a) -> Bool in
		fs.reduce(true, combine: { (result, f: (a) -> Bool) -> Bool in
			return result && f(input)
		})
	}
}
