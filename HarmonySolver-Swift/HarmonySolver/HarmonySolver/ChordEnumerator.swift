//
//  ChordEnumerator.swift
//  HarmonySolver
//
//  Created by Parker Wightman on 2/14/15.
//  Copyright (c) 2015 Alora Studios. All rights reserved.
//

import Foundation

extension Array {
    func shuffled() -> [T] {
        var list = self
        for i in 0..<(list.count - 1) {
            let j = Int(arc4random_uniform(UInt32(list.count - i))) + i
            swap(&list[i], &list[j])
        }
        return list
    }
}

struct ChordEnumerator : SequenceType {
    let chord: Chord

    func notesInRange(range: Range<Int>) -> [Note] {
        let set = Set(chord.semitones.map { (self.chord.noteType + $0) % 12 })
        return Array(range).filter { set.contains($0 % 12) }.map { Note(absoluteValue: $0) }
    }

    var bassRange: Range<Int> {
        return Note(E,3).absoluteValue...Note(C,5).absoluteValue
    }

    var tenorRange: Range<Int> {
        return Note(C,4).absoluteValue...Note(G,5).absoluteValue
    }

    var altoRange: Range<Int> {
        return Note(G,4).absoluteValue...Note(C,6).absoluteValue
    }

    var sopranoRange: Range<Int> {
        return Note(C,5).absoluteValue...Note(G,6).absoluteValue
    }

    func generate() -> GeneratorOf<FourPartChord> {
        let bassNotes = notesInRange(bassRange)
        let tenorNotes = notesInRange(tenorRange)
        let altoNotes = notesInRange(altoRange)
        let sopranoNotes = notesInRange(sopranoRange)
        let sequences = [bassNotes, tenorNotes, altoNotes, sopranoNotes].map { SequenceOf($0) }.reverse()
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