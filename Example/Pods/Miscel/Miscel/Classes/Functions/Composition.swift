//
//  Composition.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 1/6/16.
//
//

import Foundation

// MARK: Functions
public func compose<a,b,c>(_ f: (b) -> (c), _ g: (a) -> (b) ) -> (a) -> (c) {
	return { f(g($0)) }
}

public func compose<a,b,c,d,e,f>(_ f: (c, d) -> (e, f), _ g: (a, b) -> (c, d) ) -> (a, b) -> (e, f) {
	return {
		let (c,d) = g($0, $1)
		return f(c, d)
	}
}

public func compose<a,b,c,d,e,f,g,h,i>(_ f: (d, e, f) -> (g, h, i), _ g: (a, b, c) -> (d, e, f) ) -> (a, b, c) -> (g, h, i) {
	return {
			let (v1, v2, v3) = g($0, $1, $2)
			return f(v1, v2, v3)
			}
}

public func compose<a,b,c,d,e,f,g,h,i,j,k,l>(_ f: (e, f, g, h) -> (i, j, k, l), _ g: (a, b, c, d) -> (e, f, g, h) ) -> (a, b, c, d) -> (i, j, k, l) {
	return {
			let (v1, v2, v3, v4) = g($0, $1, $2, $3)
			return f(v1, v2, v3, v4)
		}
}

// MARK: Operator
infix operator ∘ { associativity left precedence 160 }

public func ∘<a,b,c>(_ f: (b) -> (c), _ g: (a) -> (b) ) -> (a) -> (c) {
    return compose(f, g)
}

public func ∘<a,b,c,d,e,f>(_ f: (c, d) -> (e, f), _ g: (a, b) -> (c, d) ) -> (a, b) -> (e, f) {
	return compose(f, g)
}

public func ∘<a,b,c,d,e,f,g,h,i>(_ f: (d, e, f) -> (g, h, i), _ g: (a, b, c) -> (d, e, f) ) -> (a, b, c) -> (g, h, i) {
	return compose(f, g)
}

public func ∘<a,b,c,d,e,f,g,h,i,j,k,l>(_ f: (e, f, g, h) -> (i, j, k, l), _ g: (a, b, c, d) -> (e, f, g, h) ) -> (a, b, c, d) -> (i, j, k, l) {
	return compose(f, g)
}

