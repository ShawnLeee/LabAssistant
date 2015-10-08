//
//  SXQSupplierListController.m
//  实验助手
//
//  Created by sxq on 15/9/30.
//  Copyright © 2015年 SXQ. All rights reserved.
//

#import "SXQSupplierListController.h"
#import "ArrayDataSource+TableView.h"
@interface SXQSupplierListController ()
@property (nonatomic,copy) SupplierChoosedBlk supplierBlk;
@property (nonatomic,strong) ArrayDataSource *supplierDataSource;
@end

@implementation SXQSupplierListController
- (instancetype)initWithReagent:(SXQExpReagent *)reagent supplierChoosedBlk:(SupplierChoosedBlk)supplierBlk
{
    if (self = [super init]) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}



@end
