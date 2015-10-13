//
//  DWStepCell.m
//  实验助手
//
//  Created by sxq on 15/9/25.
//  Copyright © 2015年 SXQ. All rights reserved.
//

#import "DWStepCell.h"
#import "SXQExperimentStep.h"
#import "UIImage+Size.h"
#import "PhotoContainer.h"
#import "SXQExpStep.h"
@interface DWStepCell ()
@property (weak, nonatomic) IBOutlet UILabel *stepLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepContentLabel;
@property (weak, nonatomic) IBOutlet PhotoContainer *photoContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconHeightConst;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@end
@implementation DWStepCell
- (void)setExpProcess:(SXQExpStep *)expProcess
{
    
}
- (void)setExpStep:(SXQExperimentStep *)expStep
{
    _expStep = expStep;
    
    _stepLabel.text= expStep.stepNum;
    _stepContentLabel.text = expStep.stepDesc;
    _remarkLabel.text = expStep.remark;
    _iconHeightConst.constant = expStep.imageHeight;
    
}
- (void)addRemark:(NSString *)remark
{
    _remarkLabel.text = remark;
}
- (void)addImage:(UIImage *)image
{
    CGFloat padding = 8;
    _iconHeightConst.constant = [image imageHeightConstraintToWidth:([UIScreen mainScreen].bounds.size.width - 2 * padding)];
    [_photoContainer addPhoto:image updatesConstraintBlk:^(BOOL success, CGFloat photoHeight) {
        if (success) {
            _iconHeightConst.constant = photoHeight;
            _expStep.imageHeight = photoHeight;
        }else
        {
            
        }
    }];
}
@end
