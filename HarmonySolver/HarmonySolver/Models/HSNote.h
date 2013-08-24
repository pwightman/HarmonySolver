//
//  HSNote.h
//  HarmonySolver
//
//  Created by Parker Wightman on 8/17/13.
//  Copyright (c) 2013 Alora Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HSNoteType) {
	HSNoteABSMIN = 0,
	HSNoteMIN = 0,
	HSNoteC = 0,
	HSNoteCsharp = 1,
	HSNoteDflat = 1,
	HSNoteD = 2,
	HSNoteDsharp = 3,
	HSNoteEflat = 3,
	HSNoteE = 4,
	HSNoteF = 5,
	HSNoteFsharp = 6,
	HSNoteGflat = 6,
	HSNoteG = 7,
	HSNoteGsharp = 8,
	HSNoteAflat = 8,
	HSNoteA = 9,
	HSNoteAsharp = 10,
	HSNoteBflat = 10,
	HSNoteB = 11,
	HSNoteMAX = 11,
	HSNoteABSMAX = 127
};

@interface HSNote : NSObject <NSCopying>

@property (nonatomic, assign, readonly) HSNoteType type;
@property (nonatomic, assign, readonly) NSInteger octave;
@property (nonatomic, assign, readonly) NSInteger absoluteValue;

+ (instancetype) noteWithAbsoluteValue:(NSInteger)absoluteValue;
+ (instancetype) noteWithType:(HSNoteType)type octave:(NSInteger)octave;

- (id) initWithType:(HSNoteType)type octave:(NSInteger)octave;
- (id) initWithAbsoluteValue:(NSInteger)absoluteValue;

- (NSString*) stringFromType;
    
@end