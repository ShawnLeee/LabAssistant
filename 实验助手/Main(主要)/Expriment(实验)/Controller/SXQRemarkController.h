//
//  SXQRemarkController.h
//  实验助手
//
//  Created by sxq on 15/9/25.
//  Copyright © 2015年 SXQ. All rights reserved.
//
@class SXQExperimentStep;
#import <UIKit/UIKit.h>

@interface SXQRemarkController : UIViewController
- (instancetype)initWithExperimentStep:(SXQExperimentStep *)experimentStep;
@property (nonatomic,copy) void (^addRemarkBlk)(NSString *remark);
@property (nonatomic,copy) void (^completion)();
@end
