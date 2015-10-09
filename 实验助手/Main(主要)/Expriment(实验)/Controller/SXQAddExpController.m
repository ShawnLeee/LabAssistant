//
//  SXQAddExpController.m
//  实验助手
//
//  Created by sxq on 15/10/9.
//  Copyright © 2015年 SXQ. All rights reserved.
//
#import "SXQAddExpController.h"
#import "UIBarButtonItem+SXQ.h"
@interface SXQAddExpController ()

@end

@implementation SXQAddExpController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupNav];
}
- (void)setupNav{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"确认" action:^{
       //写入数据到正在进行的实验
    }];
}



@end
