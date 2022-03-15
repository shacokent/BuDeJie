//
//  SKSubTagCell.m
//  BuDeJie
//
//  Created by hongchen li on 2022/2/22.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKSubTagCell.h"
#import "SKSubTagItem.h"
#import <UIImageView+WebCache.h>

@interface SKSubTagCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;

@end
@implementation SKSubTagCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItem:(SKSubTagItem *)item{
    _item = item;
    _nameLab.text = item.name;
    _numLab.text = item.download;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:item.icon] placeholderImage:[UIImage imageWithRenderOriginalName:@"defaultUserIcon"]];
    
    //设置头像圆角，方法二，裁剪图片，在sd_setImageWithURL中下载好图片后做
//    [_iconView sd_setImageWithURL:[NSURL URLWithString:item.icon] placeholderImage:[UIImage imageWithRenderOriginalName:@"defaultUserIcon"] options:SDWebImageFromCacheOnly completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        //    1.开启图形上下文
//        //    参数1:图片尺寸
//        //    参数2:是否透明
//        //参数3:当前点和像素的比例，0自动识别
//        UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
//        //    2.描述裁剪区域
//        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
//        //    3.设置裁剪区域
//        [path addClip];
//        //    4.画图片
//        [image drawAtPoint:CGPointZero];
//        //    5.取出图片
//        image = UIGraphicsGetImageFromCurrentImageContext();
//        //    6.关闭上下文
//        UIGraphicsEndImageContext();
//        self.iconView.image = image;
//    }];
    
}

//从XIB加载就会调用一次
- (void)awakeFromNib{
    //设置头像圆角,方法一，IOS9才可以
    _iconView.layer.cornerRadius = 30;
    _iconView.layer.masksToBounds = YES;
    //修改分割线边距，设置完self.tableView.separatorInset =  UIEdgeInsetsZero，发现还有内边距，所以找到cell修改约束,都是iOS8.0后新增
//    self.layoutMargins = UIEdgeInsetsZero;
    [super awakeFromNib];
}

- (void)setFrame:(CGRect)frame{
    frame.size.height -= 1;
    [super setFrame:frame];
}
@end
