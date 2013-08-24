//
//  HSChord.m
//  HarmonySolver
//
//  Created by Parker Wightman on 8/17/13.
//  Copyright (c) 2013 Alora Studios. All rights reserved.
//

#import "HSChord.h"

@interface HSChord ()

@property (nonatomic, strong) NSMutableDictionary *notes;

@end

@implementation HSChord

+ (instancetype) AFlat  { return [HSChord chordWithAbsoluteRoot:8];  }
+ (instancetype) A      { return [HSChord chordWithAbsoluteRoot:9];  }
+ (instancetype) ASharp { return [HSChord chordWithAbsoluteRoot:10]; }
+ (instancetype) BFlat  { return [HSChord chordWithAbsoluteRoot:10]; }
+ (instancetype) B      { return [HSChord chordWithAbsoluteRoot:11]; }
+ (instancetype) C      { return [HSChord chordWithAbsoluteRoot:0];  }
+ (instancetype) CSharp { return [HSChord chordWithAbsoluteRoot:1];  }
+ (instancetype) DFlat  { return [HSChord chordWithAbsoluteRoot:1];  }
+ (instancetype) D      { return [HSChord chordWithAbsoluteRoot:2];  }
+ (instancetype) DSharp { return [HSChord chordWithAbsoluteRoot:3];  }
+ (instancetype) EFlat  { return [HSChord chordWithAbsoluteRoot:3];  }
+ (instancetype) E      { return [HSChord chordWithAbsoluteRoot:4];  }
+ (instancetype) F      { return [HSChord chordWithAbsoluteRoot:5];  }
+ (instancetype) FSharp { return [HSChord chordWithAbsoluteRoot:6];  }
+ (instancetype) GFlat  { return [HSChord chordWithAbsoluteRoot:6];  }
+ (instancetype) G      { return [HSChord chordWithAbsoluteRoot:7];  }
+ (instancetype) GSharp { return [HSChord chordWithAbsoluteRoot:8];  }

+ (instancetype) chordWithAbsoluteRoot:(NSInteger)root {
    return [[HSChord alloc] initWithAbsoluteRoot:root];
}

- (id) initWithAbsoluteRoot:(NSInteger)root {
    self = [super init];
    
    if (self) {
        _root = root;
        _notes = [NSMutableDictionary dictionary];
        
        // Each chord starts with the major triad
        [@[ @1, @3, @5 ] each:^(id number) {
            [_notes setObject:@0 forKey:number];
        }];
    }
    
    return self;
}

- (instancetype) add:(NSInteger)step {
    [_notes setObject:@0 forKey:@(step)];
    return self;
}

- (instancetype) remove:(NSInteger)step {
    [_notes removeObjectForKey:@(step)];
    return self;
}

- (instancetype) flat:(NSInteger)step {
    [_notes setObject:@(-1) forKey:@(step)];
    return self;
}

- (instancetype) doubleFlat:(NSInteger)step {
    [_notes setObject:@(-2) forKey:@(step)];
    return self;
}

- (instancetype) sharp:(NSInteger)step {
    [_notes setObject:@1 forKey:@(step)];
    return self;
}

- (instancetype) minor {
    [self flat:3];
    return self;
}

- (instancetype) suspendedFour {
    [self remove:3];
    [self add:4];
    return self;
}

- (instancetype) suspendedTwo {
    [self remove:3];
    [self add:2];
    return self;
}

- (instancetype) seven {
    [self flat:7];
    return self;
}

- (instancetype) majorSeven {
    [self add:7];
    return self;
}

- (instancetype) augmented {
    [self sharp:5];
    return self;
}

- (instancetype) halfDiminished {
    [self flat:3];
    [self flat:5];
    [self flat:7];
    return self;
}

- (instancetype) fullyDiminished {
    [self flat:3];
    [self flat:5];
    [self doubleFlat:7];
    return self;
}

- (NSArray *) halfSteps {
    NSMutableArray *halfSteps = [NSMutableArray arrayWithCapacity:_notes.count];
    
    [_notes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSInteger adjustedHalfStep = [HSChord halfStepForScaleStep:[key integerValue]] + [obj integerValue];
        [halfSteps addObject:@(adjustedHalfStep)];
    }];
    
    [halfSteps sortUsingSelector:@selector(compare:)];
    
    return halfSteps;
}

+ (NSInteger) halfStepForScaleStep:(NSInteger)scaleStep {
    NSInteger halfStep = 0;
    
    switch (scaleStep) {
        case 1: halfStep = 0; break;
        case 2: halfStep = 2; break;
        case 3: halfStep = 4; break;
        case 4: halfStep = 5; break;
        case 5: halfStep = 7; break;
        case 6: halfStep = 9; break;
        case 7: halfStep = 11; break;
        case 8: halfStep = 12; break;
        case 9: halfStep = 14; break;
        case 10: halfStep = 16; break;
        case 11: halfStep = 17; break;
        case 12: halfStep = 19; break;
        case 13: halfStep = 21; break;
        case 14: halfStep = 23; break;
        default:
            NSAssert(NO, @"HSChord hafStepForScale: %i scaleStep not supported", scaleStep);
    }
    
    return halfStep;
}

- (BOOL) isEqual:(id)object {
    HSChord *other = object;
    return other.root == self.root && [[other halfSteps] isEqual:[self halfSteps]];
}


@end
