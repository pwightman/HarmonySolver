//
//  Note.swift
//  HarmonySolver
//
//  Created by Parker Wightman on 2/14/15.
//  Copyright (c) 2015 Alora Studios. All rights reserved.
//

import Foundation

typealias NoteType = Int

let C = 0
let CSharp = 1
let DFlat = 1
let D = 2
let DSharp = 3
let EFlat = 3
let E = 4
let F = 5
let FSharp = 6
let GFlat = 6
let G = 7
let GSharp = 8
let AFlat = 8
let A = 9
let ASharp = 10
let BFlat = 10
let B = 11

func ==(lhs: Note, rhs: Note) -> Bool {
    return lhs.absoluteValue == rhs.absoluteValue
}

func <(lhs: Note, rhs: Note) -> Bool {
    return lhs.absoluteValue < rhs.absoluteValue
}

struct Note : Hashable, Comparable, Printable, DebugPrintable {
    let octave: Int
    let noteType: NoteType
    let absoluteValue: Int

    init(absoluteValue: Int) {
        self.absoluteValue = absoluteValue
        self.octave = absoluteValue / 12
        self.noteType = absoluteValue % 12
    }

    init(_ noteType: NoteType, _ octave: Int) {
        self.absoluteValue = octave * 12 + noteType
        self.noteType = noteType
        self.octave = octave
    }

    var description: String {
        return "\(self.stringForNoteType)\(octave)"
    }

    var debugDescription: String {
        return self.description
    }

    var stringForNoteType: String {
        switch noteType {
        case C: return "C"
        case CSharp: return "C#"
        case D: return "D"
        case DSharp: return "D#"
        case E: return "E"
        case F: return "F"
        case FSharp: return "F#"
        case G: return "G"
        case GSharp: return "G#"
        case A: return "A"
        case ASharp: return "A#"
        case B: return "B"
        default:
            assert(false, "Unknown note type \(noteType)")
        }
    }

    var hashValue: Int {
        return self.absoluteValue.hashValue
    }
}