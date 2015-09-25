//
//  SXQExperimentStep.m
//  实验助手
//
//  Created by sxq on 15/9/18.
//  Copyright (c) 2015年 SXQ. All rights reserved.
//

#import "SXQExperimentStep.h"
#import <UIKit/UIKit.h>
@interface SXQExperimentStep ()
@property (nonatomic,strong) NSMutableArray *theMutableArray;
@end
@implementation SXQExperimentStep
- (instancetype)init
{
    if (self =  [super init]) {
        _images = [@[] mutableCopy];
    }
    return self;
}


- (void)addExpImage:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    [self.images addObject:image];
}
@end
