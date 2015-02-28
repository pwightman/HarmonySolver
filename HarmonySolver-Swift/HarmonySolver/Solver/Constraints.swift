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

public func parallelIntervalConstraint(interval: Int)(_ first: FourPartChord, _ second: FourPartChord) -> Bool {
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

public func smallJumpsConstraint(interval: Int)(_ first: FourPartChord, _ second: FourPartChord) -> Bool {
    return all(zip(first.values, second.values)) { pair in
        return abs(pair.0.absoluteValue - pair.1.absoluteValue) <= interval
    }
}

public func noVoiceCrossingConstraint(chord: FourPartChord) -> Bool {
    return chord.bass < chord.tenor &&
        chord.tenor < chord.alto &&
        chord.alto < chord.soprano
}

public func completeChordConstraint(chord: FourPartChord) -> Bool {
    return Set(chord.values.map {
        $0.absoluteValue % 12
    }).count == chord.chord.semitones.count
}

public func allowRootNotes(intervals: [Int])(chord: FourPartChord) -> Bool {
    return any(intervals) {
        NoteType(fromValue: $0) == chord.transposedTo(.C).bass.noteType
    }
}

public func allVoicesIntervalConstraint(interval: Int) -> ChordConstraint {
    return bassTenorIntervalConstraint(interval)
        & tenorAltoIntervalConstraint(interval)
        & altoSopranoIntervalConstraint(interval)
}

public func bassTenorIntervalConstraint(interval: Int)(chord: FourPartChord) -> Bool {
    return chord.tenor.absoluteValue - chord.bass.absoluteValue < interval
}

public func tenorAltoIntervalConstraint(interval: Int)(chord: FourPartChord) -> Bool {
    return chord.alto.absoluteValue - chord.tenor.absoluteValue < interval
}

public func altoSopranoIntervalConstraint(interval: Int)(chord: FourPartChord) -> Bool {
    return chord.soprano.absoluteValue - chord.alto.absoluteValue < interval
}