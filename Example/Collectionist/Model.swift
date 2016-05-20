//
//  Model.swift
//  Collectionist
//
//  Created by José Manuel Sánchez Peñarroja on 11/5/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

struct Model {
	var name: String
	var text: String
}

extension Model : Hashable {
    var hashValue: Int {
		return "\(name),\(text)".hashValue
	}
}

extension Model: Equatable {}
func ==(lhs: Model, rhs: Model) -> Bool {
	return lhs.hashValue == rhs.hashValue
}

extension Model {
	static func exampleModels() -> [Model] {
		return Array(1...100).map { index in
			let numChars = Int(arc4random_uniform(10000) + 100)
		
			let string = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
			
			let substring = string.substringToIndex(string.startIndex.advancedBy(min(numChars,string.characters.count-1)))
		
			return Model(name: "model \(index)", text: substring)
		}
	}
}

