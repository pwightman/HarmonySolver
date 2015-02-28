## Four-Part Harmony Solver in Swift

![](http://d.pr/i/gAmK/gpO0xwg6+)

Four-part harmony is a style of music writing where pitches are given to 4 voices (bass, tenor, alto, and soprano) to construct chords. In "proper" four-part harmony (read: the kind taught in college but hardly used in modern music writing), the intervals between voices and how they move from chord to chord should follow particular rules, hereafter referred to as *constraints*. Examples of constraints are no parallel fifths between any two voices moving from one chord to another, no doubling the third, etc. A more thorough treatment of the "rules" can be found [here](http://d.pr/f/6ad9/5k6SrIi8+).

Given a set of abstract chords, such as Dm -> G7 -> C (or ii -> V7 -> I in the key of C, for the music theory savvy), this library will "solve" for a four-part harmony matching those chords and a given set of constraints. Solving involves the building up of notes and abstract chords into concrete chords, enumerating over various combinations of concrete chords, and satisfying constraints.

## Notes

`NoteType` is an enum representing all the note types (C, C#...B). The `value` property returns
a number 0, 1,...11, representing C, C#,...B respectively.

```swift
let noteType = NoteType.C
noteType.value // 0
```

`Note` objects define absolute pitches as used by MIDI, where the notation C5 denotes the note C at the 5th octave. For frame of reference, C5 is considered middle C. Notes are also given an absolute numeric value that uniquely identifies a given note at a specific octave. C0 is 0 and C5 is 60. [See diagram](http://www.midimountain.com/midi/midi_note_numbers.html).

```swift
Note(.C, 5)
Note(absoluteValue: 60)
```

## Abstract Chords

Abstract chords are constructed using `Chord` objects. Each chord (A - G) starts as a 1-3-5 major triad. Subsequent method and properties such as `minor`, `seven`, and `flat` modify the initial triad.

```objc
Chord(.G)
Chord(.G).minor.seven.flat(9)

Chord(.G).minor
// same as
Chord(.G).flat(3)

Chord(.G).seven
// same as
Chord(.G).flat(7)
```

Calling `semitones` returns all half-step intervals in the chord from the root. (0 - 23)

```objc
Chord(.G).semitones       // [ 0, 4, 7 ]
Chord(.G).seven.semitones // [ 0, 4, 7, 10 ]
Chord(.G).nine.semitones  // [ 0, 4, 7, 14 ]
```

The `noteType` property returns a `NoteType` enum representing the root note of the chord.

```objc
Chord(.G).noteType.value // 7
```

## Four-Part Chords

`FourPartChord` is a concrete chord, made up of an abstract chord and concrete
`Note` objects for each voice.

```objc
let chord = FourPartChord(
    chord:   Chord(.C)
    bass:    Note(.C,4)
    tenor:   Note(.G,4)
    alto:    Note(.C,5)
    soprano: Note(.E,5)
)
```

### Four-Part Chord Enumerator

Enumerates through all possible four-part chord arrangements for the given chord, including invalid/bad style ones.

```objc
let enumerator = ChordEnumerator(chord: Chord(.C))
for chord in enumerator {
    // Do thing with chord
}
```

## Constraints

`ChordConstraint`s take in one `FourPartChord` object and return `true` or `false`.

```swift
typealias ChordConstraint = FourPartChord -> Bool
```

Many constraints are already built, such as `completeChordConstraint` which returns
`true` if all notes in a chord are represented in the `FourPartChord`, `noVoiceCrossingConstraint`
which returns `true` if none of the voices cross, and many more.

```swift
var chord = FourPartChord(
    chord:   Chord(.C)
    bass:    Note(.C,4)
    tenor:   Note(.G,4)
    alto:    Note(.C,5)
    soprano: Note(.E,5)
)

completeChordConstraint(chord) // true

chord = FourPartChord(
    chord:   Chord(.C)
    bass:    Note(.C,4)
    tenor:   Note(.G,4)
    alto:    Note(.C,5)
    soprano: Note(.C,6)
)

completeChordConstraint(chord) // false
```

Constraints can be composed with the `&` operator:

```swift
let constraint = completeChordConstraint & noVoiceCrossingConstraint
constraint(chord)
```

There are also `AdjacentChordConstraint` blocks to verify cross-chord constraints
such as parallel fifths or constraining how far a voice can jump between chords.

## Solver

Solving is done by using an object that conforms to the `SolverStrategy` protocol. There is
currently `PermutationSolver` (inefficient for many chords) and `RecursiveSolver`(fairly
efficient). A `SolverStrategy`, given an array of enumerators for each chord and
constraints, can produce a set of chords that pass all constraints.

```swift
var solver = RecursiveSolver(
    enumerators: enumerators,
    chordConstraint:
        noVoiceCrossingConstraint &
        completeChordConstraint &
        noMoreThanOneOctaveBetweenVoices,
    adjacentConstraint:
        not(parallelIntervalConstraint(7)) &
        not(parallelIntervalConstraint(5)) &
        smallJumpsConstraint(7)
)

if let chords = solver.generate().next {
    // chords is a [FourPartChord] which passes all constraints
}
```

### Helper: Key

Key allows you to express chords in terms of ii-V-I (two-five-one) instead of D-G-C. Basic semantics of the key are applied as well, such as the two chord being minor.

```swift
let key = Key(.C)
key.two // Chord(.D).minor
key.five // Chord(.G)
key.one // Chord(.C)
```


## Putting it all together

```
let key = Key(.C)

let enumerators = [
    key.two,
    key.five,
    key.four,
    key.five,
    key.two,
    key.seven,
    key.one
].map { ChordEnumerator(chord: $0) }

var solver = RecursiveSolver(
    enumerators: enumerators,
    chordConstraint:
          noVoiceCrossingConstraint
        & completeChordConstraint
        & noMoreThanOneOctaveBetweenVoices,
    adjacentConstraint:
        not(parallelIntervalConstraint(7)) &
        not(parallelIntervalConstraint(5)) &
        smallJumpsConstraint(7)
)

var generator = solver.generate()
if let solution = generator.next() {
    println(solution)
}
```

## Roadmap

The current effort is to get a working solver using brute-force and strict constraint passing. While brute-force will likely be plenty performant for the uses of four-part harmony, it would be a great academic exercise to attempt more graceful/elegant/intelligent combinations of chords that increase either performance or the quality of solutions produced. It would also be nice to have more nuanced constraint passing, since there are certain rules where breaking them should be avoided where possible but is sometimes inevitable.

I also plan to open source a UI library for laying out notes on a staff which would be hugely useful for this library, but that's for another day.

## Contributing

You are welcome to help out with the different TODO list items. Be sure to write tests.

Built by [Parker Wightman](https://github.com/pwightman) ([@parkerwightman](https://twitter.com/parkerwightman)), feel free to ask questions on Twitter or via issues.
