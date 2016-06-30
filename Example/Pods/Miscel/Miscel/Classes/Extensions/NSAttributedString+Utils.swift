//
//  NSAttributedString+Utils.swift
//  Miscel
//
//  Created by Jose Manuel Sánchez Peñarroja on 11/11/15.
//  Copyright © 2015 vitaminew. All rights reserved.
//

import Foundation

extension AttributedString {

	 public func trimmed(set: CharacterSet) -> AttributedString {
		let result = self.mutableCopy()
	
        // Trim leading characters from character set.
		while true {
			let range = (result.string as NSString).rangeOfCharacter(from: set)
			
			guard range.length != 0 && range.location == 0 else {
				break
			}
			
			result.replaceCharacters(in: range, with: "")
		}

        // Trim trailing characters from character set.
		while true {
			let range = (result.string as NSString).rangeOfCharacter(from: set, options: .backwardsSearch)
			
			guard range.length != 0 && NSMaxRange(range) == result.length else {
				break
			}
			
			result.replaceCharacters(in: range, with: "")
		}
		
		return result as! AttributedString
    }
}

public func +(left: AttributedString, right: AttributedString) -> AttributedString {
	let result = NSMutableAttributedString()
	
	result.append(left)
	result.append(right)
	
	return result
}

