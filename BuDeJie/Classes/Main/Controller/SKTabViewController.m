//
//  SKTabViewController.m
//  BuDeJie
//
//  Created by hongchen li on 2022/2/18.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKTabViewController.h"
#import "SKFriendTrendViewController.h"
#import "SKEssenceViewController.h"
#import "SKMeViewController.h"
#import "SKNewViewController.h"
#import "SKTabBar.h"
#import "SKBaseNavigationController.h"

@interface SKTabViewController ()

@end

@implementation SKTabViewController
#pragma mark - 添加所有子控制器
//可能调用多次，需要判断
+ (void)initialize{
    if(self == [SKTabViewController class]){
        //设置全局的样式首先想到用appearance
    /*
     以UITabBarItem为例，UITabBarItem可以使用appearance
    1、不是所有类都可以使用appearance，appearance是一个协议，遵守UIAppearance协议，还要实现appearance方法
     2、不是所有通过appearance获取的UITabBarItem的属性都可以设置（如）item.title=@"123",查看setTitleTextAttributes方法发现只有被UI_APPEARANCE_SELECTOR宏修饰的属性，才能设置
     3.appearance：注意只能在控件显示之前，才有作用，可以采用移除父控件的方式，重新加载
        例如：需求：点击屏幕，改变多个UISwitc的颜色
            [self.view removeFromSuperview];
            UISwitch *switchView = [UISwitch appearance];
            switchView.onTintColor = [UIColor redColor];
            [[UIApplication sharedApplication].keyWindow addSubview:self.view];
     4.夜间模式可以用appearance
     */
        //appearance，一般开发中很少用，但是会把整个应用都改掉，不好控制，容易坑
    //    UITabBarItem * item = [UITabBarItem appearance];
        
     //所以采用appearanceWhenContainedIn,ios9以上使用appearanceWhenContainedInInstancesOfClasses,表示获取哪个类中的UITabBarItem
        UITabBarItem * item = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[self]];
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        //UIKit->NSAttributedString.h富文本设置在这个文件中找对应的key
        attrs[NSForegroundColorAttributeName] = [UIColor blackColor];
        [item setTitleTextAttributes:attrs forState:UIControlStateSelected];
        //字体只有设置正常状态才有效果
        NSMutableDictionary *attrsNor = [NSMutableDictionary dictionary];
        attrsNor[NSFontAttributeName] = [UIFont systemFontOfSize:14];
        [item setTitleTextAttributes:attrsNor forState:UIControlStateNormal];
        //设置文字位置，向上偏移15
    //    [item setTitlePositionAdjustment:UIOffsetMake(0, -15)];
    }
}

/**
 自定义TabBar
 */
-(void)setupTabbar{
    SKTabBar *tabBar = [[SKTabBar alloc] init];
//    self.tabBar = tabbar;readonly
    [self setValue:tabBar forKey:@"tabBar"];
    //监听二次点击事件（注意如果想监听拿不到的控件的点击，可以称为他父控件的代理，需要在SKTabViewController中设置代理）
//    self.tabBar.delegate = self;//不需要设置代理，因为SKTabViewController本身已经有了tabBar代理，并且不允许改，会崩溃，所以成为SKTabViewController的代理，需要在初始化SKTabViewController的时候设置，但不让广告界面成为SKTabViewController的代理，因为用完后会被销毁，一般会设置AppDelegate作为代理，上述方法不推荐（一种方法补充）
}


-(void)setupAllChildController{
    //精华
    SKEssenceViewController * essenceVc = [[SKEssenceViewController alloc] init];
    SKBaseNavigationController * essenceNav = [[SKBaseNavigationController alloc] initWithRootViewController:essenceVc];
    [self addChildViewController:essenceNav];
    //新帖
    SKNewViewController * newVc = [[SKNewViewController alloc] init];
    SKBaseNavigationController * newNav = [[SKBaseNavigationController alloc]  initWithRootViewController:newVc];
    [self addChildViewController:newNav];
    
    //关注
    SKFriendTrendViewController * friendTrendVc = [[SKFriendTrendViewController alloc] init];
    SKBaseNavigationController * friendTrendNav = [[SKBaseNavigationController alloc]  initWithRootViewController:friendTrendVc];
    [self addChildViewController:friendTrendNav];
    //我
    UIStoryboard *meStoryboard = [UIStoryboard storyboardWithName:NSStringFromClass([SKMeViewController class]) bundle:nil];
    SKMeViewController * meVc = [meStoryboard instantiateInitialViewController];
    SKBaseNavigationController * meNav = [[SKBaseNavigationController alloc]  initWithRootViewController:meVc];
    [self addChildViewController:meNav];
    
}

-(void)setupAllTitleButton{
    SKBaseNavigationController * essenceNav = self.childViewControllers[0];
    essenceNav.tabBarItem.title = @"精华";
    essenceNav.tabBarItem.image = [UIImage imageWithRenderOriginalName:@"tabBar_essence_icon"];
    essenceNav.tabBarItem.selectedImage = [UIImage imageWithRenderOriginalName:@"tabBar_essence_click_icon"];
    
    
    SKBaseNavigationController * newNav = self.childViewControllers[1];
    newNav.tabBarItem.title = @"新帖";
    newNav.tabBarItem.image = [UIImage imageWithRenderOriginalName:@"tabBar_new_icon"];
    newNav.tabBarItem.selectedImage = [UIImage imageWithRenderOriginalName:@"tabBar_new_click_icon"];
    
    SKBaseNavigationController * friendTrendNav = self.childViewControllers[2];
    friendTrendNav.tabBarItem.title = @"关注";
    friendTrendNav.tabBarItem.image = [UIImage imageWithRenderOriginalName:@"tabBar_friendTrends_icon"];
    friendTrendNav.tabBarItem.selectedImage = [UIImage imageWithRenderOriginalName:@"tabBar_friendTrends_click_icon"];
    
    SKBaseNavigationController * meNav = self.childViewControllers[3];
    meNav.tabBarItem.title = @"我";
    meNav.tabBarItem.image = [UIImage imageWithRenderOriginalName:@"tabBar_me_icon"];
    meNav.tabBarItem.selectedImage = [UIImage imageWithRenderOriginalName:@"tabBar_me_click_icon"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加子控制器
    [self setupAllChildController];
    //设置所有tabbar的按钮
    [self setupAllTitleButton];
    //自定义tabbar
    [self setupTabbar];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];//系统的tabbar在这里添加，所以自定义的在这行代码之前添加，最安全
}
@end
