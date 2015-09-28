//
//  SXQExperimentStep.m
//  实验助手
//
//  Created by sxq on 15/9/18.
//  Copyright (c) 2015年 SXQ. All rights reserved.
//

#import "SXQExperimentStep.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
@interface SXQExperimentStep ()
@property (nonatomic,strong) NSMutableArray *theMutableArray;
@end
@implementation SXQExperimentStep
- (CGFloat)imageHeight
{
    if (_image) {
        CGRect boundingRect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 16, MAXFLOAT);
        CGRect frame = AVMakeRectWithAspectRatioInsideRect(_image.size, boundingRect);
        return frame.size.height;
    }
    return 0;
    
}
@end
