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
struct PermutationGenerator<S : SequenceType> : GeneratorType {
    private let sequences: [S]
    private var generator: GeneratorOf<[S.Generator.Element]>?

    init(sequences: [S]) {
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
            var restGenerator = PermutationGenerator(sequences: rest(self.sequences))
            var firstGenerator = self.sequences[0].generate()
            var currentRestElement = restGenerator.next()
            var currentFirstElement = firstGenerator.next()
            self.generator = GeneratorOf {
                switch (currentFirstElement, currentRestElement) {
                // While there are elements left in our single-element generator, iterate over it
                case (.Some(let first), .Some(let rest)):
                    currentFirstElement = firstGenerator.next()
                    return rest + [first]
                // If we run out of single-element items, reset its generator and increment the
                // `restGenerator`
                case (.None, .Some(let rest)):
                    firstGenerator = self.sequences.first!.generate()
                    currentRestElement = restGenerator.next()
                    if let el = firstGenerator.next(), restEl = currentRestElement {
                        currentFirstElement = firstGenerator.next()
                        return restEl + [el]
                    } else {
                        return nil
                    }
                    // Once the rest generator, or both, have run out, there's no more permutations
                case (.Some, .None), (.None, .None): return nil
                }
            }
        }
    }

    mutating func next() -> [S.Generator.Element]? {
        return generator?.next()
    }
}