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
    case C
    case CSharp
    case DFlat
    case D
    case DSharp
    case EFlat
    case E
    case F
    case FSharp
    case GFlat
    case G
    case GSharp
    case AFlat
    case A
    case ASharp
    case BFlat
    case B

    public init(fromValue value: Int) {
        switch value % 12 {
        case 0: self = .C
        case 1: self = .CSharp
        case 2: self = .D
        case 3: self = .DSharp
        case 4: self = .E
        case 5: self = .F
        case 6: self = .FSharp
        case 7: self = .G
        case 8: self = .GSharp
        case 9: self = .A
        case 10: self = .ASharp
        case 11: self = .B
        default: self = .C
        }
    }

    public var value: Int {
        switch self {
        case .C: return 0
        case .CSharp, .DFlat: return 1
        case .D: return 2
        case .DSharp, .EFlat: return 3
        case .E: return 4
        case .F: return 5
        case .FSharp, .GFlat: return 6
        case .G: return 7
        case .GSharp, .AFlat: return 8
        case .A: return 9
        case .ASharp, .BFlat: return 10
        case .B: return 11
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
        case .C: return "C"
        case .CSharp: return "C#"
        case .DFlat: return "Db"
        case .D: return "D"
        case .DSharp: return "D#"
        case .EFlat: return "Eb"
        case .E: return "E"
        case .F: return "F"
        case .FSharp: return "F#"
        case .GFlat: return "Gb"
        case .G: return "G"
        case .GSharp: return "G#"
        case .AFlat: return "Ab"
        case .A: return "A"
        case .ASharp: return "A#"
        case .BFlat: return "Bb"
        case .B: return "B"
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.absoluteValue)
    }
}
