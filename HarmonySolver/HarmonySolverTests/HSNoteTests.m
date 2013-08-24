//
//  HSNoteTests.m
//  HarmonySolver
//
//  Created by Parker Wightman on 8/17/13.
//  Copyright (c) 2013 Alora Studios. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HSNote.h"

@interface HSNoteTests : XCTestCase

@end

@implementation HSNoteTests

- (void)testTypeOctaveHaveCorrectAbsolute
{
    HSNote *note = [HSNote noteWithType:HSNoteC octave:5];
    XCTAssertEqual(60, note.absoluteValue, @"");
}

- (void)testAbsoluteHasCorrectNoteAndOctave
{
    HSNote *note = [HSNote noteWithAbsoluteValue:60];
    XCTAssertEqual(HSNoteC, note.type, @"");
    XCTAssertEqual(5, note.octave, @"");
}

@end
