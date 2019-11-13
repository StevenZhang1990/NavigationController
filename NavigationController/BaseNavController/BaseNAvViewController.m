//
//  BaseViewController.m
//  NavigationController
//
//  Created by 张稳 on 2019/11/13.
//  Copyright © 2019 张稳. All rights reserved.
//

#import "BaseNAvViewController.h"
#import "FakeNavigationBar.h"
#import "UIViewController+NavBar.h"

@interface BaseNAvViewController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) FakeNavigationBar *fakeBar;
@property (nonatomic, strong) FakeNavigationBar *fromFakeBar;
@property (nonatomic, strong) FakeNavigationBar *toFakeBar;
@property (nonatomic, strong) UIView *fakeSuperView;
@property (nonatomic, weak) UIViewController *poppingVC;
@property (nonatomic, strong) NSObject *fakeFrameObserver;


@end

@implementation BaseNAvViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.interactivePopGestureRecognizer.delegate = self;
    [self.interactivePopGestureRecognizer addTarget:self action:@selector(handlerInteractivePopGesture:)];
    [self setupNavigationBar];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    UIViewController *fromVC = [self.transitionCoordinator viewControllerForKey:UITransitionContextFromViewKey];
    if (fromVC == self.poppingVC) {

    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

#pragma mark -- private
- (void)setupNavigationBar {
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [[UIImage alloc] init];
    [self setupFakeSubviews];
}

- (void)setupFakeSubviews {
    if (!self.fakeSuperView) return;
    if (!self.fakeSuperView.superview) {
        [self.fakeSuperView addObserver:self forKeyPath:@"farme" options:0 context:nil];
        [self.fakeSuperView insertSubview:self.fakeBar atIndex:0];
    }
}

- (void)layoutFakeSubviews {
    if (!self.fakeSuperView) return;
    self.fakeBar.frame = self.fakeSuperView.bounds;
    [self.fakeBar setNeedsLayout];
}

#pragma mark -- observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    [self layoutFakeSubviews];
}

- (void)handlerInteractivePopGesture:(UIScreenEdgePanGestureRecognizer *) gesture {
    
    if (!self.transitionCoordinator) return;
    UIViewController *fromVC = [self.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
    if (!fromVC) return;
    UIViewController *toVC = [self.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
    if (!toVC) return;

    if (gesture.state == UIGestureRecognizerStateChanged) {
        self.navigationBar.tintColor = [self averageFromColor:fromVC.zTintColor toColor:toVC.zTintColor percent:self.transitionCoordinator.percentComplete];
    }
}

- (UIColor *)averageFromColor:(UIColor *) fromColor toColor:(UIColor *) toColor percent:(CGFloat) percent {
 
    CGFloat fromRed = 0;
    CGFloat fromGreen = 0;
    CGFloat fromBlue = 0;
    CGFloat fromAlpha = 0;
    [fromColor getRed:&fromRed green:&fromGreen blue:&fromBlue alpha:&fromAlpha];
    
    CGFloat toRed = 0;
    CGFloat toGreen = 0;
    CGFloat toBlue = 0;
    CGFloat toAlpha = 0;
    [toColor getRed:&toRed green:&toGreen blue:&toBlue alpha:&toAlpha];
    
    CGFloat red = fromRed + (toRed - fromRed) * percent;
    CGFloat green = fromGreen + (toGreen - fromGreen) * percent;
    CGFloat blue = fromBlue + (toBlue - fromBlue) * percent;
    CGFloat alpha = fromAlpha + (toAlpha - fromAlpha) * percent;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

#pragma mark -- public
- (void)updateNavigationBarFor:(UIViewController *) viewController {
     
}

- (void)updateNavigationBarTintFor:(UIViewController *) viewController {
    
}

- (void)updateNavigationBarBackgroundFor:(UIViewController *) viewController {
    
}

- (void)updateNavigationBarShadowFor:(UIViewController *) viewController {
    
}

#pragma mark -- delloc
- (void)dealloc {
    [self.fakeSuperView removeObserver:self forKeyPath:@"frame"];
}


@end
