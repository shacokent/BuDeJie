//
//  SKSquareCell.m
//  BuDeJie
//
//  Created by hongchen li on 2022/2/24.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKSquareCell.h"
#import "SKFootCellItem.h"
#import <UIImageView+WebCache.h>
@interface SKSquareCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconFootIcellView;
@property (weak, nonatomic) IBOutlet UILabel *nameFootIcellLab;


@end
@implementation SKSquareCell

- (void)awakeFromNib {
    //设置头像圆角,方法一，IOS9才可以
    _iconFootIcellView.layer.cornerRadius = 30;
    _iconFootIcellView.layer.masksToBounds = YES;
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    // Initialization code
}


- (void)setItem:(SKFootCellItem *)item{
    _item = item;
    _nameFootIcellLab.text = item.name;
    [_iconFootIcellView sd_setImageWithURL:[NSURL URLWithString:item.icon]];
}

@end
