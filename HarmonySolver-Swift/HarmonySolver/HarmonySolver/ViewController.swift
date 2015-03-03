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
    class func fromProgression(chords: [FourPartChord]) -> MIKMIDISequence {
        let sopranoNotes = chords.map { $0.soprano }
        let altoNotes = chords.map { $0.alto }
        let tenorNotes = chords.map { $0.tenor }
        let bassNotes = chords.map { $0.bass }

        let sequence = MIKMIDISequence()
        sequence.setOverallTempo(60)
        sequence.setOverallTimeSignature(MIKMIDITimeSignatureMake(4, 4))

        let track = sequence.addTrack()
        let treble = zip(altoNotes, sopranoNotes)
        let bass = zip(tenorNotes, bassNotes)
        [treble, bass].map { staffVoices -> MIKMIDITrack in
            let track = sequence.addTrack()
            for pair in enumerate(staffVoices) {
                [pair.element.0, pair.element.1].map { note -> MIKMIDINoteEvent in
                    MIKMIDINoteEvent(timeStamp: MusicTimeStamp(pair.index), note: UInt8(note.absoluteValue), velocity: 90, duration: 1.0, channel: 0)
                }.map(track.insertMIDIEvent)
            }
            return track
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

    func printSequence(sequence: MIKMIDISequence) {
        func printTrack(track: MIKMIDITrack) {
            println("Track \(track)")
            for event in track.events! as! [MIKMIDIEvent] {
                println(event)
            }
        }
        let tracks = [sequence.tempoTrack] + sequence.tracks as! [MIKMIDITrack]
        tracks.map(printTrack)
    }

    @IBAction func buttonTapped(sender: AnyObject) {
        let key = Key(.C, minor: false)

        var constraints: [ChordConstraint] = [
            inversionConstraint(0),
            inversionConstraint(2),
            inversionConstraint(1),
            inversionConstraint(0),
            inversionConstraint(2),
            inversionConstraint(0),
            inversionConstraint(0)
        ]

        var enumerators = [
            key.one,
            key.five,
            key.one,
            key.four,
            key.one,
            key.five.seven,
            key.one
        ].map { ChordEnumerator(chord: $0, randomize: true) }.map { SequenceOf($0) }

        // apply inversion constraints to all enumerators
        enumerators = map(zip(enumerators, constraints)) { SequenceOf(filter($0, $1)) }

        var solver = RecursiveSolver(
            enumerators: enumerators,
            chordConstraint:
                  noVoiceCrossingConstraint
                & completeChordConstraint
                & tenorAltoIntervalConstraint(12)
                & altoSopranoIntervalConstraint(12)
                & bassTenorIntervalConstraint(20),
            adjacentConstraint:
                  not(parallelIntervalConstraint(7)) // parallel 5ths
                & not(parallelIntervalConstraint(5)) // parallel 4ths
                & smallJumpsConstraint(7)
        )

        var generator = solver.generate()
        if let solution = generator.next() {
            println(LilyPondSerializer(chords: solution).toString())
            let URL = NSBundle.mainBundle().URLForResource("correct-four-part", withExtension: "mid")!
            var error: NSError? = nil
            let sequence = MIKMIDISequence.fromProgression(solution)
            self.sequencer = MIKMIDISequencer(sequence: sequence)
            let soundFileURL = NSBundle.mainBundle().URLForResource("soundfont-stripped", withExtension: "sf2")!
            self.sequencer.builtinSynthesizer.loadSoundfontFromFileAtURL(soundFileURL, error: nil)
            println(error)
            self.sequencer.startPlayback()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

