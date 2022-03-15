//
//  UIBarButtonItem+SKBarButtonItem.m
//  BuDeJie
//
//  Created by hongchen li on 2022/2/21.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "UIBarButtonItem+SKBarButtonItem.h"

@implementation UIBarButtonItem (SKBarButtonItem)

+(UIBarButtonItem*)itemWithImage:(UIImage*)image highImage:(UIImage*)highImage target:(id)target action:(SEL)action{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:highImage forState:UIControlStateHighlighted];
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    //直接将按钮添加入UIBarButtonItem，点击范围有问题，可能是UIBarButtonItem对UIButton特殊处理了，所以放在UIView中再添加进UIBarButtonItem
    UIView *leftBtnView = [[UIView alloc] initWithFrame:btn.frame];
    [leftBtnView addSubview:btn];
    
    return [[UIBarButtonItem alloc] initWithCustomView:leftBtnView];
}


+(UIBarButtonItem*)itemWithImage:(UIImage*)image selImage:(UIImage*)selImage target:(id)target action:(SEL)action{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selImage forState:UIControlStateSelected];
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIView *leftBtnView = [[UIView alloc] initWithFrame:btn.frame];
    [leftBtnView addSubview:btn];
    
    return [[UIBarButtonItem alloc] initWithCustomView:leftBtnView];
}

+(UIBarButtonItem*)backItemWithImage:(UIImage*)image highImage:(UIImage*)highImage target:(id)target action:(SEL)action title:(NSString*)title{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:highImage forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [btn sizeToFit];
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIView *leftBtnView = [[UIView alloc] initWithFrame:btn.frame];
    [leftBtnView addSubview:btn];
    
    return [[UIBarButtonItem alloc] initWithCustomView:leftBtnView];
}

@end
