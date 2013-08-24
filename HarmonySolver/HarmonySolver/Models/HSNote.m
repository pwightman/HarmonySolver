//
//  HSNote.m
//  HarmonySolver
//
//  Created by Parker Wightman on 8/17/13.
//  Copyright (c) 2013 Alora Studios. All rights reserved.
//

#import "HSNote.h"

#pragma mark -
#pragma mark Private Interface
@interface HSNote ()
@end

#pragma mark -
@implementation HSNote

#pragma mark Constructors
+ (instancetype) noteWithType:(HSNoteType)type octave:(NSInteger)octave {
    return [[HSNote alloc] initWithType:type octave:octave];
}

+ (instancetype) noteWithAbsoluteValue:(NSInteger)absoluteValue {
    return [[HSNote alloc] initWithAbsoluteValue:absoluteValue];
}

- (id) init { return nil; }

- (id) initWithType:(HSNoteType)type octave:(NSInteger)octave {
    self = [super init];
    if (self == nil)
        return nil;
	
	// NSAssert(type >= HSNoteC && type <= HSNoteB, @"HSNote: Invalid type: %i", type);
	// NSAssert(octave >= -1 && octave <= 9, @"HSNote: Invalid octave: %i", octave);
	
	_type = type;
	_octave = octave;
	_absoluteValue = [self absoluteValueForType:_type octave:_octave];
	
    return self;
}

- (id) initWithAbsoluteValue:(NSInteger)absoluteValue {
	self = [super init];
    if (self == nil)
        return nil;
	
	// NSAssert(absValue >= HSNoteABSMIN && absValue <= HSNoteABSMAX, @"HSNote: Invalid absValue: %i", absValue);
	
	_absoluteValue = absoluteValue;
	_type          = [self noteTypeForAbsoluteValue:absoluteValue];
	_octave        = [self octaveForAbsoluteValue:absoluteValue];
    
    return self;
}

#pragma mark -
#pragma mark Methods

- (NSInteger) absoluteValueForType:(HSNoteType)type octave:(NSInteger)octave {
    return octave * 12 + type;
}

- (HSNoteType) noteTypeForAbsoluteValue:(NSInteger)absoluteValue {
	return absoluteValue % 12;
}

- (NSInteger) octaveForAbsoluteValue:(NSInteger)absoluteValue {
    return absoluteValue / 12;
}

- (NSString*) description {
	return [NSString stringWithFormat:@"%@%i", [self stringFromType], self.octave];
	//return [NSString stringWithFormat:@"Type: %@ Octave: %i", [self typeToString:[self type]], [self octave]];
}

- (NSString*) stringFromType {
	NSString* newString;
	switch (self.type) {
		case HSNoteC:
			newString = @"C";
			break;
		case HSNoteCsharp:
			newString = @"C#";
			break;
		case HSNoteD:
			newString = @"D";
			break;
		case HSNoteDsharp:
			newString = @"D#";
			break;
		case HSNoteE:
			newString = @"E";
			break;
		case HSNoteF:
			newString = @"F";
			break;
		case HSNoteFsharp:
			newString = @"F#";
			break;
		case HSNoteG:
			newString = @"G";
			break;
		case HSNoteGsharp:
			newString = @"G#";
			break;
		case HSNoteA:
			newString = @"A";
			break;
		case HSNoteAsharp:
			newString = @"A#";
			break;
		case HSNoteB:
			newString = @"B";
			break;
		default:
			//NSAssert(FALSE, @"Bad type sent to typeToString: %i", type);
			break;
	}
	
	return newString;
}

- (BOOL) isEqual:(id)object
{
	HSNote* note = (HSNote*)object;
	return note.absoluteValue == self.absoluteValue ;
}

- (NSComparisonResult) compare:(HSNote *)other
{
	if (self.absoluteValue > other.absoluteValue)
		return NSOrderedAscending;
	else if (self.absoluteValue < other.absoluteValue )
		return NSOrderedDescending;
	else
		return NSOrderedSame;
}

- (id) copyWithZone:(NSZone *)zone
{
	return [HSNote noteWithAbsoluteValue:self.absoluteValue];
}

// Keepingt his around in case I need it later.
- (NSInteger) octavesFrom:(HSNote *)other
{
    NSInteger difference = other.absoluteValue - self.absoluteValue;
    
    return difference / (HSNoteMAX + 1);
}


@end
