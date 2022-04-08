//
//  SKAppJumpOrShareOrThithSignOrUmengOrZhifubaoVC.m
//  BuDeJie
//
//  Created by hongchen li on 2022/4/6.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKAppJumpOrShareOrThithSignOrUmengOrZhifubaoVC.h"
#import <Social/Social.h>

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
    NSURL *url = [NSURL URLWithString:@"tiantianairecsample://history?mytest"];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        if(@available(iOS 10.0, *)){
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
    //监测通过URL打开我们的APP，在AppDelegate里- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options;
}

- (IBAction)settingViewsOnClick:(UIButton *)sender {
    
//    注意：IOS10以后需要用App-Prefs，IOS10之前用prefs
    //        About — prefs:root=General&path=About
    //        Accessibility — prefs:root=General&path=ACCESSIBILITY
    //        AirplaneModeOn — prefs:root=AIRPLANE_MODE
    //        Auto-Lock — prefs:root=General&path=AUTOLOCK
    //        Brightness — prefs:root=Brightness
    //        Bluetooth — prefs:root=General&path=Bluetooth
    //        Date& Time — prefs:root=General&path=DATE_AND_TIME
    //        FaceTime — prefs:root=FACETIME
    //        General— prefs:root=General
    //        Keyboard — prefs:root=General&path=Keyboard
    //        iCloud — prefs:root=CASTLE  iCloud
    //        Storage & Backup — prefs:root=CASTLE&path=STORAGE_AND_BACKUP
    //        International — prefs:root=General&path=INTERNATIONAL
    //        Location Services — prefs:root=LOCATION_SERVICES
    //        Wi-Fi — prefs:root=WIFI
    //        Setting — prefs:root=INTERNET_TETHERING
    //        Wallpaper — prefs:root=Wallpaper
    //        VPN — prefs:root=General&path=Network/VPN
    //        Twitter — prefs:root=TWITTER
    //        Usage — prefs:root=General&path=USAGE
    //        Store — prefs:root=STORE
    //        SoftwareUpdate — prefs:root=General&path=SOFTWARE_UPDATE_LINK
    //        Sounds — prefs:root=Sounds
    //        Siri — prefs:root=General&path=Assistant
    //        Safari — prefs:root=Safari
    //        Reset — prefs:root=General&path=Reset
    //        Profile — prefs:root=General&path=ManagedConfigurationList
    //        Phone — prefs:root=Phone
    //        Photos — prefs:root=Photos
    //        Notification — prefs:root=NOTIFICATIONS_ID
    //        Notes — prefs:root=NOTES
    //        Nike + iPod — prefs:root=NIKE_PLUS_IPOD
    //        Network — prefs:root=General&path=Network
    //        Music VolumeLimit — prefs:root=MUSIC&path=VolumeLimit
    //        Music Equalizer — prefs:root=MUSIC&path=EQ
    //        Music — prefs:root=MUSIC
    NSURL *url = [NSURL URLWithString:@"App-Prefs:root=General&path=About"];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        if(@available(iOS 10.0, *)){
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (IBAction)socialshare:(UIButton *)sender {
    //系统自带的分享
//    判断用户是否绑定账号密码
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]){
        SLComposeViewController * sVc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
        [self presentViewController:sVc animated:YES completion:nil];
    }
    else{
        SKLog(@"新浪微博-请输入账号密码");
    }
//    弹出一个分享窗口让用户输入内容
//    监听是否分享成功
}

@end
