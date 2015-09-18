//
//  SXQCurrentExperimentController.m
//  实验助手
//
//  Created by sxq on 15/9/15.
//  Copyright (c) 2015年 SXQ. All rights reserved.
//

#import "SXQCurrentExperimentController.h"
#import "SXQExperimentToolBar.h"
#import "ArrayDataSource+TableView.h"
#import "SXQExperimentModel.h"
#import "SXQExperimentStep.h"
#import "SXQStepCell.h"
#import "ExperimentTool.h"
@interface SXQCurrentExperimentController ()<UITableViewDelegate>
@property (weak, nonatomic) IBOutlet SXQExperimentToolBar *toolBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) ArrayDataSource *experimentDatasource;
@property (weak, nonatomic) IBOutlet UILabel *experimentName;

@property (nonatomic,strong) NSArray *steps;
@property (nonatomic,strong) ArrayDataSource *stepsDataSource;
@end

@implementation SXQCurrentExperimentController
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
}
- (void)viewDidLoad {
    [super viewDidLoad];
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
    SXQExperimentToolBar *toolBar = [[SXQExperimentToolBar alloc] init];
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
    [ExperimentTool fetchExperimentStepWithParam:param success:^(FetchStepResult *result) {
        self.steps = result.steps;
        _stepsDataSource.items = result.steps;
        _experimentName.text = result.experimentName;
        [self.tableView reloadData];  
    } failure:^(NSError *error) {
        
    }];
}

@end
