//
//  UIView+SKFrame.h
//  BuDeJie
//
//  Created by hongchen li on 2022/2/21.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (SKFrame)
@property CGFloat sk_width;
@property CGFloat sk_height;
@property CGFloat sk_x;
@property CGFloat sk_y;
@property CGFloat sk_centerX;
@property CGFloat sk_centerY;

//返回同名的类型的xib
+(instancetype)SK_viewFromXib;
@end

NS_ASSUME_NONNULL_END
