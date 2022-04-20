#import "AppDelegate.h"
#ifdef DEBUG//调试阶段
    #import "SKTabViewController.h"
#else//发布环境
    #import "SKADViewController.h"
#endif
#import <AFNetworking/AFNetworking.h>
#import <UserNotifications/UserNotifications.h>
#import <objc/message.h>
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>
#import <UMPush/UMessage.h>

//监听tabbarbutton点击，不推荐（一种方法补充）
//@interface AppDelegate ()<UITabBarControllerDelegate>
@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

//监听tabbarbutton点击，不推荐（一种方法补充）
//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
//    SKFunc;
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    如果app不是通过正常启动（点击图标启动），都会把信息放在这个字典中launchOptions
    if(launchOptions != nil){
        if(launchOptions[UIApplicationLaunchOptionsLocalNotificationKey] != nil){
            [SVProgressHUD showInfoWithStatus:@"点击了本地通知进入"];
        }
    }
    SKLog(@"%@",[NSBundle mainBundle].bundleIdentifier);
    
    //远程推送注册
    if (@available(iOS 10.0, *)) {
//  必须在sign&capalities 中添加 push notifications
//  Code=3000 "未找到应用程序的“aps-environment”的授权字符串"解决：https://cloud.tencent.com/developer/article/1365780
//  实现方法 https://www.jianshu.com/p/406378355804
//  实现方法+添加action:    https://www.jianshu.com/p/2c8cf1ccf625
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //必须写代理，不然无法监听通知的接收与点击事件
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error && granted) {
                //用户点击允许
                NSLog(@"远程推送注册成功");
            }else{
                //用户点击不允许
                NSLog(@"远程推送注册失败");
            }
        }];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else if(@available(iOS 8.0,*)){
        UIUserNotificationType type = UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound;
        UIUserNotificationSettings * setting = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else{
        UIRemoteNotificationType type = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:type];
    }
    
    //友盟分享集成
    [UMConfigure initWithAppkey:@"624fe5850059ce2bad28b5b2" channel:@"test"];
    // U-Share 平台设置
    [self confitUShareSettings];
    [self configUSharePlatforms];
    //友盟推送集成
//    [UMConfigure initWithAppkey:@"624fe5850059ce2bad28b5b2" channel:@"test"];
    // Push组件基本功能配置
    UMessageRegisterEntity* entity =[[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
        entity.types =UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
    if (@available(iOS 10.0, *)) {
        [UNUserNotificationCenter currentNotificationCenter].delegate=self;
    } else {
        // Fallback on earlier versions
    }
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted,NSError*_Nullable error){
        if (!error && granted) {
            //用户点击允许
            NSLog(@"UMessage远程推送注册成功");
        }else{
            //用户点击不允许
            NSLog(@"UMessage远程推送注册失败");
        }
    }];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    //    2.设置控制器
#ifdef DEBUG//调试阶段
    SKTabViewController * sktabVC =  [[SKTabViewController alloc]init];
//    sktabVC.delegate = self;//监听tabbarbutton点击，不推荐（一种方法补充）
    self.window.rootViewController = sktabVC;
#else//发布环境
    self.window.rootViewController = [[SKADViewController alloc]init];
#endif
    
    
    //    3.显示窗口
    [self.window makeKeyAndVisible];
    
    //4.开启网络监控
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    return YES;
}

#pragma mark - 授权申请token回调
- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSData  *apnsToken = [NSData dataWithData:deviceToken];
    NSString *tokenString = [self getHexStringForData:apnsToken];
    NSLog(@"token获取成功 = %@", tokenString);
    
}

- (NSString *)getHexStringForData:(NSData *)data {
    NSUInteger length = [data length];
    char *chars = (char *)[data bytes];
    NSMutableString *hexString = [[NSMutableString alloc] init];
    for (NSUInteger i = 0; i < length; i++) {
        [hexString appendString:[NSString stringWithFormat:@"%0.2hhx", chars[i]]];
    }
    return hexString;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"token获取失败: %@", error);
}

#pragma mark - 接收远程通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    //前台，从后台进入前台都会执行，完全退出不执行
    [SVProgressHUD showInfoWithStatus:@"接收到远程通知"];
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    if(state == UIApplicationStateActive){
        //在前台，收到通知，加一个提醒数字
    }else if(state == UIApplicationStateInactive){
        //在后台点击了通知进入前台，打开对应的窗口
    }
}
//这个方法实现上面的-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo方法不在执行
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
//  前台，从后台进入前台，完全退出都会执行
//要求：只要接收到通知，不管当前APP的状态，在后台，锁屏都自动执行这个方法，不用点击
//1.必须勾选后台模式：Remote Notification
//2.告诉系统是否有新内容（执行完成代码块completionHandler）
//3.设置发送通知的格式（"content-available":"随便传"）格式：{"aps":{"alert":"some message","badge":1,"content-available":"随便传"}}
//    [SVProgressHUD showInfoWithStatus:@"接收到远程通知-带block-完全退出在进入前台也会执行"];
//调用系统代码块的作用
//1.系统会估量App消耗的电量，并根据传递的UIBackgroundFetchResult参数记录新数据是否可用
//2.调用完成处理代码时，缩略图会自动更新（缩略图指的是双击HOME，看到后台打开的应用时显示的应用图）
//    completionHandler(UIBackgroundFetchResultNewData);
//}

#pragma mark - 接收本地通知
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    [SVProgressHUD showInfoWithStatus:@"接收到通知"];
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    if(state == UIApplicationStateActive){
        //在前台，收到通知，加一个提醒数字
    }else if(state == UIApplicationStateInactive){
        //在后台点击了通知进入前台，打开对应的窗口
    }
    
}

//- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)(void))completionHandler{
//    SKLog(@"通知行为监听---行为标识---%@",identifier);
//    //必须执行
//    completionHandler();
//}

//9.0以后才有
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)(void))completionHandler{
    SKLog(@"通知行为监听---行为标识---%@---发送的文本---%@",identifier,responseInfo);
    //必须执行
    completionHandler();
}

- (void)applicationWillResignActive:(UIApplication *)application{
    
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    //清除通知角标
    application.applicationIconBadgeNumber =0;
}

//IOS12.4已经无效
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = touches.anyObject;
//    CGPoint point = [touch locationInView:nil];
//    if(point.y <= 20){
//        SKLog(@"点击了状态栏===%@",NSStringFromCGPoint(point));
//    }
//}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    SKLog(@"监测通过URL打开我们的BuDeJie APP---%@",url);
//    URL如果等于：tiantianairecsample://history?mytest，那么url.host == history 参数url.query == mytest,被跳转的APP可以利用这个值（mytest）返回原来的APP，或者添加多个值，实现更多功能
    SKLog(@"url.query---%@",url.query);
    if([url.host isEqualToString:@"new"]){
        //跳转history
        UITabBarController *nav = (UITabBarController*)self.window.rootViewController;
        [nav dismissViewControllerAnimated:YES completion:nil];
        for(UIView * view in nav.view.subviews){
            if([view isKindOfClass:NSClassFromString(@"SKTabBar")]){
                NSInteger i =0;
                for(UIView * subview in view.subviews){
                    if([subview isKindOfClass:NSClassFromString(@"UITabBarButton")]){
                        if(i == 1){
                            //不报漏sktabBar的方法，使用runtime
                            void (* my_objc_msgSend_withView)(id,SEL,UIView*) = (void (*) (id,SEL,UIView*))objc_msgSend;//真机不能直接使用objc_msgSend，必须加上这句声明自己的objc_msgSend才能用，否则报错
                            my_objc_msgSend_withView(view, @selector(tabBarBtnClick:),subview);
                            nav.selectedIndex = i;
                            break;
                        }
                        i++;
                    }
                }
            }
        }
        
        for(UIViewController * vc in nav.childViewControllers){
            for(UIViewController * subvc in vc.childViewControllers){
                if([subvc isKindOfClass:NSClassFromString(@"SKNewViewController")]){

                    //不报漏sktabBar的方法，使用runtime
                    void (* my_objc_msgSend_withView)(id,SEL) = (void (*) (id,SEL))objc_msgSend;//真机不能直接使用objc_msgSend，必须加上这句声明自己的objc_msgSend才能用，否则报错
                    my_objc_msgSend_withView(subvc, @selector(tagClick));
                    break;;
                }
            }
        }

    }
    return YES;
}
//9.0过期
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
//    SKLog(@"监测通过URL打开我们的APP");
//    return YES;
//}


#pragma mark - 友盟分享

-(void)confitUShareSettings
{
/*
     * 打开图片水印
     */
//[UMSocialGlobal shareInstance].isUsingWaterMark = YES;

/*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    // 微信、QQ、微博完整版会校验合法的universalLink，不设置会在初始化平台失败
       //配置微信Universal Link需注意 universalLinkDic的key是rawInt类型，不是枚举类型 ，即为 UMSocialPlatformType.wechatSession.rawInt
    [UMSocialGlobal shareInstance].universalLinkDic =@{@(UMSocialPlatformType_WechatSession):@"https://umplus-sdk-download.oss-cn-shanghai.aliyuncs.com/",
    @(UMSocialPlatformType_QQ):@"https://umplus-sdk-download.oss-cn-shanghai.aliyuncs.com/qq_conn/101830139",
     @(UMSocialPlatformType_Sina):@"https://umplus-sdk-download.oss-cn-shanghai.aliyuncs.com/"};

    //extraInitDic，企业微信增加了corpid和agentid，故在UMSocialGlobal的全局配置里面增加extraInitDic来存储额外的初始化参数。extraInitDic的key:corpId和agentId为固定值
//    [UMSocialGlobal shareInstance].extraInitDic =@{
//    @(UMSocialPlatformType_WechatWork):@{@"corpId":@"wwac6ffb259ff6f66a",@"agentId":@"1000002"}
//    };
}

-(void)configUSharePlatforms{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxdc1e388c3822c80b" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:@"http://mobile.umeng.com/social"];
    /*设置小程序回调app的回调*/
//    [[UMSocialManager defaultManager] setLauchFromPlatform:(UMSocialPlatformType_WechatSession) completion:^(id userInfoResponse,NSError*error){
//    NSLog(@"setLauchFromPlatform:userInfoResponse:%@",userInfoResponse);
//    }];

//    /* 设置分享到QQ互联的appID，
//         * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
//        */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105821097"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
//
//    /* 设置新浪的appKey和appSecret */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
//
//    /* 钉钉的appKey */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_DingDing appKey:@"dingoalmlnohc0wggfedpk" appSecret:nil redirectURL:nil];
//
//    /* 设置企业微信的appKey和appSecret */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatWork appKey:@"wwauthac6ffb259ff6f66a000002" appSecret:@"EU1LRsWC5uWn6KUuYOiWUpkoH45eOA0yH-ngL8579zs" redirectURL:nil];
//
//    /* 设置抖音的appKey和appSecret */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_DouYin appKey:@"awd1cemo6d0l69zp" appSecret:@"a2dce41fff214270dd4a7f60ac885491" redirectURL:nil];
//
//    /* 设置易信的appKey */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_YixinSession appKey:@"yx35664bdff4db42c2b7be1e29390c1a06" appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
//
//
//    /* 设置领英的appKey和appSecret */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Linkedin appKey:@"81t5eiem37d2sc"  appSecret:@"7dgUXPLH8kA8WHMV" redirectURL:@"https://api.linkedin.com/v1/people"];
//
//    /* 设置Twitter的appKey和appSecret */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Twitter appKey:@"fB5tvRpna1CKK97xZUslbxiet"  appSecret:@"YcbSvseLIwZ4hZg9YmgJPP5uWzd4zr6BpBKGZhf07zzh3oj62K" redirectURL:nil];
//
//    /* 设置Facebook的appKey和UrlString */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Facebook appKey:@"506027402887373"  appSecret:nil redirectURL:@"http://www.umeng.com/social"];
//
//    /* 设置Pinterest的appKey */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Pinterest appKey:@"4864546872699668063"  appSecret:nil redirectURL:nil];
//
//    /* dropbox的appKey */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_DropBox appKey:@"k4pn9gdwygpy4av" appSecret:@"td28zkbyb9p49xu" redirectURL:@"https://mobile.umeng.com/social"];
//
//    /* vk的appkey */
//    [[UMSocialManager defaultManager]  setPlaform:UMSocialPlatformType_VKontakte appKey:@"5786123" appSecret:nil redirectURL:nil];

}
@end
