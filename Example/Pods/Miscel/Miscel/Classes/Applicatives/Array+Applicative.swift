//
//  Array+Applicative.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 21/7/16.
//
//

import Foundation

extension Array {
    public func apply<U>(_ fs: [(Element) -> U]) -> [U] {
        var result = [U]()
        for f in fs {
            for element in self.map(f) {
                result.append(element)
            }
        }
        return result
    }
}
//public func <*><T0, T1>(lhs: [T0 -> T1], rhs: [T0]) -> [T1] {
//    return lhs.flatMap { f in rhs.map(f) }
//}

//infix operator <*> { associativity left precedence }
public func <*><T, U>(_ f: [(T) -> U], _ a: [T]) -> [U] {
    return a.apply(f)
}


