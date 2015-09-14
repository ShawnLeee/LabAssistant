//
//  SXQAllInstructionController.m
//  实验助手
//
//  Created by SXQ on 15/8/30.
//  Copyright (c) 2015年 SXQ. All rights reserved.
//

#import "SXQAllInstructionController.h"
#import "SXQInstrutionCell.h"
#import "ArrayDataSource+CollectionView.h"

static NSString *CollectionViewIdentier = @"Instrution Cell";

@interface SXQAllInstructionController ()<UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) ArrayDataSource *collectionViewDataSource;
@property (nonatomic,strong) NSArray *items;
@end

@implementation SXQAllInstructionController
- (NSArray *)items
{
    if (!_items) {
        _items = @[@"DNA酶切",@"基因转染",@"DNA染色",@"DNA测序",@"DNA纯化",@"定点突变",@"DNA制备",
                   @"比较基因",@"功能基因",@"甲基化",@"结构基因",@"DNA重组",@"DNA标记",@"质粒",@"原位杂交",@"含量测定",@"DNA酶切",@"基因转染",@"DNA染色",@"DNA测序"];
    }
    return _items;
}
static NSString * const reuseIdentifier = @"Cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SXQInstrutionCell" bundle:nil]forCellWithReuseIdentifier:@"Instrution Cell"];
    // Do any additional setup after loading the view.
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.collectionViewDataSource = [[ArrayDataSource alloc] initWithItems:self.items cellIdentifier:CollectionViewIdentier cellConfigureBlock:^(SXQInstrutionCell *cell,id item) {
        cell.instructionTitle.text = item;
    }];
    
    self.collectionView.dataSource = self.collectionViewDataSource;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 120);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
