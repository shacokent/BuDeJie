//
//  SKRefreshHeader.m
//  BuDeJie
//
//  Created by hongchen li on 2022/3/15.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKRefreshHeader.h"

@implementation SKRefreshHeader

- (instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        [self setImages:@[[UIImage imageNamed:@"Profile_AddV_authen"],[UIImage imageNamed:@"mainCellCaiClick"]] forState:MJRefreshStateRefreshing];
        [self setTitle:@"设置状态文字" forState:MJRefreshStateRefreshing];//更改文字
        self.stateLabel.textColor = [UIColor redColor];//更改文字颜色
        self.stateLabel.font = [UIFont systemFontOfSize:18];//更改文字大小
        self.lastUpdatedTimeLabel.hidden = YES;//隐藏时间显示
        self.automaticallyChangeAlpha = YES;//自动切换透明度
    }
    return self;
}

@end
