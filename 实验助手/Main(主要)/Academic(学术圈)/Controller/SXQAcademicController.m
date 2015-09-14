//
//  SXQAcademicController.m
//  实验助手
//
//  Created by sxq on 15/9/14.
//  Copyright (c) 2015年 SXQ. All rights reserved.
//
#import "ArrayDataSource+TableView.h"
#import "DWGroup.h"
#import "SXQAcademicController.h"
#import "SXQReagentContoller.h"
@interface SXQAcademicController ()
@property (nonatomic,strong) ArrayDataSource *academicDataSource;
@property (nonatomic,strong) NSArray *academics;
@end

@implementation SXQAcademicController
- (NSArray *)academics
{
    if (_academics == nil) {
        DWGroup *group0 = [DWGroup groupWithItems:@[@"xxx",@"xxx",@"xxx",@"xxx"] identifier:@"cell" header:@"BBS交流"];
        group0.configureBlk = ^(UITableViewCell *cell,NSString *title){
            cell.textLabel.text = title;
        };
        
        DWGroup *group1 = [DWGroup groupWithItems:@[@"资讯资讯资讯资讯资讯资讯",@"资讯资讯资讯资讯资讯资讯",@"资讯资讯资讯资讯资讯资讯",] identifier:@"cell1" header:@"前沿资讯"];
        group1.configureBlk = group0.configureBlk;
        
        DWGroup *group2 = [DWGroup groupWithItems:@[@"交换一",@"交换一",@"交换一",@"交换一",] identifier:@"ssss" header:@"试剂交换"];
        group2.configureBlk = group0.configureBlk;
        _academics = @[group0,group1,group2];
    }
    return _academics;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSelf];
}
- (void)setupSelf
{
    self.title = @"学术圈";
    [self setupTableView];
}
- (void)setupTableView
{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell1"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ssss"];
    _academicDataSource = [[ArrayDataSource alloc] initWithGroups:self.academics];
    self.tableView.dataSource = _academicDataSource;
}
#pragma mark - TableView Delegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DWGroup *group = self.academics[indexPath.section];
    if ([group.headerTitle isEqualToString:@"试剂交换"]) {
        SXQReagentContoller *reagentVC = [SXQReagentContoller new];
        [self.navigationController pushViewController:reagentVC animated:YES];
    }
}
@end
