//
//  SXQExpStep.h
//  实验助手
//
//  Created by sxq on 15/10/9.
//  Copyright © 2015年 SXQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SXQExpStep : NSObject
@property (nonatomic,copy) NSString  *expInstructionID;
@property (nonatomic,copy) NSString  *expStepDesc;
@property (nonatomic,copy) NSString  *expStepID;
@property (nonatomic,copy) NSString  *expStepTime;
@property (nonatomic,assign) int  stepNum;
@end
