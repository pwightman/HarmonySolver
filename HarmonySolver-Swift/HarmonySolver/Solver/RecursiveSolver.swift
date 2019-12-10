//
//  RecursiveSolver.swift
//  HarmonySolver
//
//  Created by Parker Wightman on 2/28/15.
//  Copyright (c) 2015 Alora Studios. All rights reserved.
//

import Foundation

public struct RecursiveSolver<S : Sequence> : Sequence where S.Element == FourPartChord {
    public let enumerators: [S]
    public let chordConstraint: ChordConstraint
    public let adjacentChordConstraint: AdjacentChordConstraint

    public init(enumerators: [S], chordConstraint: @escaping ChordConstraint, adjacentConstraint: @escaping AdjacentChordConstraint) {
        self.enumerators = enumerators
        self.chordConstraint = chordConstraint
        self.adjacentChordConstraint = adjacentConstraint
    }

    private func findMatch(_ currentChord: FourPartChord, restChords: [[FourPartChord]]) -> [FourPartChord]? {
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
    
    public func makeIterator() -> AnyIterator<[FourPartChord]> {
        let arrays = enumerators.map {
            $0.filter(self.chordConstraint)
        }
        return IteratorOf(block: {
            if let array = arrays.first {
                for el in array {
                    if let match = self.findMatch(el, restChords: rest(arrays)) {
                        return match
                    }
                }
            }
            return nil
        }).anyIterator()
    }
}
