//
//  SKAnnotationView.m
//  BuDeJie
//
//  Created by hongchen li on 2022/3/21.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKAnnotationView.h"

@implementation SKAnnotationView

//返回点是否子自己坐标系
//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
//    SKLog(@"SKAnnotationView");
//    return YES;
//}
//
//拦截点击穿透
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    return self;
//}

//重写点击事件，防止大头针点击在自己上面时，删除并继续创建，导致无法拖动大头针
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    return;
}
@end
