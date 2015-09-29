//
//  SXQMyInstructionsController.m
//  实验助手
//
//  Created by sxq on 15/9/15.
//  Copyright (c) 2015年 SXQ. All rights reserved.
//
#import "ArrayDataSource+TableView.h"
#import "SXQMyInstructionsController.h"
#import "DWGroup.h"
#import "SXQMyInstructionCell.h"
#import "SXQInstructionManager.h"
#import "SXQMyGenericInstruction.h"
#define MyInstructionIdentifier @"SXQMyInstructionCell"

@interface SXQMyInstructionsController ()
@property (nonatomic,strong) NSArray *groups;
@property (nonatomic,strong) ArrayDataSource *instructionsDataSource;
@end

@implementation SXQMyInstructionsController
- (NSArray *)groups
{
    if (_groups == nil) {
        NSArray *arr = [SXQInstructionManager fetchAllInstruction];
        DWGroup *group0 = [DWGroup groupWithItems:arr identifier:MyInstructionIdentifier header:@"我的常用说明书"];
        group0.configureBlk = ^(SXQMyInstructionCell *cell,SXQMyGenericInstruction *item){
            [cell configureCellForItem:item];
        };
        _groups = @[group0];
    }
    return _groups;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_setupSelf];
}
#pragma mark - Private Method
- (void)p_setupSelf
{
    self.title = @"我的常用说明书";
    [self p_setupTableView];
}
- (void)p_setupTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"SXQMyInstructionCell" bundle:nil] forCellReuseIdentifier:MyInstructionIdentifier];
    _instructionsDataSource = [[ArrayDataSource alloc] initWithGroups:self.groups];
    self.tableView.dataSource = _instructionsDataSource;
}
@end
