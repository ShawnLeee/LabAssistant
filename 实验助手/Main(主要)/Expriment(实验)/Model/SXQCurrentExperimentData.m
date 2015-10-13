//
//  SXQCurrentExperimentData.m
//  实验助手
//
//  Created by sxq on 15/10/12.
//  Copyright © 2015年 SXQ. All rights reserved.
//
#import "SXQDBManager.h"
#import "SXQCurrentExperimentData.h"
@interface SXQCurrentExperimentData ()
@property (nonatomic,copy) void (^completion)(BOOL success);
@property (nonatomic,copy) NSString *myExpId;
@end
@implementation SXQCurrentExperimentData
- (instancetype)initWithMyExpId:(NSString *)myExpId completion:(void (^)(BOOL))completion
{
    if (self = [super init]) {
        _completion = [completion copy];
        _myExpId = [myExpId copy];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self loadData];
        });
    }
    return self;
    
}
- (void)loadData
{
    [[SXQDBManager sharedManager] loadCurrentDataWithMyExpId:_myExpId completion:^(SXQCurrentExperimentData *currentExprimentData) {
        if (currentExprimentData) {
            _myExperiment = currentExprimentData.myExperiment;
            _expProcesses = currentExprimentData.expProcesses;
            _completion(YES);
        }else
        {
            _completion(NO);
        }
    }];
}
@end
