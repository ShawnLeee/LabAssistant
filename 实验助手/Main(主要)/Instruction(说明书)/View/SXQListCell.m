//
//  SXQListCell.m
//  实验助手
//
//  Created by sxq on 15/9/1.
//  Copyright © 2015年 SXQ. All rights reserved.
//

#import "SXQListCell.h"
#import "SXQExpInstruction.h"
@interface SXQListCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *supplierLabel;
@property (weak, nonatomic) IBOutlet UILabel *supplierIDLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;

@end
@implementation SXQListCell
- (void)configureCellWithItem:(SXQExpInstruction *)item
{
    _nameLabel.text = item.experimentName;
    _supplierLabel.text = [NSString stringWithFormat:@"厂商:%@",item.supplierName];
    _supplierIDLabel.text  = [NSString stringWithFormat:@"货号:%@",item.supplierID];
    
    NSString *buttonTitle = item.isDownloaded ? @"已下载" : @"下载";
    [_downloadBtn setTitle:buttonTitle forState:UIControlStateNormal];
}
- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)download:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(listCell:clickedDownloadBtn:)]) {
        [self.delegate listCell:self clickedDownloadBtn:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
