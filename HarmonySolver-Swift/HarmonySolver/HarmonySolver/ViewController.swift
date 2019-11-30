//
//  ViewController.swift
//  HarmonySolver
//
//  Created by Parker Wightman on 2/9/15.
//  Copyright (c) 2015 Alora Studios. All rights reserved.
//

import UIKit
import MIKMIDI
import Solver

extension MIKMIDISequence {
    class func fromProgression(_ chords: [FourPartChord]) -> MIKMIDISequence {
        let sopranoNotes = chords.map { $0.soprano }
        let altoNotes = chords.map { $0.alto }
        let tenorNotes = chords.map { $0.tenor }
        let bassNotes = chords.map { $0.bass }

        let sequence = MIKMIDISequence()
        sequence.setOverallTempo(60)
        sequence.setOverallTimeSignature(MIKMIDITimeSignatureMake(4, 4))

        // TODO: Is this necessary?
//        _ = sequence.addTrack()
        let treble = zip(altoNotes, sopranoNotes)
        let bass = zip(tenorNotes, bassNotes)
        [treble, bass].forEach { staffVoices in
            let track = sequence.addTrack()!
            for pair in staffVoices.enumerated() {
                [pair.element.0, pair.element.1].forEach { note in
                    let event = MIKMIDINoteEvent(timeStamp: MusicTimeStamp(pair.offset), note: UInt8(note.absoluteValue), velocity: 90, duration: 1.0, channel: 0)
                    track.insert(event)
                }
            }
        }

        return sequence
    }
}


class ViewController: UIViewController {

    var sequencer: MIKMIDISequencer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

//    func printSequence(sequence: MIKMIDISequence) {
//        func printTrack(track: MIKMIDITrack) {
//            println("Track \(track)")
//            for event in track.events! as! [MIKMIDIEvent] {
//                println(event)
//            }
//        }
//        let tracks = [sequence.tempoTrack] + sequence.tracks as! [MIKMIDITrack]
//        tracks.map(printTrack)
//    }

    @IBAction func buttonTapped(sender: AnyObject) {
        let key = Key(.A, minor: true)

        let constraints: [ChordConstraint] = [
            inversionConstraint(0),
            inversionConstraint(2),
            inversionConstraint(1),
            inversionConstraint(0),
            inversionConstraint(2),
            inversionConstraint(0),
            inversionConstraint(0)
        ]

        let enumerators = [
            key.one,
            key.four,
            key.five,
            key.six,
            key.one,
//            key.seven,
//            key.three,
//            key.two,
//            key.five,
//            key.one
        ].map { ChordEnumerator(chord: $0, randomize: true) }

        // apply inversion constraints to all enumerators
        let filteredEnumerators =  zip(enumerators, constraints).map { $0.filter($1) }
        
        

        let solver = RecursiveSolver(
            enumerators: enumerators,
            chordConstraint:
                  noVoiceCrossingConstraint
                & completeChordConstraint
                & tenorAltoIntervalConstraint(12)
                & altoSopranoIntervalConstraint(12)
                & bassTenorIntervalConstraint(12),
            adjacentConstraint:
                  not(parallelIntervalConstraint(7)) // parallel 5ths
                & not(parallelIntervalConstraint(5)) // parallel 4ths
                & smallJumpsConstraint(7)
                & smallJumpsAltoConstraint(3)
//                & descendingBass()
//                & ascendingSoprano()
        )

        let generator = solver.makeIterator()
        if let solution = generator.next() {
            print(LilyPondSerializer(chords: solution).toString())
//            let URL = Bundle.main.url(forResource: "correct-four-part", withExtension: "mid")!
            let sequence = MIKMIDISequence.fromProgression(solution)
            self.sequencer = MIKMIDISequencer(sequence: sequence)
            let soundFileURL = Bundle.main.url(forResource: "soundfont-stripped", withExtension: "sf2")!
            try! self.sequencer.builtinSynthesizer.loadSoundfontFromFile(at: soundFileURL)
            self.sequencer.startPlayback()
        } else {
            print("No solution")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

