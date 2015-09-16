//
//  SXQNowExperimentController.m
//  实验助手
//
//  Created by sxq on 15/9/14.
//  Copyright (c) 2015年 SXQ. All rights reserved.
//
#define Identifier @"cell"
#import "ArrayDataSource+TableView.h"
#import "SXQCurrentExperimentController.h"
#import "SXQNowExperimentController.h"
#import "SXQExperimentModel.h"
#import "ExperimentTool.h"
@interface SXQNowExperimentController ()
@property (nonatomic,strong) ArrayDataSource *nowDataSource;
@end

@implementation SXQNowExperimentController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSelf];
    
}
- (void)setupSelf
{
    self.title = @"进行中";
    [self setupTableView];
    [self p_loadData];
}
- (void)p_loadData
{
    [ExperimentTool fetchNowExperimentWithParam:nil completion:^(NSArray *resultArray) {
        _nowDataSource.items = resultArray;
        [self.tableView reloadData];
    }];
}
- (void)setupTableView
{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:Identifier];
    _nowDataSource = [[ArrayDataSource alloc] initWithItems:@[] cellIdentifier:Identifier cellConfigureBlock:^(UITableViewCell *cell, SXQExperimentModel *model) {
        cell.textLabel.text = model.instructionName;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }];
    self.tableView.dataSource = _nowDataSource;
}
#pragma mark - TableView Delegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:[SXQCurrentExperimentController new] animated:YES];
}

@end
