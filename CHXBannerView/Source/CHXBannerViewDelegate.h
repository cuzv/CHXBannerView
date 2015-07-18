//
//  CHXBannerViewDelegate.h
//  CHXBannerView
//
//  Created by Moch Xiao on 7/18/15.
//  Copyright (c) 2015 Foobar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CHXBannerView;

@protocol CHXBannerViewDelegate <NSObject>

@optional
- (void)bannerView:(CHXBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index;

@end
