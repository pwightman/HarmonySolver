//
//  HarmonySolver.swift
//  HarmonySolver
//
//  Created by Parker Wightman on 2/14/15.
//  Copyright (c) 2015 Alora Studios. All rights reserved.
//

import Foundation


typealias ChordConstraint = FourPartChord -> Bool
typealias AdjacentChordConstraint = (FourPartChord, FourPartChord) -> Bool

let noParallelFifthsConstraint: AdjacentChordConstraint = { first, second in
    return !any(zip(first.values, second.values)) { pair in
        let hasParallelFifth: (Note, [Note]) -> Bool = { item, rest in
            any(rest) {
                let difference = (item.absoluteValue % 12) - ($0.absoluteValue % 12)
                return abs(difference) == 5 || abs(difference) == 7
            }
        }

        if hasParallelFifth(pair.0, first.values) && hasParallelFifth(pair.1, second.values) {
            return true
        }
        return false
    }
}

let smallJumpsConstraint: Int -> AdjacentChordConstraint = { interval in
    return { first, second in
        return all(zip(first.values, second.values)) { pair in
            return abs(pair.0.absoluteValue - pair.1.absoluteValue) <= interval
        }
    }
}

let noVoiceCrossingConstraint: ChordConstraint = { chord in
    return chord.bass < chord.tenor &&
        chord.tenor < chord.alto &&
        chord.alto < chord.soprano
}

let completeChordConstraint: ChordConstraint = { chord in
    Set(chord.values.map {
        $0.absoluteValue % 12
    }).count == chord.chord.semitones.count
}

let allowRootNotes: [Int] -> ChordConstraint = { intervals in
    return { chord in
        return any(intervals) {
            NoteType(fromValue: $0) == chord.transposedTo(.C).bass.noteType
        }
    }
}

let noMoreThanOneOctaveBetweenVoices: ChordConstraint = { chord in
    let first = chord.tenor.absoluteValue - chord.bass.absoluteValue < 12
    let second = chord.alto.absoluteValue - chord.tenor.absoluteValue < 12
    let third = chord.soprano.absoluteValue - chord.alto.absoluteValue < 12
    return first && second && third
}

protocol SolverStrategy : SequenceType {
    var enumerators: [ChordEnumerator] { get }
    var chordConstraint: ChordConstraint { get }
    var adjacentChordConstraint: AdjacentChordConstraint  { get }
}

struct PermutationSolver : SolverStrategy {
    let enumerators: [ChordEnumerator]
    let chordConstraint: ChordConstraint
    let adjacentChordConstraint: AdjacentChordConstraint

    init(enumerators: [ChordEnumerator], chordConstraint: ChordConstraint, adjacentConstraint: AdjacentChordConstraint) {
        self.enumerators = enumerators
        self.chordConstraint = chordConstraint
        self.adjacentChordConstraint = adjacentConstraint
    }

    func generate() -> GeneratorOf<[FourPartChord]> {
        var arrays = enumerators.map {
            Array($0).filter {
                return self.chordConstraint($0)
            }
        }
        var generator = PermutationGenerator(sequences: arrays.reverse())
        return GeneratorOf {
            while let chords = generator.next() {
                let adjacentPassed = everyTwo(SequenceOf(chords), self.adjacentChordConstraint)
                if adjacentPassed {
                    return chords
                }
            }
            return nil
        }
    }
}

struct RecursiveSolver : SolverStrategy {
    let enumerators: [ChordEnumerator]
    let chordConstraint: ChordConstraint
    let adjacentChordConstraint: AdjacentChordConstraint

    init(enumerators: [ChordEnumerator], chordConstraint: ChordConstraint, adjacentConstraint: AdjacentChordConstraint) {
        self.enumerators = enumerators
        self.chordConstraint = chordConstraint
        self.adjacentChordConstraint = adjacentConstraint
    }

    func findMatch(var currentChords: GeneratorOf<FourPartChord>, var restChords: [GeneratorOf<FourPartChord>]) -> [(FourPartChord, GeneratorOf<FourPartChord>)]? {
        if var otherChords = restChords.first {
            while let currentChord = currentChords.next() {
                while let otherChord = otherChords.next() {
                    if self.adjacentChordConstraint(currentChord, otherChord) {
                        if let match = self.findMatch(otherChords, restChords: rest(restChords)) {
                            return [(currentChord, currentChords)] + match
                        }
                    }
                }
            }
        } else {
            if let chord = currentChords.next() {
                return [(chord, currentChords)]
            }
        }
        return nil
    }

    func generate() -> GeneratorOf<[FourPartChord]> {
        var arrays = enumerators.map {
            Array($0).filter {
                return self.chordConstraint($0)
            }
        }.map { GeneratorOf($0.generate()) }
        return GeneratorOf {
            if let array = arrays.first {
                if let match = self.findMatch(array, restChords: rest(arrays)) {
                    return match.map { $0.0 }
                }
            } else {
                return nil
            }
            return nil
        }
    }
}