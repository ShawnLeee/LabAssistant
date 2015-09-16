//
//  ExperimentTool.m
//  实验助手
//
//  Created by sxq on 15/9/16.
//  Copyright (c) 2015年 SXQ. All rights reserved.
//
#import "SXQHttpTool.h"
#import "ExperimentTool.h"
#import <MJExtension/MJExtension.h>
#import "SXQExperimentModel.h"

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
    [SXQHttpTool getWithURL:@"http://172.18.0.55:8080/LabAssistant/lab/getUnComplete?userID=4028c681494b994701494b99aba50000" params:param success:^(id json) {
        if (completion) {
            NSArray *resultArr = [SXQExperimentModel objectArrayWithKeyValuesArray:json[@"unCompletes"]];
            completion(resultArr);
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
