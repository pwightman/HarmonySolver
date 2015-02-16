//
//  Chord.swift
//  HarmonySolver
//
//  Created by Parker Wightman on 2/14/15.
//  Copyright (c) 2015 Alora Studios. All rights reserved.
//

import Foundation

func ==(lhs: Chord, rhs: Chord) -> Bool {
    return lhs.noteType == rhs.noteType && lhs.semitones == rhs.semitones
}

struct Chord : Equatable, Printable, DebugPrintable {
    var semitones: [Int] {
        return reduce(stepsToOffsets, []) { arr, pair in
            arr + [self.halfStepForScaleStep(pair.0) + pair.1]
        }.sorted { $0 < $1 }
    }

    func halfStepForScaleStep(scaleStep: Int) -> Int {
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
        }
    }

    private let stepsToOffsets: [Int:Int] // Maps scale step to offset. [ 1 : 0, 3 : -1, 5 : 0 ] would be a minor chord
    let noteType: NoteType

    var description: String {
        return Note(absoluteValue: self.noteType).description
    }

    var debugDescription: String {
        return self.description
    }

    init(_ noteType: NoteType) {
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

    private func chordBySetting(stepsToOffsets: [Int:Int]) -> Chord {
        var newOffsets = self.stepsToOffsets
        for (step, offset) in stepsToOffsets {
            newOffsets[step] = offset
        }
        return Chord(self.noteType, stepsToOffsets: newOffsets)
    }

    private func chordByRemoving(scaleStep: Int) -> Chord {
        var newOffsets = self.stepsToOffsets
        newOffsets.removeValueForKey(scaleStep)
        return Chord(self.noteType, stepsToOffsets: newOffsets)
    }

    var minor: Chord {
        return self.flat(3)
    }

    var major: Chord {
        return self.chordBySetting([3 : 0])
    }

    var seven: Chord {
        return self.flat(7)
    }

    var majorSeven: Chord {
        return self.add(7)
    }

    var halfDiminished: Chord {
        return self.minor.flat(5).flat(7)
    }

    var fullyDiminished: Chord {
        return self.minor.flat(5).doubleFlat(7)
    }

    var powerChord: Chord {
        return Chord(self.noteType).remove(3)
    }

    func flat(scaleStep: Int) -> Chord {
        return self.chordBySetting([scaleStep : -1])
    }

    func doubleFlat(scaleStep: Int) -> Chord {
        return self.chordBySetting([scaleStep : -2])
    }

    func sharp(scaleStep: Int) -> Chord {
        return self.chordBySetting([scaleStep : 1])
    }

    func add(scaleStep: Int) -> Chord {
        return self.chordBySetting([scaleStep : 0])
    }

    func remove(scaleStep: Int) -> Chord {
        return self.chordByRemoving(scaleStep)
    }
}