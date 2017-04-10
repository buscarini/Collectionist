//
//  String.swift
//  Miscel
//
//  Created by Jose Manuel Sánchez Peñarroja on 11/11/15.
//  Copyright © 2015 vitaminew. All rights reserved.
//

import UIKit

public extension String {

	public static func length(_ string: String) -> Int {
		return string.characters.count
	}

	public static func empty(_ string: String) -> Bool {
		return self.length(string) == 0
	}
	
	public static func isBlank(_ string: String?) -> Bool {
		guard let string = string else { return true }
	
		return trimmed(string).characters.count == 0
	}
	
	public static func trimmed(_ string: String) -> String {
		return string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
	}
	
	public static func joined(_ components: [String?], separator: String = "\n") -> String {
		return components.flatMap {$0}
				.filter(not(isBlank))
				.joined(separator: separator)
	}
	
	public static func plainString(_ htmlString: String) -> String {
		return htmlString.withBRsAsNewLines().convertingHTMLToPlainText()
	}
	
	public static func localize(_ string: String) -> String {
		return string.localized()
	}
	
	public func localized() -> String {
		return NSLocalizedString(self, comment: "")
	}
	
	public static func wholeRange(_ string: String) -> Range<Index> {
		return string.characters.startIndex..<string.characters.endIndex
	}
	
	public static func words(_ string: String) -> [String] {
		var results : [String] = []
		string.enumerateLinguisticTags(in: self.wholeRange(string), scheme: NSLinguisticTagWord, options: [], orthography: nil) {
		
//		string.enumerateLinguisticTagsInRange(self.wholeRange(string), scheme: NSLinguisticTagWord, options: [], orthography: nil) {
			(tag, tokenRange, sentenceRange,_) in
			results.append(string.substring(with: tokenRange))
//			results.append(string.substringWithRange(tokenRange))
		}
		
		return results
	}
}
