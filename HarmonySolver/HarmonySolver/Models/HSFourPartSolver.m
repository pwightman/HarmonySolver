//
//  HSFourPartSolver.m
//  HarmonySolver
//
//  Created by Parker Wightman on 8/21/13.
//  Copyright (c) 2013 Alora Studios. All rights reserved.
//

#import "HSFourPartSolver.h"


@interface HSFourPartSolver ()

@property (nonatomic, strong) NSArray *enumerators;

@end

@implementation HSFourPartSolver

+ (instancetype) solverWithEnumerators:(NSArray *)enumerators {
    return [[HSFourPartSolver alloc] initWithEnumerators:enumerators];
}

- (id) initWithEnumerators:(NSArray *)enumerators {
    self = [super init];
    
    if (self) {
        _enumerators = enumerators;
    }
    
    return self;
}

- (NSArray *) nextSolution {
    return nil;
}

@end
