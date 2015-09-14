//
//  ArrayDataSource+TableView.m
//  SXQMovie
//
//  Created by SXQ on 15/8/11.
//  Copyright (c) 2015年 SXQ. All rights reserved.
//

#import "ArrayDataSource+TableView.h"

@implementation ArrayDataSource (TableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
//    }
    
    id item = [self itemAtIndexPath:indexPath];
    self.configureBlock(cell,item);
    
    return cell;
}
@end
