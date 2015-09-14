//
//  SXQExpeirmentController.m
//  实验助手
//
//  Created by sxq on 15/9/14.
//  Copyright (c) 2015年 SXQ. All rights reserved.
//
#import "SXQDoneExperimentController.h"
#import "SXQExpeirmentController.h"
#import "SXQNowExperimentController.h"

@interface SXQExpeirmentController ()

@end

@implementation SXQExpeirmentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)nowButtonClicked:(UIButton *)sender {
    [self.navigationController pushViewController:[SXQNowExperimentController new] animated:YES];
}
- (IBAction)doneButtonClicked:(UIButton *)sender {
    [self.navigationController pushViewController:[SXQDoneExperimentController new] animated:YES];
}



@end
