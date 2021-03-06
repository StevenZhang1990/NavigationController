//
//  BaseViewController.h
//  NavigationController
//
//  Created by 张稳 on 2019/11/13.
//  Copyright © 2019 张稳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseNavViewController : UINavigationController

- (void)updateNavigationBarFor:(UIViewController *) viewController;

- (void)updateNavigationBarTintFor:(UIViewController *) viewController ignoreTintColor:(BOOL) ignoreTintColor;

- (void)updateNavigationBarBackgroundFor:(UIViewController *) viewController;

- (void)updateNavigationBarShadowFor:(UIViewController *) viewController;

@end

NS_ASSUME_NONNULL_END
