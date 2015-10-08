//
//  SXQReagentListController.m
//  实验助手
//
//  Created by sxq on 15/9/30.
//  Copyright © 2015年 SXQ. All rights reserved.
//

#import "FPPopoverController.h"
#import "SXQSupplierListController.h"

#import "SXQReagentListData.h"
#import "ArrayDataSource+TableView.h"
#import "SXQReagentListController.h"
#import "SXQExpReagent.h"
#import "SXQReagentCell.h"
#define ReagentCellIdentifier @"Reagent Cell"

@interface SXQReagentListController ()<SXQReagentCellDelegate>
@property (nonatomic,copy) NSString *expId;
@property (nonatomic,strong) ArrayDataSource *reagentDataSource;
@property (nonatomic,strong) SXQReagentListData *reagentData;
@end

@implementation SXQReagentListController

- (instancetype)initWithExpInstructionID:(NSString *)expId
{
    if (self = [super init]) {
        _expId = expId;
        _reagentData = [[SXQReagentListData alloc] initWithExpInstructionID:_expId DataLoadComletedBlock:^{
            _reagentDataSource.items = _reagentData.reagents;
            [self.tableView reloadData];
        }];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_setupTableView];
}
- (void)p_setupTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"SXQReagentCell" bundle:nil] forCellReuseIdentifier:ReagentCellIdentifier];
    
    _reagentDataSource= [[ArrayDataSource alloc] initWithItems:_reagentData.reagents cellIdentifier:ReagentCellIdentifier cellConfigureBlock:^(SXQReagentCell *cell, SXQExpReagent *reagent) {
        cell.delegate = self;
        [cell configureCellWithItem:reagent];
    }];
    self.tableView.dataSource = _reagentDataSource;
}
- (SXQExpReagent *)reagentForCell:(SXQReagentCell *)cell
{
    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
    return _reagentData.reagents[indexpath.row];
}
- (void)showPopoverWithReagent:(SXQExpReagent *)reagent sender:(id)sender
{
    SXQSupplierListController *supplierVC = [SXQSupplierListController new];
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:supplierVC];
    popover.tint = FPPopoverDefaultTint;
    popover.arrowDirection = FPPopoverArrowDirectionAny;
    [popover presentPopoverFromView:sender];
}
#pragma mark reagentcell delegate method
- (void)reagentCell:(SXQReagentCell *)reagentCell clickedSupplierButton:(UIButton *)button
{
    [self showPopoverWithReagent:[self reagentForCell:reagentCell] sender:button];
}

@end
