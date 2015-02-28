//
//  Key.swift
//  HarmonySolver
//
//  Created by Parker Wightman on 2/14/15.
//  Copyright (c) 2015 Alora Studios. All rights reserved.
//

import Foundation

public struct Key {
    public let isMinor: Bool
    public let noteType: NoteType

    public init(_ noteType: NoteType, minor: Bool = false) {
        self.noteType = noteType
        self.isMinor = minor
    }

    public var minor: Key {
        return Key(self.noteType, minor: true)
    }

    public var major: Key {
        return Key(self.noteType, minor: false)
    }

    public var one: Chord {
        return Chord(self.noteType)
    }

    public var two: Chord {
        return Chord(self.noteType.cycledBy(2)).minor
    }

    public var three: Chord {
        return Chord(self.noteType.cycledBy(4)).minor
    }

    public var four: Chord {
        return Chord(self.noteType.cycledBy(5))
    }

    public var five: Chord {
        return Chord(self.noteType.cycledBy(7))
    }

    public var six: Chord {
        return Chord(self.noteType.cycledBy(9)).minor
    }

    public var seven: Chord {
        return Chord(self.noteType.cycledBy(11)).fullyDiminished
    }
}