//
//  SKTitleButton.m
//  BuDeJie
//
//  Created by hongchen li on 2022/2/25.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKTitleButton.h"
/**
 特定构造方法
 后面带有NS_DESIGNATED_INITIALIZER的方法就是特定构造方法
 子类重写特定构造方法，那么必须调用super放法，不然会报警告
*/
@implementation SKTitleButton

- (instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor systemRedColor] forState:UIControlStateSelected];
    }
    return self;;
}

- (void)setHighlighted:(BOOL)highlighted{
    //只要重写这个方法，按钮就不会进入高亮状态
}

@end
