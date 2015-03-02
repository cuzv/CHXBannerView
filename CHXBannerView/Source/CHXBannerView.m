//
//  CHXBannerView.m
//  CHXBannerView
//
//  Created by Moch Xiao on 2015-02-16.
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

#pragma mark - NSTimer

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

    if (self.animationDelayDuration) {
        [self.timer resumeAfterDuration:self.animationDelayDuration()];
    }
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (!newWindow) {
        [self.timer invalidate];
    }
}

#pragma mark - Private

- (void)pr_updateControlsFrame {
    // set contentOffset will trigger delegate method, which will call some unimplements block yet.
    _baseScrollView.delegate = nil;
    _baseScrollView.frame = self.bounds;
    _baseScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) * 3, 0);
    _baseScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.bounds), 0);
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = (UIImageView *)_imageViewList[i];
        imageView.frame = CGRectMake(CGRectGetWidth(_baseScrollView.bounds) * i,
                                     0,
                                     CGRectGetWidth(_baseScrollView.bounds),
                                     CGRectGetHeight(_baseScrollView.bounds));
    }
    _baseScrollView.delegate = self;
}

- (void)pr_initializeControls {
    _baseScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _baseScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _baseScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) * 3, 0);
    _baseScrollView.pagingEnabled = YES;
    _baseScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.bounds), 0);
    _baseScrollView.showsVerticalScrollIndicator = NO;
    _baseScrollView.showsHorizontalScrollIndicator = NO;
    _baseScrollView.delegate = self;
    [self addSubview:_baseScrollView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pr_handleTaped:)];
    [_baseScrollView addGestureRecognizer:tap];
    
    _pageControl = [UIPageControl new];
    _pageControl.bounds = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 30);
    _pageControl.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds) - CGRectGetMidY(_pageControl.bounds));
    _pageControl.userInteractionEnabled = NO;
    [self addSubview:_pageControl];
    
    _imageViewList = [NSMutableArray new];
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_baseScrollView.bounds) * i,
                                                                               0,
                                                                               CGRectGetWidth(_baseScrollView.bounds),
                                                                               CGRectGetHeight(_baseScrollView.bounds))];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        imageView.tag = i;

        [_baseScrollView addSubview:imageView];
        [_imageViewList addObject:imageView];
    }
}

- (void)pr_handleTaped:(UITapGestureRecognizer *)sender {
    if (self.didSelectItemAtIndex) {
        self.didSelectItemAtIndex(_currentIndex);
    }
}

- (NSInteger)pr_realIndexWithIndex:(NSInteger)index {
    NSParameterAssert(_numberOfPages);
    // 获取最大索引
    NSInteger maximumIndex = self.numberOfPages() - 1;
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

    if (contentOffset.x >= CGRectGetWidth(_baseScrollView.bounds) * 2) {
        // 向右
        shouldUpdate = YES;
        _currentIndex = [self pr_realIndexWithIndex:++_currentIndex];
    } else if (contentOffset.x <= 0) {
        // 向左
        shouldUpdate = YES;
        _currentIndex = [self pr_realIndexWithIndex:--_currentIndex];
    }
    
    // 判断是否需要更新
    if (!shouldUpdate) {
        return;
    }

    _pageControl.currentPage = _currentIndex;
    
    [self pr_updateUserInterface];
}

- (void)pr_updateUserInterface {
    // 更新所有imageView显示的图片
    NSParameterAssert(self.updateImageViewForIndex);
    self.updateImageViewForIndex((UIImageView *)_imageViewList[0], [self pr_realIndexWithIndex:_currentIndex - 1]);
    self.updateImageViewForIndex((UIImageView *)_imageViewList[1], [self pr_realIndexWithIndex:_currentIndex]);
    self.updateImageViewForIndex((UIImageView *)_imageViewList[2], [self pr_realIndexWithIndex:_currentIndex + 1]);

    // 恢复可见区域
    _baseScrollView.contentOffset = CGPointMake(CGRectGetWidth(_baseScrollView.bounds), 0);
}

- (void)pr_handleSwitchImageView:(NSTimer *)sender {
    CGPoint newOffset = CGPointMake(self.baseScrollView.contentOffset.x + CGRectGetWidth(self.baseScrollView.bounds), 0);
    [self.baseScrollView setContentOffset:newOffset animated:YES];
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer pause];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.animationDelayDuration) {
        [self.timer resumeAfterDuration:self.animationDelayDuration()];
    }
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
    _pageControl.numberOfPages = _numberOfPages();
    _baseScrollView.scrollEnabled = _pageControl.numberOfPages > 1;
}

- (void)setUpdateImageViewForIndex:(void (^)(UIImageView *, NSUInteger))configureImageForViewWithIndex {
    _updateImageViewForIndex = configureImageForViewWithIndex;
    [self pr_updateUserInterface];
}

- (void)setAnimationDelayDuration:(NSTimeInterval (^)(void))animationDelayDuration {
    _animationDelayDuration = animationDelayDuration;
    _timer = [NSTimer scheduledTimerWithTimeInterval:_animationDelayDuration()
                                              target:self
                                            selector:@selector(pr_handleSwitchImageView:)
                                            userInfo:nil
                                             repeats:YES];
    [_timer resume];
}


@end
