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
//            key.two,
//            key.five,
//            key.four,
//            key.five,
//            key.two,
//            key.seven,
            key.one,
            key.one,
            key.one,
            key.one,
            key.one,
            key.one,
            key.one,
            key.one,
        ].map { ChordEnumerator(chord: $0, randomize: true) }

        var solver = RecursiveSolver(
            enumerators: enumerators,
            chordConstraint:
                  noVoiceCrossingConstraint
                & completeChordConstraint
                & noMoreThanOneOctaveBetweenVoices,
//                            & allowRootNotes([0, 7]), // This causes no matches to be found, Bug? :-/
            adjacentConstraint:
                not(parallelIntervalConstraint(7)) & // This is buggy
                not(parallelIntervalConstraint(5)) & // This is buggy
                smallJumpsConstraint(7)
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

