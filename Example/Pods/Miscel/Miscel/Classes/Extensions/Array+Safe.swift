//
//  Array+Safe.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 7/11/16.
//
//

import Foundation

/// Use as array[safe:3]
extension Array {
    subscript (safe index: UInt) -> Element? {
        return Int(index) < count ? self[Int(index)] : nil
    }
}
