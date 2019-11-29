//
//  Chord.swift
//  HarmonySolver
//
//  Created by Parker Wightman on 2/14/15.
//  Copyright (c) 2015 Alora Studios. All rights reserved.
//

import Foundation

public func ==(lhs: Chord, rhs: Chord) -> Bool {
    return lhs.noteType == rhs.noteType && lhs.semitones == rhs.semitones
}

public struct Chord : Equatable {
    private let stepsToOffsets: [Int:Int] // Maps scale step to offset. [ 1 : 0, 3 : -1, 5 : 0 ] would be a minor chord
    public let noteType: NoteType

    public var description: String {
        return Note(absoluteValue: self.noteType.value).description
    }

    public var debugDescription: String {
        return self.description
    }

    public init(_ noteType: NoteType) {
        self.noteType = noteType
        self.stepsToOffsets = [ // Starts as major chord
            1: 0,
            3: 0,
            5: 0
        ]
    }

    private init(_ noteType: NoteType, stepsToOffsets: [Int:Int]) {
        self.noteType = noteType
        self.stepsToOffsets = stepsToOffsets
    }

    public var semitones: [Int] {
        return stepsToOffsets.reduce([]) { arr, pair in
            arr + [self.halfStepForScaleStep(pair.0) + pair.1]
        }.sorted { $0 < $1 }
    }

    public func halfStepForScaleStep(_ scaleStep: Int) -> Int {
        switch (scaleStep) {
        case 1: return 0;
        case 2: return 2;
        case 3: return 4;
        case 4: return 5;
        case 5: return 7;
        case 6: return 9;
        case 7: return 11;
        case 8: return 12;
        case 9: return 14;
        case 10: return 16;
        case 11: return 17;
        case 12: return 19;
        case 13: return 21;
        case 14: return 23;
        default:
            assert(false, "Chord halfStepForScaleStep: \(scaleStep) scaleStep not supported");
            return 0
        }
    }

    private func chordBySetting(_ stepsToOffsets: [Int:Int]) -> Chord {
        var newOffsets = self.stepsToOffsets
        for (step, offset) in stepsToOffsets {
            newOffsets[step] = offset
        }
        return Chord(self.noteType, stepsToOffsets: newOffsets)
    }

    private func chordByRemoving(_ scaleStep: Int) -> Chord {
        var newOffsets = self.stepsToOffsets
        newOffsets.removeValue(forKey: scaleStep)
        return Chord(self.noteType, stepsToOffsets: newOffsets)
    }

    public func transposedTo(_ noteType: NoteType) -> Chord {
        return Chord(noteType, stepsToOffsets: self.stepsToOffsets)
    }

    public var minor: Chord {
        return self.flat(3)
    }

    public var major: Chord {
        return self.chordBySetting([3 : 0])
    }

    public var seven: Chord {
        return self.flat(7)
    }

    public var majorSeven: Chord {
        return self.add(7)
    }

    public var halfDiminished: Chord {
        return self.minor.flat(5).flat(7)
    }

    public var fullyDiminished: Chord {
        return self.minor.flat(5).doubleFlat(7)
    }

    public var powerChord: Chord {
        return Chord(self.noteType).remove(3)
    }

    public func flat(_ scaleStep: Int) -> Chord {
        return self.chordBySetting([scaleStep : -1])
    }

    public func doubleFlat(_ scaleStep: Int) -> Chord {
        return self.chordBySetting([scaleStep : -2])
    }

    public func sharp(_ scaleStep: Int) -> Chord {
        return self.chordBySetting([scaleStep : 1])
    }

    public func add(_ scaleStep: Int) -> Chord {
        return self.chordBySetting([scaleStep : 0])
    }

    public func remove(_ scaleStep: Int) -> Chord {
        return self.chordByRemoving(scaleStep)
    }
}
