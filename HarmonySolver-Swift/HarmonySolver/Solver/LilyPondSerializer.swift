//
//  LilyPondSerializer.swift
//  HarmonySolver
//
//  Created by Parker Wightman on 2/14/15.
//  Copyright (c) 2015 Alora Studios. All rights reserved.
//

import Foundation

public class LilyPondSerializer {
    public let chords: [FourPartChord]
    public init(chords: [FourPartChord]) {
        self.chords = chords
    }

    public func toString() -> String {
        let topNotes = join(" ", chords.map { "<\(self.lilyPondNoteForNote($0.alto)) \(self.lilyPondNoteForNote($0.soprano))>" })
        let bottomNotes = join(" ", chords.map { "<\(self.lilyPondNoteForNote($0.bass)) \(self.lilyPondNoteForNote($0.tenor))>" })
        let path = NSBundle(forClass: LilyPondSerializer.self).pathForResource("LilyPondTemplate", ofType: "ly")!
        var template = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)!
        template = (template as NSString).stringByReplacingOccurrencesOfString("{{treble}}", withString: topNotes)
        template = (template as NSString).stringByReplacingOccurrencesOfString("{{bass}}", withString: bottomNotes)
        return template
    }

    func lilyPondNoteForNote(note: Note) -> String {
        let noteStr: String
        switch note.noteType {
        case .C: noteStr = "c"
        case .CSharp, .DFlat: noteStr = "cis"
        case .D: noteStr = "d"
        case .DSharp, .EFlat: noteStr = "dis"
        case .E: noteStr = "e"
        case .F: noteStr = "f"
        case .FSharp, .GFlat: noteStr = "fis"
        case .G: noteStr = "g"
        case .GSharp, .AFlat: noteStr = "gis"
        case .A: noteStr = "a"
        case .ASharp, .BFlat: noteStr = "ais"
        case .B: noteStr = "b"
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