//
//  SXQExperimentStep.h
//  实验助手
//
//  Created by sxq on 15/9/18.
//  Copyright (c) 2015年 SXQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SXQExperimentStep : NSObject
@property (nonatomic,copy) NSString *stepDesc;
@property (nonatomic,copy) NSString *stepNum;
/**
 *  实验备注
 */
@property (nonatomic,strong) NSString *remark;
/**
 *  实验图片
 */
@property (nonatomic,strong) NSMutableArray *images;

- (void)addExpImage:(NSString *)imageName;

@end
