//
//  HSChordTests.m
//  HarmonySolver
//
//  Created by Parker Wightman on 8/17/13.
//  Copyright (c) 2013 Alora Studios. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HSChord.h"

@interface HSChordTests : XCTestCase

@end

@implementation HSChordTests

- (void)testMajorTriad {
    HSChord *chord = [HSChord G];
    XCTAssertEqualObjects([chord halfSteps], (@[ @0, @4, @7 ]), @"");
}

- (void)testAdd {
    HSChord *chord = [[HSChord G] add:9];
    XCTAssertEqualObjects([chord halfSteps], (@[ @0, @4, @7, @14 ]), @"");
}

- (void)testRemove {
    HSChord *chord = [[HSChord G] remove:5];
    XCTAssertEqualObjects([chord halfSteps], (@[ @0, @4 ]), @"");
}

- (void)testFlat {
    HSChord *chord = [[HSChord G] flat:7];
    XCTAssertEqualObjects([chord halfSteps], (@[ @0, @4, @7, @10 ]), @"");
}

- (void)testDoubleFlat {
    HSChord *chord = [[HSChord G] doubleFlat:7];
    XCTAssertEqualObjects([chord halfSteps], (@[ @0, @4, @7, @9 ]), @"");
}

- (void)testSharp {
    HSChord *chord = [[HSChord G] sharp:5];
    XCTAssertEqualObjects([chord halfSteps], (@[ @0, @4, @8 ]), @"");
}

- (void)testMinor {
    HSChord *chord = [[HSChord G] minor];
    XCTAssertEqualObjects([chord halfSteps], (@[ @0, @3, @7 ]), @"");
}

- (void)testSuspendedFour {
    HSChord *chord = [[HSChord G] suspendedFour];
    XCTAssertEqualObjects([chord halfSteps], (@[ @0, @5, @7 ]), @"");
}

- (void)testSuspendedTwo {
    HSChord *chord = [[HSChord G] suspendedTwo];
    XCTAssertEqualObjects([chord halfSteps], (@[ @0, @2, @7 ]), @"");
}

- (void)testSeven {
    HSChord *chord = [[HSChord G] seven];
    XCTAssertEqualObjects([chord halfSteps], (@[ @0, @4, @7, @10 ]), @"");
}

- (void)testMajorSeven {
    HSChord *chord = [[HSChord G] majorSeven];
    XCTAssertEqualObjects([chord halfSteps], (@[ @0, @4, @7, @11 ]), @"");
}

- (void)testAugmented {
    HSChord *chord = [[HSChord G] augmented];
    XCTAssertEqualObjects([chord halfSteps], (@[ @0, @4, @8 ]), @"");
}

- (void)testHalfDiminished {
    HSChord *chord = [[HSChord G] halfDiminished];
    XCTAssertEqualObjects([chord halfSteps], (@[ @0, @3, @6, @10 ]), @"");
}

- (void)testFullDiminished {
    HSChord *chord = [[HSChord G] fullyDiminished];
    XCTAssertEqualObjects([chord halfSteps], (@[ @0, @3, @6, @9 ]), @"");
}

- (void)testChaining {
    HSChord *chord = [[[[[HSChord G] minor] add:9] flat:5] seven];
    XCTAssertEqualObjects([chord halfSteps], (@[ @0, @3, @6, @10, @14 ]), @"");
}

- (void)testIsEqual {
    HSChord *chord = [[HSChord G] majorSeven];
    HSChord *other = [[HSChord G] add:7];
    
    XCTAssertEqualObjects(chord, other, @"");
    
    chord = [[HSChord G] majorSeven];
    other = [[HSChord C] add:7];
    
    XCTAssertNotEqualObjects(chord, other, @"");
}

- (void)testC      { XCTAssertEqual(0, [HSChord C].root, @"");       }
- (void)testCSharp { XCTAssertEqual(1, [HSChord CSharp].root, @"");  }
- (void)testDFlat  { XCTAssertEqual(1, [HSChord DFlat].root, @"");   }
- (void)testD      { XCTAssertEqual(2, [HSChord D].root, @"");       }
- (void)testDSharp { XCTAssertEqual(3, [HSChord DSharp].root, @"");  }
- (void)testEFlat  { XCTAssertEqual(3, [HSChord EFlat].root, @"");   }
- (void)testE      { XCTAssertEqual(4, [HSChord E].root, @"");       }
- (void)testF      { XCTAssertEqual(5, [HSChord F].root, @"");       }
- (void)testFSharp { XCTAssertEqual(6, [HSChord FSharp].root, @"");  }
- (void)testGFlat  { XCTAssertEqual(6, [HSChord GFlat].root, @"");   }
- (void)testG      { XCTAssertEqual(7, [HSChord G].root, @"");       }
- (void)testGSharp { XCTAssertEqual(8, [HSChord GSharp].root, @"");  }
- (void)testAFlat  { XCTAssertEqual(8, [HSChord AFlat].root, @"");   }
- (void)testA      { XCTAssertEqual(9, [HSChord A].root, @"");       }
- (void)testASharp { XCTAssertEqual(10, [HSChord ASharp].root, @""); }
- (void)testBFlat  { XCTAssertEqual(10, [HSChord BFlat].root, @"");  }
- (void)testB      { XCTAssertEqual(11, [HSChord B].root, @"");      }

@end
