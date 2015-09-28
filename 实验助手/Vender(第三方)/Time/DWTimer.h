//
//  DWTimer.h
//  实验助手
//
//  Created by sxq on 15/9/28.
//  Copyright © 2015年 SXQ. All rights reserved.
//
@import UIKit;
@class DWTimer;
@protocol DWTimerDelegate <NSObject>
@optional
- (void)timerDidPaused:(DWTimer *)timer;
- (void)timerDidCancelled:(DWTimer *)timer confirmBlk:(void (^)(BOOL confirmed))comfirmBlk;
- (void)timer:(DWTimer *)timer finishedWithTime:(NSTimeInterval)time;
@end
@interface DWTimer : UIView
+ (void)showTimer;
@property (nonatomic,weak) id<DWTimerDelegate> delegate;
@end
