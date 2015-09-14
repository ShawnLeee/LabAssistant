//
//  ArrayDataSource.m
//  SXQMovie
//
//  Created by SXQ on 15/8/11.
//  Copyright (c) 2015年 SXQ. All rights reserved.
//

#import "ArrayDataSource.h"
@interface ArrayDataSource ()

@end
@implementation ArrayDataSource
- (id)init
{
    return nil;
}
- (instancetype)initWithItems:(NSArray *)anItems cellIdentifier:(NSString *)aCellIdentifier cellConfigureBlock:(CellConfigureBlock)aConfigureBlock
{
    self = [super init];
    if (self) {
        self.items = anItems;
        self.cellIdentifier = aCellIdentifier;
        self.configureBlock = aConfigureBlock;
    }
    return self;
}
- (instancetype)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.items[indexPath.row];
}
@end
