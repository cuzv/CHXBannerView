//
//  NSTimer+CHXAddition.m
//  CHXBannerView
//
//  Created by Moch Xiao on 7/14/15.
//  Copyright (c) 2015 Foobar. All rights reserved.
//

#import "NSTimer+CHXAddition.h"

@implementation NSTimer (CHXAddition)

- (void)pause {
    if (!self.isValid) {
        return;
    }
    
    [self setFireDate:[NSDate distantFuture]];
}

- (void)resume {
    if (!self.isValid) {
        return;
    }
    
    [self setFireDate:[NSDate date]];
}

- (void)resumeAfterDuration:(NSTimeInterval)interval {
    if (!self.isValid) {
        return;
    }
    
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
