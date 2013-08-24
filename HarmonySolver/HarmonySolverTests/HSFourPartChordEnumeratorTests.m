//
//  HSFourPartChordEnumeratorTests.m
//  HarmonySolver
//
//  Created by Parker Wightman on 8/19/13.
//  Copyright (c) 2013 Alora Studios. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HSFourPartChordEnumerator.h"

@interface HSFourPartChordEnumeratorTests : XCTestCase

@end

@implementation HSFourPartChordEnumeratorTests

- (void)testInit
{
    HSFourPartChordEnumerator *enumerator = [HSFourPartChordEnumerator enumeratorWithChord:[HSChord G]];
    
    XCTAssertEqualObjects([HSChord G], enumerator.chord, @"");
}

- (void)testNextChord {
    HSFourPartChordEnumerator *enumerator = [HSFourPartChordEnumerator enumeratorWithChord:[HSChord C]];
    
    NSMutableSet *chords = [NSMutableSet set];
    
    // These values were deduced by hand from page two of this PDF: http://d.pr/f/1yLn/4AGxmgFz+
    NSInteger bassCount    = 6;
    NSInteger tenorCount   = 6;
    NSInteger altoCount    = 5;
    NSInteger sopranoCount = 6;
    
    NSInteger expectedCount = bassCount * tenorCount * altoCount * sopranoCount;
    
    NSInteger count = 0;
    
    HSFourPartChord *currentChord = nil;
    while ( (currentChord = [enumerator nextChord]) ) {
        XCTAssertFalse([chords containsObject:currentChord], @"");
        [chords addObject:currentChord];
        count++;
    }
    
    XCTAssertEqual(expectedCount, count, @"");
}

@end
