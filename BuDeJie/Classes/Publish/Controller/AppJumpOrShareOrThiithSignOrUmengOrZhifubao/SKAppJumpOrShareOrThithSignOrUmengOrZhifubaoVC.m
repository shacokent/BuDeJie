//
//  SKAppJumpOrShareOrThithSignOrUmengOrZhifubaoVC.m
//  BuDeJie
//
//  Created by hongchen li on 2022/4/6.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKAppJumpOrShareOrThithSignOrUmengOrZhifubaoVC.h"
#import <Social/Social.h>
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>
#import "SKTestStaticLibraryTool.h"
#import <myTestFrameWork/SKTestStaticFrameWorkTool.h>
#import <dylibTestFrameWork/SKTestDylibFrameWorkTool.h>
#import "testThisProStaticLib.h"

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
    
    //打开应用,跳转微信，需要先在info里面设置URL types添加wechat，9.0之后需要在info中加入白名单key：LSApplicationQueriesSchemes（Array类型）添加一个元素wechat
//    目前版本15不需要白名单
//    NSURL *url = [NSURL URLWithString:@"wechat://"];

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
//    //系统自带的分享
////    判断用户是否绑定账号密码
//    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]){
//        SLComposeViewController * sVc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
//        //    弹出一个分享窗口让用户输入内容
//        [sVc setInitialText:@"内容"];
//        [sVc addImage:[UIImage imageNamed:@""]];
//        [sVc addURL:[NSURL URLWithString:@""]];
//        //    监听是否分享成功
//        [sVc setCompletionHandler:^(SLComposeViewControllerResult result) {
////            SLComposeViewControllerResultCancelled,
////            SLComposeViewControllerResultDone
//            SKLog(@"result---%zd",result);
//        }];
//        [self presentViewController:sVc animated:YES completion:nil];
//    }
//    else{
//        SKLog(@"新浪微博-请输入账号密码");
//    }
    //第三方友盟分享https://developer.umeng.com/docs/128606/detail/193653
//    //分享面板
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),
                                                  @(UMSocialPlatformType_QQ),
                                               @(UMSocialPlatformType_Sina)]];

    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        NSLog(@"选中分享平台类型:%ld",platformType);
        //授权
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
            if (error) {
                NSLog(@"************授权失败 %@*********",error);
                return;
            }
            else if(result){
                NSLog(@"授权成功---result:%@",result);
                //分享WebURL
            //    创建分享消息对象
                UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                //创建网页内容对象
                UIImage* image =  [UIImage imageNamed:@"icon"];
                UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"title" descr:@"descr" thumImage:image];
                //设置网页地址
                shareObject.webpageUrl = @"https://developer.umeng.com/";

                //分享消息对象设置分享内容对象
                messageObject.shareObject = shareObject;

                //调用分享接口
                [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                    if (error) {
                        NSLog(@"************分享失败 %@*********",error);
                    }else{
                        if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                            UMSocialShareResponse *resp = data;
                            //分享结果消息
                            NSLog(@"************分享成功 %@*********",resp.message);
                        }else{
                            NSLog(@"response data is %@",data);
                        }
                    }
                }];
            }
        }];
    }]; 
}

- (IBAction)signInOnClick:(UIButton *)sender {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {

           UMSocialUserInfoResponse *resp = result;

           // 第三方登录数据(为空表示平台未提供)
           // 授权数据
           NSLog(@" uid: %@", resp.uid);
           NSLog(@" openid: %@", resp.openid);
           NSLog(@" accessToken: %@", resp.accessToken);
           NSLog(@" refreshToken: %@", resp.refreshToken);
           NSLog(@" expiration: %@", resp.expiration);

           // 用户数据
           NSLog(@" name: %@", resp.name);
           NSLog(@" iconurl: %@", resp.iconurl);
           NSLog(@" gender: %@", resp.unionGender);

           // 第三方平台SDK原始数据
           NSLog(@" originalResponse: %@", resp.originalResponse);
       }];
}

#pragma mark - 调用静态库
/**
 备注：发布版本和调试版本区别
 调试版本断点会打印符号信息
 发布版本更快更小
 （打包库时注意）
 
 测试静态库：创建一个复合项目，在工程的Targets所在的列表下方点击+号创建静态库工程，然后再主工程的Targets-—>build phases->Target Depondencies中添加创建的静态库，然后Targets-—>build phases->Link Binary With libriries中添加静态库
 
 调用.a
 创建静态库，创建工程时选择static library
 需要暴露头文件，在build phases中的copy files点“+”，添加要暴露的.h头文件，并且删除subpath路径
 然后编译运行(注意选择真机，或者是模拟器)，运行成功，在上面菜单中选择product->show build folder in finder，静态库的.a文件和暴露的.h在Products中()
 
 查看静态库的架构
 终端，输入：lipo -nfo 静态库路径
 
！！静态库打包，模拟器打得包不能在真机上使用，因为架构不同，要想使用，需要打包两个静态库（真机版和模拟器版）之后进行合并操作：
 lipo -create 静态库路径1.a 静态库路径2.a -output 新静态库名字.a
 
报错have the same architectures (arm64) and can't be in the same fat output file处理方法
 在 Target->BuildSetting->Architectures->Excluded Architectures 中添加arm64（注打包时真机不添加，模拟器添加防止arm64重复无法打包）
 
 （如：真机：5S之后是arm64，5/5c是armv7,armv7s,3gp-4s是armv7
模拟器：4s-5:i386，5s以后X86_64）
 不同版本的IOS版本架构不一样，需要在静态库打包时设置Build Setting->Build Active->NO
 
 
 推荐使用framework
 
 调用framework
 创建静态库，创建工程时选择framework
 需要暴露头文件，在build phases中的Header,把要暴露的.h文件挪入public中
 然后编译运行(注意选择真机，或者是模拟器)，运行成功，在上面菜单中选择product->show build folder in finder，.framework文件在其中
 
 查看.framwork文件==文件夹，进入其中，查看unix文件
 终端，输入：lipo -nfo unix文件路径
 
 ！！静态库打包，模拟器打得包不能在真机上使用，因为架构不同，要想使用，需要打包两个静态库（真机版和模拟器版）之后进行合并操作：
  lipo -create 静态库真机路径/name.framework/name 静态库模拟器路径/name.framework/name -output 静态库真机路径/name.framework/name
  
 报错have the same architectures (arm64) and can't be in the same fat output file处理方法
  在 Target->BuildSetting->Architectures->Excluded Architectures 中添加arm64，以排除arm64（注打包时真机不添加，模拟器添加防止arm64重复无法打包）
 
 （如：真机：5S之后是arm64，5/5c是armv7,armv7s,3gp-4s是armv7
模拟器：4s-5:i386，5s以后X86_64）
 不同版本的IOS版本架构不一样，需要在静态库打包时设置Build Setting-> 搜索Build Active->NO
 然后Build Setting-> 搜索mach->更改static library（静态库）
 
 然后把.framwork加入要用的项目
 
 */

- (IBAction)testStaticLib:(UIButton *)sender {
    //调用.a
    [SKTestStaticLibraryTool logToConsole];
    //调用framework
    [SKTestStaticFrameWorkTool logFrameWorkTest];
    //测试自己工程的静态库
    [testThisProStaticLib logToConsole];
}


#pragma mark - 动态库
/**
 调用framework
 基本和静态库一样
 注意：然后Build Setting-> 搜索mach->更改Dynamic library（动态库）
 
 使用时，在使用的APP中设置
 在targets->General->Embedded Binaries中加入framework
 新版Xcode在targets->General->frameworks,libraries,Embedded content->动态库.framework的embed改为embed&sign
 然后在Buil Settings --> Build Options --> Validate Workspace 改为Yes
 
 */

- (IBAction)dylibTest:(UIButton *)sender {
    NSLog(@"dylibTest");
    [SKTestDylibFrameWorkTool logFrameWorkTest];
}

@end
