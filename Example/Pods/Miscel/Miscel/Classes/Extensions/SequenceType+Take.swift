//
//  SequenceType+Take.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 8/6/16.
//
//

import Foundation

extension Sequence where SubSequence : Sequence, SubSequence.Iterator.Element == Iterator.Element, SubSequence.SubSequence == SubSequence {

	func takeFirst(n: Int = 1) -> AnySequence<Self.Iterator.Element> {
		return self.prefix(n)
	}
	
	func takeLast(n: Int = 1) -> AnySequence<Self.Iterator.Element> {
		return self.suffix(n)
	}
}

