//
//  SolverStrategy.swift
//  HarmonySolver
//
//  Created by Parker Wightman on 2/28/15.
//  Copyright (c) 2015 Alora Studios. All rights reserved.
//

import Foundation

public protocol SolverStrategy : SequenceType {
    var enumerators: [ChordEnumerator] { get }
    var chordConstraint: ChordConstraint { get }
    var adjacentChordConstraint: AdjacentChordConstraint  { get }
    init(enumerators: [ChordEnumerator], chordConstraint: ChordConstraint, adjacentConstraint: AdjacentChordConstraint)
}
