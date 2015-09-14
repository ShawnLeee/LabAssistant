//
//  SXQGroup.m
//  实验助手
//
//  Created by sxq on 15/9/14.
//  Copyright (c) 2015年 SXQ. All rights reserved.
//

#import "DWGroup.h"
@interface DWGroup ()
@property (nonatomic,strong,readwrite) NSArray *items;
@end
@implementation DWGroup
-  (instancetype)initWithWithHeader:(NSString *)headerTitle footer:(NSString *)footerTitle items:(NSArray *)items
{
    if (self = [super init]) {
        _headerTitle = headerTitle;
        _footerTitle = footerTitle;
        _items = items;
    }
    return self;
}
+ (instancetype)groupWithItems:(NSArray *)items
{
    return [[DWGroup alloc] initWithWithHeader:nil footer:nil items:items];
}
@end
