//
//  DWTimer.m
//  实验助手
//
//  Created by sxq on 15/9/28.
//  Copyright © 2015年 SXQ. All rights reserved.
//
#import "MZTimerLabel.h"
#import "DWTimer.h"
#import "TimeRecorder.h"
@interface DWTimer ()<TimeRecorderDelegate>
@property (weak, nonatomic) IBOutlet TimeRecorder *timeRecorder;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@end
@implementation DWTimer
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupContentView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupContentView];
    }
    return self;
}
- (void)setupContentView
{
    CGRect screenRect = [UIScreen mainScreen].bounds;
    self.frame = screenRect;
    [[NSBundle mainBundle] loadNibNamed:@"DWTimer" owner:self options:nil];
    _contentView.frame = self.frame;
    _contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    _timeRecorder.delegate = self;
    [self addSubview:_contentView];
}

+ (void)showTimer
{
    DWTimer *timer = [[DWTimer alloc] init];
    timer.frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:timer];
}
#pragma mark timer recorde delegate method
- (void)timeRecorderdidCancel:(TimeRecorder *)timeRecorder
{
    if ([self.delegate respondsToSelector:@selector(timerDidCancelled:confirmBlk:)]) {
        [self.delegate timerDidCancelled:self confirmBlk:^(BOOL confirmed) {
            if (confirmed) {
                [UIView animateWithDuration:0.5 animations:^{
                    _contentView.alpha = 0;
                    _timeRecorder.alpha = 0;
                } completion:^(BOOL finished) {
                    [self removeFromSuperview];
                }];            
            }else
            {
                [_timeRecorder.recordLabel start];
            }
        }];
    }
    
}
- (void)timeRecorderdidPaused:(TimeRecorder *)timeRecorder
{
    
}
- (void)timeRecorder:(TimeRecorder *)timeRecorder finishedTimerWithTime:(NSTimeInterval)countTime
{
    
}
@end
