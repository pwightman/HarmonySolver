## Four-Part Harmony Solver in Objective-C

![](http://d.pr/i/gAmK/gpO0xwg6+)

Four-part harmony is a style of music writing where pitches are given to 4 voices (bass, tenor, alto, and soprano) to construct chords. In "proper" four-part harmony (read: the kind taught in college but hardly used in modern music writing), the intervals between voices and how they move from chord to chord should follow particular rules, hereafter referred to as *constraints*. Examples of constraints are no parallel fifths between any two voices moving from one chord to another, no doubling the third, etc. A more thorough treatment of the "rules" can be found [here](http://d.pr/f/6ad9/5k6SrIi8+).

Given a set of abstract chords, such as Dm -> G7 -> C (or ii -> V7 -> I in the key of C, for the music theory savvy), this library will "solve" for a four-part harmony matching those chords and a given set of constraints. Solving involves the building up of notes and abstract chords into concrete chords, enumerating over various combinations of concrete chords, and satisfying constraints.

## Notes

`HSNote` objects define absolute pitches as used by MIDI, where the notation C5 denotes the note C at the 5th octave. For frame of reference, C5 is considered middle C. Notes are also given an absolute numeric value that uniquely identifies a given note at a specific octave. C0 is 0 and C5 is 60. [See diagram](http://www.midimountain.com/midi/midi_note_numbers.html).

```objc
HSNote *note = [HSNote noteWithType:HSNoteC octave:5];
[note absoluteValue];  // => 60
```

## Abstract Chords

Abstract chords are constructed using idiomatic messages on `HSChord` objects, which ought to be recognizable to any trained musician. Each chord (A - G) starts as a 1-3-5 major triad. Subsequent methods such as `minor`, `seven`, and `flat:` modify the initial triad.

```objc
HSChord *chord = [HSChord G];
HSChord *chord = [[HSChord G] minor];
HSChord *chord = [[[HSChord G] minor] seven];
HSChord *chord = [[[[HSChord G] minor] seven] flat:9];

HSChord *chord = [[HSChord G] minor];
// same as
HSChord *chord = [[HSChord G] flat:3];

HSChord *chord = [[HSChord G] seven];
// same as
HSChord *chord = [[HSChord G] flat:7];
```

Calling `halfSteps` returns the half-step interval from the root. (0 - 23)

```objc
NSArray *tones = [[HSChord G] halfSteps];         // @[ @0, @4, @7 ]
NSArray *tones = [[[HSChord G] seven] halfSteps]; // @[ @0, @4, @7, @10 ]
NSArray *tones = [[[HSChord G] nine] halfSteps];  // @[ @0, @4, @7, @14 ]
```

The `root` property returns an integer between 0 - 11 where 0 is C, 1 is C#, etc. These values correspond to C0 through B0 as defined by `HSNote`.

```objc
[HSChord G].root; // 7
```

## Four-Part Chords

`HSFourPartChord` is a concrete chord, made up of [MIDI absolute values](http://www.midimountain.com/midi/midi_note_numbers.html) for each voice.

```objc
HSFourPartChord *chord = [SHFourPartChord fourPartChordWithChord:[HSChord C]
                                                            bass:48    // C4
                                                           tenor:55    // G4
                                                            alto:60    // C5
                                                         soprano:64];  // E5
```

`HSNote` objects make building `HSFourPartChord` objects more idiomatic.

```objc
HSNote *bass    = [HSNote noteWithType:HSNoteTypeC octave:4];
HSNote *tenor   = [HSNote noteWithType:HSNoteTypeG octave:4];
HSNote *alto    = [HSNote noteWithType:HSNoteTypeC octave:5];
HSNote *soprano = [HSNote noteWithType:HSNoteTypeE octave:5];

HSFourPartChord *chord = [HSFourPartChord fourPartChordWithChord: [HSChord C]
                                                            bass: bass.absoluteValue
                                                           tenor: tenor.absoluteValue
                                                            alto: alto.absoluteValue
                                                         soprano: soprano.absoluteValue];
```


### Four-Part Chord Enumerator

Enumerates through all possible four-part chord arrangements for the given chord, including invalid/bad style ones. 
Rejection should happen later with constraints, not at this stage.

```objc
HSFourPartChordEnumerator *enumerator = [SHFourPartChordEnumerator enumeratorForChord:[HSChord G]];
HSFourPartChord *chord = nil;

while ( (chord = [enumerator nextChord]) ) {
    // Do something with chord
}
```

If some notes in the chord should hold static through enumeration (in the case of "starting pitches", for example), setting them explicitly will cause the enumerator not to move them. As such, setting all four voices explictly would result in a single variation.

```objc
HSFourPartChordEnumerator *enumerator = [SHFourPartChordEnumerator enumeratorForChord:[HSChord g]];
enumerator.bassNote    = @1;
enumerator.tenorNote   = @14;
enumerator.sopranoNote = @37;
```

---

**NOTE**: Only parts of the rest of this API have been implemented and are definitely subject to change. Feedback welcome.

---

### Solver

The solver solves for an array of `HSFourPartEnumerator` objects.

```objc
NSArray *enumerators = ...;
HSFourPartSolver *solver = [HSFourPartSolver solverForEnumerators:enumerators];
```

Constraints of various types can then be added to the solver. These constraint blocks take in chord(s) and return either `YES` or `NO` to indicate whether the chord(s) satisfy the constraint.

#### Single Chord Constraints

```objc
[solver addChordConstraint:^BOOL (HSFourPartChord *chord) {

}];
```

#### Adjacent chord constraints

```objc
[solver addAdjacentChordConstraint:^BOOL (HSFourPartChord *firstChord, HSFourPartChord *secondChord) {

}];
```

#### Consecutive Chord Constraints

Constraints on chord groups larger than two can use the `addConsecutiveChordConstraintWithWidth:block:` method. If the `width` is larger than the number of chords in the `HSChordSet` being solved, these constraints are ignored and a warning is printed to the console.

```objc
[solver addConsecutiveChordConstraintWithWidth:3 block:^BOOL (NSArray *chords) {

}];
```

#### Solutions

Calling `nextSolution` on the solver returns a solution as an array of `HSFourPartChord` objects with the same length as the given array of `HSFourPartChordEnumerator` objects. A solution is defined as a set of `HSFourPartChord` objects for which all constraint blocks return `YES`.

```objc
NSArray *solution = [solver nextSolution];
```

`nextSolution` can be called multiple times as multiple solutions may exist. It will return `nil` when there are no more solutions.

### Helper: HSKey

HSKey allows you to express chords in terms of ii-V-I (two-five-one) instead of D-G-C. Basic semantics of the key are applied as well, such as the two chord being minor.

```objc
HSKey *key = [HSKey keyWithType:HSKeyC];
HSChord *chord = [key twoChord];    // returns [[HSChord D] minor];
HSChord *chord = [key fiveChord];   // returns [HSChord G];     
HSChord *chord = [key oneChord];    // returns [HSChord C];
```

This could be extended to advanced chord types as well.

```objc
HSKey *key = [HSKey keyWithType:HSKeyCMinor];
```

## TODO

* Finish the solver.
* Finish writing constraint blocks for the [different rules](http://d.pr/f/6ad9/5k6SrIi8+).
* Write HSKey.
* Perhaps build a simple UI in the demo project to show the notes (though this could easily be an open-sourced library in and of itself)

## Roadmap

The current effort is to get a working solver using brute-force and strict constraint passing. While brute-force will likely be plenty performant for the uses of four-part harmony, it would be a great academic exercise to attempt more graceful/elegant/intelligent combinations of chords that increase either performance or the quality of solutions produced. It would also be nice to have more nuanced constraint passing, since there are certain rules where breaking them should be avoided where possible but is sometimes inevitable.

I also plan to open source a UI library for laying out notes on a staff which would be hugely useful for this library, but that's for another day.

## Contributing

You are welcome to help out with the different TODO list items. Be sure to write tests. This project uses Xcode \<redacted\>.

Built by [Parker Wightman](https://github.com/pwightman) ([@parkerwightman](https://twitter.com/parkerwightman)), feel free to ask questions on Twitter or via issues.
