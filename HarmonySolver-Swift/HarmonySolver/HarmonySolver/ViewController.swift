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
        let key = Key(.C)

        let enumerators = [
            key.one,
            key.four,
            key.two,
            key.five,
            key.three,
            key.six.minor,
            key.two.add(6),
            key.six.minor,
            key.four.add(6),
            key.four.add(6),
            key.one,
            key.five,
            key.one
        ].map { ChordEnumerator(chord: $0, randomize: true) }

        var solver = RecursiveSolver(
            enumerators: enumerators,
            chordConstraint:
                  noVoiceCrossingConstraint
                & completeChordConstraint
                & tenorAltoIntervalConstraint(12)
                & altoSopranoIntervalConstraint(12)
                & bassTenorIntervalConstraint(19),
            adjacentConstraint:
                not(parallelIntervalConstraint(7))
                & not(parallelIntervalConstraint(5))
                & smallJumpsConstraint(4)
        )

        var generator = solver.generate()
        if let solution = generator.next() {
            println(LilyPondSerializer(chords: solution).toString())
            let URL = NSBundle.mainBundle().URLForResource("correct-four-part", withExtension: "mid")!
            var error: NSError? = nil
            let sequence = MIKMIDISequence.fromProgression(solution)
//            printSequence(sequence)
            println(error)
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

