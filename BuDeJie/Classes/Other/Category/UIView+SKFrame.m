//
//  UIView+SKFrame.m
//  BuDeJie
//
//  Created by hongchen li on 2022/2/21.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "UIView+SKFrame.h"

@implementation UIView (SKFrame)

+(instancetype)SK_viewFromXib{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)setSk_height:(CGFloat)sk_height{
    CGRect rect = self.frame;
    rect.size.height = sk_height;
    self.frame = rect;
}

- (CGFloat)sk_height{
    return self.frame.size.height;
}

- (void)setSk_width:(CGFloat)sk_width{
    CGRect rect = self.frame;
    rect.size.width = sk_width;
    self.frame = rect;
}

- (CGFloat)sk_width{
    return self.frame.size.width;
}

- (void)setSk_x:(CGFloat)sk_x{
    CGRect rect = self.frame;
    rect.origin.x = sk_x;
    self.frame = rect;
}

- (CGFloat)sk_x{
    return self.frame.origin.x;
}

- (void)setSk_y:(CGFloat)sk_y{
    CGRect rect = self.frame;
    rect.origin.y = sk_y;
    self.frame = rect;
}

- (CGFloat)sk_y{
    return self.frame.origin.y;
}

- (void)setSk_centerX:(CGFloat)sk_centerX{
    CGPoint center = self.center;
    center.x = sk_centerX;
    self.center = center;
}

- (CGFloat)sk_centerX{
    return self.center.x;
}

- (void)setSk_centerY:(CGFloat)sk_centerY{
    CGPoint center = self.center;
    center.y = sk_centerY;
    self.center = center;
}

- (CGFloat)sk_centerY{
    return self.center.y;
}
@end
