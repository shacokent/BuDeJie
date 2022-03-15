//
//  SKBaseNavigationController.m
//  BuDeJie
//
//  Created by hongchen li on 2022/2/21.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKBaseNavigationController.h"

@interface SKBaseNavigationController ()<UIGestureRecognizerDelegate>

@end
//IOS15以后Navigationbar的坑（默认变成了透明），修改成不透明
@implementation SKBaseNavigationController

+ (void)initialize{
    //屏蔽子类，只加载一次
    if(self == [SKBaseNavigationController class]){
        UINavigationBar *bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[self]];
        //设置导航条字体大小
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSFontAttributeName] = [UIFont systemFontOfSize:21];
        if (@available(iOS 13.0, *)) {
            UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
            [appearance configureWithOpaqueBackground];
            appearance.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:SKTabBar_Nav_ColorAlpha]; // 项目导航的颜色
            [appearance setTitleTextAttributes:attrs];
//            appearance.backgroundImage = [UIImage imageNamed:@"navigationbarBackgroundWhite"];
            bar.standardAppearance = appearance;
            bar.scrollEdgeAppearance=bar.standardAppearance;
        }
        else {
            [bar setTitleTextAttributes:attrs];
//            [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
            [bar setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:SKTabBar_Nav_ColorAlpha]];
        }
    }
}



- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //    当非根控制器设置导航条左侧返回按钮,隐藏tabbar
    if(self.childViewControllers.count > 0){
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithImage:[UIImage imageNamed:@"navigationButtonReturn"] highImage:[UIImage imageNamed:@"navigationButtonReturnClick"] target:self action:@selector(backClick) title:@"返回"];
    }
    [super pushViewController:viewController animated:animated];
}


-(void)backClick{
    [self popViewControllerAnimated:YES];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    self.childViewControllers.count == 1 是根控制器
    return self.childViewControllers.count > 1;//非根控制器才可以滑动返回
}

- (void)viewDidLoad{
    [super viewDidLoad];
    //添加全屏滑动手势
    //打印self.interactivePopGestureRecognizer可以看到Target和action
    //刚好self.interactivePopGestureRecognizer.delegate == Target
    //handleNavigationTransition:可以直接用action
    UIPanGestureRecognizer *pan =[[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    [self.view addGestureRecognizer:pan];
    //避免根控制器滑动假死，调用代理
    pan.delegate = self;
    //同时禁止系统的手势
    self.interactivePopGestureRecognizer.enabled = NO;
}

@end
