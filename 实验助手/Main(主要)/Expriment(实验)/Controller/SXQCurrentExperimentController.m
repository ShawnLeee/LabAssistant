//
//  SXQCurrentExperimentController.m
//  实验助手
//
//  Created by sxq on 15/9/15.
//  Copyright (c) 2015年 SXQ. All rights reserved.
//
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "SXQCurrentExperimentController.h"
#import "SXQExperimentToolBar.h"
#import "ArrayDataSource+TableView.h"
#import "SXQExperimentModel.h"
#import "SXQExperimentStep.h"
#import "SXQStepCell.h"
#import "ExperimentTool.h"
#import "SXQExperimentStepResult.h"
#import "SXQExperiment.h"
#import "TimeRecorder.h"

@interface SXQCurrentExperimentController ()<UITableViewDelegate,SXQExperimentToolBarDelegate,TimeRecorderDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,assign) BOOL showingTimer;
@property (weak, nonatomic) IBOutlet SXQExperimentToolBar *toolBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) ArrayDataSource *experimentDatasource;
@property (weak, nonatomic) IBOutlet UILabel *experimentName;
@property (weak, nonatomic) IBOutlet TimeRecorder *timeRecorder;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timerHeightConst;

@property (nonatomic,strong) NSArray *steps;
@property (nonatomic,strong) ArrayDataSource *stepsDataSource;
@end

@implementation SXQCurrentExperimentController
- (instancetype)init
{
    if (self = [super init]) {
        _showingTimer = NO;
    }
    return self;
}

- (NSArray *)steps
{
    if (!_steps) {
        _steps = @[];
    }
    return _steps;
}
- (void)viewDidLayoutSubviews
{
    [_toolBar setNeedsUpdateConstraints];
    [_timeRecorder setNeedsUpdateConstraints];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     _timeRecorder.alpha = 0;
    [self p_setupSelf];
    [self p_setupTableView];
    
}
- (void)p_setupTableView
{
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SXQStepCell" bundle:nil] forCellReuseIdentifier:@"SXQStepCell"];
    _stepsDataSource = [[ArrayDataSource alloc] initWithItems:self.steps cellIdentifier:@"SXQStepCell" cellConfigureBlock:^(SXQStepCell *cell, SXQExperimentStep *stepModel) {
        [cell configureCellWithModel:stepModel];
    }];
    self.tableView.dataSource = _stepsDataSource;
    [self p_setupTableFooter];
}

- (void)p_setupTableFooter
{
    _timeRecorder.delegate = self;
    SXQExperimentToolBar *toolBar = [[SXQExperimentToolBar alloc] init];
    toolBar.delegate = self;
    [self.view addSubview:toolBar];
    _toolBar = toolBar;
    toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self layoutToolBar];
    
}
- (void)layoutToolBar
{
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_toolBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_toolBar attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_toolBar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_toolBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44]];
}
- (void)p_setupSelf
{
    self.navigationItem.title = @"实验步骤说明";
}
- (void)setExperimentModel:(SXQExperimentModel *)experimentModel
{
    _experimentModel = experimentModel;
    ExperimentParam *param = [ExperimentParam paramWithExperimentModel:experimentModel];
    param.userID = @"";
    [ExperimentTool fetchExperimentStepWithParam:param success:^(SXQExperimentStepResult *result) {
        _stepsDataSource.items = result.data.steps;
        _experimentName.text = result.data.experimentName;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
    
}
- (void)experimentToolBar:(SXQExperimentToolBar *)toolBar clickButtonWithType:(ExperimentTooBarButtonType)buttonType
{
    switch (buttonType) {
            case ExperimentTooBarButtonTypeBack:
            break;
            
            case ExperimentTooBarButtonTypePhoto:
            [self choosePhotoOrigin];
            break;
            
            case ExperimentTooBarButtonTypeStart:
            {//启动/暂停定时器
                [self showTimerRecorder];
                break;
            }
            case ExperimentTooBarButtonTypeRemark:
            break;
            
            case ExperimentTooBarButtonTypeReport:
            [self choosePhotoOrigin];
            break;
    }
}
- (void)choosePhotoOrigin
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:nil
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"从相册选择",@"拍一张", nil];
    [actionSheet.rac_buttonClickedSignal subscribeNext:^(NSNumber *index) {
        switch ([index integerValue]) {
            case 0:
                //从相册选择
                [self openPhotoLibrary];
                break;
            case 1:
                //拍一张
                [self openCamera];
                break;
        }
    }];
    [actionSheet showInView:self.view];
}
/**
 *  打开相机
 */
- (void)openCamera
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}
/**
 *  打开相册
 */
- (void)openPhotoLibrary
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}
- (void)timeRecorderdidPaused:(TimeRecorder *)timeRecorder
{
    
}
- (void)timeRecorder:(TimeRecorder *)timeRecorder finishedTimerWithTime:(NSTimeInterval)countTime
{
    
}
- (void)showTimerRecorder
{
    if (_showingTimer) {
        _tableView.userInteractionEnabled = YES;
     [UIView animateWithDuration:0.5 animations:^{
         _timeRecorder.alpha = 0;
     }];
    }else
    {
        _tableView.userInteractionEnabled = NO;
     [UIView animateWithDuration:0.5 animations:^{
         _timeRecorder.alpha = 1;
     }];
    }
    _showingTimer = !_showingTimer;
}
- (void)doTimerAnimation
{
    [UIView animateWithDuration:0.5 animations:^{
        _timeRecorder.hidden = !_timeRecorder.hidden;
        [_timeRecorder layoutIfNeeded];
    }];
}
@end