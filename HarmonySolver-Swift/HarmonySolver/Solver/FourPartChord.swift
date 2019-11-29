//
//  FourPartChord.swift
//  HarmonySolver
//
//  Created by Parker Wightman on 2/14/15.
//  Copyright (c) 2015 Alora Studios. All rights reserved.
//

import Foundation

public func ==(lhs: FourPartChord, rhs: FourPartChord) -> Bool {
    return lhs.chord == rhs.chord && lhs.values == rhs.values
}

public struct FourPartChord : Equatable {
    public let chord: Chord
    public let bass: Note
    public let tenor: Note
    public let alto: Note
    public let soprano: Note

    public init(chord: Chord, bass: Note, tenor: Note, alto: Note, soprano: Note) {
        self.chord = chord
        self.bass = bass
        self.tenor = tenor
        self.alto = alto
        self.soprano = soprano
    }

    public var values: [Note] {
        return [bass, tenor, alto, soprano]
    }

    public var description: String {
        return "\(Note(absoluteValue: chord.noteType.value)) \(bass) \(tenor) \(alto) \(soprano)"
    }

    public var debugDescription: String {
        return self.description
    }

    public func transposedTo(_ noteType: NoteType) -> FourPartChord {
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
