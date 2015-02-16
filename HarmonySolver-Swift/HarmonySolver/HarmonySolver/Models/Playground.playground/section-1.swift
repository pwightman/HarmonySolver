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

func rest<T>(array: [T]) -> [T] {
    var new: [T] = []
    for i in 1..<array.count {
        new.append(array[i])
    }
    return new
}

struct PermutationGenerator<T> : GeneratorType {
    private let sequences: [SequenceOf<T>]
    private var generator: GeneratorOf<[T]>?

    init(sequences: [SequenceOf<T>]) {
        self.sequences = sequences
        switch sequences.count {
        case 0: self.generator = nil
        case 1:
            var generator = sequences.first?.generate()
            self.generator = GeneratorOf {
                if let el = generator?.next() {
                    return [el]
                } else {
                    return nil
                }
            }
        default:
            var newSequences: [SequenceOf<T>] = rest(self.sequences)
            var restGenerator = PermutationGenerator(sequences: newSequences)
            var firstGenerator = self.sequences[0].generate()
            var currentRestElement = restGenerator.next()
            var currentFirstElement = firstGenerator.next()
            self.generator = GeneratorOf {
                switch (currentFirstElement, currentRestElement) {
                case (.Some(let first), .Some(let rest)):
                    currentFirstElement = firstGenerator.next()
                    return rest + [first]
                case (.None, .Some(let rest)):
                    firstGenerator = self.sequences.first!.generate()
                    currentRestElement = restGenerator.next()
                    if let el = firstGenerator.next(), restEl = currentRestElement {
                        currentFirstElement = firstGenerator.next()
                        return restEl + [el]
                    } else {
                        return nil
                    }
                case (.Some, .None), (.None, .None): return nil
                }
            }
        }
    }

    mutating func next() -> [T]? {
        return generator?.next()
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
        var generator = PermutationGenerator(sequences: [bassNotes, tenorNotes, altoNotes, sopranoNotes].map { SequenceOf($0) }.reverse())
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

typealias HarmonyConstraintBlock = [FourPartChord] -> Bool
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
    Set(chord.values.map {
        $0.absoluteValue % 12
    }).count == chord.chord.semitones.count
}


func &<T>(lhs: T -> Bool, rhs: T -> Bool) -> T -> Bool {
    return { t in return lhs(t) && rhs(t) }
}

//filter(enumerator, noVoiceCrossingConstraint & completeChordConstraint).count

var generator = ChordEnumerator(chord: Chord(C)).generate()
generator.next()

//for thing in ChordEnumerator(chord: Chord(C)) {
//    println(thing)
//}

func everyTwo<T,U>(sequence: SequenceOf<T>, block: (T, T) -> U) -> U? {
    var generator = sequence.generate()
    var first = generator.next()
    var second = generator.next()
    var ret: U?
    while let f = first, s = second {
        ret = block(f, s)
        first = second
        second = generator.next()
    }
    return ret
}

struct HarmonySolver : SequenceType {
    let enumerators: [ChordEnumerator]
    let chordConstraint: ChordConstraintBlock
    let adjacentChordConstraint: AdjacentChordConstraintBlock

    init(enumerators: [ChordEnumerator], chordConstraint: ChordConstraintBlock, adjacentConstraint: AdjacentChordConstraintBlock) {
        self.enumerators = enumerators
        self.chordConstraint = chordConstraint
        self.adjacentChordConstraint = adjacentConstraint
    }

    func generate() -> GeneratorOf<[FourPartChord]> {
        var arrays = enumerators.map {
            Array($0).filter {
                return self.chordConstraint($0)
            }
        }
        var generator = PermutationGenerator(sequences: arrays.map { SequenceOf($0) }.reverse())
        return GeneratorOf {
            while let chords = generator.next() {
                if let bool = everyTwo(SequenceOf(chords), self.adjacentChordConstraint) where bool {
                    return chords
                }
            }
            return nil
        }
    }
}

//Array(ChordEnumerator(chord: Chord(C))).count

var solverGenerator = HarmonySolver(
    enumerators: [ChordEnumerator(chord: Chord(G).seven), ChordEnumerator(chord: Chord(C))],
    chordConstraint: noVoiceCrossingConstraint & completeChordConstraint,
    adjacentConstraint: noParallelFifthsConstraint
).generate()

//while let el = solverGenerator.next() fa
//    println(el)
//}

println(solverGenerator.next()!)
println(solverGenerator.next()!)
println(solverGenerator.next()!)
println(solverGenerator.next()!)
println(solverGenerator.next()!)
