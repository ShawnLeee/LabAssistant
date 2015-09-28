//
//  SXQInstructionManager.h
//  实验助手
//
//  Created by sxq on 15/9/25.
//  Copyright © 2015年 SXQ. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^CompletionHandler)(BOOL success,NSDictionary *info);
@interface SXQInstructionManager : NSObject
/**
 *  下载实验说明书
 */
- (void)downloadInstruction:(id)instruction completion:(CompletionHandler)completion;
/**
 *  查询说明书是否下载
 */
+ (BOOL)instructionIsdownload:(NSString *)instrucitonID;
@end
