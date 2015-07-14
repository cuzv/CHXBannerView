//
//  CHXBannerView.m
//  CHXBannerView
//
//  Created by Moch Xiao on 2015-03-01.
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

#import "CHXBannerView.h"
#import "NSTimer+CHXAddition.h"

#pragma mark - CHXBannerView

@interface CHXBannerView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *baseScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, strong) NSMutableArray *imageViewList;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation CHXBannerView

#if DEBUG
- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}
#endif

#pragma mark - Init

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self pr_initializeControls];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self pr_initializeControls];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.timer pause];
    
    [self pr_updateControlsFrame];
    
    [self.timer resumeAfterDuration:[self pr_animationDuration]];
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [self.timer invalidate];
    
    NSTimeInterval delay = [self pr_animationDuration];
    if (newWindow && delay) {
        [self pr_updateControlsFrame];
        self.timer = nil;
        [self.timer resumeAfterDuration:delay];
    }
}

#pragma mark - Private

- (void)pr_updateControlsFrame {
    // set contentOffset will trigger delegate method, which will call some unimplements block yet.
    self.baseScrollView.delegate = nil;
    self.baseScrollView.frame = self.bounds;
    self.baseScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) * 3, CGRectGetHeight(self.bounds));
    self.baseScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.bounds), 0);
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = (UIImageView *)self.imageViewList[i];
        imageView.frame = CGRectMake(CGRectGetWidth(self.baseScrollView.bounds) * i,
                                     0,
                                     CGRectGetWidth(self.baseScrollView.bounds),
                                     CGRectGetHeight(self.baseScrollView.bounds));
    }
    self.baseScrollView.delegate = self;
    self.pageControl.bounds = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 30);
    self.pageControl.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds) - CGRectGetMidY(self.pageControl.bounds));
}

- (void)pr_initializeControls {
    self.baseScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.baseScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.baseScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) * 3, CGRectGetHeight(self.bounds));
    self.baseScrollView.pagingEnabled = YES;
    self.baseScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.bounds), 0);
    self.baseScrollView.showsVerticalScrollIndicator = NO;
    self.baseScrollView.showsHorizontalScrollIndicator = NO;
    self.baseScrollView.delegate = self;
    self.baseScrollView.scrollsToTop = NO;
    self.baseScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.baseScrollView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pr_handleTaped:)];
    [self.baseScrollView addGestureRecognizer:tap];
    
    self.pageControl = [UIPageControl new];
    self.pageControl.userInteractionEnabled = NO;
    [self addSubview:self.pageControl];
    
    self.imageViewList = [NSMutableArray new];
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.baseScrollView.bounds) * i,
                                                                               0,
                                                                               CGRectGetWidth(self.baseScrollView.bounds),
                                                                               CGRectGetHeight(self.baseScrollView.bounds))];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        imageView.tag = i;
        
        [self.baseScrollView addSubview:imageView];
        [self.imageViewList addObject:imageView];
    }
}

- (void)pr_handleTaped:(UITapGestureRecognizer *)sender {
    [self pr_handleDidSelectItem];
}

- (NSInteger)pr_realIndexWithIndex:(NSInteger)index {
    NSUInteger numberOfPages = [self pr_numberOfPages];
    
    // 更新页码总数
    _pageControl.numberOfPages = numberOfPages;
    // 更新是否允许用户交互
    _baseScrollView.scrollEnabled = numberOfPages > 1;
    // 获取最大索引
    NSInteger maximumIndex = numberOfPages - 1;
    maximumIndex = maximumIndex > 0 ? maximumIndex : 0;
    // 判断真实索引位置
    if (index > maximumIndex) {
        index = 0;
    } else if (index < 0) {
        index = maximumIndex;
    }
    
    return index;
}

- (void)pr_updateUserInterfaceWithScrollViewContentOffset:(CGPoint)contentOffset {
    BOOL shouldUpdate = NO;
    
    if (contentOffset.x >= CGRectGetWidth(self.baseScrollView.bounds) * 2) {
        // 向右
        shouldUpdate = YES;
        self.currentIndex = [self pr_realIndexWithIndex:++self.currentIndex];
    } else if (contentOffset.x <= 0) {
        // 向左
        shouldUpdate = YES;
        self.currentIndex = [self pr_realIndexWithIndex:--self.currentIndex];
    }
    
    // 判断是否需要更新
    if (!shouldUpdate) {
        return;
    }
    
    self.pageControl.currentPage = self.currentIndex;
    
    [self pr_updateUserInterface];
}

- (void)pr_updateUserInterface {
    // 更新所有imageView显示的图片
    [self pr_presentImageViewForIndex];

    // 恢复可见区域
    self.baseScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.baseScrollView.bounds), 0);
}

- (void)pr_handleSwitchImageView:(NSTimer *)sender {
    NSInteger numberOfPages = [self pr_numberOfPages];
    if (numberOfPages <= 1) {
        return;
    }
    
    CGPoint newOffset = CGPointMake(self.baseScrollView.contentOffset.x + CGRectGetWidth(self.baseScrollView.bounds), 0);
    [self.baseScrollView setContentOffset:newOffset animated:YES];
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer pause];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSTimeInterval delay = [self pr_animationDuration];
    [self.timer resumeAfterDuration:delay];
}

// scrollview滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self pr_updateUserInterfaceWithScrollViewContentOffset:scrollView.contentOffset];
}

// scrollView停止减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self pr_updateUserInterfaceWithScrollViewContentOffset:scrollView.contentOffset];
}

#pragma mark - Public

- (void)setNumberOfPages:(NSInteger (^)(void))numberOfPages {
    _numberOfPages = numberOfPages;
    NSInteger count = numberOfPages();
    count = count > 0 ?: 0;
    self.pageControl.numberOfPages = count;
    self.baseScrollView.scrollEnabled = self.pageControl.numberOfPages > 1;
}

- (void)setUpdateImageViewForIndex:(void (^)(UIImageView *, NSUInteger))configureImageForViewWithIndex {
    _updateImageViewForIndex = configureImageForViewWithIndex;
    [self pr_updateUserInterface];
}

- (void)setAnimationDelayDuration:(NSTimeInterval (^)(void))animationDelayDuration {
    _animationDelayDuration = animationDelayDuration;
    [self.timer invalidate];
    self.timer = nil;
    [self.timer resume];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    self.layer.contents = (id)backgroundImage.CGImage;
}

- (UIImage *)backgroundImage {
    return [UIImage imageWithCGImage:(__bridge CGImageRef)((id)self.layer.contents)];
}

- (void)replay {
    NSInteger numberOfPages = [self pr_numberOfPages];
    self.currentIndex = numberOfPages + 1;
    [self pr_updateUserInterfaceWithScrollViewContentOffset:CGPointZero];
}

#pragma mark - Accessor

- (NSTimer *)timer {
    __weak typeof(self) weak_self = self;
    if (!_timer) {
        __strong typeof(weak_self) strong_self = weak_self;
        NSTimeInterval interval = [strong_self pr_animationDuration];
        _timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                  target:self
                                                selector:@selector(pr_handleSwitchImageView:)
                                                userInfo:nil
                                                 repeats:YES];
        [_timer pause];
    }
    return _timer;
}


#pragma mark - invoke block or protocol methods

- (NSTimeInterval)pr_animationDuration {
    if (self.animationDelayDuration) {
        return self.animationDelayDuration();
    } else if (self.delegate && [self.delegate respondsToSelector:@selector(playTimeIntervalOfBannerView:)]) {
        return [self.delegate playTimeIntervalOfBannerView:self];
    }
    
    return 5.0f;
}

- (NSInteger)pr_numberOfPages {
    if (self.numberOfPages) {
        return self.numberOfPages();
    } else if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfPagesInBannerView:)]) {
        return  [self.delegate numberOfPagesInBannerView:self];
    }
    
    return 0;
}

- (void)pr_handleDidSelectItem {
    if (self.didSelectItemAtIndex) {
        self.didSelectItemAtIndex(self.currentIndex);
    } else if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:didSelectItemAtIndex:)]) {
        [self.delegate bannerView:self didSelectItemAtIndex:self.currentIndex];
    }
}

- (void)pr_presentImageViewForIndex {
    if (self.updateImageViewForIndex) {
        self.updateImageViewForIndex((UIImageView *)self.imageViewList[0], [self pr_realIndexWithIndex:self.currentIndex - 1]);
        self.updateImageViewForIndex((UIImageView *)self.imageViewList[1], [self pr_realIndexWithIndex:self.currentIndex]);
        self.updateImageViewForIndex((UIImageView *)self.imageViewList[2], [self pr_realIndexWithIndex:self.currentIndex + 1]);
        return;
    } else if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:presentImageView:forIndex:)]) {
        [self.delegate bannerView:self presentImageView:self.imageViewList[0] forIndex:[self pr_realIndexWithIndex:self.currentIndex - 1]];
        [self.delegate bannerView:self presentImageView:self.imageViewList[1] forIndex:[self pr_realIndexWithIndex:self.currentIndex]];
        [self.delegate bannerView:self presentImageView:self.imageViewList[2] forIndex:[self pr_realIndexWithIndex:self.currentIndex + 1]];
        return;
    }

    NSAssert(NO, @"Must implement `updateImageViewForIndex` or `bannerView:presentImageView:forIndex:`");
}


@end
