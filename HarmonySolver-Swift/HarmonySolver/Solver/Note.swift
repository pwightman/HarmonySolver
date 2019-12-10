//
//  Note.swift
//  HarmonySolver
//
//  Created by Parker Wightman on 2/14/15.
//  Copyright (c) 2015 Alora Studios. All rights reserved.
//

import Foundation

//typealias NoteType = Int

public func ==(lhs: NoteType, rhs: NoteType) -> Bool {
    return lhs.value == rhs.value
}

public enum NoteType : Hashable {
    case c
    case cSharp
    case dFlat
    case d
    case dSharp
    case eFlat
    case e
    case f
    case fSharp
    case gFlat
    case g
    case gSharp
    case aFlat
    case a
    case aSharp
    case bFlat
    case b

    public init(fromValue value: Int) {
        switch value % 12 {
        case 0: self = .c
        case 1: self = .cSharp
        case 2: self = .d
        case 3: self = .dSharp
        case 4: self = .e
        case 5: self = .f
        case 6: self = .fSharp
        case 7: self = .g
        case 8: self = .gSharp
        case 9: self = .a
        case 10: self = .aSharp
        case 11: self = .b
        default: self = .c
        }
    }

    public var value: Int {
        switch self {
        case .c: return 0
        case .cSharp, .dFlat: return 1
        case .d: return 2
        case .dSharp, .eFlat: return 3
        case .e: return 4
        case .f: return 5
        case .fSharp, .gFlat: return 6
        case .g: return 7
        case .gSharp, .aFlat: return 8
        case .a: return 9
        case .aSharp, .bFlat: return 10
        case .b: return 11
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.value)
    }
    
    public func cycledBy(_ distance: Int) -> NoteType {
        return NoteType(fromValue: self.value + distance)
    }
}

public func ==(lhs: Note, rhs: Note) -> Bool {
    return lhs.absoluteValue == rhs.absoluteValue
}

public func <(lhs: Note, rhs: Note) -> Bool {
    return lhs.absoluteValue < rhs.absoluteValue
}

public struct Note : Hashable, Comparable {
    public let octave: Int
    public let noteType: NoteType
    public let absoluteValue: Int

    public init(absoluteValue: Int) {
        self.absoluteValue = absoluteValue
        self.octave = absoluteValue / 12
        self.noteType = NoteType(fromValue: absoluteValue)
    }

    public init(_ noteType: NoteType, _ octave: Int) {
        self.absoluteValue = octave * 12 + noteType.value
        self.noteType = noteType
        self.octave = octave
    }

    public var description: String {
        return "\(self.stringForNoteType)\(octave)"
    }

    public var debugDescription: String {
        return self.description
    }

    public var stringForNoteType: String {
        switch noteType {
        case .c: return "C"
        case .cSharp: return "C#"
        case .dFlat: return "Db"
        case .d: return "D"
        case .dSharp: return "D#"
        case .eFlat: return "Eb"
        case .e: return "E"
        case .f: return "F"
        case .fSharp: return "F#"
        case .gFlat: return "Gb"
        case .g: return "G"
        case .gSharp: return "G#"
        case .aFlat: return "Ab"
        case .a: return "A"
        case .aSharp: return "A#"
        case .bFlat: return "Bb"
        case .b: return "B"
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.absoluteValue)
    }
}
