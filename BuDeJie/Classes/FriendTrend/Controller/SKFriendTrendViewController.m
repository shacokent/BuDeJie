//
//  SKFriendTrendViewController.m
//  BuDeJie
//
//  Created by hongchen li on 2022/2/18.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKFriendTrendViewController.h"
#import "SKLoginRegisterViewController.h"

@interface SKFriendTrendViewController ()

@end

@implementation SKFriendTrendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航条
    [self setupNavBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarBtnRepeatClick) name:SKTabBarButtonDidRepeatClickNSNotification object:nil];
}

-(void)tabBarBtnRepeatClick{
    //重复点击不是关注按钮，那么关注不再window上,所以return
    if(self.view.window == nil) return;
    SKFunc;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 设置导航条
-(void)setupNavBar{
    //关注
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"friendsRecommentIcon"] highImage:[UIImage imageNamed:@"friendsRecommentIcon-click"] target:self action:@selector(friendRecommentClick)];
    
//i18n:国际化(其他语言)
//locallization:本地化(ios)
//    注意：APP名字本地化：必须创建名为InfoPlist的文件"CFBundleName" = "name"
//[[NSBundle mainBundle] localizedStringForKey:@"Key" value:@"找不到Key就返回这个字符串" table:@"本地化的文件名"]
//  系统自带宏NSLocalizedStringFromTable(@"Key", @"本地化的文件名", @"描述可以写nil");
//    生成本地化文件：终端进入当前工程文件夹输入：
//    find . -name \*.m | xargs genstrings
    
    NSString *title = NSLocalizedStringFromTable(@"FriendTrendTitle", @"AppLocalString", nil);
    self.navigationItem.title = title;//本地化
}

-(void)friendRecommentClick{
    
}

- (IBAction)loginRegisterOnClick:(UIButton *)sender {
    //进入登录注册
    SKLoginRegisterViewController *loginVc = [[SKLoginRegisterViewController alloc]init];
    [self presentViewController:loginVc animated:YES completion:nil];
}


@end
