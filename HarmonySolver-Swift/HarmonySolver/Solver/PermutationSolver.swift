//
//  PermutationSolver.swift
//  HarmonySolver
//
//  Created by Parker Wightman on 2/28/15.
//  Copyright (c) 2015 Alora Studios. All rights reserved.
//

import Foundation

public struct PermutationSolver : SolverStrategy {
    public let enumerators: [ChordEnumerator]
    public let chordConstraint: ChordConstraint
    public let adjacentChordConstraint: AdjacentChordConstraint

    public init(enumerators: [ChordEnumerator], chordConstraint: @escaping ChordConstraint, adjacentConstraint: @escaping AdjacentChordConstraint) {
        self.enumerators = enumerators
        self.chordConstraint = chordConstraint
        self.adjacentChordConstraint = adjacentConstraint
    }

    public func makeIterator() -> AnyIterator<[FourPartChord]> {
        let arrays = enumerators.map {
            Array($0).filter {
                return self.chordConstraint($0)
            }
        }
        var generator = PermutationGenerator(sequences: arrays.reversed())
        return IteratorOf(block: {
            while let chords = generator.next() {
                let adjacentPassed = everyTwo(chords, block: self.adjacentChordConstraint)
                if adjacentPassed {
                    return chords
                }
            }
            return nil
        }).anyIterator()
    }
}
