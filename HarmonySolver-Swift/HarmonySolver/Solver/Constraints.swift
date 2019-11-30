//
//  HarmonySolver.swift
//  HarmonySolver
//
//  Created by Parker Wightman on 2/14/15.
//  Copyright (c) 2015 Alora Studios. All rights reserved.
//

import Foundation


public typealias ChordConstraint = (FourPartChord) -> Bool
public typealias AdjacentChordConstraint = (FourPartChord, FourPartChord) -> Bool

public func not(_ constraint: @escaping ChordConstraint) -> ChordConstraint {
    return { !constraint($0) }
}

public func not(_ constraint: @escaping AdjacentChordConstraint) -> AdjacentChordConstraint {
    return { !constraint($0, $1) }
}

public func parallelIntervalConstraint(_ interval: Int) -> AdjacentChordConstraint {
    return { (first: FourPartChord, second: FourPartChord) -> Bool in
        return any(zip(first.values, second.values)) { pair in
            let difference = pair.1.absoluteValue - pair.0.absoluteValue
            let badIntervals = first.values.filter {
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

public func smallJumpsConstraint(_ interval: Int) -> AdjacentChordConstraint {
    return { (first: FourPartChord, second: FourPartChord) -> Bool in
        return all(zip(first.values, second.values)) { pair in
            return abs(pair.0.absoluteValue - pair.1.absoluteValue) <= interval
        }
    }
}

public func smallJumpsAltoConstraint(_ interval: Int) -> AdjacentChordConstraint {
    return { (first: FourPartChord, second: FourPartChord) -> Bool in
        return abs(first.alto.absoluteValue - second.alto.absoluteValue) <= interval
    }
}

public func adjacentVoiceCrossing() -> AdjacentChordConstraint {
    return { (first: FourPartChord, second: FourPartChord) -> Bool in
        return second.bass < first.tenor && second.tenor < first.alto && second.alto < first.soprano
    }
}

public func descendingBass() -> AdjacentChordConstraint {
    return { (first: FourPartChord, second: FourPartChord) -> Bool in
        return second.bass < first.bass
    }
}

public func ascendingSoprano() -> AdjacentChordConstraint {
    return { (first: FourPartChord, second: FourPartChord) -> Bool in
        return second.soprano > first.soprano
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

public func allowRootNotes(intervals: [Int]) -> ChordConstraint {
    return { (chord: FourPartChord) -> Bool in
        return any(intervals) {
            NoteType(fromValue: $0) == chord.transposedTo(.C).bass.noteType
        }
    }
}

public func allVoicesIntervalConstraint(interval: Int) -> ChordConstraint {
    return bassTenorIntervalConstraint(interval)
        & tenorAltoIntervalConstraint(interval)
        & altoSopranoIntervalConstraint(interval)
}

public func bassTenorIntervalConstraint(_ interval: Int) -> ChordConstraint {
    return { (chord: FourPartChord) -> Bool in
        return chord.tenor.absoluteValue - chord.bass.absoluteValue < interval
    }
}

public func tenorAltoIntervalConstraint(_ interval: Int) -> ChordConstraint {
    return { (chord: FourPartChord) -> Bool in
        return chord.alto.absoluteValue - chord.tenor.absoluteValue < interval
    }
}

public func altoSopranoIntervalConstraint(_ interval: Int) -> ChordConstraint {
    return { (chord: FourPartChord) -> Bool in
        return chord.soprano.absoluteValue - chord.alto.absoluteValue < interval
    }
}
