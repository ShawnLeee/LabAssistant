//
//  SXQMenuViewController.m
//  实验助手
//
//  Created by sxq on 15/9/16.
//  Copyright (c) 2015年 SXQ. All rights reserved.
//

#import "SXQMenuViewController.h"
#import "ArrayDataSource+TableView.h"
#import "SXQMenuCell.h"
#import "SXQColor.h"
#define Identifier @"SXQMenuCell"
@interface SXQMenuViewController ()
@property (nonatomic,strong) ArrayDataSource *menuDataSource;
@end

@implementation SXQMenuViewController
- (instancetype)init{
    if (self = [super init] ) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = MenuCellBgColor;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_setupTableView];
}

- (void)p_setupTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"SXQMenuCell" bundle:nil] forCellReuseIdentifier:Identifier];
    _menuDataSource = [[ArrayDataSource alloc] initWithItems:@[@"DNA实验",@"DNA实验",@"DNA实验",@"DNA实验",@"DNA实验",@"DNA实验",@"DNA实验"] cellIdentifier:Identifier  cellConfigureBlock:^(SXQMenuCell *cell, NSString *title) {
        cell.itemTitle.text = title;
    }];
    self.tableView.dataSource = _menuDataSource;
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    SXQMenuCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    //发送请求
//}
@end
