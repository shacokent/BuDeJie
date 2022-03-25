//
//  SKPushNotification.m
//  BuDeJie
//
//  Created by hongchen li on 2022/3/24.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKPushNotification.h"

@interface SKPushNotification ()

@end

@implementation SKPushNotification

- (void)viewDidLoad {
    [super viewDidLoad];
    [self isNotfAuth];
}

//如果是IOS8.0以前可以直接发送，8.0以后需要主动请求授权
-(void)isNotfAuth{
    //创建一组操作行为
    UIMutableUserNotificationCategory * category = [[UIMutableUserNotificationCategory alloc] init];
    category.identifier = @"组标识";
    //设置组的操作行为，监听行为需要在AppDelegate中的handleActionWithIdentifier方法中操作
    UIMutableUserNotificationAction * action = [[UIMutableUserNotificationAction alloc]init];
    action.title = @"操作行为1";
    action.identifier =@"操作行为1标识";
    //用户模式，点击了这个动作是在前台还是在后台
    action.activationMode = UIUserNotificationActivationModeForeground;//会切换到前台在执行
    //authenticationRequired==YES必须要解锁之后行为才会执行，如果activationMode设置前台，那么这个属性会被忽略
    action.authenticationRequired = YES;
    //是否是破坏性行为,设置为YES则会显示红色标识
    action.destructive = YES ;
    
    UIMutableUserNotificationAction * action2 = [[UIMutableUserNotificationAction alloc]init];
    action2.title = @"操作行为2";
    action2.identifier =@"操作行为2标识";
    action2.activationMode = UIUserNotificationActivationModeBackground;//在后台就可以执行
    action2.authenticationRequired = YES;
    action2.destructive = NO ;
//    行为触发文本框，检测文本框输入发送的内容需要在AppDelegate中的handleActionWithIdentifier方法中操作
    action2.behavior = UIUserNotificationActionBehaviorTextInput;
    //设置输入框的发送按钮文字
    action2.parameters = @{UIUserNotificationTextInputActionButtonTitleKey:@"发送按钮文字"};
    
    NSArray<UIUserNotificationAction *> * actions =@[action,action2];
//    UIUserNotificationActionContextDefault:弹框样式通知，最多4个按钮
//    UIUserNotificationActionContextMinimal:弹框样式通知空间不足，最多2个按钮
    [category setActions:actions forContext:UIUserNotificationActionContextDefault];
    //附加操作行为
    NSSet<UIUserNotificationCategory *> * categories = [NSSet setWithObjects:category, nil];
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeNone|UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:categories];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

- (IBAction)sendNotf:(UIButton *)sender {
//一、本地通知
//    创建本地通知
    UILocalNotification * localNof = [[UILocalNotification alloc] init];
    //通知的必须项
    localNof.alertTitle = @"alertTitle";
    localNof.alertBody = @"alertBody";
    //通知角标,在AppDelegate中的applicationDidBecomeActive方法，实现进入软件清除角标数
    localNof.applicationIconBadgeNumber = 1;
    //发送时间
    localNof.fireDate = [NSDate dateWithTimeIntervalSinceNow:3];
    //设置锁屏滑动文字，
    localNof.alertAction = @"alertAction";
    //设置通知声音
//    localNof.soundName = @"音频名";
    //9.0以前有效启动图片：当用户点击了本地通知，启动我们APP时带的启动图片
//    localNof.alertLaunchImage = @"LaunchImage-700";
//    发送本地通知
    //立即发送
//    [[UIApplication sharedApplication] presentLocalNotificationNow:localNof];
    //设置通知的组标识
    localNof.category = @"组标识";
    
    //根据设置的时间那发送
    [[UIApplication sharedApplication] scheduleLocalNotification:localNof];
    
    
    //！！重要：在AppDelegate中的didReceiveLocalNotification中监测到用户点击通知从后台进入APP或者APP就在前台时触发此方法，完全关闭软件，不会触发，需要查看didFinishLaunchingWithOptions的launchOptions，如果app不是通过正常启动（点击图标启动），都会把信息放在这个字典中
    
    
//    二、远程推送利用deviceToken（像苹果注册远程通知时获得，是由bounldID+UUID计算生成）https://www.jianshu.com/p/ec249057fac7
    
}

- (IBAction)cancelNotf:(UIButton *)sender {
    //取消所有通知
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (IBAction)showNotf:(UIButton *)sender {
//    查看所有通知
    SKLog(@"%@",[[UIApplication sharedApplication] scheduledLocalNotifications]);
}

@end
