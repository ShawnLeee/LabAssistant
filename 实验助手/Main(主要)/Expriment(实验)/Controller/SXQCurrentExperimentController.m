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
@interface SXQCurrentExperimentController ()<UITableViewDelegate>
@property (weak, nonatomic) IBOutlet SXQExperimentToolBar *toolBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) ArrayDataSource *experimentDatasource;
@end

@implementation SXQCurrentExperimentController
- (void)viewDidLayoutSubviews
{
//    [_toolBar layoutIfNeeded];
    [_toolBar setNeedsUpdateConstraints];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _experimentDatasource = [[ArrayDataSource alloc] initWithItems:@[] cellIdentifier:nil cellConfigureBlock:nil];
    self.tableView.dataSource = _experimentDatasource;
}


@end
