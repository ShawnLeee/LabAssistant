//
//  ExperimentTool.h
//  实验助手
//
//  Created by sxq on 15/9/16.
//  Copyright (c) 2015年 SXQ. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef void (^CompletionBlock)(NSArray *resultArray);

@interface ExperimentTool : NSObject
/**
 *  获取已完成的实验列表
 *
 *  @param completion 获取成功后的回调
 */
+ (void)fetchDoneExperimentWithParam:(id)param completion:(CompletionBlock)completion;
/**
 *  获取进行中的实验列表
 *
 *  @param completion 获取成功后的回调
 */
+ (void)fetchNowExperimentWithParam:(id)param completion:(CompletionBlock)completion;
@end
