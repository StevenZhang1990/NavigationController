//
//  TestViewController.m
//  NavigationController
//
//  Created by Taipingjinfu on 2020/9/7.
//  Copyright © 2020 张稳. All rights reserved.
//

#import "TestViewController.h"
#import "PushViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.zBackgroundColor = [UIColor clearColor];
    self.zTitleColor = [UIColor greenColor];
    self.zTintColor = [UIColor redColor];
//    self.zBarStyle = UIBarStyleDefault;
    self.zShadowHidden = YES;
//    self.zShadowColor = [UIColor blueColor];
    
    
    UIButton *btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(0, 0, 100, 50);
    btn.center = self.view.center;
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnClick {
    PushViewController *vc = [[PushViewController alloc] init];
    vc.title = @"push";
    [self presentViewController:vc animated:YES completion:nil];
//    [self.navigationController pushViewController:vc animated:YES];
}

@end
