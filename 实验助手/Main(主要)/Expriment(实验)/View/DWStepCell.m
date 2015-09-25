//
//  DWStepCell.m
//  实验助手
//
//  Created by sxq on 15/9/25.
//  Copyright © 2015年 SXQ. All rights reserved.
//

#import "DWStepCell.h"
#import "SXQExperimentStep.h"
@interface DWStepCell ()
@property (weak, nonatomic) IBOutlet UILabel *stepLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepContentLabel;
@property (weak, nonatomic) IBOutlet UIStackView *imageContainer;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@end
@implementation DWStepCell

- (void)setExpStep:(SXQExperimentStep *)expStep
{
    _expStep = expStep;
    
    _stepLabel.text= expStep.stepNum;
    _stepContentLabel.text = expStep.stepDesc;
}
- (void)addRemark:(NSString *)remark
{
    _remarkLabel.text = remark;
}
@end
