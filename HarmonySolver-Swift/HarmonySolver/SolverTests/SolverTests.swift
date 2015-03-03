//
//  SolverTests.swift
//  SolverTests
//
//  Created by Parker Wightman on 2/22/15.
//  Copyright (c) 2015 Alora Studios. All rights reserved.
//

import UIKit
import XCTest
import Solver

class SolverTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParallelFifths() {
        // Parallel fifths because they're they same chord
        let first = FourPartChord(
            chord:   Chord(.G),
            bass:    Note(.G,3),
            tenor:   Note(.D,4),
            alto:    Note(.B,4),
            soprano: Note(.G,5)
        )

        let second = FourPartChord(
            chord:   Chord(.G),
            bass:    Note(.G,3),
            tenor:   Note(.D,4),
            alto:    Note(.B,4),
            soprano: Note(.G,5)
        )

        XCTAssertEqual(parallelIntervalConstraint(7)(first, second), true, "")
    }

    func testParallelFifths2() {
        // Parallel fifths from G/D -> F/C
        let first = FourPartChord(
            chord:   Chord(.G),
            bass:    Note(.G,3),
            tenor:   Note(.D,4),
            alto:    Note(.B,4),
            soprano: Note(.G,5)
        )

        let second = FourPartChord(
            chord:   Chord(.F),
            bass:    Note(.F,4),
            tenor:   Note(.C,5),
            alto:    Note(.A,5),
            soprano: Note(.F,6)
        )

        XCTAssertEqual(parallelIntervalConstraint(7)(first, second), true, "")
    }

    func testParallelFifths3() {
        // No parallel fifths
        let first = FourPartChord(
            chord:   Chord(.F),
            bass:    Note(.F,4),
            tenor:   Note(.C,5),
            alto:    Note(.A,5),
            soprano: Note(.F,6)
        )

        let second = FourPartChord(
            chord:   Chord(.G),
            bass:    Note(.D,4),
            tenor:   Note(.B,4),
            alto:    Note(.G,5),
            soprano: Note(.B,5)
        )

        println(LilyPondSerializer(chords: [first, second]).toString())

        XCTAssertEqual(parallelIntervalConstraint(7)(first, second), false, "")
    }

    func testParallelFourths() {
        let first = FourPartChord(
            chord:   Chord(.G),
            bass:    Note(.G,3),
            tenor:   Note(.C,4),
            alto:    Note(.B,4),
            soprano: Note(.G,5)
        )

        let second = FourPartChord(
            chord:   Chord(.F),
            bass:    Note(.F,3),
            tenor:   Note(.BFlat,3),
            alto:    Note(.A,4),
            soprano: Note(.F,5)
        )

        println(LilyPondSerializer(chords: [first, second]).toString())

        XCTAssertEqual(parallelIntervalConstraint(5)(first, second), true, "")
    }

    func testChordEnumerators() {
        var enumerator = ChordEnumerator(chord: Chord(.C))
        XCTAssertEqual(Array(enumerator).count, 1080, "") // 6 bass * 6 tenor * 5 alto * 6 soprano = 1080
        var constraint = pinnedVoiceConstraint(.Bass, Note(.E,3))
        XCTAssertEqual(filter(enumerator, constraint).count, 180, "")
        constraint = constraint & pinnedVoiceConstraint(.Tenor, Note(.C,4))
        XCTAssertEqual(filter(enumerator, constraint).count, 30, "")
        constraint = constraint & pinnedVoiceConstraint(.Alto, Note(.E,5))
        XCTAssertEqual(filter(enumerator, constraint).count, 6, "")
        constraint = constraint & pinnedVoiceConstraint(.Soprano, Note(.C,6))
        XCTAssertEqual(filter(enumerator, constraint).count, 1, "")
    }

    func testInversionConstraint1() {
        let chord = FourPartChord(
            chord:   Chord(.G),
            bass:    Note(.G,3),
            tenor:   Note(.C,4),
            alto:    Note(.B,4),
            soprano: Note(.G,5)
        )

        XCTAssertTrue(inversionConstraint(0)(chord), "")
    }

    func testInversionConstraint2() {
        let chord = FourPartChord(
            chord:   Chord(.G),
            bass:    Note(.E,3),
            tenor:   Note(.C,4),
            alto:    Note(.B,4),
            soprano: Note(.G,5)
        )

        XCTAssertFalse(inversionConstraint(0)(chord), "")
    }

    func testInversionConstraint3() {
        let chord = FourPartChord(
            chord:   Chord(.G),
            bass:    Note(.B,4),
            tenor:   Note(.C,4),
            alto:    Note(.B,4),
            soprano: Note(.G,5)
        )

        XCTAssertTrue(inversionConstraint(1)(chord), "")
    }

}
