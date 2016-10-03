//
//  Functor.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 21/7/16.
//
//

import Foundation

infix operator <^>: Additive

public func <^><T, U>(_ f: (T) -> U, a: T?) -> U? {
    return a.map(f)
}

