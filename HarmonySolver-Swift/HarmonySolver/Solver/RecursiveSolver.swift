//
//  RecursiveSolver.swift
//  HarmonySolver
//
//  Created by Parker Wightman on 2/28/15.
//  Copyright (c) 2015 Alora Studios. All rights reserved.
//

import Foundation

public struct RecursiveSolver<S : SequenceType where S.Generator.Element == FourPartChord> : SequenceType {
    public let enumerators: [S]
    public let chordConstraint: ChordConstraint
    public let adjacentChordConstraint: AdjacentChordConstraint

    public init(enumerators: [S], chordConstraint: ChordConstraint, adjacentConstraint: AdjacentChordConstraint) {
        self.enumerators = enumerators
        self.chordConstraint = chordConstraint
        self.adjacentChordConstraint = adjacentConstraint
    }

    private func findMatch(var currentChord: FourPartChord, var restChords: [[FourPartChord]]) -> [FourPartChord]? {
        if let chords = restChords.first {
            for chord in chords {
                if self.adjacentChordConstraint(currentChord, chord),
                    let match = self.findMatch(chord, restChords: rest(restChords)) {
                        return [currentChord] + match
                }
            }
            return nil
        } else {
            return [currentChord]
        }

    }

    public func generate() -> GeneratorOf<[FourPartChord]> {
        var arrays = map(enumerators) {
            filter($0, self.chordConstraint)
        }
        return GeneratorOf {
            if let array = arrays.first {
                for el in array {
                    if let match = self.findMatch(el, restChords: rest(arrays)) {
                        return match
                    }
                }
            } else {
                return nil
            }
            return nil
        }
    }
}