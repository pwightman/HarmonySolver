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
        let topNotes = chords.map { "<\(self.lilyPondNoteForNote($0.alto)) \(self.lilyPondNoteForNote($0.soprano))>" }.joined(separator: " ")
        let bottomNotes = chords.map { "<\(self.lilyPondNoteForNote($0.bass)) \(self.lilyPondNoteForNote($0.tenor))>" }.joined(separator: " ")
        let path = Bundle(for: LilyPondSerializer.self).path(forResource: "LilyPondTemplate", ofType: "ly")!
        var template = try! String(contentsOfFile: path, encoding: .utf8)
        template = (template as NSString).replacingOccurrences(of: "{{treble}}", with: topNotes)
        template = (template as NSString).replacingOccurrences(of: "{{bass}}", with: bottomNotes)
        return template
    }

    func lilyPondNoteForNote(_ note: Note) -> String {
        let noteStr: String
        switch note.noteType {
        case .c: noteStr = "c"
        case .cSharp, .dFlat: noteStr = "cis"
        case .d: noteStr = "d"
        case .dSharp, .eFlat: noteStr = "dis"
        case .e: noteStr = "e"
        case .f: noteStr = "f"
        case .fSharp, .gFlat: noteStr = "fis"
        case .g: noteStr = "g"
        case .gSharp, .aFlat: noteStr = "gis"
        case .a: noteStr = "a"
        case .aSharp, .bFlat: noteStr = "ais"
        case .b: noteStr = "b"
        }
        return noteStr + self.octavesForNote(note)
    }

    func octavesForNote(_ note: Note) -> String {
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
