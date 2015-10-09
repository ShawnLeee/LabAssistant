//
//  SXQReagentListController.m
//  实验助手
//
//  Created by sxq on 15/9/30.
//  Copyright © 2015年 SXQ. All rights reserved.
//
#import "SXQAddExpController.h"
#import "UIBarButtonItem+SXQ.h"
#import "FPPopoverController.h"
#import "SXQSupplierListController.h"
#import "SXQReagentListData.h"
#import "ArrayDataSource+TableView.h"
#import "SXQReagentListController.h"
#import "SXQExpReagent.h"
#import "SXQReagentCell.h"
#import "SXQSupplier.h"
#import "SXQHotInstruction.h"
#import "SXQMyGenericInstruction.h"
#define ReagentCellIdentifier @"Reagent Cell"

@interface SXQReagentListController ()<SXQReagentCellDelegate>
@property (nonatomic,strong) id instruction;
@property (nonatomic,strong) ArrayDataSource *reagentDataSource;
@property (nonatomic,strong) SXQReagentListData *reagentData;
@property (nonatomic,weak) FPPopoverController *popOver;
@end

@implementation SXQReagentListController
- (instancetype)initWithExpInstruction:(id)instruction
{
    if (self = [super init]) {
        _instruction = instruction;
        NSString *instructionID = nil;
        if ([_instruction isKindOfClass:[SXQHotInstruction class]]) {
            SXQHotInstruction *hotInstruction = (SXQHotInstruction *)_instruction;
            instructionID = hotInstruction.expInstructionID;
        }else
        {
            SXQMyGenericInstruction *genericInstruction = (SXQMyGenericInstruction *)_instruction;
            instructionID = genericInstruction.expInstructionID;
        }
        _reagentData = [[SXQReagentListData alloc] initWithExpInstructionID:instructionID DataLoadComletedBlock:^{
            _reagentDataSource.items = _reagentData.reagents;
            [self.tableView reloadData];
        }];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_setupTableView];
    [self setupNav];
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
- (void)showPopoverWithReagent:(SXQExpReagent *)reagent sender:(UIButton *)sender
{
    SXQSupplierListController *supplierVC = [[SXQSupplierListController alloc] initWithReagent:reagent supplierChoosedBlk:^(SXQSupplier *supplier) {
        [sender setTitle:supplier.supplierName forState:UIControlStateNormal];
        [_popOver dismissPopoverAnimated:YES];
    }];
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:supplierVC];
    _popOver = popover;
    popover.tint = FPPopoverDefaultTint;
    popover.arrowDirection = FPPopoverArrowDirectionAny;
    [popover presentPopoverFromView:sender];
}
#pragma mark reagentcell delegate method
- (void)reagentCell:(SXQReagentCell *)reagentCell clickedSupplierButton:(UIButton *)button
{
    [self showPopoverWithReagent:[self reagentForCell:reagentCell] sender:button];
}
#pragma mark setupNav
- (void)setupNav
{
    UIBarButtonItem *rightBarButton = [UIBarButtonItem itemWithTitle:@"下一步" action:^{
        SXQAddExpController *addExpController = [[SXQAddExpController alloc] init];
        [self.navigationController pushViewController:addExpController animated:YES];
    }];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}
@end
