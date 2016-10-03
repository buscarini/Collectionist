//
//  Optional+Applicative.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 21/7/16.
//
//

import Foundation

//public func <*><A, B>(lhs: (A -> B)?, rhs: A?) -> B? {
//    return lhs.flatMap { f in rhs.map(f) }
//}


extension Optional {
    public func apply<U>(_ f: ((Wrapped) -> U)?) -> U? {
        switch f {
			case .some(let someF):
				return self.map(someF)
			case nil:
				return nil
        }
    }
}

//infix operator <*>: Additive // { associativity left }
public func <*><T, U>(_ f: ((T) -> U)?, a: T?) -> U? {
    return a.apply(f)
}

