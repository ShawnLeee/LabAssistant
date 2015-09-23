//
//  DWInstructionActionView.m
//  实验助手
//
//  Created by sxq on 15/9/23.
//  Copyright © 2015年 SXQ. All rights reserved.
//

#import "DWInstructionActionView.h"
@interface DWInstructionActionView ()
@property (strong, nonatomic) IBOutlet UIView *view;

@end
@implementation DWInstructionActionView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setuSelf];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setuSelf];
    }
    return self;
}
- (void)setuSelf
{
    [[NSBundle mainBundle] loadNibNamed:@"DWInstructionActionView" owner:self options:nil];
    _view.frame = self.bounds;
    _view.backgroundColor = [UIColor purpleColor];
    [self addSubview:_view];
}

@end
