//
//  HSFourPartSolver.h
//  HarmonySolver
//
//  Created by Parker Wightman on 8/21/13.
//  Copyright (c) 2013 Alora Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSFourPartChord.h"
#import "HSChord.h"

typedef BOOL(^HSChordConstraintBlock)(HSFourPartChord *fourPartChord);
typedef BOOL(^HSAdjacentChordConstraintBlock)(HSFourPartChord *firstChord, HSFourPartChord *secondChord);
typedef BOOL(^HSConsecutiveChordConstraintBlock)(NSArray *chords);

@interface HSFourPartSolver : NSObject

+ (instancetype) solverWithEnumerators:(NSArray *)enumerators;
- (id) initWithEnumerators:(NSArray *)enumerators;

- (NSArray *)nextSolution;

- (void) addChordConstraint:(HSChordConstraintBlock)block;
- (void) addAdjacentChordConstraint:(HSAdjacentChordConstraintBlock)block;
- (void) addConsecutiveChordConstraintWithWidth:(NSInteger)width block:(HSConsecutiveChordConstraintBlock)block;

@end
