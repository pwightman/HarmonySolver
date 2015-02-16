//
//  LilyPondSerializer.swift
//  HarmonySolver
//
//  Created by Parker Wightman on 2/14/15.
//  Copyright (c) 2015 Alora Studios. All rights reserved.
//

import Foundation

class LilyPondSerializer {
    let chords: [FourPartChord]
    init(chords: [FourPartChord]) {
        self.chords = chords
    }

    func toString() -> String {
        let topNotes = join(" ", chords.map { "<\(self.lilyPondNoteForNote($0.alto)) \(self.lilyPondNoteForNote($0.soprano))>" })
        let bottomNotes = join(" ", chords.map { "<\(self.lilyPondNoteForNote($0.bass)) \(self.lilyPondNoteForNote($0.tenor))>" })
        let path = NSBundle.mainBundle().pathForResource("LilyPondTemplate", ofType: "ly")!
        var template = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)!
        template = (template as NSString).stringByReplacingOccurrencesOfString("{{treble}}", withString: topNotes)
        template = (template as NSString).stringByReplacingOccurrencesOfString("{{bass}}", withString: bottomNotes)
        return template
    }

    func lilyPondNoteForNote(note: Note) -> String {
        let noteStr: String
        switch note.noteType {
        case C: noteStr = "c"
        case CSharp: noteStr = "cis"
        case D: noteStr = "d"
        case DSharp: noteStr = "dis"
        case E: noteStr = "e"
        case F: noteStr = "f"
        case FSharp: noteStr = "fis"
        case G: noteStr = "g"
        case GSharp: noteStr = "gis"
        case A: noteStr = "a"
        case ASharp: noteStr = "ais"
        case B: noteStr = "b"
        default:
            assert(false, "Unknown note type \(note.noteType)")
            noteStr = ""
        }
        return noteStr + self.octavesForNote(note)
    }

    func octavesForNote(note: Note) -> String {
        let lpOctave = note.octave - 4
        var returnStr = ""
        if lpOctave > 0 {
            returnStr = "'" * lpOctave
        } else if lpOctave < 0 {
            returnStr = "," * abs(lpOctave)
        }
        return returnStr
    }

}