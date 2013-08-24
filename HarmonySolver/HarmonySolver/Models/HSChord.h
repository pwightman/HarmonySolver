//
//  HSChord.h
//  HarmonySolver
//
//  Created by Parker Wightman on 8/17/13.
//  Copyright (c) 2013 Alora Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSChord : NSObject

@property (nonatomic, assign, readonly) NSInteger root;

+ (instancetype) AFlat;
+ (instancetype) A;
+ (instancetype) ASharp;
+ (instancetype) BFlat;
+ (instancetype) B;
+ (instancetype) C;
+ (instancetype) CSharp;
+ (instancetype) DFlat;
+ (instancetype) D;
+ (instancetype) DSharp;
+ (instancetype) EFlat;
+ (instancetype) E;
+ (instancetype) F;
+ (instancetype) FSharp;
+ (instancetype) GFlat;
+ (instancetype) G;
+ (instancetype) GSharp;

- (instancetype) add:(NSInteger)step;
- (instancetype) remove:(NSInteger)step;
- (instancetype) flat:(NSInteger)step;
- (instancetype) doubleFlat:(NSInteger)step;
- (instancetype) sharp:(NSInteger)step;
- (instancetype) minor;
- (instancetype) seven;
- (instancetype) majorSeven;
- (instancetype) augmented;
- (instancetype) halfDiminished;
- (instancetype) fullyDiminished;
- (instancetype) suspendedFour;
- (instancetype) suspendedTwo;

- (NSArray *)halfSteps;

@end
