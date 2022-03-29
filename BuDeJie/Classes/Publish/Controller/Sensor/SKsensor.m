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
@interface SKsensor ()<UICollisionBehaviorDelegate>
@property (nonatomic,strong) CMMotionManager * manager;
//@property (nonatomic,strong) CMStepCounter *stepCount;
@property (nonatomic,strong) CMPedometer *stepPedometer;
@property (weak, nonatomic) IBOutlet UIImageView *box1;
@property (weak, nonatomic) IBOutlet UIImageView *box2;
@property (nonatomic,strong) UIDynamicAnimator * animator;
@end

@implementation SKsensor

- (UIDynamicAnimator *)animator{
    if(_animator == nil){
        //    创建物理仿真器
            UIDynamicAnimator * animator =  [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        _animator = animator;
    }
    return _animator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_register_background"]];
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
    
    //计步器
    
    //8.0前，Info.plist中加入NSMotionUsageDescription
    //判断计步器是否可用
//    if([CMStepCounter isStepCountingAvailable]){
//        CMStepCounter *stepCount = [[CMStepCounter alloc]init];
//        NSDate* startTime = [NSDate dateWithTimeIntervalSinceNow:-24*60*60];
//        NSDate* endTime = [NSDate dateWithTimeIntervalSinceNow:0];
//        //查询一天的步数
//        [stepCount queryStepCountStartingFrom:startTime to:endTime toQueue:[NSOperationQueue mainQueue] withHandler:^(NSInteger numberOfSteps, NSError * _Nullable error) {
//            SKLog(@"计步器---%zd",numberOfSteps);
//        }];
//        //走步状态每隔2秒计步一次
//        [stepCount startStepCountingUpdatesToQueue:[NSOperationQueue mainQueue] updateOn:2 withHandler:^(NSInteger numberOfSteps, NSDate * _Nonnull timestamp, NSError * _Nullable error) {
//            SKLog(@"计步器---startStepCountingUpdatesToQueue---%zd",numberOfSteps);
//        }];
//        _stepCount = stepCount;
//    }
    
    //8.0以后
    if([CMPedometer isStepCountingAvailable]){
        CMPedometer *stepCount = [[CMPedometer alloc]init];

        //查询一天的步数
//        NSDate* startTime = [NSDate dateWithTimeIntervalSinceNow:-24*60*60];
//        NSDate* endTime = [NSDate dateWithTimeIntervalSinceNow:0];
//        [stepCount queryPedometerDataFromDate:startTime toDate:endTime withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
//            SKLog(@"计步器---%@",pedometerData.numberOfSteps);
//        }];
        
        //从当前时间开始计步
        [stepCount startPedometerUpdatesFromDate:[NSDate dateWithTimeIntervalSinceNow:0] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
            SKLog(@"计步器---startPedometerUpdatesFromDate---%@",pedometerData.numberOfSteps);
        }];
        _stepPedometer = stepCount;
    }
    
    //UIDynamic
    //重力，//碰撞，//捕捉，//推动
}
//重力
-(void)gravity{

    //仿真行为
    UIGravityBehavior * behavior = [[UIGravityBehavior alloc] initWithItems:@[self.box1]];
    //设置重力方向和速度
//    behavior.gravityDirection = CGVectorMake(10, 10);
    //0代表右侧
//    behavior.angle = (CGFloat)M_PI;
//    //量级
//    behavior.magnitude =5;
    [self.animator addBehavior:behavior];
}
//碰撞
-(void)collision{
    //仿真行为
    UICollisionBehavior * behavior = [[UICollisionBehavior alloc] initWithItems:@[self.box1,self.box2]];
    //设置屏幕可视范围为碰撞边界
    behavior.translatesReferenceBoundsIntoBoundary =YES;
    //设置边界的内边距
    [behavior setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    //添加一个边界
    [behavior addBoundaryWithIdentifier:@"边界标识" fromPoint:CGPointMake(0, 500) toPoint:CGPointMake(self.view.sk_width, 300)];
    
    //碰撞代理,UICollisionBehaviorDelegate
    behavior.collisionDelegate = self;
    
//    UICollisionBehaviorModeItems//只碰撞元素
//    UICollisionBehaviorModeBoundaries//只碰撞边界
//    UICollisionBehaviorModeEverything//都碰撞，默认
//    behavior.collisionMode = UICollisionBehaviorModeEverything;
    [self.animator addBehavior:behavior];
}
//捕捉
-(void)snap:(CGPoint)point{
//    如果想要多次执行捕捉行为，那必须在之前益处已经添加的捕捉行为
    [self.animator removeAllBehaviors];
    UISnapBehavior * behavior = [[UISnapBehavior alloc] initWithItem:self.box2 snapToPoint:point];
    behavior.damping = 0.5;//0.0~1.0//震动，越接近1越硬
    [self.animator addBehavior:behavior];
}
//推动
-(void)push{
// UIPushBehaviorMode：
//    UIPushBehaviorModeContinuous//一直推
//    UIPushBehaviorModeInstantaneous//推一次
    UIPushBehavior * behavior = [[UIPushBehavior alloc] initWithItems:@[self.box1] mode:UIPushBehaviorModeInstantaneous];
    //设置推的方向
    behavior.pushDirection = CGVectorMake(0, -5);
    [self.animator addBehavior:behavior];
}

#pragma mark - UICollisionBehaviorDelegate
- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p{
    //元素和元素开始碰撞
    SKLog(@"元素和元素开始碰撞---%@",NSStringFromCGPoint(p));
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2{
    //元素和元素结束碰撞
    SKLog(@"元素和元素结束碰撞");
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p{
    //元素和边界开始碰撞
    SKLog(@"元素和边界开始碰撞---%@",NSStringFromCGPoint(p));
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier{
    //元素和边界结束碰撞
    SKLog(@"元素和边界结束碰撞---%@",identifier);
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
    //捕捉
    [self snap:[[touches anyObject] locationInView:self.view]];
    //重力
    [self gravity];
    //碰撞
    [self collision];
    //推动
    [self push];
    
    
    
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
