//
//  BaseViewController.m
//  NavigationController
//
//  Created by 张稳 on 2019/11/14.
//  Copyright © 2019 张稳. All rights reserved.
//

#import "BaseViewController.h"
#import "UIViewController+NavBar.h"
#import <objc/message.h>
#import "BaseNAvViewController.h"

struct NavigationBarKeys {
    NSString *barStyle;
    NSString *backgroundColor;
    NSString *backgroundImage;
    NSString *tintColor;
    NSString *barAlpha;
    NSString *titleColor;
    NSString *titleFont;
    NSString *shadowHidden;
    NSString *shadowColor;
    NSString *enablePopGesture;
} navigationBarKeys;

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    navigationBarKeys.barStyle = @"NavigationBarKeys_barStyle";
    navigationBarKeys.backgroundColor = @"NavigationBarKeys_backgroundColor";
    navigationBarKeys.backgroundImage = @"NavigationBarKeys_backgroundImage";
    navigationBarKeys.tintColor = @"NavigationBarKeys_tintColor";
    navigationBarKeys.barAlpha = @"NavigationBarKeys_barAlpha";
    navigationBarKeys.titleColor = @"NavigationBarKeys_titleColor";
    navigationBarKeys.titleFont = @"NavigationBarKeys_titleFont";
    navigationBarKeys.shadowHidden = @"NavigationBarKeys_shadowHidden";
    navigationBarKeys.shadowColor = @"NavigationBarKeys_shadowColor";
    navigationBarKeys.enablePopGesture = @"NavigationBarKeys_enablePopGesture";
}

- (void)setZBarStyle:(UIBarStyle)zBarStyle {
    objc_setAssociatedObject(self, &navigationBarKeys.barStyle, @(zBarStyle), OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self zsetNeedsNavigationBarTintUpdate];
}

- (UIBarStyle)zBarStyle {
    id barStyle = objc_getAssociatedObject(self, &navigationBarKeys.barStyle);
    return barStyle ? [barStyle integerValue] : UINavigationBar.appearance.barStyle;
}

- (void)setZBackgroundColor:(UIColor *)zBackgroundColor {
    objc_setAssociatedObject(self, &navigationBarKeys.backgroundColor, zBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self zsetNeedsNavigationBarBackgroundUpdate];
}

- (UIColor *)zBackgroundColor {
    
    if (objc_getAssociatedObject(self, &navigationBarKeys.backgroundColor)) {
        UIColor *backgroundColor = objc_getAssociatedObject(self, &navigationBarKeys.backgroundColor);
        return backgroundColor;
    }
    
    if (UINavigationBar.appearance.barTintColor) {
        return UINavigationBar.appearance.barTintColor;
    }
    
    return [UIColor whiteColor];
}

- (void)setZBackgroundImage:(UIImage *)zBackgroundImage {
    objc_setAssociatedObject(self, &navigationBarKeys.backgroundImage, zBackgroundImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self zsetNeedsNavigationBarBackgroundUpdate];
}

- (UIImage *)zBackgroundImage {
    UIImage *backgroundImage = objc_getAssociatedObject(self, &navigationBarKeys.backgroundImage);
    return backgroundImage ? backgroundImage : [[UINavigationBar appearance] backgroundImageForBarMetrics:UIBarMetricsDefault];
}

- (void)setZTintColor:(UIColor *)zTintColor {
    objc_setAssociatedObject(self, &navigationBarKeys.tintColor, zTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self zsetNeedsNavigationBarTintUpdate];
}

- (UIColor *)zTintColor {
    
    if (objc_getAssociatedObject(self, &navigationBarKeys.tintColor)) {
        UIColor *tintColor = objc_getAssociatedObject(self, &navigationBarKeys.tintColor);
        return tintColor;
    }
    
    if ([UINavigationBar appearance].tintColor) {
        return [UINavigationBar appearance].tintColor;
    }
    
    return [UIColor blackColor];
}

- (void)setZBarAlpha:(CGFloat)zBarAlpha {
    objc_setAssociatedObject(self, &navigationBarKeys.barAlpha, @(zBarAlpha), OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self zsetNeedsNavigationBarBackgroundUpdate];
}

- (CGFloat)zBarAlpha {
    if (objc_getAssociatedObject(self, &navigationBarKeys.barAlpha)) {
        CGFloat barAlpha = [objc_getAssociatedObject(self, &navigationBarKeys.barAlpha) floatValue];
        return barAlpha;
    }
    return 1;
}

- (void)setZTitleColor:(UIColor *)zTitleColor {
    objc_setAssociatedObject(self, &navigationBarKeys.titleColor, zTitleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self zsetNeedsNavigationBarTintUpdate];
}

- (UIColor *)zTitleColor {
    
    if (objc_getAssociatedObject(self, &navigationBarKeys.titleColor)) {
        UIColor *titleColor = objc_getAssociatedObject(self, &navigationBarKeys.titleColor);
        return titleColor;
    }
    
    if ([UINavigationBar appearance].titleTextAttributes[NSForegroundColorAttributeName]) {
        UIColor *titleColor = [UINavigationBar appearance].titleTextAttributes[NSForegroundColorAttributeName];
        return titleColor;
    }
    
    return [UIColor blackColor];
}

- (void)setZTitleFont:(UIFont *)zTitleFont {
    objc_setAssociatedObject(self, &navigationBarKeys.titleFont, zTitleFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self zsetNeedsNavigationBarTintUpdate];
}

- (UIFont *)zTitleFont {
    
    if (objc_getAssociatedObject(self, &navigationBarKeys.titleFont)) {
        UIFont *titleFont = objc_getAssociatedObject(self, &navigationBarKeys.titleFont);
        return titleFont;
    }
    
    if ([UINavigationBar appearance].titleTextAttributes[NSFontAttributeName]) {
        UIFont *titleFont = [UINavigationBar appearance].titleTextAttributes[NSFontAttributeName];
        return titleFont;
    }
    
    return [UIFont boldSystemFontOfSize:17];
}

- (void)setZShadowHidden:(BOOL)zShadowHidden {
    objc_setAssociatedObject(self, &navigationBarKeys.shadowHidden, @(zShadowHidden), OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self zsetNeedsNavigationBarShadowUpdate];
}

- (BOOL)zShadowHidden {
    if (objc_getAssociatedObject(self, &navigationBarKeys.shadowHidden)) {
        BOOL shadowHidden = [objc_getAssociatedObject(self, &navigationBarKeys.shadowHidden) boolValue];
        return shadowHidden;
    } else {
        return false;
    }
}

- (void)setZShadowColor:(UIColor *)zShadowColor {
    objc_setAssociatedObject(self, &navigationBarKeys.shadowColor, zShadowColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self zsetNeedsNavigationBarShadowUpdate];
}

- (UIColor *)zShadowColor {
    UIColor *shadowColor = objc_getAssociatedObject(self, &navigationBarKeys.shadowColor);
    return shadowColor ? shadowColor : [UIColor colorWithWhite:0 alpha:0.3];
}

- (void)setZEnablePopGesture:(BOOL)zEnablePopGesture {
    objc_setAssociatedObject(self, &navigationBarKeys.enablePopGesture, @(zEnablePopGesture), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)zEnablePopGesture {
    if (objc_getAssociatedObject(self, &navigationBarKeys.enablePopGesture)) {
        BOOL enablePopGesture = [objc_getAssociatedObject(self, &navigationBarKeys.enablePopGesture) boolValue];
        return enablePopGesture;
    }
    else {
        return YES;
    }
}

#pragma mark -- 更新UI
- (void)zsetNeedsNavigationBarUpdate {
    if ([self.navigationController isKindOfClass:[BaseNavViewController class]]) {
        BaseNavViewController *nav = (BaseNavViewController *)self.navigationController;
        [nav updateNavigationBarFor:self];
    }
}

- (void)zsetNeedsNavigationBarTintUpdate {
    if ([self.navigationController isKindOfClass:[BaseNavViewController class]]) {
        BaseNavViewController *nav = (BaseNavViewController *)self.navigationController;
        [nav updateNavigationBarTintFor:self ignoreTintColor:NO];
    }
}

- (void)zsetNeedsNavigationBarBackgroundUpdate {
    if ([self.navigationController isKindOfClass:[BaseNavViewController class]]) {
        BaseNavViewController *nav = (BaseNavViewController *)self.navigationController;
        [nav updateNavigationBarBackgroundFor:self];
    }
}

- (void)zsetNeedsNavigationBarShadowUpdate {
    if ([self.navigationController isKindOfClass:[BaseNavViewController class]]) {
        BaseNavViewController *nav = (BaseNavViewController *)self.navigationController;
        [nav updateNavigationBarShadowFor:self];
    }
}

@end
