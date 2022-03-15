//
//  UITextField+SKPlaceHolder.m
//  BuDeJie
//
//  Created by hongchen li on 2022/2/24.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "UITextField+SKPlaceHolder.h"
#import <objc/message.h>

@implementation UITextField (SKPlaceHolder)

+ (void)load{
    Method setPlaceholderMethod = class_getInstanceMethod(self, @selector(setPlaceholder:));
    Method setSKPlaceholderMethod = class_getInstanceMethod(self, @selector(setSK_Placeholder:));
    method_exchangeImplementations(setPlaceholderMethod, setSKPlaceholderMethod);
    
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    
    //bug,如果没有设置文字就设置颜色，会设置失败，因为是IOS是懒加载，设置颜色时候还没有生成属性，所以kvc拿到的是nil,这里想到用runtime给系统添加成员属性,然后再给textfield.placeholder添加交换方法setSK_Placeholder
    objc_setAssociatedObject(self, @"placeholderColor", placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UILabel * placeholderLabel = [self valueForKey:@"placeholderLabel"];
    placeholderLabel.textColor = placeholderColor;
}

- (UIColor *)placeholderColor{
    return objc_getAssociatedObject(self, @"placeholderColor");
}

//设置占位文字，设置颜色
- (void)setSK_Placeholder:(NSString *)placeholder{
    [self setSK_Placeholder:placeholder];
    self.placeholderColor = self.placeholderColor;
}
@end
