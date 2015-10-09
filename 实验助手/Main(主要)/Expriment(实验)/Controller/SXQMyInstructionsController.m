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
#import "DWMyInstructionData.h"
#import "SXQReagentListController.h"
#import "SXQHotInstruction.h"
#import "SXQMyExperimentManager.h"
typedef NS_ENUM(NSUInteger,SectionType){
    SectionTypeMyInstructionType = 0,
    SectionTypeHotInstructionType = 1,
};
@interface SXQMyInstructionsController ()
@property (nonatomic,strong) NSArray *groups;
@property (nonatomic,strong) ArrayDataSource *instructionsDataSource;
@end

@implementation SXQMyInstructionsController
- (NSArray *)groups
{
    if (_groups == nil) {
        DWMyInstructionData *instructionData = [[DWMyInstructionData alloc] init];
        instructionData.dataLoadCompletedBlk = ^{
            [self.tableView reloadData];
        };
        _groups = instructionData.groups;
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
    [self.tableView registerNib:[UINib nibWithNibName:@"SXQHotInstructionCell" bundle:nil] forCellReuseIdentifier:HotInstructionIdentifier];
    _instructionsDataSource = [[ArrayDataSource alloc] initWithGroups:self.groups];
    self.tableView.dataSource = _instructionsDataSource;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
#pragma mark tableview delegate method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SectionTypeHotInstructionType) {
        DWGroup *group = self.groups[indexPath.section];
        SXQHotInstruction *instruction = group.items[indexPath.row];
        //检查/下载说明书
        SXQReagentListController *listVC = [[SXQReagentListController alloc] initWithExpInstruction:instruction];
        [self.navigationController pushViewController:listVC animated:YES];
    }else
    {
        DWGroup *group = self.groups[indexPath.section];
        SXQMyGenericInstruction *genericInstruciton = group.items[indexPath.row];
        [SXQMyExperimentManager addExperimentWithInstructionId:genericInstruciton.expInstructionID];
    }
}
@end












