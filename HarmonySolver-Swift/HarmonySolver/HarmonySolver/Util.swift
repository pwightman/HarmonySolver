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

func everyTwo<T>(sequence: SequenceOf<T>, block: (T, T) -> Bool) -> Bool {
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

func zip<T,U>(first: [T], second: [U]) -> [(T,U)] {
    var list: [(T,U)] = []
    for (i, el) in enumerate(first) {
        list.append(el, second[i])
    }
    return list
}

func any<T>(array: [T], block: T -> Bool) -> Bool {
    for el in array {
        if block(el) {
            return true
        }
    }
    return false
}

func all<T>(array: [T], block: T -> Bool) -> Bool {
    for el in array {
        if !block(el) {
            return false
        }
    }
    return true
}

func rest<T>(array: [T]) -> [T] {
    var new: [T] = []
    for i in 1..<array.count {
        new.append(array[i])
    }
    return new
}

func find<T>(array: [T], block: T -> Bool) -> T? {
    for el in array {
        if block(el) {
            return el
        }
    }
    return nil
}

struct PermutationGenerator<T> : GeneratorType {
    private let sequences: [SequenceOf<T>]
    private var generator: GeneratorOf<[T]>?

    init(sequences: [SequenceOf<T>]) {
        self.sequences = sequences
        switch sequences.count {
        case 0: self.generator = nil
        case 1:
            var generator = sequences.first?.generate()
            self.generator = GeneratorOf {
                if let el = generator?.next() {
                    return [el]
                } else {
                    return nil
                }
            }
        default:
            var newSequences: [SequenceOf<T>] = rest(self.sequences)
            var restGenerator = PermutationGenerator(sequences: newSequences)
            var firstGenerator = self.sequences[0].generate()
            var currentRestElement = restGenerator.next()
            var currentFirstElement = firstGenerator.next()
            self.generator = GeneratorOf {
                switch (currentFirstElement, currentRestElement) {
                case (.Some(let first), .Some(let rest)):
                    currentFirstElement = firstGenerator.next()
                    return rest + [first]
                case (.None, .Some(let rest)):
                    firstGenerator = self.sequences.first!.generate()
                    currentRestElement = restGenerator.next()
                    if let el = firstGenerator.next(), restEl = currentRestElement {
                        currentFirstElement = firstGenerator.next()
                        return restEl + [el]
                    } else {
                        return nil
                    }
                case (.Some, .None), (.None, .None): return nil
                }
            }
        }
    }

    mutating func next() -> [T]? {
        return generator?.next()
    }
}