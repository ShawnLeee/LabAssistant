//
//  SXQInstructionController.m
//  实验助手
//
//  Created by SXQ on 15/8/30.
//  Copyright (c) 2015年 SXQ. All rights reserved.
//
#import "SXQInstructionHeader.h"
#import "SXQInstructionController.h"
#import "SXQGroup.h"
#import "SXQGroupCell.h"
#import "SXQAllInstructionController.h"
#import "SXQInstructionListController.h"
@interface SXQInstructionController ()<SXQInstructionHeaderDelegate,SXQGroupCellDelegate>
@property (nonatomic,strong) NSArray *groups;
@end

@implementation SXQInstructionController
- (NSArray *)groups
{
    if (!_groups) {
        SXQGroup *group1 = [SXQGroup groupWithGroupTitle:@"DNA实验" items:@[@"DNA酶切",@"定点突变",@"DNA纯化",@"基因转染",@"比较基因"]];
        SXQGroup *group2 = [SXQGroup groupWithGroupTitle:@"生物化学" items:@[@"DNA酶切",@"定点突变",@"DNA纯化",@"基因转染",@"比较基因"]];
        SXQGroup *group3 = [SXQGroup groupWithGroupTitle:@"RNA实验" items:@[@"DNA酶切",@"定点突变",@"DNA纯化",@"基因转染",@"比较基因"]];
        SXQGroup *group4 = [SXQGroup groupWithGroupTitle:@"DNA重组" items:@[@"DNA酶切",@"定点突变",@"DNA纯化",@"基因转染",@"比较基因"]];
        _groups = @[group1,group2,group3,group4];
    }
    return _groups;
}
- (instancetype)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}
- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:UITableViewStyleGrouped];
}
//- (instancetype)initWithCoder:(NSCoder *)aDecoder
//{
//    return [super initWithStyle:UITableViewStyleGrouped];
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[SXQGroupCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[SXQInstructionHeader class] forHeaderFooterViewReuseIdentifier:@"header"];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SXQGroup *group = self.groups[indexPath.section];
    
    SXQGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.items = group.items;
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SXQGroup *group = self.groups[section];
    SXQInstructionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    header.delegate = self;
    header.groupTitle = group.groupTitle;
    return header;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}
#pragma mark - Header delegate method 
- (void)didSelectedInstructionHeader:(SXQInstructionHeader *)header
{
    SXQAllInstructionController *allVC = [[SXQAllInstructionController alloc] initWithCollectionViewLayout:[UICollectionViewFlowLayout new]];
    [self.navigationController pushViewController:allVC animated:YES];
}
#pragma mark - cell Delegate
- (void)groupCell:(SXQGroupCell *)cell selectedItem:(id)item
{
    [self.navigationController pushViewController:[SXQInstructionListController new] animated:YES];
}
@end

