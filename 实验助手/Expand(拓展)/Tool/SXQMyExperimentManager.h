//
//  SXQMyExperimentManager.h
//  实验助手
//
//  Created by sxq on 15/9/25.
//  Copyright © 2015年 SXQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SXQMyExperimentManager : NSObject
/**
 *  写一条备注到对应步骤
 */
- (void)writeRemak:(NSString *)remark toExperiment:(NSString *)myExpID expStepID:(NSString *)expStepID;
@end
