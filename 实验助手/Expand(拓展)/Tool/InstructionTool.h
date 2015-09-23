//
//  InstructionTool.h
//  实验助手
//
//  Created by sxq on 15/9/21.
//  Copyright (c) 2015年 SXQ. All rights reserved.
//
@class SXQInstructionDetail;
#import <Foundation/Foundation.h>
#import "SXQBaseResult.h"
@interface ExpCategoryResult : SXQBaseResult
@end
@interface ExpSubCategoryResult : SXQBaseResult
@end
@interface ExpInstructionsResult : SXQBaseResult
@end

@interface InstructionDetailResult : NSObject
@property (nonatomic,copy) NSString *code;
@property (nonatomic,strong) SXQInstructionDetail *data;
@property (nonatomic,copy) NSString *msg;
@end

@interface InstructionDetailParam : NSObject
@property (nonatomic,copy) NSString *expInstructionID;
@property (nonatomic,copy) NSString *userID;
@end
@interface InstructionTool : NSObject
+ (void)fetchAllExpSuccess:(void (^)(ExpCategoryResult *result))success failure:(void (^)(NSError *error))failure;

+ (void)fetchSubCategoryWithCategoryId:(NSString *)categoryID success:(void (^)(ExpSubCategoryResult *result))success failure:(void (^)(NSError *error))failure;

+ (void)fetchInstructionLishWithExpSubCategoryID:(NSString *)subID success:(void (^)(ExpInstructionsResult *result))success failure:(void (^)(NSError *error))failure;

+ (void)downloadInstructionWithID:(NSString *)instructionID success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;

+ (void)fetchInstructionDetailWithParam:(InstructionDetailParam *)param success:(void (^)(InstructionDetailResult *result))success failure:(void (^)(NSError *error))failure;
@end

