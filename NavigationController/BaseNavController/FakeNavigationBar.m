//
//  FakeNavigationBar.m
//  NavigationController
//
//  Created by 张稳 on 2019/11/13.
//  Copyright © 2019 张稳. All rights reserved.
//

#import "FakeNavigationBar.h"
#import "UIViewController+NavigationBar.h"

@interface FakeNavigationBar()

@property (nonatomic, strong) UIImageView *fakeBackgroundImageView;
@property (nonatomic, strong) UIVisualEffectView *fakeBackgroundEffectView;
@property (nonatomic, strong) UIImageView *fakeShadowImageView;

@end

@implementation FakeNavigationBar

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.fakeBackgroundEffectView];
    [self addSubview:self.fakeBackgroundImageView];
    [self addSubview:self.fakeShadowImageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT);
    self.fakeBackgroundEffectView.frame = self.frame;
    self.fakeBackgroundImageView.frame = self.frame;
    self.fakeShadowImageView.frame = CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5);
}

#pragma mark -- public
- (void)updateFakeBarBackgroundWithViewController:(UIViewController *) viewController {
    
    self.fakeBackgroundEffectView.subviews.lastObject.backgroundColor = viewController.zBackgroundColor;
    self.fakeBackgroundImageView.image = viewController.zBackgroundImage;
    
    if (viewController.zBackgroundImage != nil) {
        // 直接使用fakeBackgroundEffectView.alpha控制台会有提示
        // 这样使用避免警告
        for (UIView *subview in self.fakeBackgroundEffectView.subviews) {
            subview.alpha = 0;
        }
    } else {
        for (UIView *subview in self.fakeBackgroundEffectView.subviews) {
            subview.alpha = viewController.zBarAlpha;
        }
    }

    self.fakeBackgroundImageView.alpha = viewController.zBarAlpha;
    self.fakeShadowImageView.alpha = viewController.zBarAlpha;
}

- (void)updateFakeBarShadowWithViewController:(UIViewController *) viewController {
    self.fakeShadowImageView.hidden = viewController.zShadowHidden;
    self.fakeShadowImageView.backgroundColor = viewController.zShadowColor;
}

#pragma mark -- lazy
- (UIImageView *)fakeBackgroundImageView {
    if (!_fakeBackgroundImageView) {
        _fakeBackgroundImageView = [[UIImageView alloc] init];
        _fakeBackgroundImageView.userInteractionEnabled = NO;
        _fakeBackgroundImageView.contentScaleFactor = 1;
        _fakeBackgroundImageView.contentMode = UIViewContentModeScaleToFill;
        _fakeBackgroundImageView.backgroundColor = [UIColor clearColor];
    }
    return _fakeBackgroundImageView;
}

- (UIVisualEffectView *)fakeBackgroundEffectView {
    if (!_fakeBackgroundEffectView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _fakeBackgroundEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _fakeBackgroundEffectView.userInteractionEnabled = NO;
    }
    return _fakeBackgroundEffectView;
}

- (UIImageView *)fakeShadowImageView {
    if (!_fakeShadowImageView) {
        _fakeShadowImageView = [[UIImageView alloc] init];
        _fakeShadowImageView.userInteractionEnabled = NO;
        _fakeShadowImageView.contentScaleFactor = 1;
    }
    return _fakeShadowImageView;
}

@end
