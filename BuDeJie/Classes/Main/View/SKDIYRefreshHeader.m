//
//  SKDIYRefreshHeader.m
//  BuDeJie
//
//  Created by hongchen li on 2022/3/15.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKDIYRefreshHeader.h"
@interface SKDIYRefreshHeader()
@property (nonatomic,weak) UISwitch *s;

@end

@implementation SKDIYRefreshHeader

- (instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        UISwitch *s = [[UISwitch alloc]init];
        [self addSubview:s];
        self.s = s;
        self.sk_height = 100;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.s.sk_centerX = self.sk_width*0.5;
    self.s.sk_centerY = self.sk_height*0.5;
}

//重写Header的内部方法
- (void)setState:(MJRefreshState)state{
    [super setState:state];
    if(state == MJRefreshStateIdle){
        [self.s setOn:NO animated:YES];
        [UIView animateWithDuration:0.5 animations:^{
            self.s.transform = CGAffineTransformIdentity;
        }];
    }
    else if (state == MJRefreshStatePulling){
        [self.s setOn:YES animated:YES];
        [UIView animateWithDuration:0.5 animations:^{
            self.s.transform = CGAffineTransformMakeRotation(M_PI_2);
        }];
    }
    else if (state == MJRefreshStateRefreshing){
        [self.s setOn:NO animated:YES];
    }
}

@end
