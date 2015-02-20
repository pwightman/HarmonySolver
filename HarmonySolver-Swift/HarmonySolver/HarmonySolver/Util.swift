//
//  Util.swift
//  HarmonySolver
//
//  Created by Parker Wightman on 2/14/15.
//  Copyright (c) 2015 Alora Studios. All rights reserved.
//

import Foundation

func *(lhs: String, rhs: Int) -> String {
    return reduce(1..<rhs, lhs) { s, e in return s + lhs }
}

func &<T>(lhs: T -> Bool, rhs: T -> Bool) -> T -> Bool {
    return { t in return lhs(t) && rhs(t) }
}

func everyTwo<S : SequenceType>(sequence: S, block: (S.Generator.Element, S.Generator.Element) -> Bool) -> Bool {
    var generator = sequence.generate()
    var first = generator.next()
    var second = generator.next()
    while let f = first, s = second {
        if !block(f, s) {
            return false
        }
        first = second
        second = generator.next()
    }
    return true
}

func any<S : SequenceType>(sequence: S, block: S.Generator.Element -> Bool) -> Bool {
    for el in sequence {
        if block(el) {
            return true
        }
    }
    return false
}

func all<S : SequenceType>(sequence: S, block: S.Generator.Element -> Bool) -> Bool {
    for el in sequence {
        if !block(el) {
            return false
        }
    }
    return true
}

func rest<S : SequenceType>(sequence: S) -> [S.Generator.Element] {
    var new: [S.Generator.Element] = []
    var generator = sequence.generate()
    generator.next()
    while let el = generator.next() {
        new.append(el)
    }
    return new
}

func find<S : SequenceType>(sequence: S, block: S.Generator.Element -> Bool) -> S.Generator.Element? {
    for el in sequence {
        if block(el) {
            return el
        }
    }
    return nil
}

