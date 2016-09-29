//
//  Dictionary+Utils.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 16/6/16.
//
//

import Foundation

public protocol OptionalType {
    associatedtype T
    func intoOptional() -> T?  
}  

extension Optional: OptionalType {
    public func intoOptional() -> Wrapped? {
        return self.flatMap {$0}
    }  
}

public extension Dictionary where Value: OptionalType {
	public func compact() -> Dictionary<Key,Value.T> {
		var dic = Dictionary<Key,Value.T>()
		for (key, value) in self {
			if let optional = value.intoOptional() {
				dic[key] = optional
			}
			else {
				dic.removeValue(forKey: key)
			}
		}
		return dic
	}
}
