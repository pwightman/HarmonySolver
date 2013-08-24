//
//  HSChordConstraints.m
//  HarmonySolver
//
//  Created by Parker Wightman on 8/21/13.
//  Copyright (c) 2013 Alora Studios. All rights reserved.
//

#import "HSChordConstraints.h"

@implementation HSChordConstraints

+ (HSChordConstraintBlock) noVoiceCrossing {
    return ^BOOL(HSFourPartChord *chord) {
        return chord.bass  < chord.tenor &&
               chord.tenor < chord.alto  &&
               chord.alto  < chord.soprano;
    };
}

+ (HSChordConstraintBlock) completeChord {
    return ^BOOL(HSFourPartChord *chord) {
        NSSet *expected = [NSSet setWithArray:[chord.chord halfSteps]];
        // Normalize the concrete notes down into their pure chord tones, to match
        // what halfSteps returns
        NSSet *actual   = [NSSet setWithArray:[[chord array] map:^id(id obj) {
            return @(([obj integerValue] - (chord.chord.root % 12)) % 12);
        }]];
        
        return [expected isEqualToSet:actual];
    };
}


@end
