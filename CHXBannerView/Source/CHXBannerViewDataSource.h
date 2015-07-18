//
//  CHXBannerViewDataSource.h
//  CHXBannerView
//
//  Created by Moch Xiao on 7/18/15.
//  Copyright (c) 2015 Foobar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CHXBannerView;

@protocol CHXBannerViewDataSource <NSObject>

@required
- (NSInteger)numberOfPagesInBannerView:(CHXBannerView *)bannerView;
- (void)bannerView:(CHXBannerView *)bannerView presentImageView:(UIImageView *)imageView forIndex:(NSInteger)index;

@optional
- (NSTimeInterval)timeIntervalOfTransitionsAnimationInBannerView:(CHXBannerView *)bannerView;

@end
