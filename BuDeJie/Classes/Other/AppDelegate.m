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
