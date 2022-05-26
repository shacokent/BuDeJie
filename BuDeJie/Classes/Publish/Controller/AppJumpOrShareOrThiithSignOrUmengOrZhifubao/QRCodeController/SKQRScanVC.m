//
//  SKQRScanVC.m
//  BuDeJie
//
//  Created by hongchen li on 2022/5/25.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKQRScanVC.h"
#import "AVFoundation/AVFoundation.h"

@interface SKQRScanVC ()<AVCaptureMetadataOutputObjectsDelegate>
@property (weak, nonatomic) IBOutlet UIView *scanBackView;

@property (weak, nonatomic) IBOutlet UIImageView *QRborderView;
@property (weak, nonatomic) IBOutlet UIImageView *QRscanlineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toScanlineBotton;
@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *vediolayer;
@end

@implementation SKQRScanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self startScanAnimation];
    [self startScan];
}

#pragma mark - 开始扫描
-(void)startScan{
    
//    1.设置输入
//    1.1获取摄像头
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    1.2把摄像头设备当做输入设备
    NSError *error =nil;
    AVCaptureDeviceInput * deviceInpiut = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if(error){return;}
//    2.设置输出
    AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc]init];
//    2.1设置结果处理的代理
    [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//    2.2设置扫描范围，限定二维码出现在扫描框中才识别
//    CGRectMake(0, 0, 1, 1)，rectOfInterest的值的范围在0.0-1.0之间，是一个比例，扫描框宽高/屏幕预览相机的范围宽高
//    注意这个的0,0在右上角，所以计算的时候注意y和x计算后调换，width和height计算后调换
    CGFloat x = self.scanBackView.frame.origin.x/self.view.layer.bounds.size.width;
    CGFloat y = self.scanBackView.frame.origin.y/self.view.layer.bounds.size.height;
    CGFloat width = self.scanBackView.frame.size.width/self.view.layer.bounds.size.width;
    CGFloat height = self.scanBackView.frame.size.height/self.view.layer.bounds.size.height;
    metadataOutput.rectOfInterest = CGRectMake(y, x, height,width);
//    3.创建会话，链接输入和输出
    AVCaptureSession *session = [[AVCaptureSession alloc]init];
    if([session canAddInput:deviceInpiut] && [session canAddOutput:metadataOutput]){
        [session addInput:deviceInpiut];
        [session addOutput:metadataOutput];
    }
    else{return;}
//    3.1设置二维码可以识别的码制（这段代码设置识别的类型，必须在输出添加到会话（session）之后才可以设置，不然会崩溃）
//    metadataOutput.availableMetadataObjectTypes//识别所有类型
    metadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];//设置识别二维码
//    3.2添加视频预览图层,不是必须的
    AVCaptureVideoPreviewLayer *vediolayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    vediolayer.frame = self.view.layer.bounds;
    _vediolayer = vediolayer;
//    [self.view.layer addSublayer:vediolayer];添加最上层会挡住扫描动画视图
    [self.view.layer insertSublayer:vediolayer atIndex:0];//添加到指定层
    
    _session = session;
//    4.启动会话（让输入开始采集，输出开始处理数据）
    [session startRunning];
}

#pragma mark - 输出代理
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    [self removeFrame];
    for(AVMetadataObject * obj in metadataObjects){
        if([obj isKindOfClass:[AVMetadataMachineReadableCodeObject class]]){
//            转换二维码坐标成为预览图层的坐标系
            AVMetadataObject * resultObj = [self.vediolayer transformedMetadataObjectForMetadataObject:obj];
            AVMetadataMachineReadableCodeObject* qrCodeObj = (AVMetadataMachineReadableCodeObject*)resultObj;
            [self drawFrame:qrCodeObj];
        }
    }
}

#pragma mark - 绘制二维码扫描边框
-(void)drawFrame:(AVMetadataMachineReadableCodeObject*)qrCodeObj{
    NSArray<NSDictionary*>* conrers = qrCodeObj.corners;
//    1.借助一个图形层来绘制
    CAShapeLayer *shaplayer = [[CAShapeLayer alloc]init];
    shaplayer.fillColor = [[UIColor clearColor] CGColor];
    shaplayer.strokeColor = [[UIColor redColor] CGColor];
    shaplayer.lineWidth = 6;
//    2.根据四个点来创建一个路径
    UIBezierPath *path = [[UIBezierPath alloc] init];
    int index =0;
    for(NSDictionary* dict in conrers){
        CGPoint point = CGPointZero;
        CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)dict, &point);
        //    第一个点
        if(index == 0){
            [path moveToPoint:point];
        }
        else{
            [path addLineToPoint:point];
        }
        index += 1;
    }
    [path closePath];
//    3.给图形图层的路径赋值，代表图层展示怎样的形状
    shaplayer.path = path.CGPath;
//    4.添加图型图层到需要展示的图层
    [self.vediolayer addSublayer:shaplayer];
}

#pragma mark - 移除二维码边框
-(void)removeFrame{
    //enumerateObjectsUsingBlock方法便利数组，避免用for方法遍历数组同时操作数组崩溃报错<CALayerArray: 0x2839ad620> was mutated while being enumerated.但是会有延迟效果，不会立即执行removeFromSuperlayer方法
//    [self.vediolayer.sublayers enumerateObjectsUsingBlock:^(__kindof CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if([obj isKindOfClass:[CAShapeLayer class]]){
//                *stop =YES;
//                if(*stop == YES){
//                    SKLog(@"removeFromSuperlayer");
//                    [obj removeFromSuperlayer];
//                }
//            }
//    }];
    
//    解决方法
    NSArray *tmparray = [NSArray arrayWithArray:self.vediolayer.sublayers];
    for(CALayer * obj in tmparray){
        if([obj isKindOfClass:[CAShapeLayer class]]){
            [obj removeFromSuperlayer];
        }
    }
}
    
#pragma mark - 开始动画
-(void)startScanAnimation{
    self.toScanlineBotton.constant = self.scanBackView.frame.size.height;
    [self.view layoutIfNeeded];
    self.toScanlineBotton.constant = -self.scanBackView.frame.size.height;
    
    [UIView animateWithDuration:1 animations:^{
        [UIView setAnimationRepeatCount:MAXFLOAT];
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 移除动画
-(void)removeAnimation{
    [self.QRscanlineView.layer removeAllAnimations];
}
@end
