//
//  DWStepCell.h
//  实验助手
//
//  Created by sxq on 15/9/25.
//  Copyright © 2015年 SXQ. All rights reserved.
//
@class SXQExperimentStep;
#import <UIKit/UIKit.h>

@interface DWStepCell : UITableViewCell
@property (nonatomic,strong) SXQExperimentStep *expStep;
/**
 *  添加评论
 */
- (void)addRemark:(NSString *)remark;
- (void)addImage:(UIImage *)image;
@end
