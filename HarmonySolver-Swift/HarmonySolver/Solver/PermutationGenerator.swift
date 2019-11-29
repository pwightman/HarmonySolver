//
//  PermutationGenerator.swift
//  HarmonySolver
//
//  Created by Parker Wightman on 2/16/15.
//  Copyright (c) 2015 Alora Studios. All rights reserved.
//

import Foundation

/*

Given an array of sequences of size N, generates all permutations of objects from
each sequence. Generation is lazy and suitable for infinite sequences. For finite sequences,
the number of output arrays produced is equal to the product of the lengths of each input 
sequence. For a concrete example, given the following two arrays:

  let a: [1, 2, 3]
  let b: ["a", "b"]

  while let array = PermutationGenerator(sequences: [a, b].map { SequenceOf($0) }) {
      println(array)
  }

The following would print:

[1, "a"]
[2, "a"]
[3, "a"]
[1, "b"]
[2, "b"]
[3, "b"]

*/
struct IteratorOf<E>: IteratorProtocol {
    typealias Element = E
    
    let block: () -> E?
    
    mutating func next() -> E? {
        return block()
    }
}

extension IteratorProtocol {
    func anyIterator() -> AnyIterator<Element> {
        return AnyIterator(self)
    }
}

struct PermutationGenerator<S : Sequence> : IteratorProtocol {
    private let sequences: [S]
    private var generator: AnyIterator<[S.Element]>?

    init(sequences: [S]) {
        self.sequences = sequences
        switch sequences.count {
        case 0: self.generator = nil
        case 1:
            var generator = sequences.first?.makeIterator()
            
            self.generator = IteratorOf(block: {
                if let el = generator?.next() {
                    return [el]
                } else {
                    return nil
                }
            }).anyIterator()
        default:
            var restGenerator = PermutationGenerator(sequences: rest(self.sequences))
            var firstGenerator = self.sequences[0].makeIterator()
            var currentRestElement = restGenerator.next()
            var currentFirstElement = firstGenerator.next()
            let sequences = self.sequences
            self.generator = IteratorOf(block: {
                switch (currentFirstElement, currentRestElement) {
                // While there are elements left in our single-element generator, iterate over it
                case (.some(let first), .some(let rest)):
                    currentFirstElement = firstGenerator.next()
                    return rest + [first]
                // If we run out of single-element items, reset its generator and increment the
                // `restGenerator`
                case (.none, .some(_)):
                    firstGenerator = sequences.first!.makeIterator()
                    currentRestElement = restGenerator.next()
                    if let el = firstGenerator.next(), let restEl = currentRestElement {
                        currentFirstElement = firstGenerator.next()
                        return restEl + [el]
                    } else {
                        return nil
                    }
                    // Once the rest generator, or both, have run out, there's no more permutations
                case (.some(_), .none), (.none, .none): return nil
                }
            }).anyIterator()
        }
    }

    mutating func next() -> [S.Element]? {
        return generator?.next()
    }
}
