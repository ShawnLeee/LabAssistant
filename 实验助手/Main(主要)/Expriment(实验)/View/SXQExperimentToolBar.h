//
//  SXQExperimentToolBar.h
//  实验助手
//
//  Created by sxq on 15/9/15.
//  Copyright (c) 2015年 SXQ. All rights reserved.
//
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, ExperimentTooBarButtonType)
{
    ExperimentTooBarButtonTypeStart = 0,
    ExperimentTooBarButtonTypePhoto = 4,
    ExperimentTooBarButtonTypeBack = 1,
    ExperimentTooBarButtonTypeReport = 3,
    ExperimentTooBarButtonTypeRemark = 2,
};
@class SXQExperimentToolBar;
@protocol SXQExperimentToolBarDelegate <NSObject>
@optional
- (void)experimentToolBar:(SXQExperimentToolBar *)toolBar clickButtonWithType:(ExperimentTooBarButtonType)buttonType;
@end

@interface SXQExperimentToolBar : UIView
@property (nonatomic,weak) id<SXQExperimentToolBarDelegate> delegate;
@end
