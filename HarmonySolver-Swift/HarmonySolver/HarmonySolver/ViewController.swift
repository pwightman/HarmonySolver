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
import WebKit

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
        let track = try! sequence.addTrack()
        let treble = zip(altoNotes, sopranoNotes)
        let bass = zip(tenorNotes, bassNotes)

        [treble, bass].forEach { staffVoices in
            // Separate tracks doesn't make a difference
            // let track = try! sequence.addTrack()
            for pair in staffVoices.enumerated() {
                [pair.element.0, pair.element.1].forEach { note in
                    let event = MIKMIDINoteEvent(timeStamp: MusicTimeStamp(pair.offset), note: UInt8(note.absoluteValue), velocity: 90, duration: 1.0, channel: 0)
                    print("Adding event at timeStamp \(MusicTimeStamp(pair.offset)) value \(note.absoluteValue)")
                    track.addEvent(event)
                }
            }
        }

        return sequence
    }
}

func vexNote(for note: Note) -> String {
    let noteStr: String
    switch note.noteType {
    case .aFlat: noteStr = "Ab"
    case .a: noteStr = "A"
    case .aSharp: noteStr = "A#"
    case .bFlat: noteStr = "Bb"
    case .b: noteStr = "B"
    case .c: noteStr = "C"
    case .cSharp: noteStr = "C#"
    case .dFlat: noteStr = "Db"
    case .d: noteStr = "D"
    case .dSharp: noteStr = "D#"
    case .eFlat: noteStr = "Eb"
    case .e: noteStr = "E"
    case .f: noteStr = "F"
    case .fSharp: noteStr = "F#"
    case .gFlat: noteStr = "Gb"
    case .g: noteStr = "g"
    case .gSharp: noteStr = "G#"
    }
    return "\(noteStr)\(note.octave - 1)";
}

func vexNotes(for notes: [Note]) -> String {
    return notes
        .map { vexNote(for: $0) + "/q" }
        .joined(separator: ", ")
}

func systemsForNotes(for notes: [Note]) -> [String] {
    if notes.count <= 4 {
        return [vexNotes(for: notes)]
    } else {
        return [vexNotes(for: Array(notes.prefix(4)))] + systemsForNotes(for: Array(notes.dropFirst(4)))
    }
}

func serializeForVex(chords: [FourPartChord]) -> String {
    let json = [
        "soprano": systemsForNotes(for: chords.map { $0.soprano }),
        "alto": systemsForNotes(for: chords.map { $0.alto }),
        "tenor": systemsForNotes(for: chords.map { $0.tenor }),
        "bass": systemsForNotes(for: chords.map { $0.bass }),
    ]
    
    let data = try! JSONEncoder().encode(json)
    
    return String(data: data, encoding: .utf8)!
}

class ViewController: UIViewController {

    var sequencer: MIKMIDISequencer!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let html = try! String(contentsOfFile: Bundle.main.path(forResource: "staff", ofType: "html")!)
        let js = try! String(contentsOfFile: Bundle.main.path(forResource: "vexflow", ofType: "min.js")!)
        
        webView.loadHTMLString(html, baseURL: nil)
        webView.evaluateJavaScript(js) { (result, error) in
            if let error = error {
                print("Error! \(error)")
            } else {
                
            }
        }
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
        let key = Key(.a, minor: false)

        let enumerators: [(Chord, [ChordConstraint])] = [
            (key.one, []),
            (key.four, []),
            (key.five, []),
            (key.six, []),
            (key.seven, []),
            (key.six, []),
            (key.seven, []),
            (key.one, [inversionConstraint(0)]),
        ]

        // apply inversion constraints to all enumerators
        let filteredEnumerators =  enumerators
            .map {
                ChordEnumerator(chord: $0.0, randomize: true)
                    .filter($0.1.reduce({_ in true}, {$0 & $1}))
            }
        
        

        let solver = RecursiveSolver(
            enumerators: filteredEnumerators,
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
//                & ascendingBass()
//                & ascendingSoprano()
        )

        let generator = solver.makeIterator()
        if let solution = generator.next() {
            print(LilyPondSerializer(chords: solution).toString())
//            let URL = Bundle.main.url(forResource: "correct-four-part", withExtension: "mid")!
            let sequence = MIKMIDISequence.fromProgression(solution)
            let url = getDocumentsDirectory().appendingPathComponent("sequence").appendingPathExtension("midi")
            print(url)
            try! sequence.write(to: url)
            self.sequencer = MIKMIDISequencer(sequence: sequence)
            let soundFileURL = Bundle.main.url(forResource: "GrandPiano", withExtension: "sf2")!
            for track in sequence.tracks {
                try! self.sequencer.builtinSynthesizer(for: track)?.loadSoundfontFromFile(at: soundFileURL)
            }
            self.sequencer.startPlayback()
            
            var appJS = try! String(contentsOfFile: Bundle.main.path(forResource: "app", ofType: "js")!)
            print(serializeForVex(chords: solution))
            appJS = appJS.replacingOccurrences(of: "%json%", with: serializeForVex(chords: solution))
            
            self.webView.evaluateJavaScript(appJS) { (_, error) in
                if let error = error {
                    print("App js error \(error)")
                }
            }
            print("It worked?")
        } else {
            print("No solution")
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}
