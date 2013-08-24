//
//  HSFourPartChordTests.m
//  HarmonySolver
//
//  Created by Parker Wightman on 8/18/13.
//  Copyright (c) 2013 Alora Studios. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HSFourPartChord.h"

@interface HSFourPartChordTests : XCTestCase

@end

@implementation HSFourPartChordTests

- (void)testInit
{
    HSFourPartChord *chord = [HSFourPartChord fourPartChordWithChord:[HSChord G]
                                                                bass:0
                                                               tenor:1
                                                                alto:2
                                                             soprano:3];
    XCTAssertEqual(0, chord.bass, @"");
    XCTAssertEqual(1, chord.tenor, @"");
    XCTAssertEqual(2, chord.alto, @"");
    XCTAssertEqual(3, chord.soprano, @"");
}

- (void)testArray {
    HSFourPartChord *chord = [HSFourPartChord fourPartChordWithChord:[HSChord G]
                                                                bass:0
                                                               tenor:1
                                                                alto:2
                                                             soprano:3];
    
    XCTAssertEqualObjects(chord.array, (@[ @0, @1, @2, @3 ]), @"");
}

- (void)testIsEqual {
    HSFourPartChord *chord = [HSFourPartChord fourPartChordWithChord:[HSChord G]
                                                                bass:0
                                                               tenor:1
                                                                alto:2
                                                             soprano:3];
    
    HSFourPartChord *other = [HSFourPartChord fourPartChordWithChord:[HSChord G]
                                                                bass:0
                                                               tenor:1
                                                                alto:2
                                                             soprano:3];
    
    XCTAssertEqualObjects(chord, other, @"");
    
    other = [HSFourPartChord fourPartChordWithChord:[HSChord G]
                                               bass:0
                                              tenor:1
                                               alto:1
                                            soprano:3];
    
    XCTAssertNotEqualObjects(chord, other, @"");
    
    other = [HSFourPartChord fourPartChordWithChord:[HSChord F]
                                               bass:0
                                              tenor:1
                                               alto:2
                                            soprano:3];
    
    XCTAssertNotEqualObjects(chord, other, @"");
}

@end
