//
//  SKlocationVC.m
//  BuDeJie
//
//  Created by hongchen li on 2022/3/16.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKlocationVC.h"
#import <CoreLocation/CoreLocation.h>
#import "INTULocationManager.h"//第三方定位框架
#import <MapKit/MapKit.h>

@interface SKlocationVC ()<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,strong) CLLocationManager *manager;
@property (nonatomic,strong) CLLocation *lastlocation;
@property (weak, nonatomic) IBOutlet UIImageView *zhinanzhenImage;
@property (nonatomic,strong) CLCircularRegion * region;
@end

@implementation SKlocationVC
- (CLLocationManager *)manager{
    if(_manager == nil){
        //创建位置管理者，
        CLLocationManager *manager = [[CLLocationManager alloc]init];
        manager.delegate=self;
        //前台定位需要info.plist加入NSLocationWhenInUseUsageDescription
//        [manager requestWhenInUseAuthorization];//请求前台定位授权
        //前后台定位需要info.plist加入NSLocationAlwaysAndWhenInUseUsageDescription，NSLocationWhenInUseUsageDescription，需要在项目管理中加入后台模式勾选定位,需要设置allowsBackgroundLocationUpdates
        manager.allowsBackgroundLocationUpdates = YES;
//        每隔一段距离定位一次，设置过滤距离,每大于100米定位一次，//经纬跨度：1度约等于111KM
//        manager.distanceFilter = 100;
//        定位精度设置，精确度越高越耗电，定位时间越长
//        kCLLocationAccuracyBestForNavigation//最适合导航
//        kCLLocationAccuracyBest;//最好的
//        kCLLocationAccuracyNearestTenMeters;//附近10米
//        kCLLocationAccuracyHundredMeters;//附近100米
//        kCLLocationAccuracyKilometer;//附近1000米
//        kCLLocationAccuracyThreeKilometers;//附近3000米
        manager.desiredAccuracy = kCLLocationAccuracyBest;
        [manager requestAlwaysAuthorization];//请求前后台定位授权
        _manager = manager;
    }
    return _manager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //一、 定位
//    使用位置管理者创建位置信息
//    小经验：如果以后使用位置管理者对象，实现某个服务，那么可以以startXX开始某个服务 以stopXX停止某个服务
    [self.manager startUpdatingLocation];//（推荐）自动的选择定位
//    [self.manager requestLocation];//只定位一次，从低到高尝试定位，把最好的返回，或者是超时返回，最后都定位不到会失败返回，必须实现失败代理,不能与startUpdatingLocation同时使用
    
//   二、 指南针
    if(CLLocationManager.headingAvailable){
        [self.manager startUpdatingHeading];
    }
    else{
        SKLog(@"磁力器设备损坏");
    }
    
//    三、区域监听
    
    //判断当前，时候可以监听某个区域
    if([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]){
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(21.123, 121.345);//监听位置定位
        CLLocationDistance distance = 1000;//监听距离半径
        //如果设置的区域大于最大监听区域，就把最大的监听区域赋值
        if(distance > self.manager.maximumRegionMonitoringDistance){
            distance = self.manager.maximumRegionMonitoringDistance;
        }
        CLCircularRegion * region = [[CLCircularRegion alloc] initWithCenter:coordinate radius:distance identifier:@"标识"];
        _region = region;
        [self.manager startMonitoringForRegion:region];
        
        //请求某个区域的状态，解决第一次进入时不知道是否在区域监听中
        [self.manager requestStateForRegion:region];//通过代理获得
    }
    
    //四、第三方框架
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    //单次定位
    //delayUntilAuthorized：超市时间从什么时候开始计算
    //NO：从执行这个代码开始计算
    //YES：从用户授权之后开始计算
    INTULocationRequestID ID = [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyCity timeout:10.0 delayUntilAuthorized:YES block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        if (status == INTULocationStatusSuccess) {
            SKLog(@"单次定位-%@",currentLocation);
         }
         else if (status == INTULocationStatusTimedOut) {
             SKLog(@"单次定位-超时");
         }
         else {
             SKLog(@"单次定位-其他");
         }
     }];
    [locMgr forceCompleteLocationRequest:ID];//强制结束定位，只能配合单次定位使用，并执行单次定位的block
    //持续定位
    INTULocationRequestID ID2 = [locMgr subscribeToLocationUpdatesWithDesiredAccuracy:INTULocationAccuracyCity block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        if (status == INTULocationStatusSuccess) {
            SKLog(@"持续定位-%@",currentLocation);
         }
         else if (status == INTULocationStatusTimedOut) {
             SKLog(@"持续定位-超时");
         }
         else {
             SKLog(@"持续定位-其他");
         }
    }];
    [locMgr cancelLocationRequest:ID2];//强制结束定位,不会执行定位的block
    
    
    //五、地图
    //样式
//    MKMapTypeStandard//标准
//    MKMapTypeSatellite//卫星
//    MKMapTypeHybrid//标准+卫星
//    MKMapTypeSatelliteFlyover//3D立体卫星
//    MKMapTypeHybridFlyover//3D立体混合
//    MKMapTypeMutedStandard//静音标准
    self.mapView.mapType = MKMapTypeStandard;
//    self.mapView.scrollEnabled = NO;//是否可以拖动
//    self.mapView.rotateEnabled =NO;//是否可以旋转
//    self.mapView.zoomEnabled = NO;//是否可以放大
//    设置地图的显示项
//    self.mapView.showsScale = NO;//显示比例尺
//    self.mapView.showsBuildings = NO;//显示建筑
//    self.mapView.showsCompass = NO;//显示指南针
//    self.mapView.showsPointsOfInterest = NO;//显示兴趣点
//    self.mapView.showsTraffic = NO;//显示交通状况
    self.mapView.showsUserLocation = YES;//    显示用户位置,不会放大，不会跟着用户跑
    self.mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;//用户的追踪模式，会方法，跟着用户跑，但是拖动地图可能会失效
    
}
#pragma mark - CLLocationManagerDelegate
#pragma mark - 定位
/// 定位到之后的调用
/// @param manager 位置管理者
/// @param locations 位置对象数组
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    if(!locations.lastObject) return;
//CLLocation:
//    coordinate：经纬度：经度latitude，纬度longitude
//    altitude:海拔
//    horizontalAccuracy如果这个数字是负数，就代表位置数据无效
//    verticalAccuracy如果这个数字是负数，就代表海拔数据无效
//    course航向，正北方向夹角0.0 - 359.9度
//    speed速度
//    [CLLocation_1 distanceFromLocation:CLLocation_2]计算两个经纬度之间的直线距离
    if(locations.lastObject.horizontalAccuracy< 0) return;
    
//        1.获取当前行走航向
    NSArray *arry = @[@"北偏东",@"东偏南",@"南偏西",@"西偏北"];
    NSString *course = arry[((int)locations.lastObject.course)/90];
//        2.行走偏离角度
    int angle = ((int)locations.lastObject.course)%90;
//        3.移动米数
    CLLocation * lastLocation = self.lastlocation;
    CLLocationDistance meter = [locations.lastObject distanceFromLocation:lastLocation];
    self.lastlocation = locations.lastObject;
    //        4.合并打印字符串
    if(angle ==0){
        course = [course substringToIndex:1];
        SKLog(@"向正%@方向移动了%f米 ",course,meter);
    }
    else{
        SKLog(@"向%@%d度方向移动了%f米 ",course,angle,meter);
    }
    
    //使用startUpdatingLocation只定位一次调用stopUpdatingLocation结束定位
//    [self.manager stopUpdatingLocation];//停止定位
    
    
    //地理编码
    CLGeocoder *geo = [[CLGeocoder alloc] init];
    [geo geocodeAddressString:@"北京市" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        //结果按着相关性排序，优先取第一个
            SKLog(@"地理编码-%@",placemarks.firstObject.location);
    }];
    //反地理编码locations.lastObject
    CLGeocoder *reversegeo = [[CLGeocoder alloc] init];
    [reversegeo reverseGeocodeLocation:locations.lastObject completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        SKLog(@"%@",error);
        SKLog(@"反地理编码-%@",placemarks.firstObject.name);
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    SKLog(@"定位失败,可以重新开始定位");
    [self.manager startUpdatingLocation];
//    [self.manager requestLocation];//从低到高尝试定位，把最好的返回，或者是超时返回，最后都定位不到会失败返回，必须实现失败代理
}

/// 授权状态发生改变时
/// @param manager 位置管理者
/// @param status 状态
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusDenied://拒绝
            //判断定位是否被拒绝true证明当前应用开启了定位，但是手机的定位功能被关闭
            if([CLLocationManager locationServicesEnabled]){
                SKLog(@"应用开启了定位，手机的定位功能被关闭,提示开启手机定位服务");
            }
            else{
                SKLog(@"跳转授权，提示给APP开启定位授权");
            }
            break;
        default:
            break;
    }
}

#pragma mark - 指南针
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
//    SKLog(@"%@",newHeading);
    //拿到当前设备朝向,磁北角度magneticHeading，正北方向trueHeading
    //角度
    CLLocationDirection angle = newHeading.magneticHeading;
    //角度转换弧度
    CGFloat hudu = angle/180 *M_PI;
    //反向旋转图片
    [UIView animateWithDuration:0.5 animations:^{
        self.zhinanzhenImage.transform = CGAffineTransformMakeRotation(-hudu);
    }];
}


#pragma mark - 监听区域
///进入区域时调用
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    SKLog(@"进入区域-%@",region.identifier);
}
///离开区域时调用
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    SKLog(@"离开区域-%@",region.identifier);
}
///获取区域的状态
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    if([region.identifier isEqualToString:@"标志"]){
        switch (state) {
            case CLRegionStateUnknown:
                SKLog(@"不知道");
                break;
            case CLRegionStateInside:
                SKLog(@"进入区域");
                break;
            case CLRegionStateOutside:
                SKLog(@"离开区域");
                break;
            default:
                break;
        }
    }
    
}
- (void)dealloc{
    [self.manager stopUpdatingLocation];
    [self.manager stopUpdatingHeading];
    [self.manager stopMonitoringForRegion:self.region];
}
@end
