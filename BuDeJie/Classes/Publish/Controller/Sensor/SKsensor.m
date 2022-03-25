//
//  SKsensor.m
//  BuDeJie
//
//  Created by hongchen li on 2022/3/24.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKsensor.h"
#import <CoreMotion/CoreMotion.h>

//IOS4前，加速计代理
//@interface SKsensor ()<UIAccelerometerDelegate>
@interface SKsensor ()
@property (nonatomic,strong) CMMotionManager * manager;
@end

@implementation SKsensor

- (void)viewDidLoad {
    [super viewDidLoad];
//    开启距离传感器
    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
    //监听物体靠近或离开设备的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityChange) name:UIDeviceProximityStateDidChangeNotification object:nil];
    
//   IOS4前， 开启加速计
//    UIAccelerometer *accelerometer =  [UIAccelerometer sharedAccelerometer];
//    //采样间隔
//    accelerometer.updateInterval = 1;
//    accelerometer.delegate = self;
    
//    IOS4后，开启加速计
    CMMotionManager * manager = [[CMMotionManager alloc] init];
    //加速计是否可用
    if(!manager.accelerometerAvailable){
        SKLog(@"加速计不可用");
    }
    //采样间隔
    manager.accelerometerUpdateInterval = 1;
    
    //拉模式，需要主动去拉取数据
    [manager startAccelerometerUpdates];
    
    //推模式，把数据主动告诉外界
    [manager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        if(error == nil){
            SKLog(@"加速计***%f***%f***%f",accelerometerData.acceleration.x,accelerometerData.acceleration.y,accelerometerData.acceleration.z);
        }
    }];
    _manager = manager;
    
    
    //摇一摇IOS内置API
//    - (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
//    - (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
//    - (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
    
}
//摇一摇
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    SKLog(@"开始");
}
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    SKLog(@"结束");
}
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    SKLog(@"取消（如电话接入）");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    SKLog(@"点击屏幕获取拉模式的数据***%f***%f***%f",self.manager.accelerometerData.acceleration.x,self.manager.accelerometerData.acceleration.y,self.manager.accelerometerData.acceleration.z);
    
}

//#pragma mark - UIAccelerometerDelegate
//IOS4前
//- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
//    SKLog(@"%f***%f***%f",acceleration.x,acceleration.y,acceleration.z);
//    //加速计代理
//}



//距离传感器,监听物体靠近或离开设备的通知
-(void)proximityChange{
    if([UIDevice currentDevice].proximityState){
        SKLog(@"靠近");
    }
    else{
        SKLog(@"离开");
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
