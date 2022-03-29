#import "AppDelegate.h"
#ifdef DEBUG//调试阶段
    #import "SKTabViewController.h"
#else//发布环境
    #import "SKADViewController.h"
#endif

#import <AFNetworking/AFNetworking.h>
#import <UserNotifications/UserNotifications.h>
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
@end
