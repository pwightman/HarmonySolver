//
//  HSFourPartChordEnumerator.m
//  HarmonySolver
//
//  Created by Parker Wightman on 8/19/13.
//  Copyright (c) 2013 Alora Studios. All rights reserved.
//

#import "HSFourPartChordEnumerator.h"
#import "HSNote.h"

@interface HSFourPartChordEnumerator ()

@property (nonatomic, assign) NSInteger currentBassIndex;
@property (nonatomic, assign) NSInteger currentTenorIndex;
@property (nonatomic, assign) NSInteger currentAltoIndex;
@property (nonatomic, assign) NSInteger currentSopranoIndex;

@property (nonatomic, strong) NSArray *bassAbsoluteValues;
@property (nonatomic, strong) NSArray *tenorAbsoluteValues;
@property (nonatomic, strong) NSArray *altoAbsoluteValues;
@property (nonatomic, strong) NSArray *sopranoAbsoluteValues;

@property (nonatomic, strong) NSArray *halfSteps;

@property (nonatomic, assign) BOOL done;

@end

@implementation HSFourPartChordEnumerator

+ (instancetype) enumeratorWithChord:(HSChord *)chord {
    return [[HSFourPartChordEnumerator alloc] initWithChord:chord];
}

- (id) initWithChord:(HSChord *)chord {
    self = [super init];
    
    if (self) {
        _chord = chord;
        
        _bassRange    = [self defaultBassRange];
        _tenorRange   = [self defaultTenorRange];
        _altoRange    = [self defaultAltoRange];
        _sopranoRange = [self defaultSopranoRange];
        
        _currentBassIndex    = 0;
        _currentTenorIndex   = 0;
        _currentAltoIndex    = 0;
        _currentSopranoIndex = 0;
        
        _halfSteps = [_chord halfSteps];
        
        _bassAbsoluteValues    = [self absoluteValueArrayForRange:_bassRange];
        _tenorAbsoluteValues   = [self absoluteValueArrayForRange:_tenorRange];
        _altoAbsoluteValues    = [self absoluteValueArrayForRange:_altoRange];
        _sopranoAbsoluteValues = [self absoluteValueArrayForRange:_sopranoRange];
    }
    
    return self;
}

- (HSFourPartChord *) nextChord {
    if (_done) return nil;
    
    NSInteger bassValue    = [_bassAbsoluteValues[_currentBassIndex] integerValue];
    NSInteger tenorValue   = [_tenorAbsoluteValues[_currentTenorIndex] integerValue];
    NSInteger altoValue    = [_altoAbsoluteValues[_currentAltoIndex] integerValue];
    NSInteger sopranoValue = [_sopranoAbsoluteValues[_currentSopranoIndex] integerValue];
    
    HSFourPartChord *chord = [HSFourPartChord fourPartChordWithChord:_chord
                                                                bass:bassValue
                                                               tenor:tenorValue
                                                                alto:altoValue
                                                             soprano:sopranoValue];
    
    if ( _currentBassIndex < _bassAbsoluteValues.count - 1 ) {
        _currentBassIndex++;
    } else {
        _currentBassIndex = 0;
        if ( _currentTenorIndex < _tenorAbsoluteValues.count - 1 ) {
            _currentTenorIndex++;
        } else {
            _currentTenorIndex = 0;
            if ( _currentAltoIndex < _altoAbsoluteValues.count - 1 ) {
                _currentAltoIndex++;
            } else {
                _currentAltoIndex = 0;
                if ( _currentSopranoIndex < _sopranoAbsoluteValues.count - 1 ) {
                    _currentSopranoIndex++;
                } else {
                    _done = YES;
                }
            }
        }
    }
    
    return chord;
}

- (NSArray *) absoluteValueArrayForRange:(NSRange)range {
    NSMutableArray *voiceArray = [NSMutableArray array];
    
    BOOL done            = NO;
    NSInteger iterations = 0;
    NSInteger voiceMax   = range.location + range.length;
    
    while (!done) {
        NSLog(@"Pre-adjustment: %@", _halfSteps);
        NSArray *adjustedHalfSteps = [_halfSteps map:^id(id obj) {
            
            // Find the C below the range, to start at some known place.
            NSInteger cBelowRange       = range.location - (range.location % 12);
            // Move down even farther to root of the chord, we're now for sure below the range
            NSInteger adjustedRoot      = cBelowRange    - (12 - _chord.root);
            NSInteger adjustedOctave    = adjustedRoot   + (iterations * 12);
            NSInteger adjustedScaleTone = adjustedOctave + [obj integerValue];
            
            return @(adjustedScaleTone);
        }];

        NSLog(@"Post-adjustment: %@", adjustedHalfSteps);
        
        for (NSNumber *absoluteNumber in adjustedHalfSteps) {
            NSInteger absoluteValue = [absoluteNumber integerValue];
            
            if ( absoluteValue < range.location ) continue;
            
            if ( absoluteValue <= voiceMax ) {
                [voiceArray addObject:absoluteNumber];
            } else {
                done = YES;
                break;
            }
            
        }
        
        iterations++;
    }

    NSLog(@"Voice array: %@", voiceArray);
    
    return voiceArray;
}

// These defaults were taken from page 2 in this PDF: http://d.pr/f/1yLn/4AGxmgFz+
- (NSRange) defaultBassRange {
    HSNote *start = [HSNote noteWithType:HSNoteE octave:3];
    HSNote *end =   [HSNote noteWithType:HSNoteC octave:5];
    return NSMakeRange(start.absoluteValue, end.absoluteValue - start.absoluteValue);
}

- (NSRange) defaultTenorRange {
    HSNote *start = [HSNote noteWithType:HSNoteC octave:4];
    HSNote *end =   [HSNote noteWithType:HSNoteG octave:5];
    return NSMakeRange(start.absoluteValue, end.absoluteValue - start.absoluteValue);
}

- (NSRange) defaultAltoRange {
    HSNote *start = [HSNote noteWithType:HSNoteG octave:4];
    HSNote *end =   [HSNote noteWithType:HSNoteC octave:6];
    return NSMakeRange(start.absoluteValue, end.absoluteValue - start.absoluteValue);
}

- (NSRange) defaultSopranoRange {
    HSNote *start = [HSNote noteWithType:HSNoteC octave:5];
    HSNote *end =   [HSNote noteWithType:HSNoteG octave:6];
    return NSMakeRange(start.absoluteValue, end.absoluteValue - start.absoluteValue);
}

@end
