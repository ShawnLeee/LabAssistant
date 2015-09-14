//
//  SXQNowExperimentController.m
//  实验助手
//
//  Created by sxq on 15/9/14.
//  Copyright (c) 2015年 SXQ. All rights reserved.
//
#define Identifier @"cell"
#import "ArrayDataSource+TableView.h"
#import "SXQNowExperimentController.h"
#import "SXQExperimentDetailController.h"
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
}
- (void)setupTableView
{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:Identifier];
    _nowDataSource = [[ArrayDataSource alloc] initWithItems:@[@"实验一",@"实验二",@"实验三"] cellIdentifier:Identifier cellConfigureBlock:^(UITableViewCell *cell, NSString *title) {
        cell.textLabel.text = title;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }];
    self.tableView.dataSource = _nowDataSource;
}
#pragma mark - TableView Delegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:[SXQExperimentDetailController new] animated:YES];
}

@end
