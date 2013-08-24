//
//  HSFourPartChordEnumerator.h
//  HarmonySolver
//
//  Created by Parker Wightman on 8/19/13.
//  Copyright (c) 2013 Alora Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSChord.h"
#import "HSFourPartChord.h"

@interface HSFourPartChordEnumerator : NSObject

@property (nonatomic, strong, readonly) HSChord *chord;

@property (nonatomic, assign) NSRange bassRange;
@property (nonatomic, assign) NSRange tenorRange;
@property (nonatomic, assign) NSRange altoRange;
@property (nonatomic, assign) NSRange sopranoRange;

+ (instancetype) enumeratorWithChord:(HSChord *)chord;

- (id) initWithChord:(HSChord *)chord;

- (HSFourPartChord *)nextChord;

@end
