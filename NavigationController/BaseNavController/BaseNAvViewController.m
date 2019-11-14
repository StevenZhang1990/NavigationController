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

@interface BaseNavViewController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) FakeNavigationBar *fakeBar;
@property (nonatomic, strong) FakeNavigationBar *fromFakeBar;
@property (nonatomic, strong) FakeNavigationBar *toFakeBar;
@property (nonatomic, strong) UIView *fakeSuperView;
@property (nonatomic, weak) UIViewController *poppingVC;

@end

@implementation BaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.interactivePopGestureRecognizer.delegate = self;
    [self.interactivePopGestureRecognizer addTarget:self action:@selector(handlerInteractivePopGesture:)];
    [self setupNavigationBar];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    if (self.transitionCoordinator) {
        UIViewController *fromVC = [self.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
        if (!fromVC) return;
        if (fromVC == self.poppingVC) {
            [self updateNavigationBarFor:fromVC];
        }
    } else {
        if (!self.topViewController) return;
        [self updateNavigationBarFor:self.topViewController];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutFakeSubviews];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    self.poppingVC = self.topViewController;
    UIViewController *viewController = [super popViewControllerAnimated:animated];
    if (self.topViewController) {
        [self updateNavigationBarTintFor:self.topViewController ignoreTintColor:YES];
    }
    return viewController;
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    self.poppingVC = self.topViewController;
    NSArray *vcArray = [super popToRootViewControllerAnimated:animated];
    if (self.topViewController) {
        [self updateNavigationBarTintFor:self.topViewController ignoreTintColor:YES];
    }
    return vcArray;
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.poppingVC = self.topViewController;
    NSArray *vcArray = [super popToViewController:viewController animated:animated];
    if (self.topViewController) {
        [self updateNavigationBarTintFor:self.topViewController ignoreTintColor:YES];
    }
    return vcArray;
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

- (void)showViewControllerWith:(UIViewController *) viewController coordinator:(id<UIViewControllerTransitionCoordinator>) coordinator {
    
    UIViewController *fromVC = [coordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [coordinator viewControllerForKey:UITransitionContextToViewControllerKey];

    if (fromVC && toVC) {
        [self resetButtonLabelsIn:self.navigationBar];
        [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            if ([viewController isEqual:toVC]) {
                [self showTempFakeBarFrom:fromVC toVC:toVC];
            } else {
                [self updateNavigationBarBackgroundFor:viewController];
                [self updateNavigationBarShadowFor:viewController];
            }
        } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            if (context.isCancelled) {
                [self updateNavigationBarFor:fromVC];
            } else {
                [self updateNavigationBarFor:viewController];
            }
            if ([viewController isEqual:toVC]) {
                [self clearTempFakeBar];
            }
        }];
    }
}

- (void)clearTempFakeBar {
    self.fakeBar.alpha = 1;
    [self.fromFakeBar removeFromSuperview];
    [self.toFakeBar removeFromSuperview];
}

- (void)showTempFakeBarFrom:(UIViewController *)fromVC toVC:(UIViewController *)toVC {
    [UIView setAnimationsEnabled:NO];
    self.fakeBar.alpha = 0;
    //from
    [fromVC.view addSubview:self.fromFakeBar];
    self.fromFakeBar.frame = [self fakeBarFrameFor:fromVC];
    [self.fromFakeBar setNeedsLayout];
    [self.fromFakeBar updateFakeBarBackgroundWithViewController:fromVC];
    [self.fromFakeBar updateFakeBarShadowWithViewController:fromVC];
    //to
    [toVC.view addSubview:self.toFakeBar];
    self.toFakeBar.frame = [self fakeBarFrameFor:toVC];
    [self.toFakeBar setNeedsLayout];
    [self.toFakeBar updateFakeBarBackgroundWithViewController:toVC];
    [self.toFakeBar updateFakeBarShadowWithViewController:toVC];
    [UIView setAnimationsEnabled:NO];
}

- (CGRect)fakeBarFrameFor:(UIViewController *) viewController {
    if (self.fakeSuperView) {
        CGRect frame = [self.navigationBar convertRect:self.fakeSuperView.frame toView:viewController.view];
        frame.origin.x = viewController.view.frame.origin.x;
        return frame;
    } else {
        return self.navigationBar.frame;
    }
}

- (void)resetButtonLabelsIn:(UIView *) view {
    NSString *viewClassName = [[[view classForCoder] description] stringByReplacingOccurrencesOfString:@"_" withString:@""];
    if ([viewClassName isEqualToString:@"UIButtonLabel"]) {
        view.alpha = 1;
    } else {
        if (view.subviews.count > 0) {
            for (UIView *subview in view.subviews) {
                [self resetButtonLabelsIn:subview];
            }
        }
    }
}

#pragma mark -- observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    [self layoutFakeSubviews];
}

#pragma mark -- UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.transitionCoordinator) {
        [self showViewControllerWith:viewController coordinator:self.transitionCoordinator];
    } else {
        if (!animated && self.viewControllers.count > 1) {
            UIViewController *lastButOneVC = self.viewControllers[self.viewControllers.count - 2];
            [self showTempFakeBarFrom:lastButOneVC toVC:viewController];
            return;
        }
        [self updateNavigationBarFor:viewController];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (!animated) {
        [self updateNavigationBarFor:viewController];
        [self clearTempFakeBar];
    }
    self.poppingVC = nil;
}

#pragma mark -- UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count <= 1) {
        return NO;
    }
    
    if (self.topViewController) {
        return self.topViewController.zEnablePopGesture;
    }
    
    return YES;
}

#pragma mark -- public
- (void)updateNavigationBarFor:(UIViewController *) viewController {
    [self setupFakeSubviews];
    [self updateNavigationBarTintFor:viewController ignoreTintColor:NO];
    [self updateNavigationBarBackgroundFor:viewController];
    [self updateNavigationBarShadowFor:viewController];
}

- (void)updateNavigationBarTintFor:(UIViewController *) viewController ignoreTintColor:(BOOL) ignoreTintColor {
    if (viewController != self.topViewController) return;
    
    [UIView setAnimationsEnabled:NO];
    self.navigationBar.barStyle = viewController.zBarStyle;
    NSDictionary *titleTextAttributes = @{NSForegroundColorAttributeName:viewController.zTitleColor,
                                          NSFontAttributeName:viewController.zTitleFont};
    self.navigationBar.titleTextAttributes = titleTextAttributes;
    if (!ignoreTintColor) {
        self.navigationBar.tintColor = viewController.zTintColor;
    }
    [UIView setAnimationsEnabled:YES];
}

- (void)updateNavigationBarBackgroundFor:(UIViewController *) viewController {
    if (viewController != self.topViewController) return;
    [self.fakeBar updateFakeBarBackgroundWithViewController:viewController];
}

- (void)updateNavigationBarShadowFor:(UIViewController *) viewController {
    if (viewController != self.topViewController) return;
    [self.fakeBar updateFakeBarShadowWithViewController:viewController];
}

#pragma mark -- delloc
- (void)dealloc {
    [self.fakeSuperView removeObserver:self forKeyPath:@"frame"];
}


@end
