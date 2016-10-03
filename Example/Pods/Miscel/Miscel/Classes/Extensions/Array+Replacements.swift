//
//  Array+Replacements.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 8/7/16.
//
//

import Foundation

extension Array {
	public func replacing(_ with: Element, shouldReplace: (Element) -> Bool) -> Array {
		return self.map { current in
			return shouldReplace(current) ? with : current
		}
	}
	
	public func replacingOrAdding(_ with: Element, shouldReplace: (Element) -> Bool) -> Array {
		let replaced = self.replacing(with, shouldReplace: shouldReplace)
		let wasReplaced = self.filter(shouldReplace).count == 0
		
		return wasReplaced ? replaced : replaced + [with]
	}
}
