//
//  SXQInstructionListController.m
//  实验助手
//
//  Created by sxq on 15/9/1.
//  Copyright (c) 2015年 SXQ. All rights reserved.
//
#import "SXQListCell.h"
#import "InstructionTool.h"
#import "SXQInstructionListController.h"
#import "SXQExpSubCategory.h"
#import "SXQExpInstruction.h"
#import "ArrayDataSource+TableView.h"
#define CellIdentifier @"List Cell"
@interface SXQInstructionListController ()<SXQListCellDelegate>
@property (nonatomic,strong) ArrayDataSource *instructionDataSource;
@property (nonatomic,strong) NSArray *instructions;
@end

@implementation SXQInstructionListController
- (instancetype)init
{
    if (self = [super init]) {
        _instructions = @[];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_setupTableView];
}
- (void)p_setupTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"SXQListCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    _instructionDataSource = [[ArrayDataSource alloc] initWithItems:_instructions cellIdentifier:CellIdentifier cellConfigureBlock:^(SXQListCell *cell, SXQExpInstruction *instruciton) {
        [cell configureCellWithItem:instruciton];
        cell.delegate = self;
    }];
    self.tableView.dataSource = _instructionDataSource;
}
- (void)setCategoryItem:(SXQExpSubCategory *)categoryItem
{
    _categoryItem = categoryItem;
    self.navigationItem.title = categoryItem.expSubCategoryName;
    [self p_loadDataWithCategoryItem:categoryItem];
}
- (void)p_loadDataWithCategoryItem:(SXQExpSubCategory *)item
{
    [InstructionTool fetchInstructionLishWithExpSubCategoryID:item.expSubCategoryID success:^(ExpInstructionsResult *result) {
        _instructionDataSource.items = result.data;
        _instructions = result.data;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 87;
}
- (void)listCell:(SXQListCell *)cell clickedDownloadBtn:(UIButton *)button
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    SXQExpInstruction *instruction = self.instructions[indexPath.row];
    [InstructionTool downloadInstructionWithID:instruction.expInstructionID success:^(id result) {
#warning 缓存说明书
    } failure:^(NSError *error) {
        
    }];
}
@end
