//
//  ChordProgression.swift
//  HarmonySolver
//
//  Created by Parker Wightman on 2/16/15.
//  Copyright (c) 2015 Alora Studios. All rights reserved.
//

import Foundation

public struct ChordProgression {
    public let key: Key
    public let chords: [FourPartChord]

    public init(key: Key, chords: [FourPartChord]) {
        self.key = key
        self.chords = chords
    }
}