//
//  HarmonySolver.swift
//  HarmonySolver
//
//  Created by Parker Wightman on 2/14/15.
//  Copyright (c) 2015 Alora Studios. All rights reserved.
//

import Foundation


typealias ChordConstraintBlock = FourPartChord -> Bool
typealias AdjacentChordConstraintBlock = (FourPartChord, FourPartChord) -> Bool

let noParallelFifthsConstraint: AdjacentChordConstraintBlock = { first, second in
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

let smallJumpsConstraint: Int -> AdjacentChordConstraintBlock = { interval in
    return { first, second in
        return all(zip(first.values, second.values)) { pair in
            return abs(pair.0.absoluteValue - pair.1.absoluteValue) <= interval
        }
    }
}

let noVoiceCrossingConstraint: ChordConstraintBlock = { chord in
    return chord.bass < chord.tenor &&
        chord.tenor < chord.alto &&
        chord.alto < chord.soprano
}

let completeChordConstraint: ChordConstraintBlock = { chord in
    Set(chord.values.map {
        $0.absoluteValue % 12
    }).count == chord.chord.semitones.count
}

let allowRootNotes: [NoteType] -> ChordConstraintBlock = { noteTypes in
    return { chord in
        return any(noteTypes) {
            $0 == (chord.transposedTo(C).bass.absoluteValue % 12)
        }
    }
}

let noMoreThanOneOctaveBetweenVoices: ChordConstraintBlock = { chord in
    let first = chord.tenor.absoluteValue - chord.bass.absoluteValue < 12
    let second = chord.alto.absoluteValue - chord.tenor.absoluteValue < 12
    let third = chord.soprano.absoluteValue - chord.alto.absoluteValue < 12
    return first && second && third
}


struct HarmonySolver : SequenceType {
    let enumerators: [ChordEnumerator]
    let chordConstraint: ChordConstraintBlock
    let adjacentChordConstraint: AdjacentChordConstraintBlock

    init(enumerators: [ChordEnumerator], chordConstraint: ChordConstraintBlock, adjacentConstraint: AdjacentChordConstraintBlock) {
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
        var generator = PermutationGenerator(sequences: arrays.map { SequenceOf($0) }.reverse())
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