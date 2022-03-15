//
//  SKFastButton.m
//  BuDeJie
//
//  Created by hongchen li on 2022/2/24.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKFastButton.h"

@implementation SKFastButton

- (void)layoutSubviews{
    [super layoutSubviews];
    //设置图片位置
    self.imageView.sk_y = 0;
    self.imageView.sk_centerX = self.sk_width * 0.5;
    //设置标题位置
    self.titleLabel.sk_y = self.sk_height - self.titleLabel.sk_height;
    
    //计算文字宽度，重新设置lable宽度,计算完在改center
    [self.titleLabel sizeToFit];
    //另外两个方法也可修改尺寸
//    [self.titleLabel.text sizeWithFont:(UIFont *)];
//    [self.titleLabel.text boundingRectWithSize:(CGSize) options:(NSStringDrawingOptions) attributes:(nullable NSDictionary<NSAttributedStringKey,id> *) context:(nullable NSStringDrawingContext *)];
    
    self.titleLabel.sk_centerX = self.sk_width * 0.5;
    
}

@end
