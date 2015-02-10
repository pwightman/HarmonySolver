// Playground - noun: a place where people can play

import UIKit

typealias NoteType = Int

let C = 0
let CSharp = 1
let DFlat = 1
let D = 2
let DSharp = 3
let EFlat = 3
let E = 4
let F = 5
let FSharp = 6
let GFlat = 6
let G = 7
let GSharp = 8
let AFlat = 8
let A = 9
let ASharp = 10
let BFlat = 10
let B = 11

func ==(lhs: Note, rhs: Note) -> Bool {
    return lhs.absoluteValue == rhs.absoluteValue
}

struct Note : Equatable, Printable, DebugPrintable {
    let octave: Int
    let noteType: NoteType
    let absoluteValue: Int

    init(absoluteValue: Int) {
        self.absoluteValue = absoluteValue
        self.octave = absoluteValue / 12
        self.noteType = absoluteValue % 12
    }

    init(_ noteType: NoteType, _ octave: Int) {
        self.absoluteValue = octave * 12 + noteType
        self.noteType = noteType
        self.octave = octave
    }

    var description: String {
        return "\(self.stringForNoteType)\(octave)"
    }

    var debugDescription: String {
        return self.description
    }

    private var stringForNoteType: String {
        switch noteType {
        case C: return "C"
        case CSharp: return "C#"
        case D: return "D"
        case DSharp: return "D#"
        case E: return "E"
        case F: return "F"
        case FSharp: return "F#"
        case G: return "G"
        case GSharp: return "G#"
        case A: return "A"
        case ASharp: return "A#"
        case B: return "B"
        default:
            assert(false, "Unknown note type \(noteType)")
        }
    }
}

Note(absoluteValue: 81)

func ==(lhs: Chord, rhs: Chord) -> Bool {
    return lhs.noteType == rhs.noteType && lhs.semitones == rhs.semitones
}

struct Chord : Equatable {
    var semitones: [Int] {
        return reduce(stepsToOffsets, []) { arr, pair in
            arr + [self.halfStepForScaleStep(pair.0) + pair.1]
        }.sorted { $0 < $1 }
    }

    func halfStepForScaleStep(scaleStep: Int) -> Int {
        switch (scaleStep) {
        case 1: return 0;
        case 2: return 2;
        case 3: return 4;
        case 4: return 5;
        case 5: return 7;
        case 6: return 9;
        case 7: return 11;
        case 8: return 12;
        case 9: return 14;
        case 10: return 16;
        case 11: return 17;
        case 12: return 19;
        case 13: return 21;
        case 14: return 23;
        default:
            assert(false, "Chord halfStepForScaleStep: \(scaleStep) scaleStep not supported");
        }
    }

    private let stepsToOffsets: [Int:Int] // Maps scale step to offset. [ 1 : 0, 3 : -1, 5 : 0 ] would be a minor chord
    let noteType: NoteType

    init(_ noteType: NoteType) {
        self.noteType = noteType
        self.stepsToOffsets = [ // Starts as major chord
            1: 0,
            3: 0,
            5: 0
        ]
    }

    private init(_ noteType: NoteType, stepsToOffsets: [Int:Int]) {
        self.noteType = noteType
        self.stepsToOffsets = stepsToOffsets
    }

    private func chordBySetting(stepsToOffsets: [Int:Int]) -> Chord {
        var newOffsets = self.stepsToOffsets
        for (step, offset) in stepsToOffsets {
            newOffsets[step] = offset
        }
        return Chord(self.noteType, stepsToOffsets: newOffsets)
    }

    private func chordByRemoving(scaleStep: Int) -> Chord {
        var newOffsets = self.stepsToOffsets
        newOffsets.removeValueForKey(scaleStep)
        return Chord(self.noteType, stepsToOffsets: newOffsets)
    }

    var minor: Chord {
        return self.flat(3)
    }

    var major: Chord {
        return self.chordBySetting([3 : 0])
    }

    var seven: Chord {
        return self.flat(7)
    }

    var majorSeven: Chord {
        return self.add(7)
    }

    var powerChord: Chord {
        return Chord(self.noteType).remove(3)
    }

    func flat(scaleStep: Int) -> Chord {
        return self.chordBySetting([scaleStep : -1])
    }

    func sharp(scaleStep: Int) -> Chord {
        return self.chordBySetting([scaleStep : 1])
    }

    func add(scaleStep: Int) -> Chord {
        return self.chordBySetting([scaleStep : 0])
    }

    func remove(scaleStep: Int) -> Chord {
        return self.chordByRemoving(scaleStep)
    }
}

Chord(C).minor.semitones

func ==(lhs: FourPartChord, rhs: FourPartChord) -> Bool {
    return lhs.chord == rhs.chord && lhs.values == rhs.values
}

struct FourPartChord : Equatable {
    let chord: Chord
    let bass: Note
    let tenor: Note
    let alto: Note
    let soprano: Note

    var values: [Note] {
        return [bass, tenor, alto, soprano]
    }
}

FourPartChord(
    chord:   Chord(C),
    bass:    Note(C,3),
    tenor:   Note(G,3),
    alto:    Note(E,5),
    soprano: Note(C,6)
)

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
        var bassIndex = 0
        var tenorIndex = 0
        var altoIndex = 0
        var sopranoIndex = 0

        let bassNotes    = notesInRange(bassRange)
        let tenorNotes   = notesInRange(tenorRange)
        let altoNotes    = notesInRange(altoRange)
        let sopranoNotes = notesInRange(sopranoRange)

        println("\(bassNotes.count) \(tenorNotes.count) \(altoNotes.count) \(sopranoNotes.count)")

        var done = false

        return GeneratorOf {

            if done {
                return nil
            }

            println(bassIndex)
            let chord = FourPartChord(
                chord:   self.chord,
                bass:    bassNotes[bassIndex],
                tenor:   tenorNotes[tenorIndex],
                alto:    altoNotes[altoIndex],
                soprano: sopranoNotes[sopranoIndex]
            )

            if bassIndex < bassNotes.count - 1 {
                bassIndex++
            } else {
                bassIndex = 0
                if tenorIndex < tenorNotes.count - 1 {
                    tenorIndex++
                } else {
                    tenorIndex = 0
                    if altoIndex < altoNotes.count - 1 {
                        altoIndex++
                    } else {
                        altoIndex = 0
                        if sopranoIndex < sopranoNotes.count - 1 {
                            sopranoIndex++
                        } else {
                            done = true
                        }
                    }
                }
            }

            return chord
        }
    }
}

var generator = ChordEnumerator(chord: Chord(C)).generate()
generator.next()

for thing in ChordEnumerator(chord: Chord(C)) {
    println(thing)
}



let enumerator = ChordEnumerator(chord: Chord(G))
enumerator.notesInRange(enumerator.bassRange)

