//
//  SXQDBManager.h
//  实验助手
//
//  Created by sxq on 15/9/25.
//  Copyright © 2015年 SXQ. All rights reserved.
//
@class SXQExpInstruction;
#import <Foundation/Foundation.h>
typedef void  (^CompletionHandler)(BOOL success,NSDictionary *info);
@interface SXQDBManager : NSObject
+ (instancetype)sharedManager;
- (void)insertInstruciton:(id)instruction completion:(CompletionHandler)completion;
- (BOOL)expInstrucitonExist:(NSString *)expInstructionID;
- (NSArray *)chechAllInstuction;
- (BOOL)writeRemark:(NSString *)remark withExpId:(NSString *)expId expProcessID:(NSString *)expProcessId;

- (BOOL)insertIntoMyExp:(NSString *)instrucitonID;
/**
 *  添加我的实验试剂表
 *
 */
- (BOOL)addReagentWithInstructionId:(NSString *)instructionid;
@end
