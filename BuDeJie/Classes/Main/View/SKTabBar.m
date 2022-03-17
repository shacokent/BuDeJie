//
//  SKTabBar.m
//  BuDeJie
//
//  Created by hongchen li on 2022/2/21.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKTabBar.h"
#import "SKPublichViewController.h"
@interface SKTabBar()
@property (nonatomic,weak) UIButton *plusButton;
@property (nonatomic,weak) UIControl *prevTabBarBtn;
@end

@implementation SKTabBar


- (UIButton *)plusButton{
    if(_plusButton == nil){
        UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [plusButton setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [plusButton setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        [plusButton addTarget:self action:@selector(openPublishModel) forControlEvents:UIControlEventTouchUpInside];
        [plusButton sizeToFit];
        _plusButton = plusButton;
        [self addSubview:_plusButton];
    }
    return _plusButton;
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f,0.0f, 1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
//        兼容tabbar半透明效果
        if (@available(iOS 13.0, *)) {
            self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:SKTabBar_Nav_ColorAlpha];
        } else {
            UIImage *image = [self  imageWithColor:SKColor(255, 255, 255, 0.9)];
            self.backgroundImage = image;
            
        }
        self.tintColor = [UIColor blackColor];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //布局tabbarbutton
    CGFloat btnW = self.sk_width / (self.items.count + 1);
    CGFloat btnX = 0;
    NSInteger i = 0;
    for (UIControl *tabBarButton in self.subviews) {
        if([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]){
            //避免初始化精华按钮二次点击事件BUG
            if(i == 0 && self.prevTabBarBtn == nil){
                self.prevTabBarBtn = tabBarButton;
            }
            if(i == 2){
                i++;
            }
            btnX = i * btnW;
            tabBarButton.frame = CGRectMake(btnX, 0, btnW, SKTabBarH);
            i++;
            
            //监听二次点击事件（注意如果想监听拿不到的控件的点击，可以称为他父控件的代理，需要在SKTabViewController中设置代理）
        //    self.tabBar.delegate = self;//不需要设置代理，因为SKTabViewController本身已经有了tabBar代理，并且不允许改，会崩溃，所以成为SKTabViewController的代理，需要在初始化SKTabViewController的时候设置，但不让广告界面成为SKTabViewController的代理，因为用完后会被销毁，一般会设置AppDelegate作为代理，上述方法不推荐（一种方法补充）
            //监听二次点击事件
            [tabBarButton addTarget:self action:@selector(tabBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    //设置加号按钮
    self.plusButton.center = CGPointMake(self.sk_width * 0.5, SKTabBarH * 0.5);
}

-(void)tabBarBtnClick:(UIControl*)tabBarBtn{
    if(self.prevTabBarBtn == tabBarBtn){
        //发出通知，告诉外界按钮被重复点击了
        [[NSNotificationCenter defaultCenter] postNotificationName:SKTabBarButtonDidRepeatClickNSNotification object:nil];
    }
    self.prevTabBarBtn = tabBarBtn;
}


-(void)openPublishModel{
    SKPublichViewController *publishVc = [[SKPublichViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]init];
    [nav addChildViewController:publishVc];
    [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
}
@end
