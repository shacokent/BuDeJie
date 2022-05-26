//
//  SKQRCodeController.m
//  BuDeJie
//
//  Created by hongchen li on 2022/5/13.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKQRCodeController.h"
#import <CoreImage/CoreImage.h>
#import "SKQRScanVC.h"

@interface SKQRCodeController ()
@property (weak, nonatomic) IBOutlet UIImageView *QRCodeIMage;

@end

@implementation SKQRCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.QRCodeIMage.image = [UIImage imageNamed:@"QRCodes"];
}

#pragma mark - 生成二维码
- (IBAction)createQRCode:(UIButton *)sender {
//    1.创建二维码滤镜
    CIFilter * filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];//固定写法，固定值CIQRCodeGenerator
//    1.1恢复滤镜默认设置,解决重用清除前一次的设置残留
    [filter setDefaults];
//    2.设置滤镜输入数据
    [filter setValue:[@"测试输入文字" dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];//KVC 固定用法，固定Key：inputMessage 值需要传入NSData类型
//    2.2设置二维码的纠错率(L代表7%纠错率，M代表15%纠错率，Q代表25%纠错率，H代表30%纠错率),就错率越高，扫描时间越长，一般设置M
    [filter setValue:@"M" forKey:@"inputCorrectionLevel"];
//    3.从二维码滤镜中获取结果图片
    CIImage *image = [filter outputImage];
    //有可能产生的缩略图，所以对图片进行缩放处理(放大20倍)
    image = [image imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
    
    //3.1自定义图片
    UIImage *resultImage = [self getNewImage:[UIImage imageWithCIImage:image] center:[UIImage imageNamed:@"publish-audio"]];
//    4.显示图片
    self.QRCodeIMage.image = resultImage;
}

-(UIImage*)getNewImage:(UIImage*)sourceImage center:(UIImage*)center{
    CGSize size = sourceImage.size;
//    1.开启图形上下文
    UIGraphicsBeginImageContext(size);
//    2.绘制大图片
    [sourceImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    3.绘制小图片
    CGFloat x = (size.width-60)/2;
    CGFloat y = (size.height-60)/2;
    [center drawInRect:CGRectMake(x, y, 60, 60)];
//    4.取出结果图片
    UIImage *relultImage = UIGraphicsGetImageFromCurrentImageContext();
//    5.关闭上下文
    UIGraphicsEndImageContext();
//    6.返回结果图片
    return relultImage;
}

#pragma mark - 扫描二维码
- (IBAction)checkQRCode:(UIButton *)sender {
    SKQRScanVC *QrSvanVc = [[SKQRScanVC alloc]init];
    [self.navigationController presentViewController:QrSvanVc animated:YES completion:nil];
}

#pragma mark - 识别图片二维码，暂时15.4模拟器不行，可用真机或者低版本模拟器
- (IBAction)checkImageQRCode:(UIButton *)sender {
//    SVProgressHUD
    if(self.QRCodeIMage.image){
        //    1.获取需要识别的图片
        UIImage *image = self.QRCodeIMage.image;
        //    2.创建二维码探测器,detectorOfType识别类型（二维码，人脸等），options可设置识别率等参数
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
        //    3.直接探测二维码特征
        CIImage *ciimage =[CIImage imageWithCGImage:image.CGImage];
        NSArray<CIFeature*>* features = [detector featuresInImage:ciimage];
        NSString *resultStr = @"";
        UIImage *resultImage = image;
        for(CIFeature* feature in features){
            CIQRCodeFeature * grFeature = (CIQRCodeFeature*)feature;
        //        4.绘制被识别的二维码边框
            resultImage = [self drawQRCodeFrame:resultImage grFeature:grFeature];
        
            resultStr = [resultStr stringByAppendingFormat:@"\n%@",grFeature.messageString];
           
        }
        [SVProgressHUD showInfoWithStatus:resultStr];
        //    4.显示图片
        if(resultImage){
            self.QRCodeIMage.image = resultImage;
        }
    }
    else{
        [SVProgressHUD showErrorWithStatus:@"先生成二维码"];
    }
}

-(UIImage*)drawQRCodeFrame:(UIImage*)image grFeature:(CIQRCodeFeature *)grFeature{
    CGSize size = image.size;
//    1.开启图形上下文
    UIGraphicsBeginImageContext(size);
//    2.绘制大图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    //    转换坐标系上下颠倒，因为grFeature.bounds的坐标系和image的坐标系是上下反的
    CGContextRef context = UIGraphicsGetCurrentContext();
    //x==1左右不变 y==-1上下颠倒,会向上平移1倍的距离，需向下平移回来
    CGContextScaleCTM(context, 1, -1);
    //向下平移size.height的距离
    CGContextTranslateCTM(context, 0, -size.height);
//    3.绘制路径
    CGRect bounds = grFeature.bounds;
    UIBezierPath * path = [UIBezierPath bezierPathWithRect:bounds];
    [UIColor.redColor setStroke];
    path.lineWidth = 5;
    [path stroke];
//    4.取出结果图片
    UIImage *relultImage = UIGraphicsGetImageFromCurrentImageContext();
//    5.关闭上下文
    UIGraphicsEndImageContext();
//    6.返回结果图片
    return relultImage;
}
@end
