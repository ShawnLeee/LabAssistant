//
//  SXQMyExperimentManager.m
//  实验助手
//
//  Created by sxq on 15/9/25.
//  Copyright © 2015年 SXQ. All rights reserved.
//
#import "SXQDBManager.h"
#import "SXQMyExperimentManager.h"
#import "SXQExpInstruction.h"
@implementation SXQMyExperimentManager
- (void)writeRemak:(NSString *)remark toExperiment:(NSString *)myExpID expStepID:(NSString *)expStepID
{
    [[SXQDBManager sharedManager] writeRemark:remark withExpId:myExpID expProcessID:expStepID];
}
+ (void)addExperimentWithInstructionId:(NSString *)instructionId
{
    SXQDBManager *manager = [SXQDBManager sharedManager];
    //添加我的实验
    [manager insertIntoMyExp:instructionId];
    //添加
}
@end

