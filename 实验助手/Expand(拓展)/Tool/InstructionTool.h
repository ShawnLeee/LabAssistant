//
//  InstructionTool.h
//  实验助手
//
//  Created by sxq on 15/9/21.
//  Copyright (c) 2015年 SXQ. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "SXQBaseResult.h"
@interface ExpCategoryResult : SXQBaseResult
@end
@interface ExpSubCategoryResult : SXQBaseResult
@end
@interface ExpInstructionsResult : SXQBaseResult
@end

@interface InstructionTool : NSObject
+ (void)fetchAllExpSuccess:(void (^)(ExpCategoryResult *result))success failure:(void (^)(NSError *error))failure;
+ (void)fetchSubCategoryWithCategoryId:(NSString *)categoryID success:(void (^)(ExpSubCategoryResult *result))success failure:(void (^)(NSError *error))failure;
+ (void)fetchInstructionLishWithExpSubCategoryID:(NSString *)subID success:(void (^)(ExpInstructionsResult *result))success failure:(void (^)(NSError *error))failure;
@end
