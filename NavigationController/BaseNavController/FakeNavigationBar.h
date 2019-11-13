//
//  FakeNavigationBar.h
//  NavigationController
//
//  Created by 张稳 on 2019/11/13.
//  Copyright © 2019 张稳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FakeNavigationBar : UIView

/**
 更新背景
 */
- (void)updateFakeBarBackgroundWithViewController:(UIViewController *) viewController;

/**
 更新底部阴影
 */
- (void)updateFakeBarShadowWithViewController:(UIViewController *) viewController;

@end

NS_ASSUME_NONNULL_END
