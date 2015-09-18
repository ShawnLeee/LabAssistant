//
//  ExperimentTool.h
//  实验助手
//
//  Created by sxq on 15/9/16.
//  Copyright (c) 2015年 SXQ. All rights reserved.
//
@class SXQExperimentModel,SXQExperimentStep;
#import <Foundation/Foundation.h>

typedef void (^CompletionBlock)(NSArray *resultArray);

@interface ExperimentParam : NSObject
@property (nonatomic,copy) NSString *userID;
@property (nonatomic,copy) NSString *myExpID;
@property (nonatomic,copy) NSString *expInstructionID;
@property (nonatomic,copy) NSString *expState;
+ (instancetype)paramWithExperimentModel:(SXQExperimentModel *)model;
@end

@interface FetchStepResult : NSObject
@property (nonatomic,copy) NSString *experimentName;
@property (nonatomic,strong) NSArray *steps;
@end

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
/**
 *  获取实验或说明书下所有的实验步骤
 */
+ (void)fetchExperimentStepWithParam:(ExperimentParam *)param success:(void (^)(FetchStepResult *result ))success failure:(void (^)(NSError *error))failure;
@end
