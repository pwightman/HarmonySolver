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
        return Chord(self.noteType.cycledBy(2)).minor
    }

    var three: Chord {
        return Chord(self.noteType.cycledBy(4)).minor
    }

    var four: Chord {
        return Chord(self.noteType.cycledBy(5))
    }

    var five: Chord {
        return Chord(self.noteType.cycledBy(7))
    }

    var six: Chord {
        return Chord(self.noteType.cycledBy(9)).minor
    }

    var seven: Chord {
        return Chord(self.noteType.cycledBy(11)).fullyDiminished
    }
}