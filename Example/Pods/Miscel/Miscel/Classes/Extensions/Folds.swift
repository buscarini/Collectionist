//
//  Folds.swift
//  Miscel
//
//  Created by Jose Manuel Sánchez Peñarroja on 5/11/15.
//  Copyright © 2015 vitaminew. All rights reserved.
//

import Foundation

public extension Collection {
	
//	func reduce1(f:(Self.Generator.Element,Self.Generator.Element) -> Self.Generator.Element)(_ xs:[Self.Generator.Element]) -> Self.Generator.Element? {
//		return self.first.map { x in
//			self.tail().reduce(x, f)
//		}
//	}
	
	public func head() -> Self.Iterator.Element? {
		return self.first
	}
	
	public func tail() -> Self.SubSequence {
		let secondIndex = self.index(after: self.startIndex)

		return self.suffix(from: secondIndex)
	}
	
	public func foldr<B>(_ accm:B, f: @escaping (Self.Iterator.Element, B) -> B) -> B {
		var g = self.makeIterator()
		func next() -> B {
			return g.next().flatMap {x in f(x, next())} ?? accm
		}
		return next()
	}
	
	public func foldl<B>(_ accm:B, f: (Self.Iterator.Element, B) -> B) -> B {
		var result = accm
		for temp in self {
			result = f(temp, result)
		}
		return result
	}	
}

