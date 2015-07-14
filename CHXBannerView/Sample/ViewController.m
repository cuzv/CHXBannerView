//
//  ViewController.m
//  CHXBannerView
//
//  Created by Moch Xiao on 2015-04-29.
//  Copyright (c) 2014 Moch Xiao (https://github.com/atcuan).
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "ViewController.h"
#import "CHXBannerView.h"

@interface ViewController () <CHXBannerViewProtocol>
@property (weak, nonatomic) IBOutlet CHXBannerView *bannerView;
@property (strong, nonatomic) CHXBannerView *bannerView2;

@property (nonatomic, strong) NSArray *urls;
@end

@implementation ViewController

#if DEBUG
- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}
#endif


- (NSArray *)urls {
    if (!_urls) {
//        _urls = @[
//                  @"http://img.pconline.com.cn/images/upload/upc/tx/wallpaper/1501/05/c0/1517640_1420467528300_800x600.jpg",
//                  @"http://img.pconline.com.cn/images/upload/upc/tx/wallpaper/1404/18/c0/33293989_1397801197913_800x600.jpg",
//                  @"http://pic1.win4000.com/wallpaper/4/54c06f59a2f09.jpg"
//                  ];
        _urls = @[
                  @"1",
                  @"2",
                  @"3",
                  @"4",
                  @"5"
                  ];
    }
    
    return _urls;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    __weak typeof(self) weakSelf = self;
    
    _bannerView.backgroundColor = [UIColor redColor];
    
    _bannerView.numberOfPages = ^NSInteger (void) {
        return 3;
    };
    _bannerView.updateImageViewForIndex = ^(UIImageView *imageView, NSUInteger index) {
        imageView.image = [UIImage imageNamed:weakSelf.urls[index]];
        UIColor *color = nil;
        if (index == 0) {
            color = [UIColor purpleColor];
        } else if (index == 1) {
            color = [UIColor yellowColor];
        } else {
            color = [UIColor blueColor];
        }
        imageView.backgroundColor = color;
    };
    _bannerView.didSelectItemAtIndex = ^(NSUInteger index) {
        NSLog(@"didSelectItemAtIndex: %ld", index);
    };
    _bannerView.animationDelayDuration = ^NSTimeInterval (void) {
        return 3;
    };
    
    
    _bannerView2 = [[CHXBannerView alloc] initWithFrame:CGRectMake(20, 220, 200, 100)];
    _bannerView2.delegate = self;
    _bannerView2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_bannerView2];
    
//    _bannerView2.numberOfPages = ^NSInteger (void) {
//        return 2;
//    };
//    _bannerView2.updateImageViewForIndex = ^(UIImageView *imageView, NSUInteger index) {
//        imageView.image = [UIImage imageNamed:weakSelf.urls[index]];
//    };
//    _bannerView2.didSelectItemAtIndex = ^(NSUInteger index) {
//        NSLog(@"didSelectItemAtIndex: %ld", index);
//    };
//    _bannerView2.animationDelayDuration = ^NSTimeInterval (void) {
//        return 2;
//    };
    
}

#pragma mark - CHXBannerViewProtocol

- (NSInteger)numberOfPagesInBannerView:(CHXBannerView *)bannerView {
    return 5;
}

- (NSTimeInterval)playTimeIntervalOfBannerView:(CHXBannerView *)bannerView {
    return 3;
}

- (void)bannerView:(CHXBannerView *)bannerView presentImageView:(UIImageView *)imageView forIndex:(NSInteger)index {
    imageView.image = [UIImage imageNamed:self.urls[index]];
}






@end
