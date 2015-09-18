//
//  ExperimentTool.m
//  实验助手
//
//  Created by sxq on 15/9/16.
//  Copyright (c) 2015年 SXQ. All rights reserved.
//
#import "SXQHttpTool.h"
#import "SXQURL.h"
#import "ExperimentTool.h"
#import <MJExtension/MJExtension.h>
#import "SXQExperimentModel.h"
#import "SXQExperimentStep.h"
#import <MJExtension/MJExtension.h>
@implementation ExperimentTool
+ (void)fetchDoneExperimentWithParam:(id)param completion:(CompletionBlock)completion
{
    [SXQHttpTool getWithURL:@"http://172.18.0.55:8080/LabAssistant/lab/getComplete?userID=4028c681494b994701494b99aba50000" params:param success:^(id json) {
        if (completion) {
            NSArray *resultArr = [SXQExperimentModel objectArrayWithKeyValuesArray:json[@"completes"]];
            completion(resultArr);
        }
    } failure:^(NSError *error) {
        
    }];
}
+ (void)fetchNowExperimentWithParam:(id)param completion:(CompletionBlock)completion
{
    [SXQHttpTool getWithURL:@"http://172.18.0.55:8080/LabAssistant/lab/getDoing?userID=4028c681494b994701494b99aba50000" params:param success:^(id json) {
        if (completion) {
            NSArray *resultArr = [SXQExperimentModel objectArrayWithKeyValuesArray:json[@"Doings"]];
            completion(resultArr);
        }
    } failure:^(NSError *error) {
        
    }];
}
+ (void)fetchExperimentStepWithParam:(ExperimentParam *)param success:(void (^)(FetchStepResult *))success failure:(void (^)(NSError *))failure
{
    [SXQHttpTool getWithURL:ExperimentStepURL params:param.keyValues success:^(id json) {
        FetchStepResult *resutlt = [FetchStepResult objectWithKeyValues:json[@"myExp"]];
        if (success) {
            success(resutlt);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
@implementation ExperimentParam
+ (instancetype)paramWithExperimentModel:(SXQExperimentModel *)experimentModel
{
    ExperimentParam *param = [[ExperimentParam alloc] init];
    param.myExpID = experimentModel.myExpID;
    param.expState = experimentModel.expState;
    param.expInstructionID = experimentModel.expInstructionID;
    return param;
}
@end
@implementation FetchStepResult
+ (NSDictionary *)objectClassInArray
{
    return @{@"steps" : [SXQExperimentStep class]};
}
@end