//
//  SXQSupplierListController.h
//  实验助手
//
//  Created by sxq on 15/9/30.
//  Copyright © 2015年 SXQ. All rights reserved.
//
@class SXQExpReagent;
#import <UIKit/UIKit.h>
typedef void (^SupplierChoosedBlk)(NSString *supplier);
@interface SXQSupplierListController : UITableViewController
- (instancetype)initWithReagent:(SXQExpReagent *)reagent supplierChoosedBlk:(SupplierChoosedBlk)supplierBlk;
@end
