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

func <(lhs: Note, rhs: Note) -> Bool {
    return lhs.absoluteValue < rhs.absoluteValue
}

struct Note : Hashable, Comparable, Printable, DebugPrintable {
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

    var stringForNoteType: String {
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

    var hashValue: Int {
        return self.absoluteValue.hashValue
    }
}

func ==(lhs: Chord, rhs: Chord) -> Bool {
    return lhs.noteType == rhs.noteType && lhs.semitones == rhs.semitones
}

struct Chord : Equatable, Printable, DebugPrintable {
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

    var description: String {
        return Note(absoluteValue: self.noteType).description
    }

    var debugDescription: String {
        return self.description
    }

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

struct FourPartChord : Equatable, Printable, DebugPrintable {
    let chord: Chord
    let bass: Note
    let tenor: Note
    let alto: Note
    let soprano: Note

    var values: [Note] {
        return [bass, tenor, alto, soprano]
    }

    var description: String {
        return "\(Note(absoluteValue: chord.noteType)) \(bass) \(tenor) \(alto) \(soprano)"
    }

    var debugDescription: String {
        return self.description
    }
}

FourPartChord(
    chord:   Chord(C),
    bass:    Note(C,3),
    tenor:   Note(G,3),
    alto:    Note(E,5),
    soprano: Note(C,6)
)

func any<T>(array: [T], block: T -> Bool) -> Bool {
    for el in array {
        if block(el) {
            return true
        }
    }
    return false
}

func all<T>(array: [T], block: T -> Bool) -> Bool {
    for el in array {
        if !block(el) {
            return false
        }
    }
    return true
}

struct PermutationGenerator<T> : GeneratorType {
    let arrays: [[T]]
    var indexes: [Int]
    var done = false

    init(arrays: [[T]]) {
        self.arrays = arrays
        self.indexes = [Int]()
        for i in 0..<arrays.count {
            self.indexes.append(0)
        }
    }

    mutating func next() -> [T]? {
        // If any of the arrays are empty, a proper permutation can't be made
        if done || any(self.arrays, { $0.isEmpty }) {
            return nil
        }
        // The current set of indexes should have a valid set
        var returnArray: [T] = []
        for (i, arr) in enumerate(self.arrays) {
            returnArray.append(arr[indexes[i]])
        }

        for i in 0..<indexes.count {
            let sequence = self.arrays[i]
            var currentIndex = indexes[i]
            if currentIndex < sequence.count - 1 {
                indexes[i] += 1
                break
            } else if i == indexes.count - 1 {
                self.done = true
            } else {
                self.indexes[i] = 0
            }
        }

        return returnArray
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
        var generator = PermutationGenerator(arrays: [bassNotes, tenorNotes, altoNotes, sopranoNotes])
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

//let enumerator = ChordEnumerator(chord: Chord(C))
//enumerator.notesInRange(enumerator.bassRange)

typealias ChordConstraintBlock = FourPartChord -> Bool
typealias AdjacentChordConstraintBlock = (FourPartChord, FourPartChord) -> Bool

func zip<T,U>(first: [T], second: [U]) -> [(T,U)] {
    var list: [(T,U)] = []
    for (i, el) in enumerate(first) {
        list.append(el, second[i])
    }
    return list
}

let noParallelFifthsConstraint: AdjacentChordConstraintBlock = { first, second in
    return any(zip(first.values, second.values)) { pair in
        let hasParallelFifth: (Note, [Note]) -> Bool = { item, rest in
            any(rest) {
                let difference = (item.absoluteValue % 12) - ($0.absoluteValue % 12)
                return abs(difference) == 5 || abs(difference) == 7
            }
        }

        if hasParallelFifth(pair.0, first.values) && hasParallelFifth(pair.1, second.values) {
            return true
        }
        return false
    }
}

let secondChord = FourPartChord(chord: Chord(G), bass: Note(G,3), tenor: Note(D,4), alto: Note(G,5), soprano: Note(B,6))
let firstChord = FourPartChord(chord: Chord(CSharp), bass: Note(CSharp,3), tenor: Note(G,3), alto: Note(CSharp,5), soprano: Note(GSharp,6))

noParallelFifthsConstraint(firstChord, secondChord)

let noVoiceCrossingConstraint: ChordConstraintBlock = { chord in
    return chord.bass < chord.tenor &&
        chord.tenor < chord.alto &&
        chord.alto < chord.soprano
}

let completeChordConstraint: ChordConstraintBlock = { chord in
    return Set(chord.values.map {
        $0.absoluteValue % 12
    }).count == chord.chord.semitones.count
}


func &(lhs: ChordConstraintBlock, rhs: ChordConstraintBlock) -> ChordConstraintBlock {
    return { chord in return lhs(chord) && rhs(chord) }
}

//filter(enumerator, noVoiceCrossingConstraint & completeChordConstraint).count

//for thing in ChordEnumerator(chord: Chord(C)) {
//    println(thing)
//}

struct HarmonySolver : SequenceType {
    let enumerators: [ChordEnumerator]
    let constraint: ChordConstraintBlock

    init(enumerators: [ChordEnumerator], constraint: ChordConstraintBlock) {
        self.enumerators = enumerators
        self.constraint = constraint
    }

    func generate() -> GeneratorOf<[FourPartChord]> {
        var arrays = enumerators.map {
            Array($0).filter {
                return self.constraint($0)
            }
        }
        var generator = PermutationGenerator(arrays: arrays)
        return GeneratorOf {
            return generator.next()
        }
    }
}

//Array(ChordEnumerator(chord: Chord(C))).count

//var solverGenerator = HarmonySolver(
//    enumerators: [ChordEnumerator(chord: Chord(C)), ChordEnumerator(chord: Chord(G))],
//    constraint: noVoiceCrossingConstraint & completeChordConstraint
//).generate()

//println(solverGenerator.next()!)
//println(solverGenerator.next()!)
//println(solverGenerator.next()!)
//println(solverGenerator.next()!)
//println(solverGenerator.next()!)
