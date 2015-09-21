//
//  InstructionTool.m
//  实验助手
//
//  Created by sxq on 15/9/21.
//  Copyright (c) 2015年 SXQ. All rights reserved.
//
#import "SXQHttpTool.h"
#import "SXQURL.h"
#import <MJExtension/MJExtension.h>
#import "InstructionTool.h"
#import "SXQExpCategory.h"
#import "SXQExpSubCategory.h"
#import "SXQExpInstruction.h"
@implementation InstructionTool
+ (void)fetchAllExpSuccess:(void (^)(ExpCategoryResult *))success failure:(void (^)(NSError *))failure
{
    [SXQHttpTool getWithURL:AllExpURL params:nil success:^(id json) {
        if (success) {
            ExpCategoryResult *result = [ExpCategoryResult objectWithKeyValues:json];
            success(result);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)fetchSubCategoryWithCategoryId:(NSString *)categoryID success:(void (^)(ExpSubCategoryResult *))success failure:(void (^)(NSError *))failure
{
    NSDictionary *param = @{@"expCategoryID" : categoryID};
    [SXQHttpTool getWithURL:SubExpURL params:param success:^(id json) {
        if (success) {
            ExpSubCategoryResult *result = [ExpSubCategoryResult objectWithKeyValues:json];
            success(result);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
+ (void)fetchInstructionLishWithExpSubCategoryID:(NSString *)subID success:(void (^)(ExpInstructionsResult *))success failure:(void (^)(NSError *))failure
{
    NSDictionary *param = @{@"expSubCategoryID" : subID};
    [SXQHttpTool getWithURL:InstructionListURL params:param success:^(id json) {
        if (success) {
            ExpInstructionsResult *result = [ExpInstructionsResult objectWithKeyValues:json];
            success(result);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end

@implementation ExpCategoryResult
+ (NSDictionary *)objectClassInArray
{
    return @{@"data" : [SXQExpCategory class]};
}
@end

@implementation ExpSubCategoryResult
+ (NSDictionary *)objectClassInArray
{
    return @{@"data" : [SXQExpSubCategory class]};
}
@end

@implementation ExpInstructionsResult
+ (NSDictionary *)objectClassInArray
{
    return @{@"data" : [SXQExpInstruction class]};
}
@end