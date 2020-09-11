//
//  UIViewController+NavigationBar.m
//  NavigationController
//
//  Created by Taipingjinfu on 2020/9/7.
//  Copyright © 2020 张稳. All rights reserved.
//

#import "UIViewController+NavigationBar.h"
#import <objc/runtime.h>
#import "BaseNAvViewController.h"

static NSString *keysBarStyle = @"NavigationBarKeys_barStyle";
static NSString *keysBackgroundColor = @"NavigationBarKeys_backgroundColor";
static NSString *keysBackgroundImage = @"NavigationBarKeys_backgroundImage";
static NSString *keysTintColor = @"NavigationBarKeys_tintColor";
static NSString *keysBarAlpha = @"NavigationBarKeys_barAlpha";
static NSString *keysTitleColor = @"NavigationBarKeys_titleColor";
static NSString *keysTitleFont = @"NavigationBarKeys_titleFont";
static NSString *keysShadowHidden = @"NavigationBarKeys_shadowHidden";
static NSString *keysShadowColor = @"NavigationBarKeys_shadowColor";
static NSString *keysEnablePopGesture = @"NavigationBarKeys_enablePopGesture";

@implementation UIViewController (NavigationBar)

+ (void)load {
    Method method_old = class_getInstanceMethod([self class], @selector(presentViewController:animated:completion:));
    Method method_new = class_getInstanceMethod([self class], @selector(zPresentViewController:animated:completion:));
    method_exchangeImplementations(method_old, method_new);
}

- (void)zPresentViewController:(UIViewController *) viewController animated:(BOOL) animated completion:(void (^ __nullable)(void)) completion {
    viewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self zPresentViewController:viewController animated:animated completion:completion];
    });
}

#pragma mark - 属性
// 导航栏样式
- (void)setZBarStyle:(UIBarStyle)zBarStyle {
    objc_setAssociatedObject(self, &keysBarStyle, @(zBarStyle), OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self zsetNeedsNavigationBarTintUpdate];
}

- (UIBarStyle)zBarStyle {
    if (objc_getAssociatedObject(self, &keysBarStyle)) {
        id barStyle = objc_getAssociatedObject(self, &keysBarStyle);
        return [barStyle integerValue];
    }
    return UINavigationBar.appearance.barStyle;
}

// 导航栏背景色，默认白色
- (void)setZBackgroundColor:(UIColor *)zBackgroundColor {
    objc_setAssociatedObject(self, &keysBackgroundColor, zBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self zsetNeedsNavigationBarBackgroundUpdate];
}

- (UIColor *)zBackgroundColor {
    if (objc_getAssociatedObject(self, &keysBackgroundColor)) {
        UIColor *backgroundColor = objc_getAssociatedObject(self, &keysBackgroundColor);
        return backgroundColor;
    }
    
    if (UINavigationBar.appearance.barTintColor) {
        return UINavigationBar.appearance.barTintColor;
    }
    
    return [UIColor whiteColor];
}

// 导航栏背景图片
- (void)setZBackgroundImage:(UIImage *)zBackgroundImage {
    objc_setAssociatedObject(self, &keysBackgroundImage, zBackgroundImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self zsetNeedsNavigationBarBackgroundUpdate];
}

- (UIImage *)zBackgroundImage {
    if (objc_getAssociatedObject(self, &keysBackgroundImage)) {
        UIImage *backgroundImage = objc_getAssociatedObject(self, &keysBackgroundImage);
        return backgroundImage;
    }
    return [[UINavigationBar appearance] backgroundImageForBarMetrics:UIBarMetricsDefault];
}

// 导航栏前景色（item的文字图标颜色），默认黑色
- (void)setZTintColor:(UIColor *)zTintColor {
    objc_setAssociatedObject(self, &keysTintColor, zTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self zsetNeedsNavigationBarTintUpdate];
}

- (UIColor *)zTintColor {
    if (objc_getAssociatedObject(self, &keysTintColor)) {
        UIColor *tintColor = objc_getAssociatedObject(self, &keysTintColor);
        return tintColor;
    }
    
    if ([UINavigationBar appearance].tintColor) {
        return [UINavigationBar appearance].tintColor;
    }
    
    return [UIColor blackColor];
}

// 导航栏背景透明度，默认为1
- (void)setZBarAlpha:(CGFloat)zBarAlpha {
    objc_setAssociatedObject(self, &keysBarAlpha, @(zBarAlpha), OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self zsetNeedsNavigationBarBackgroundUpdate];
}

- (CGFloat)zBarAlpha {
    if (objc_getAssociatedObject(self, &keysBarAlpha)) {
        CGFloat barAlpha = [objc_getAssociatedObject(self, &keysBarAlpha) floatValue];
        return barAlpha;
    }
    return 1;
}

// 导航栏标题文字颜色，默认黑色
- (void)setZTitleColor:(UIColor *)zTitleColor {
    objc_setAssociatedObject(self, &keysTitleColor, zTitleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self zsetNeedsNavigationBarTintUpdate];
}

- (UIColor *)zTitleColor {
    if (objc_getAssociatedObject(self, &keysTitleColor)) {
        UIColor *titleColor = objc_getAssociatedObject(self, &keysTitleColor);
        return titleColor;
    }
    
    if ([UINavigationBar appearance].titleTextAttributes[NSForegroundColorAttributeName]) {
        UIColor *titleColor = [UINavigationBar appearance].titleTextAttributes[NSForegroundColorAttributeName];
        return titleColor;
    }
    
    return [UIColor blackColor];
}

// 导航栏标题文字字体，默认17号粗体
- (void)setZTitleFont:(UIFont *)zTitleFont {
    objc_setAssociatedObject(self, &keysTitleFont, zTitleFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self zsetNeedsNavigationBarTintUpdate];
}

- (UIFont *)zTitleFont {
    if (objc_getAssociatedObject(self, &keysTitleFont)) {
        UIFont *titleFont = objc_getAssociatedObject(self, &keysTitleFont);
        return titleFont;
    }
    
    if ([UINavigationBar appearance].titleTextAttributes[NSFontAttributeName]) {
        UIFont *titleFont = [UINavigationBar appearance].titleTextAttributes[NSFontAttributeName];
        return titleFont;
    }
    
    return [UIFont boldSystemFontOfSize:17];
}

// 导航栏底部分割线是否隐藏，默认不隐藏
- (void)setZShadowHidden:(BOOL)zShadowHidden {
    objc_setAssociatedObject(self, &keysShadowHidden, @(zShadowHidden), OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self zsetNeedsNavigationBarShadowUpdate];
}

- (BOOL)zShadowHidden {
    if (objc_getAssociatedObject(self, &keysShadowHidden)) {
        BOOL shadowHidden = [objc_getAssociatedObject(self, &keysShadowHidden) boolValue];
        return shadowHidden;
    } else {
        return NO;
    }
}

// 导航栏底部分割线颜色
- (void)setZShadowColor:(UIColor *)zShadowColor {
    objc_setAssociatedObject(self, &keysShadowColor, zShadowColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self zsetNeedsNavigationBarShadowUpdate];
}

- (UIColor *)zShadowColor {
    if (objc_getAssociatedObject(self, &keysShadowColor)) {
        UIColor *shadowColor = objc_getAssociatedObject(self, &keysShadowColor);
        return shadowColor;
    }
    return [UIColor colorWithWhite:0 alpha:0.3];
}

// 是否开启手势返回，默认开启
- (void)setZEnablePopGesture:(BOOL)zEnablePopGesture {
    objc_setAssociatedObject(self, &keysEnablePopGesture, @(zEnablePopGesture), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)zEnablePopGesture {
    if (objc_getAssociatedObject(self, &keysEnablePopGesture)) {
        BOOL enablePopGesture = [objc_getAssociatedObject(self, &keysEnablePopGesture) boolValue];
        return enablePopGesture;
    }
    else {
        return YES;
    }
}

#pragma mark -- 更新UI
- (void)zsetNeedsNavigationBarUpdate {
    if ([self.navigationController isMemberOfClass:[BaseNavViewController class]]) {
        BaseNavViewController *navController = (BaseNavViewController *)self.navigationController;
        [navController updateNavigationBarFor:self];
    }
}

- (void)zsetNeedsNavigationBarTintUpdate {
    if ([self.navigationController isMemberOfClass:[BaseNavViewController class]]) {
        BaseNavViewController *navController = (BaseNavViewController *)self.navigationController;
        [navController updateNavigationBarTintFor:self ignoreTintColor:NO];
    }
}

- (void)zsetNeedsNavigationBarBackgroundUpdate {
    if ([self.navigationController isMemberOfClass:[BaseNavViewController class]]) {
        BaseNavViewController *navController = (BaseNavViewController *)self.navigationController;
        [navController updateNavigationBarBackgroundFor:self];
    }
}

- (void)zsetNeedsNavigationBarShadowUpdate {
    if ([self.navigationController isMemberOfClass:[BaseNavViewController class]]) {
        BaseNavViewController *navController = (BaseNavViewController *)self.navigationController;
        [navController updateNavigationBarShadowFor:self];
    }
}

@end
