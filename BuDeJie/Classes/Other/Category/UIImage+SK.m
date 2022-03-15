//
//  UIImage+SK.m
//  BuDeJie
//
//  Created by hongchen li on 2022/2/18.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "UIImage+SK.h"

@implementation UIImage (SK)
+ (UIImage *)imageWithRenderOriginalName:(NSString *)name{
    UIImage *image = [UIImage imageNamed:name];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//取消渲染，保持原始图片样式
}
@end
