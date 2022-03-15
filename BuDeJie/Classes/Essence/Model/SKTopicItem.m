//
//  SKTopicItem.m
//  BuDeJie
//
//  Created by hongchen li on 2022/3/2.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKTopicItem.h"

@implementation SKTopicItem
- (CGFloat)cellHeight{
    if(_cellHeight) return _cellHeight;//如果_cellHeight==0才计算
    //文字的Y值
    _cellHeight += (50+10+10);//头像高度+上下边距
    //文字的高度,boundingRectWithSize计算多行文字的高度
    CGSize textMaxSize = CGSizeMake(SKSCreenW-20, MAXFLOAT);
    _cellHeight += [self.topic boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height;
    _cellHeight += 10;//topic内容下边距
    //中间内容
    if(self.type != TopicType){//中间有内容，非段子需要计算
        CGFloat middleW = textMaxSize.width;
        CGFloat middleH = middleW *self.imageHeight/self.imageWidth;
        CGFloat middleY = _cellHeight;//计算中间部分Y值
        if(middleH >=SKSCreenH){//如果高度超过屏幕，就是超长图片
            middleH = 200;
            self.bigPictureTag = YES;
        }
        else{
            self.bigPictureTag = NO;
        }
        self.middleFrame = CGRectMake(10, middleY, middleW, middleH);
        _cellHeight += middleH;//中间内容高度
        _cellHeight += 10;//中间内容下边距
    }
    
    
    if(self.hotReplay.length){
        _cellHeight += 21;//最热评论标题
        //最热评论内容
        _cellHeight += [self.hotReplay boundingRectWithSize:CGSizeMake(SKSCreenW-20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
        _cellHeight += 10;//最热评论下边距
    }
    _cellHeight += 50;//底部工具栏
    return _cellHeight;
}
@end
