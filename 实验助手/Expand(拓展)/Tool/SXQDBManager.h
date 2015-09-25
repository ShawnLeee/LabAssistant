//
//  SXQDBManager.h
//  实验助手
//
//  Created by sxq on 15/9/25.
//  Copyright © 2015年 SXQ. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void  (^CompletionHandler)(BOOL success,NSDictionary *info);
@interface SXQDBManager : NSObject
+ (instancetype)sharedManager;
- (void)insertInstruciton:(id)instruction completion:(CompletionHandler)completion;
@end
