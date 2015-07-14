//
//  NSTimer+CHXAddition.h
//  CHXBannerView
//
//  Created by Moch Xiao on 7/14/15.
//  Copyright (c) 2015 Foobar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (CHXAddition)
- (void)pause;
- (void)resume;
- (void)resumeAfterDuration:(NSTimeInterval)interval;
@end
