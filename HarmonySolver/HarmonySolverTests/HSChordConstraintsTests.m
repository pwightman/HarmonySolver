//
//  HSChordConstraintsTests.m
//  HarmonySolver
//
//  Created by Parker Wightman on 8/21/13.
//  Copyright (c) 2013 Alora Studios. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HSChordConstraints.h"
#import "HSNote.h"

@interface HSChordConstraintsTests : XCTestCase

@end

@implementation HSChordConstraintsTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testNoVoiceCrossing
{
    HSFourPartChord *chord = [HSFourPartChord fourPartChordWithChord:[HSChord G]
                                                                bass:1
                                                               tenor:2
                                                                alto:3
                                                             soprano:4];
    
    XCTAssert([HSChordConstraints noVoiceCrossing](chord), @"");
    
    chord = [HSFourPartChord fourPartChordWithChord:[HSChord G]
                                               bass:1
                                              tenor:3
                                               alto:2
                                            soprano:4];
    
    XCTAssertFalse([HSChordConstraints noVoiceCrossing](chord), @"");
}

- (void)testCompleteChord {
    NSInteger bass    = [HSNote noteWithType:HSNoteB octave:3].absoluteValue;
    NSInteger tenor   = [HSNote noteWithType:HSNoteDsharp octave:4].absoluteValue;
    NSInteger alto    = [HSNote noteWithType:HSNoteB octave:5].absoluteValue;
    NSInteger soprano = [HSNote noteWithType:HSNoteFsharp octave:5].absoluteValue;
    
    HSFourPartChord *chord = [HSFourPartChord fourPartChordWithChord:[HSChord B]
                                                                bass:bass
                                                               tenor:tenor
                                                                alto:alto
                                                             soprano:soprano];
    
    XCTAssert([HSChordConstraints completeChord](chord), @"");
    
    // Missing G
    bass    = [HSNote noteWithType:HSNoteB octave:3].absoluteValue;
    tenor   = [HSNote noteWithType:HSNoteDsharp octave:4].absoluteValue;
    alto    = [HSNote noteWithType:HSNoteB octave:5].absoluteValue;
    soprano = [HSNote noteWithType:HSNoteB octave:5].absoluteValue;
    
    chord = [HSFourPartChord fourPartChordWithChord:[HSChord B]
                                               bass:bass
                                              tenor:tenor
                                               alto:alto
                                            soprano:soprano];
    
    XCTAssertFalse([HSChordConstraints completeChord](chord), @"");
    
    // Missing E
    bass    = [HSNote noteWithType:HSNoteB octave:3].absoluteValue;
    tenor   = [HSNote noteWithType:HSNoteFsharp octave:4].absoluteValue;
    alto    = [HSNote noteWithType:HSNoteB octave:5].absoluteValue;
    soprano = [HSNote noteWithType:HSNoteFsharp octave:5].absoluteValue;
    
    chord = [HSFourPartChord fourPartChordWithChord:[HSChord B]
                                               bass:bass
                                              tenor:tenor
                                               alto:alto
                                            soprano:soprano];
    
    XCTAssertFalse([HSChordConstraints completeChord](chord), @"");
    
    // Missing C
    bass    = [HSNote noteWithType:HSNoteFsharp octave:3].absoluteValue;
    tenor   = [HSNote noteWithType:HSNoteDsharp octave:4].absoluteValue;
    alto    = [HSNote noteWithType:HSNoteFsharp octave:5].absoluteValue;
    soprano = [HSNote noteWithType:HSNoteDsharp octave:5].absoluteValue;
    
    chord = [HSFourPartChord fourPartChordWithChord:[HSChord B]
                                               bass:bass
                                              tenor:tenor
                                               alto:alto
                                            soprano:soprano];
    
    XCTAssertFalse([HSChordConstraints completeChord](chord), @"");
}

@end
