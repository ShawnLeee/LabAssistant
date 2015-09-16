//
//  SXQDoneExperimentController.m
//  实验助手
//
//  Created by sxq on 15/9/14.
//  Copyright (c) 2015年 SXQ. All rights reserved.
//
#import "ArrayDataSource+TableView.h"
#import "SXQDoneExperimentController.h"
#import "SXQExperimentModel.h"
#import "ExperimentTool.h"
@interface SXQDoneExperimentController ()
@property (nonatomic,strong) ArrayDataSource *dataSource;
@end

@implementation SXQDoneExperimentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self p_setupTable];
    [self p_loadData];
    
}
- (void)p_loadData
{
    [ExperimentTool fetchDoneExperimentWithParam:nil completion:^(NSArray *resultArray) {
        _dataSource.items = resultArray;
        [self.tableView reloadData];
    }];
}
- (void)p_setupTable
{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _dataSource = [[ArrayDataSource alloc] initWithItems:@[] cellIdentifier:@"cell" cellConfigureBlock:^(UITableViewCell *cell, SXQExperimentModel *experimentModel) {
        cell.textLabel.text = experimentModel.instructionName;
    }];
    self.tableView.dataSource = _dataSource;
}


@end
