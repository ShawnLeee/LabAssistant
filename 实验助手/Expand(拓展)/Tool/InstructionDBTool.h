//
//  InstructionDBTool.h
//  实验助手
//
//  Created by sxq on 15/9/24.
//  Copyright © 2015年 SXQ. All rights reserved.
//
#import <Foundation/Foundation.h>
typedef void (^CompletionBlock)(BOOL success,NSDictionary *info);
@interface InstructionDBTool : NSObject
+ (void)downloadInstruction:(NSDictionary *)instructionData completion:(CompletionBlock)completion;
@end
