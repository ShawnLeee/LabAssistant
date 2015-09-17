//
//  DWInstructionController.m
//  实验助手
//
//  Created by sxq on 15/9/16.
//  Copyright (c) 2015年 SXQ. All rights reserved.
//
#define MJMenuWidth 100
#import "DWInstructionController.h"
#import "DWInstructionChildController.h"
#import "SXQMenuViewController.h"
#import "SXQColor.h"
#import "UIView+MJ.h"
#import "ArrayDataSource+CollectionView.h"
#import "SXQInstructionCell.h"
@interface DWInstructionController ()<UITableViewDelegate>
@property (nonatomic,assign) BOOL menuFold;
@property (nonatomic,weak) UICollectionView *centerView;
@property (nonatomic,strong) ArrayDataSource *collectionViewDataSource;
@property (nonatomic,strong) NSArray *instructions;
@end

@implementation DWInstructionController
- (NSArray *)instructions
{
    if (_instructions == nil) {
        _instructions = @[@"基因转染",@"基因转染",@"基因转染",@"基因转染",@"基因转染",@"基因转染",@"基因转染",@"基因转染",@"基因转染"];
    }
    return _instructions;
}
- (instancetype)init
{
    if (self = [super init]) {
        _menuFold = NO;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_setup];
}
- (void)p_setup
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [button addTarget:self action:@selector(menuButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    //初始化子控制器
    //1.左侧菜单
    SXQMenuViewController *menuVC = [SXQMenuViewController new];
    menuVC.view.width = MJMenuWidth;
    menuVC.view.y = 0;
    menuVC.view.height = self.view.frame.size.height;
    menuVC.tableView.delegate = self;
    [self.view addSubview:menuVC.view];
    [self addChildViewController:menuVC];
    
    //2.中间内容
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(80, 80);
    DWInstructionChildController *centerVC = [[DWInstructionChildController alloc] initWithCollectionViewLayout:layout];
    centerVC.collectionView.backgroundColor = MenuCellSelectedBgColor;
    centerVC.collectionView.frame = CGRectOffset(self.view.bounds, MJMenuWidth, 0);
    centerVC.collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [centerVC.collectionView registerNib:[UINib nibWithNibName:@"SXQInstructionCell" bundle:nil] forCellWithReuseIdentifier:@"SXQInstructionCell"];
    _collectionViewDataSource = [[ArrayDataSource alloc] initWithItems:self.instructions cellIdentifier:@"SXQInstructionCell" cellConfigureBlock:^(SXQInstructionCell *cell, NSString *instructionName) {
        cell.instructionNameLabel.text = instructionName;
    }];
    centerVC.collectionView.dataSource = _collectionViewDataSource;
    [self.view addSubview:centerVC.collectionView];
    _centerView = centerVC.collectionView;
    [self addChildViewController:centerVC];
    
    // 2.监听手势
    [_centerView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragView:)]];
}
- (void)dragView:(UIPanGestureRecognizer *)panGesture
{
    CGPoint point = [panGesture translationInView:panGesture.view];
    //Drag ended.
    if (panGesture.state == UIGestureRecognizerStateCancelled || panGesture.state == UIGestureRecognizerStateEnded) {
        if (panGesture.view.x <= MJMenuWidth * 0.5) {//往左边走动至少一半
            [self p_foldMenu];
        }else
        {
            [self p_unfoldMenu];
        }
    }else//while draging
    {
        panGesture.view.transform = CGAffineTransformTranslate(panGesture.view.transform, point.x, 0);
        [panGesture setTranslation:CGPointZero inView:panGesture.view];
        if (panGesture.view.x <= 0) {
            panGesture.view.transform = CGAffineTransformMakeTranslation(-MJMenuWidth, 0);
        }else if(panGesture.view.x >= MJMenuWidth)
        {
            panGesture.view.transform = CGAffineTransformIdentity;
        }
    }
}
- (void)menuButtonClicked
{
    if (_menuFold) {
        [self p_unfoldMenu];
    }else
    {
        [self p_foldMenu];
    }
}
#pragma mark - Private Method
- (void)p_foldMenu
{
    [UIView animateWithDuration:0.5 animations:^{
         _centerView.transform = CGAffineTransformMakeTranslation(-MJMenuWidth, 0);
    }];
    _menuFold = !_menuFold;
}
- (void)p_unfoldMenu
{
    [UIView animateWithDuration:0.5 animations:^{
        _centerView.transform = CGAffineTransformIdentity;
    }];
    _menuFold = !_menuFold;
}
#pragma mark TableView Delegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _collectionViewDataSource.items = @[@"DNA测序",@"DNA测序",@"DNA测序",@"DNA测序",@"DNA测序",@"DNA测序",@"DNA测序",@"DNA测序",@"DNA测序",@"DNA测序",@"DNA测序",@"DNA测序"];
    [_centerView reloadData];
    
}
@end
