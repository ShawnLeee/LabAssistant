//
//  SXQListCell.m
//  实验助手
//
//  Created by sxq on 15/9/1.
//  Copyright © 2015年 SXQ. All rights reserved.
//

#import "SXQListCell.h"
#import "SXQExpInstruction.h"
#import "SXQInstructionManager.h"
#import "SXQInstructionManager.h"
@interface SXQListCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *supplierLabel;
@property (weak, nonatomic) IBOutlet UILabel *supplierIDLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@end
@implementation SXQListCell
- (instancetype)init
{
    if (self = [super init]) {
//        _downloaded = NO;
    }
    return self;
}
- (void)configureCellWithItem:(SXQExpInstruction *)item
{
    _nameLabel.text = item.experimentName;
    _supplierLabel.text = [NSString stringWithFormat:@"厂商:%@",item.supplierName];
    _supplierIDLabel.text  = [NSString stringWithFormat:@"货号:%@",item.supplierID];
    [_downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
//    _downloadBtn.enabled = NO;
    //检索说明书是否已经下载
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.downloaded = [SXQInstructionManager instructionIsdownload:item.expInstructionID];
    });
}
- (void)setDownloaded:(BOOL)downloaded
{
    _downloaded = downloaded;
//    _downloadBtn.enabled = !_downloadBtn;
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
