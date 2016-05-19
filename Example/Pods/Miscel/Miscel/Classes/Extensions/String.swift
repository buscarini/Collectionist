//
//  String.swift
//  OnePodcast
//
//  Created by Jose Manuel Sánchez Peñarroja on 11/11/15.
//  Copyright © 2015 vitaminew. All rights reserved.
//

import UIKit

public extension String {
	public static func empty(string: String) -> Bool {
		return string.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0
	}
	
	public static func plainString(htmlString: String) -> String {
		return htmlString.stringWithBRsAsNewLines().stringByConvertingHTMLToPlainText()
	}
	
	public static func localize(string: String) -> String {
		return string.localized()
	}
	
	public func localized() -> String {
		return NSLocalizedString(self, comment: "")
	}
	
	public static func wholeRange(string: String) -> Range<Index> {
		return string.startIndex..<string.endIndex
	}
	
	public static func words(string: String) -> [String] {
		var results : [String] = []
		string.enumerateLinguisticTagsInRange(self.wholeRange(string), scheme: NSLinguisticTagWord, options: [], orthography: nil) {
			(tag, tokenRange, sentenceRange,_) in
			results.append(string.substringWithRange(tokenRange))
		}
		
		return results
	}
}
