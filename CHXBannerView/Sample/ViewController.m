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

@interface ViewController () <CHXBannerViewDelegate, CHXBannerViewDataSource>
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


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.bannerView2 reloadData];
}

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.bannerView.delegate = self;
    self.bannerView.dataSource = self;
    [self.bannerView reloadData];
    
    self.bannerView2 = [[CHXBannerView alloc] initWithFrame:CGRectMake(20, 220, 200, 100)];
    self.bannerView2.dataSource = self;
    self.bannerView2.delegate = self;
    self.bannerView2.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    self.bannerView2.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    self.bannerView2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.bannerView2];
    [self.bannerView2 reloadData];
}

#pragma mark - CHXBannerViewDataSource

- (NSInteger)numberOfPagesInBannerView:(CHXBannerView *)bannerView {
    if (self.bannerView == bannerView) {
        return 3;
    }
    return self.urls.count;
}

- (void)bannerView:(CHXBannerView *)bannerView presentImageView:(UIImageView *)imageView forIndex:(NSInteger)index {
    imageView.image = [UIImage imageNamed:self.urls[index]];
}

- (NSTimeInterval)timeIntervalOfTransitionsAnimationInBannerView:(CHXBannerView *)bannerView {
    return 3;
}

#pragma mark - CHXBannerViewDelegate

- (void)bannerView:(CHXBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"didSelectItemAtIndex: %@", @(index));
}



@end
