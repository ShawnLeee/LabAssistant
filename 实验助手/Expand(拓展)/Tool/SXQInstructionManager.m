//
//  SXQInstructionManager.m
//  实验助手
//
//  Created by sxq on 15/9/25.
//  Copyright © 2015年 SXQ. All rights reserved.
//
#import "SXQDBManager.h"
#import "SXQInstructionManager.h"

@implementation SXQInstructionManager
- (void)downloadInstruction:(id)instruction completion:(CompletionHandler)completion
{
    [[SXQDBManager sharedManager] insertInstruciton:instruction completion:^(BOOL success, NSDictionary *info) {
        completion(success,info);
    }];
}
+ (BOOL)instructionIsdownload:(NSString *)instrucitonID
{
    return  [[SXQDBManager sharedManager] expInstrucitonExist:instrucitonID];
}
@end
