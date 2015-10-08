//
//  PhotoContainer.m
//  Photo
//
//  Created by SXQ on 15/10/2.
//  Copyright © 2015年 SXQ. All rights reserved.
//

#import "PhotoContainer.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
static NSUInteger CountOfImageView = 9;
static CGFloat kPadding = 10;
static NSUInteger numberOfColumns = 3;
@interface PhotoContainer ()
@property (nonatomic,strong) NSMutableArray *imageViews;
@property (nonatomic,assign) CGFloat imageWidth;
@property (nonatomic,strong) NSMutableArray *photos;
@end
@implementation PhotoContainer
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [self setupSelf];
    }
    return self;
}
- (instancetype)init
{
    if (self = [super init]) {
        [self setupSelf];
    }
    return self;
}
- (void)setupSelf
{
    self.backgroundColor = [UIColor whiteColor];
     _photos = [NSMutableArray array];
        _imageViews = [@[] mutableCopy];
    CGRect rect = [UIScreen mainScreen].bounds;
        _imageWidth = ([UIScreen mainScreen].bounds.size.width - (numberOfColumns + 1) * kPadding)/(CGFloat)numberOfColumns;
        //创建9个imageview
        for (int i = 0; i < CountOfImageView; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapped:)]];
            [_imageViews addObject:imageView];
            [self addSubview:imageView];
        }
}
- (void)photoTapped:(UITapGestureRecognizer *)tapGesture
{
    NSUInteger count = _photos.count;
    // 1.封装图片数据
    NSMutableArray *myphotos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
//        // 一个MJPhoto对应一张显示的图片
        MJPhoto *mjphoto = [[MJPhoto alloc] init];
        mjphoto.image = _photos[i];
        mjphoto.srcImageView = self.imageViews[i]; // 来源于哪个UIImageView

        [myphotos addObject:mjphoto];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tapGesture.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = myphotos; // 设置所有的图片
    [browser show];
}
- (void)addPhoto:(UIImage *)image 
{
    NSUInteger index = _photos.count;
    NSAssert(index < CountOfImageView,@"");
    
    UIImageView *imageView = _imageViews[index];
    imageView.image = image;
    [_photos addObject:image];
    [self layoutCustomSubviews];
}
- (void)addPhoto:(UIImage *)image updatesConstraintBlk:(void (^)(BOOL, CGFloat))completion
{
    NSUInteger index = _photos.count;
    if (index >= _imageViews.count) {
        completion(NO,0);
        return;
    }
    
    UIImageView *imageView = _imageViews[index];
    imageView.image = image;
    [_photos addObject:image];
    [self layoutCustomSubviews];
    CGFloat photoHeight = [self heightOfPhotoContainer];
    completion(YES,photoHeight);
}

- (void)layoutCustomSubviews
{
    [super layoutSubviews];
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    for (int i = 0; i < _photos.count; ++i) {
        NSUInteger row = i / numberOfColumns;
        NSUInteger column = i % numberOfColumns;
        imageX = column * (_imageWidth + kPadding) + kPadding;
        imageY = row * (_imageWidth + kPadding) + kPadding;
        UIImageView *imageView = _imageViews[i];
        imageView.frame = CGRectMake(imageX, imageY, _imageWidth, _imageWidth);
    }
}

- (CGFloat)heightOfPhotoContainer
{
    NSUInteger numberOfRows = (_photos.count - 1)/3 + 1;
    return numberOfRows * _imageWidth + (numberOfRows + 1) * kPadding;
}
@end











