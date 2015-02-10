//
//  HSFourPartChord.m
//  HarmonySolver
//
//  Created by Parker Wightman on 8/18/13.
//  Copyright (c) 2013 Alora Studios. All rights reserved.
//

#import "HSFourPartChord.h"
#import "HSNote.h"

@implementation HSFourPartChord

+ (instancetype) fourPartChordWithChord:(HSChord *)chord
                                   bass:(NSInteger)bass
                                  tenor:(NSInteger)tenor
                                   alto:(NSInteger)alto
                                soprano:(NSInteger)soprano {
    return [[HSFourPartChord alloc] initWithChord:chord
                                             bass:bass
                                            tenor:tenor
                                             alto:alto
                                          soprano:soprano];
}

- (id) initWithChord:(HSChord *)chord
                bass:(NSInteger)bass
               tenor:(NSInteger)tenor
                alto:(NSInteger)alto
             soprano:(NSInteger)soprano {
    self = [super init];
    
    if (self) {
        _chord   = chord;
        _bass    = bass;
        _tenor   = tenor;
        _alto    = alto;
        _soprano = soprano;
    }
    
    return self;
}

- (NSArray *) array {
    return @[ @(_bass), @(_tenor), @(_alto), @(_soprano) ];
}

- (BOOL)isEqual:(id)object {
    HSFourPartChord *fourPartChord = object;
    
    if ( ![_chord isEqual:fourPartChord.chord] )
        return false;
    
    return [[self array] isEqual:[fourPartChord array]];
}

- (NSString *)description {
    NSArray *result = [[self array] map:^id(id obj) {
        HSNote *note = [HSNote noteWithAbsoluteValue:[obj integerValue]];
        return [NSString stringWithFormat:@"%@%@", [note stringFromType], @(note.octave)];
    }];
    
    return [result componentsJoinedByString:@" "];
}

@end
