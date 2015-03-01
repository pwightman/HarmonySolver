//
//  ChordEnumerator.swift
//  HarmonySolver
//
//  Created by Parker Wightman on 2/14/15.
//  Copyright (c) 2015 Alora Studios. All rights reserved.
//

import Foundation

public struct ChordEnumerator : SequenceType {
    public let chord: Chord
    public let randomize: Bool

    public var pinnedBassNote: Note?
    public var pinnedTenorNote: Note?
    public var pinnedAltoNote: Note?
    public var pinnedSopranoNote: Note?

    public init(chord: Chord, randomize: Bool = false) {
        self.chord = chord
        self.randomize = randomize
    }

    func notesInRange(range: Range<Int>) -> [Note] {
        let set = Set(chord.semitones.map { (self.chord.noteType.value + $0) % 12 })
        return Array(range).filter { set.contains($0 % 12) }.map { Note(absoluteValue: $0) }
    }

    var bassRange: Range<Int> {
        if let note = pinnedBassNote {
            return Range(start: note.absoluteValue, end: note.absoluteValue + 1)
        } else {
            return Note(.E,3).absoluteValue...Note(.C,5).absoluteValue
        }
    }

    var tenorRange: Range<Int> {
        if let note = pinnedTenorNote {
            return Range(start: note.absoluteValue, end: note.absoluteValue + 1)
        } else {
            return Note(.C,4).absoluteValue...Note(.G,5).absoluteValue
        }
    }

    var altoRange: Range<Int> {
        if let note = pinnedAltoNote {
            return Range(start: note.absoluteValue, end: note.absoluteValue + 1)
        } else {
            return Note(.G,4).absoluteValue...Note(.C,6).absoluteValue
        }
    }

    var sopranoRange: Range<Int> {
        if let note = pinnedSopranoNote {
            return Range(start: note.absoluteValue, end: note.absoluteValue + 1)
        } else {
            return Note(.C,5).absoluteValue...Note(.G,6).absoluteValue
        }
    }

    public func generate() -> GeneratorOf<FourPartChord> {
        let bassNotes = notesInRange(bassRange)
        let tenorNotes = notesInRange(tenorRange)
        let altoNotes = notesInRange(altoRange)
        let sopranoNotes = notesInRange(sopranoRange)
        let sequences = [bassNotes, tenorNotes, altoNotes, sopranoNotes].reverse().map { range -> [Note] in
            if self.randomize {
                return range.shuffled()
            } else {
                return range
            }
        }
        var generator = PermutationGenerator(sequences: sequences)
        return GeneratorOf {
            if let notes = generator.next() {
                return FourPartChord(
                    chord:   self.chord,
                    bass:    notes[0],
                    tenor:   notes[1],
                    alto:    notes[2],
                    soprano: notes[3]
                )
            } else {
                return nil
            }
        }
    }
}