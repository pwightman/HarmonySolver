//
//  Key.swift
//  HarmonySolver
//
//  Created by Parker Wightman on 2/14/15.
//  Copyright (c) 2015 Alora Studios. All rights reserved.
//

import Foundation

private let MajorKeyChords: [Chord] = [
    Chord(.C),
    Chord(.D).minor,
    Chord(.E).minor,
    Chord(.F),
    Chord(.G),
    Chord(.A).minor,
    Chord(.B).halfDiminished
]

private let MinorKeyChords: [Chord] = [
    Chord(.C).minor,
    Chord(.D).halfDiminished,
    Chord(.E),
    Chord(.F).minor,
    Chord(.G).minor,
    Chord(.A),
    Chord(.B)
]

public struct Key {
    public let isMinor: Bool
    public let noteType: NoteType
    private let chords: [Chord]

    public init(_ noteType: NoteType, minor: Bool = false) {
        self.noteType = noteType
        self.isMinor = minor
        let chords = minor ? MinorKeyChords : MajorKeyChords
        self.chords = chords.map { $0.transposedTo($0.noteType.cycledBy(noteType.value)) }
    }

    public var minor: Key {
        return Key(self.noteType, minor: true)
    }

    public var major: Key {
        return Key(self.noteType, minor: false)
    }

    public var one: Chord {
        return self.chords[0]
    }

    public var two: Chord {
        return self.chords[1]
    }

    public var three: Chord {
        return self.chords[2]
    }

    public var four: Chord {
        return self.chords[3]
    }

    public var five: Chord {
        return self.chords[4]
    }

    public var six: Chord {
        return self.chords[5]
    }

    public var seven: Chord {
        return self.chords[6]
    }
}