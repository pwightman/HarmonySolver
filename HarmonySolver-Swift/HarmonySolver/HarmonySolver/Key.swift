//
//  Key.swift
//  HarmonySolver
//
//  Created by Parker Wightman on 2/14/15.
//  Copyright (c) 2015 Alora Studios. All rights reserved.
//

import Foundation

struct Key {
    let isMinor: Bool
    let noteType: NoteType

    init(_ noteType: NoteType, minor: Bool = false) {
        self.noteType = noteType
        self.isMinor = minor
    }

    var minor: Key {
        return Key(self.noteType, minor: true)
    }

    var major: Key {
        return Key(self.noteType, minor: false)
    }

    var one: Chord {
        return Chord(self.noteType)
    }

    var two: Chord {
        return Chord((self.noteType + 2) % 12).minor
    }

    var three: Chord {
        return Chord((self.noteType + 4) % 12).minor
    }

    var four: Chord {
        return Chord((self.noteType + 5) % 12)
    }

    var five: Chord {
        return Chord((self.noteType + 7) % 12)
    }

    var six: Chord {
        return Chord((self.noteType + 9) % 12).minor
    }

    var seven: Chord {
        return Chord((self.noteType + 11) % 12).fullyDiminished
    }
}