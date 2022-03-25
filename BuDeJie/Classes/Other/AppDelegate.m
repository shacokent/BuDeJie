#import "AppDelegate.h"
#ifdef DEBUG//调试阶段
    #import "SKTabViewController.h"
#else//发布环境
    #import "SKADViewController.h"
#endif

#import <AFNetworking/AFNetworking.h>
//监听tabbarbutton点击，不推荐（一种方法补充）
//@interface AppDelegate ()<UITabBarControllerDelegate>
@interface AppDelegate ()

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

- (void)applicationDidBecomeActive:(UIApplication *)application{
    //清除通知角标
    application.applicationIconBadgeNumber =0;
}
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

//IOS12.4已经无效
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = touches.anyObject;
//    CGPoint point = [touch locationInView:nil];
//    if(point.y <= 20){
//        SKLog(@"点击了状态栏===%@",NSStringFromCGPoint(point));
//    }
//}
@end
