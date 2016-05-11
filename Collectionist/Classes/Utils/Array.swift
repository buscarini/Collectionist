//
//  Array.swift
//  OnePodcast
//
//  Created by Jose Manuel Sánchez Peñarroja on 29/10/15.
//  Copyright © 2015 vitaminew. All rights reserved.
//

import Foundation

func removeDups<S : SequenceType, T : Hashable where S.Generator.Element == T>(source: S) -> [T] {
	var buffer = [T]()
	var added = Set<T>()
	for elem in source {
		if !added.contains(elem) {
			buffer.append(elem)
			added.insert(elem)
		}
	}
	return buffer
}