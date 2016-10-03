//
//  Array+Split.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 20/7/16.
//
//

import Foundation

extension Array {
	public func split(accept: (Element) -> Bool) -> (Array, Array) {
		return self.reduce( (Array<Element>(),Array<Element>())
			, { acc, item in
			var (accepted, rejected) = acc
			
			accept(item) ? accepted.append(item) : rejected.append(item)
			
			return (accepted, rejected)
		})
	}
}

