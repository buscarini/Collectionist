//
//  Sequence+Equatable.swift
//  Miscel
//
//  Created by José Manuel Sánchez Peñarroja on 27/4/16.
//
//

import Foundation

public func ==<T: Equatable>(lhs: [T]?, rhs: [T]?) -> Bool {
    switch (lhs, rhs) {
    case (.some(let lhs), .some(let rhs)):
        return lhs == rhs
    case (nil, nil):
        return true
    default:
        return false
    }
}

