//
//  ViewController.m
//  NavigationController
//
//  Created by 张稳 on 2019/11/13.
//  Copyright © 2019 张稳. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.zBackgroundColor = [UIColor clearColor];
//    self.zShadowHidden = YES;
    self.zTitleColor = [UIColor blueColor];
    self.zShadowColor = [UIColor blueColor];
    
    UIButton *btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(0, 0, 100, 50);
    btn.center = self.view.center;
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.zBackgroundColor = [UIColor orangeColor];
}

- (void)btnClick {
    TestViewController *vc = [[TestViewController alloc] init];
    vc.title = @"测试";
    [self.navigationController pushViewController:vc animated:YES];
}

@end
