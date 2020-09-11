//
//  UIViewController+NavigationBar.h
//  NavigationController
//
//  Created by Taipingjinfu on 2020/9/7.
//  Copyright © 2020 张稳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (NavigationBar)

/**
 导航栏样式，默认样式
 */
@property (nonatomic, assign) UIBarStyle zBarStyle;

/**
 导航栏前景色（item的文字图标颜色），默认黑色
 */
@property (nonatomic, strong) UIColor *zTintColor;

/**
 导航栏标题文字颜色，默认黑色
 */
@property (nonatomic, strong) UIColor *zTitleColor;

/**
 导航栏标题文字字体，默认17号粗体
 */
@property (nonatomic, strong) UIFont *zTitleFont;

/**
 导航栏背景色，默认白色
 */
@property (nonatomic, strong) UIColor *zBackgroundColor;

/**
 导航栏背景图片
 */
@property (nonatomic, strong) UIImage *zBackgroundImage;

/**
 导航栏背景透明度，默认为1
 */
@property (nonatomic, assign) CGFloat zBarAlpha;

/**
 导航栏底部分割线是否隐藏，默认不隐藏
 */
@property (nonatomic, assign) BOOL zShadowHidden;

/**
 导航栏底部分割线颜色
 */
@property (nonatomic, strong) UIColor *zShadowColor;

/**
 是否开启手势返回，默认开启
 */
@property (nonatomic, assign) BOOL zEnablePopGesture;

/**
 更新整体
 */
- (void)zsetNeedsNavigationBarUpdate;

/**
 更新文字、title颜色
 */
- (void)zsetNeedsNavigationBarTintUpdate;

/**
 更新背景
 */
- (void)zsetNeedsNavigationBarBackgroundUpdate;

/**
 更新shadow
 */
- (void)zsetNeedsNavigationBarShadowUpdate;

@end

NS_ASSUME_NONNULL_END
