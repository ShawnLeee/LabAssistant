//
//  TimeRecorder.m
//  TimeMachine
//
//  Created by sxq on 15/9/21.
//  Copyright (c) 2015年 sxq. All rights reserved.
//
#import "MZTimerLabel.h"
#import "TimeRecorder.h"
@interface TimeRecorder ()<MZTimerLabelDelegate>
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic,assign) BOOL isCounting;
@end
@implementation TimeRecorder
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self p_loadNibFile];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self p_loadNibFile];
    }
    return self;
}
- (void)p_loadNibFile
{
    [[NSBundle mainBundle] loadNibNamed:@"TimeRecorder" owner:self options:nil];
    
    //初始化timealbel
    _recordLabel = [[MZTimerLabel alloc] initWithLabel:_timeLabel andTimerType:MZTimerLabelTypeTimer];
    _recordLabel.delegate = self;
    
    _isCounting = NO;
    _datePicker.hidden = NO;
    _timeLabel.hidden = YES;
    _pauseButton.enabled = _isCounting;
    
    _timeRecorderView.frame = self.frame;
    _datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    [self addSubview:_timeRecorderView]; 
}
- (IBAction)starBtnClicked:(UIButton *)sender {
    if (_isCounting) {//正在计时,即需要点击取消计时
        
        //隐藏计时器,显示时间选择
//        _timeLabel.hidden = YES;
//        _datePicker.hidden = NO;
        //重置计时器
//        [self resetTimer];
        [_recordLabel pause];
        if ([self.delegate respondsToSelector:@selector(timeRecorderdidCancel:)]) {
            [self.delegate timeRecorderdidCancel:self];
        }
    }else//没有计时
    {
        //显示计时器,隐藏时间选择
        _timeLabel.hidden = NO;
        _datePicker.hidden = YES;
        //开始计时
        [self startTimeRecordWithTime:_datePicker.countDownDuration];
        
    }
    NSString *buttonTitle = _isCounting ? @"开始计时" : @"取消";
    [_startButton setTitle:buttonTitle forState:UIControlStateNormal];
    _isCounting = !_isCounting;
    _pauseButton.enabled = _isCounting;
}
- (IBAction)pauseBtnClicked:(UIButton *)sender {
    NSString *pauseTitle = nil;
    if (_isCounting) {//正在计时
        //暂停计时器
        [_recordLabel pause];
        pauseTitle = @"继续";
        if ([self.delegate respondsToSelector:@selector(timeRecorderdidPaused:)]) {
            [self.delegate timeRecorderdidPaused:self];
        }
    }else
    {
        [_recordLabel start];
        pauseTitle = @"暂停";
    }
    [_pauseButton setTitle:pauseTitle forState:UIControlStateNormal];
    _isCounting = !_isCounting;
}
- (void)startTimeRecordWithTime:(NSTimeInterval)times
{
    [_recordLabel setCountDownTime:times];
    [_recordLabel start];
}
/**
 *  重置计时器
 */
- (void)resetTimer
{
    [_recordLabel reset];
}
- (void)timerLabel:(MZTimerLabel *)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime
{
    if ([self.delegate respondsToSelector:@selector(timeRecorder:finishedTimerWithTime:)]) {
        [self.delegate timeRecorder:self finishedTimerWithTime:countTime];
    }
}
- (void)updateConstraints
{
    [super updateConstraints];
    self.timeRecorderView.frame = self.bounds;
}
@end
