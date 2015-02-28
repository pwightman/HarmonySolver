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

}
