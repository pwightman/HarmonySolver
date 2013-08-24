//
//  HSChordConstraints.h
//  HarmonySolver
//
//  Created by Parker Wightman on 8/21/13.
//  Copyright (c) 2013 Alora Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSFourPartSolver.h"

@interface HSChordConstraints : NSObject

+ (HSChordConstraintBlock) noVoiceCrossing;
+ (HSChordConstraintBlock) completeChord;

@end
