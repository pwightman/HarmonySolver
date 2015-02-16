//
//  AppDelegate.swift
//  HarmonySolver
//
//  Created by Parker Wightman on 2/9/15.
//  Copyright (c) 2015 Alora Studios. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        println("Starting")

        let key = Key(C)

        let enumerators = [
            key.two,
            key.five,
            key.one,
        ].map { ChordEnumerator(chord: $0) }

        var solverGenerator = HarmonySolver(
            enumerators: enumerators,
            chordConstraint:
                  noVoiceCrossingConstraint
                & completeChordConstraint
                & noMoreThanOneOctaveBetweenVoices,
            //                & allowRootNotes([0, 7]), // This causes no matches to be found, Bug? :-/
            adjacentConstraint:
            //                  noParallelFifthsConstraint // This is buggy
                smallJumpsConstraint(12)
        ).generate()

        while let solution = solverGenerator.next() {
            let serializer = LilyPondSerializer(chords: solution)
            println(serializer.toString())
        }
        
        println("Done")
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

