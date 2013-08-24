//
//  HSFourPartChord.h
//  HarmonySolver
//
//  Created by Parker Wightman on 8/18/13.
//  Copyright (c) 2013 Alora Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSChord.h"

@interface HSFourPartChord : NSObject

@property (nonatomic, assign, readonly) NSInteger bass;
@property (nonatomic, assign, readonly) NSInteger tenor;
@property (nonatomic, assign, readonly) NSInteger alto;
@property (nonatomic, assign, readonly) NSInteger soprano;
@property (nonatomic, strong, readonly) HSChord   *chord;

+ (instancetype) fourPartChordWithChord:(HSChord *)chord
                                   bass:(NSInteger)bass
                                  tenor:(NSInteger)tenor
                                   alto:(NSInteger)alto
                                soprano:(NSInteger)soprano;

- (id) initWithChord:(HSChord *)chord
                bass:(NSInteger)bass
               tenor:(NSInteger)tenor
                alto:(NSInteger)alto
             soprano:(NSInteger)soprano;

- (NSArray *)array;

@end
