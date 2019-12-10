//
//  ChordEnumerator.swift
//  HarmonySolver
//
//  Created by Parker Wightman on 2/14/15.
//  Copyright (c) 2015 Alora Studios. All rights reserved.
//

import Foundation

public enum VoiceType {
    case Bass, Tenor, Alto, Soprano
}

extension VoiceType {

    func noteForChord(_ chord: FourPartChord) -> Note {
        switch self {
        case .Bass: return chord.bass
        case .Tenor: return chord.tenor
        case .Alto: return chord.alto
        case .Soprano: return chord.soprano
        }
    }

}

public func pinnedVoiceConstraint(voiceType: VoiceType, note: Note) -> ChordConstraint {
    return { (chord: FourPartChord) -> Bool in
        if voiceType.noteForChord(chord) == note {
            return true
        }
        return false

    }
}

public func inversionConstraint(_ inversion: Int) -> ChordConstraint {
    return { (chord: FourPartChord) -> Bool in
        return NoteType(fromValue: chord.chord.semitones[inversion]).cycledBy(chord.chord.noteType.value) == chord.bass.noteType
    }
}

public struct ChordIterator: IteratorProtocol {
    let enumerator: ChordEnumerator
    
    public mutating func next() -> FourPartChord? {
        return nil
    }
}

public struct ChordEnumerator : Sequence {
    public let chord: Chord
    public let randomize: Bool

    public init(chord: Chord, randomize: Bool = false) {
        self.chord = chord
        self.randomize = randomize
    }

    func notesInRange(_ range: ClosedRange<Int>) -> [Note] {
        let set = Set(chord.semitones.map { (self.chord.noteType.value + $0) % 12 })
        return Array(range).filter { set.contains($0 % 12) }.map { Note(absoluteValue: $0) }
    }

    var bassRange: ClosedRange<Int> {
        return Note(.e,3).absoluteValue...Note(.c,5).absoluteValue
    }

    var tenorRange: ClosedRange<Int> {
        return Note(.c,4).absoluteValue...Note(.g,5).absoluteValue
    }

    var altoRange: ClosedRange<Int> {
        return Note(.g,4).absoluteValue...Note(.c,6).absoluteValue
    }

    var sopranoRange: ClosedRange<Int> {
        return Note(.c,5).absoluteValue...Note(.g,6).absoluteValue
    }
    
//    public func makeIterator() -> ChordIterator {
//        return ChordIterator(enumerator: self)
//    }

    public func makeIterator() -> AnyIterator<FourPartChord> {
        let bassNotes = notesInRange(bassRange)
        let tenorNotes = notesInRange(tenorRange)
        let altoNotes = notesInRange(altoRange)
        let sopranoNotes = notesInRange(sopranoRange)
        let sequences = [bassNotes, tenorNotes, altoNotes, sopranoNotes].reversed().map { range -> [Note] in
            if self.randomize {
                return range.shuffled()
            } else {
                return range
            }
        }
        var generator = PermutationGenerator(sequences: sequences)
        return IteratorOf(block: {
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
        }).anyIterator()
    }
}
