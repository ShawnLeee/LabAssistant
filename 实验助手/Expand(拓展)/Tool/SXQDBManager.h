//
//  SXQDBManager.h
//  实验助手
//
//  Created by sxq on 15/9/25.
//  Copyright © 2015年 SXQ. All rights reserved.
//
@class SXQExpInstruction,SXQInstructionData,SXQCurrentExperimentData;
#import <Foundation/Foundation.h>
typedef void  (^CompletionHandler)(BOOL success,NSDictionary *info);
@interface SXQDBManager : NSObject
+ (instancetype)sharedManager;
/**
 *  下载说明书
 */
- (void)insertInstruciton:(SXQInstructionData *)instructionData completion:(CompletionHandler)completion;
/**
 *   检查说明书是否已经下载
 */
- (BOOL)expInstrucitonExist:(NSString *)expInstructionID;

- (NSArray *)chechAllInstuction;
- (BOOL)writeRemark:(NSString *)remark withExpId:(NSString *)expId expProcessID:(NSString *)expProcessId;

- (BOOL)insertIntoMyExp:(NSString *)instrucitonID;
/**
 *  添加我的实验试剂表
 *
 */
- (BOOL)addReagentWithInstructionId:(NSString *)instructionid;
/**
 *   根据试剂ID查询供应商
 *
 *  @return [SXQSupplier] 数组
 */
- (NSArray *)querySupplierWithReagetID:(NSString *)reagentID;
/**
 *  取出说明书数据
 */
- (void)fetchInstructionDataWithInstructionID:(NSString *)instructionId success:(void (^)(SXQInstructionData *instructionData))success;
/**
 *  添加实验
 */
- (void)addExpWithInstructionData:(SXQInstructionData *)instructionData completion:(void (^)(BOOL success,NSString *myExpId))completion;
/**
 *  根据我的实验ID获取正在我的实验
 *
 *  @param myExpId     我的实验ID
 */
- (void)loadCurrentDataWithMyExpId:(NSString *)myExpId completion:(void (^)(SXQCurrentExperimentData *currentExprimentData))completioin;
@end
