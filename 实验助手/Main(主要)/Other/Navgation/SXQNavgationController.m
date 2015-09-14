//
//  SXQNavgationController.m
//  实验助手
//
//  Created by SXQ on 15/8/30.
//  Copyright (c) 2015年 SXQ. All rights reserved.
//

#import "SXQNavgationController.h"

@interface SXQNavgationController ()

@end

@implementation SXQNavgationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
+ (void)initialize
{
    UINavigationBar *navbarAppearance = [UINavigationBar appearance];
    navbarAppearance.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"naviBG"]];
    navbarAppearance.tintColor = [UIColor colorWithRed:92/255.0 green:145/255.0 blue:229/255.0 alpha:1.0];
    navbarAppearance.translucent = NO;
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.hidesBottomBarWhenPushed = YES;
//    viewController.view.window.backgroundColor = [UIColor whiteColor];
    [super pushViewController:viewController animated:YES];
}

@end
