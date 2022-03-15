//
//  SKLoginField.m
//  BuDeJie
//
//  Created by hongchen li on 2022/2/24.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKLoginField.h"

@implementation SKLoginField

/**
 文本框光标变成白色
 文本框开始编辑，占位文字变为白色
 */

- (void)awakeFromNib{
    [super awakeFromNib];
    //设置光标颜色
    self.tintColor = [UIColor whiteColor];
    //监听文本框编辑1.代理，2.通知，3.target
    //原则：不要自己成为自己的代理
    //一般用target
    [self addTarget:self action:@selector(textBegin) forControlEvents:UIControlEventEditingDidBegin];
    [self addTarget:self action:@selector(textEnd) forControlEvents:UIControlEventEditingDidEnd];
    
    [self setPHColor:[UIColor lightGrayColor]];
}

-(void)textBegin{
    [self setPHColor:[UIColor whiteColor]];
}

-(void)textEnd{
    [self setPHColor:[UIColor lightGrayColor]];
}

-(void)setPHColor:(UIColor*)color{
//    方法一
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSForegroundColorAttributeName]=color;
//    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attrs];
    
    //方法二
    //快速设置占位文字颜色=>文本框占位文字可能是Lable => 验证占位文字是lable（用小面包）=>拿到Lable => 查看Lable属性名(1.runtime，2.断点)
    //kvc获取占位文字控件
//    UILabel * placeholderLabel = [self valueForKey:@"placeholderLabel"];
//    placeholderLabel.textColor = color;
    
    //方法三，写分类UITextField
    self.placeholderColor = color;
}


@end
