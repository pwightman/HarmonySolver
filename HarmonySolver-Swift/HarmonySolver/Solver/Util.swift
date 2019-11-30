//
//  Util.swift
//  HarmonySolver
//
//  Created by Parker Wightman on 2/14/15.
//  Copyright (c) 2015 Alora Studios. All rights reserved.
//

import Foundation

func *(lhs: String, rhs: Int) -> String {
    return (1..<rhs).reduce(lhs) { s, e in return s + lhs }
}

public func &(lhs: @escaping ChordConstraint, rhs: @escaping ChordConstraint) -> ChordConstraint {
    return { t in return lhs(t) && rhs(t) }
}

public func &(lhs: @escaping AdjacentChordConstraint, rhs: @escaping AdjacentChordConstraint) -> AdjacentChordConstraint {
    return { t, v in return lhs(t, v) && rhs(t, v) }
}

extension Array {
    func shuffled() -> [Element] {
        var list = self
        for i in 0..<(list.count - 1) {
            let j = Int(arc4random_uniform(UInt32(list.count - i))) + i
            list.swapAt(i, j)
        }
        return list
    }
}

func everyTwo<S : Sequence>(_ sequence: S, block: (S.Element, S.Element) -> Bool) -> Bool {
    var generator = sequence.makeIterator()
    var first = generator.next()
    var second = generator.next()
    while let f = first, let s = second {
        if !block(f, s) {
            return false
        }
        first = second
        second = generator.next()
    }
    return true
}

func any<S : Sequence>(_ sequence: S, block: (S.Element) -> Bool) -> Bool {
    for el in sequence {
        if block(el) {
            return true
        }
    }
    return false
}

func all<S : Sequence>(_ sequence: S, block: (S.Element) -> Bool) -> Bool {
    for el in sequence {
        if !block(el) {
            return false
        }
    }
    return true
}

// TODO: replace usages with dropFirst()
func rest<S : Sequence>(_ sequence: S) -> [S.Element] {
    var new: [S.Element] = []
    var generator = sequence.makeIterator()
    _ = generator.next()
    while let el = generator.next() {
        new.append(el)
    }
    return new
}

func find<S : Sequence>(_ sequence: S, block: (S.Element) -> Bool) -> S.Element? {
    for el in sequence {
        if block(el) {
            return el
        }
    }
    return nil
}

