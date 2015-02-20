//
//  FourPartChord.swift
//  HarmonySolver
//
//  Created by Parker Wightman on 2/14/15.
//  Copyright (c) 2015 Alora Studios. All rights reserved.
//

import Foundation

func ==(lhs: FourPartChord, rhs: FourPartChord) -> Bool {
    return lhs.chord == rhs.chord && lhs.values == rhs.values
}

struct FourPartChord : Equatable, Printable, DebugPrintable {
    let chord: Chord
    let bass: Note
    let tenor: Note
    let alto: Note
    let soprano: Note

    var values: [Note] {
        return [bass, tenor, alto, soprano]
    }

    var description: String {
        return "\(Note(absoluteValue: chord.noteType.value)) \(bass) \(tenor) \(alto) \(soprano)"
    }

    var debugDescription: String {
        return self.description
    }

    func transposedTo(noteType: NoteType) -> FourPartChord {
        let newValues = self.values.map { Note(absoluteValue: $0.absoluteValue - noteType.value) }
        return FourPartChord(
            chord: self.chord,
            bass:    newValues[0],
            tenor:   newValues[1],
            alto:    newValues[2],
            soprano: newValues[3]
        )
    }
}