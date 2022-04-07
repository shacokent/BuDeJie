//
//  SKAppJumpOrShareOrThithSignOrUmengOrZhifubaoVC.m
//  BuDeJie
//
//  Created by hongchen li on 2022/4/6.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKAppJumpOrShareOrThithSignOrUmengOrZhifubaoVC.h"

@interface SKAppJumpOrShareOrThithSignOrUmengOrZhifubaoVC ()

@end

@implementation SKAppJumpOrShareOrThithSignOrUmengOrZhifubaoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

- (IBAction)jumpApp:(UIButton *)sender {
    //打电话
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://10086"]];
//    //发短信
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms://10086"]];
    
    //打开应用,跳转微信，需要先在info里面设置URL types添加WeChat，9.0之后需要在info中加入白名单key：LSApplicationQueriesSchemes（Array类型）添加一个元素WeChat
//    目前版本15不需要白名单
//    NSURL *url = [NSURL URLWithString:@"WeChat://"];

    //允许自己的APP被跳转，需要在自己APP的URL types要加入自己的Bounld Identifier，
    //跳转到其他的APP需要在info.plist中把其他的APP加入白名单key：LSApplicationQueriesSchemes（Array类型）添加其他的APP的APP的Bounld Identifier
    //跳转到指定APP的指定界面
    NSURL *url = [NSURL URLWithString:@"tiantianairecsample://history"];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
    }
    //监测通过URL打开我们的APP，在AppDelegate里- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options;
    
    
    
    
}

@end
