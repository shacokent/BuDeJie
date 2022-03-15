//
//  SKNewViewController.m
//  BuDeJie
//
//  Created by hongchen li on 2022/2/18.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKNewViewController.h"
#import "SKSubTagViewController.h"
@interface SKNewViewController ()

@end

@implementation SKNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SKRandomColor;
    //设置导航条
    [self setupNavBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarBtnRepeatClick) name:SKTabBarButtonDidRepeatClickNSNotification object:nil];
}

-(void)tabBarBtnRepeatClick{
    //重复点击不是新帖按钮，那么新帖不再window上,所以return
    if(self.view.window == nil) return;
    SKFunc;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 设置导航条
-(void)setupNavBar{
    //订阅
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"MainTagSubIcon"] highImage:[UIImage imageNamed:@"MainTagSubIconClick"] target:self action:@selector(tagClick)];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
}

-(void)tagClick{
    //进入推荐标签界面
    SKSubTagViewController *subTagVc = [[SKSubTagViewController alloc]init];
    [self.navigationController pushViewController:subTagVc animated:YES];
}


@end
