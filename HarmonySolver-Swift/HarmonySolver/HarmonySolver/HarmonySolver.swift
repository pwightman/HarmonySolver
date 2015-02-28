//
//  HarmonySolver.swift
//  HarmonySolver
//
//  Created by Parker Wightman on 2/14/15.
//  Copyright (c) 2015 Alora Studios. All rights reserved.
//

import Foundation


public typealias ChordConstraint = FourPartChord -> Bool
public typealias AdjacentChordConstraint = (FourPartChord, FourPartChord) -> Bool

public func not<T>(condition: T -> Bool) -> T -> Bool {
    return { !condition($0) }
}

public func parallelIntervalConstraint(interval: Int) -> AdjacentChordConstraint {
    return { first, second in
        return any(zip(first.values, second.values)) { pair in
            let difference = pair.1.absoluteValue - pair.0.absoluteValue
            let badIntervals = filter(first.values) {
                    pair.0.noteType.cycledBy(interval) == $0.noteType
            }
            return any(badIntervals) { badNote in
                any(second.values) { otherNote in
                    otherNote.absoluteValue - badNote.absoluteValue == difference
                }
            }
        }
    }
}

public let smallJumpsConstraint: Int -> AdjacentChordConstraint = { interval in
    return { first, second in
        return all(zip(first.values, second.values)) { pair in
            return abs(pair.0.absoluteValue - pair.1.absoluteValue) <= interval
        }
    }
}

public let noVoiceCrossingConstraint: ChordConstraint = { chord in
    return chord.bass < chord.tenor &&
        chord.tenor < chord.alto &&
        chord.alto < chord.soprano
}

public let completeChordConstraint: ChordConstraint = { chord in
    Set(chord.values.map {
        $0.absoluteValue % 12
    }).count == chord.chord.semitones.count
}

public let allowRootNotes: [Int] -> ChordConstraint = { intervals in
    return { chord in
        return any(intervals) {
            NoteType(fromValue: $0) == chord.transposedTo(.C).bass.noteType
        }
    }
}

public let noMoreThanOneOctaveBetweenVoices: ChordConstraint = { chord in
    let first = chord.tenor.absoluteValue - chord.bass.absoluteValue < 12
    let second = chord.alto.absoluteValue - chord.tenor.absoluteValue < 12
    let third = chord.soprano.absoluteValue - chord.alto.absoluteValue < 12
    return first && second && third
}

public protocol SolverStrategy : SequenceType {
    var enumerators: [ChordEnumerator] { get }
    var chordConstraint: ChordConstraint { get }
    var adjacentChordConstraint: AdjacentChordConstraint  { get }
}

public struct PermutationSolver : SolverStrategy {
    public let enumerators: [ChordEnumerator]
    public let chordConstraint: ChordConstraint
    public let adjacentChordConstraint: AdjacentChordConstraint

    public init(enumerators: [ChordEnumerator], chordConstraint: ChordConstraint, adjacentConstraint: AdjacentChordConstraint) {
        self.enumerators = enumerators
        self.chordConstraint = chordConstraint
        self.adjacentChordConstraint = adjacentConstraint
    }

    public func generate() -> GeneratorOf<[FourPartChord]> {
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

public struct RecursiveSolver : SolverStrategy {
    public let enumerators: [ChordEnumerator]
    public let chordConstraint: ChordConstraint
    public let adjacentChordConstraint: AdjacentChordConstraint

    public init(enumerators: [ChordEnumerator], chordConstraint: ChordConstraint, adjacentConstraint: AdjacentChordConstraint) {
        self.enumerators = enumerators
        self.chordConstraint = chordConstraint
        self.adjacentChordConstraint = adjacentConstraint
    }

    func findMatch(var currentChord: FourPartChord, var restChords: [[FourPartChord]]) -> [FourPartChord]? {
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
        var arrays = enumerators.map {
            Array($0).filter {
                return self.chordConstraint($0)
            }
        }
        return GeneratorOf {
            if let array = arrays.first {
                for el in array {
                    if let match = self.findMatch(el, restChords: rest(arrays)) {
                        return match.map { $0.0 }
                    }
                }
            } else {
                return nil
            }
            return nil
        }
    }
}