//
//  SKADViewController.m
//  BuDeJie
//
//  Created by hongchen li on 2022/2/21.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKADViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "SKAdItem.h"
#import <MJExtension/MJExtension.h>
#import <UIImageView+WebCache.h>
#import "SKTabViewController.h"

#define code2 @"phcqnauGuHYkFMRquANhmgN_IauBThfqmgKsUARhIWdGULPxnz3vndtkQW08nau_I1Y1P1Rhmhwz5Hb8nBuL5HDknWRhTA_qmvqVQhGGUhI_py4MQhF1TvChmgKY5H6hmyPW5RFRHzuET1dGULnhuAN85HchUy7s5HDhIywGujY3P1n3mWb1PvDLnvF-Pyf4mHR4nyRvmWPBmhwBPjcLPyfsPHT3uWm4FMPLpHYkFh7sTA-b5yRzPj6sPvRdFhPdTWYsFMKzuykEmyfqnauGuAu95Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiu9mLfqHbD_H70hTv6qnHn1PauVmynqnjclnj0lnj0lnj0lnj0lnj0hThYqniuVujYkFhkC5HRvnB3dFh7spyfqnW0srj64nBu9TjYsFMub5HDhTZFEujdzTLK_mgPCFMP85Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiuBnHfdnjD4rjnvPWYkFh7sTZu-TWY1QW68nBuWUHYdnHchIAYqPHDzFhqsmyPGIZbqniuYThuYTjd1uAVxnz3vnzu9IjYzFh6qP1RsFMws5y-fpAq8uHT_nBuYmycqnau1IjYkPjRsnHb3n1mvnHDkQWD4niuVmybqniu1uy3qwD-HQDFKHakHHNn_HR7fQ7uDQ7PcHzkHiR3_RYqNQD7jfzkPiRn_wdKHQDP5HikPfRb_fNc_NbwPQDdRHzkDiNchTvwW5HnvPj0zQWndnHRvnBsdPWb4ri3kPW0kPHmhmLnqPH6LP1ndm1-WPyDvnHKBrAw9nju9PHIhmH9WmH6zrjRhTv7_5iu85HDhTvd15HDhTLTqP1RsFh4ETjYYPW0sPzuVuyYqn1mYnjc8nWbvrjTdQjRvrHb4QWDvnjDdPBuk5yRzPj6sPvRdgvPsTBu_my4bTvP9TARqnam"

@interface SKADViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *lauchImageView;
@property (weak, nonatomic) IBOutlet UIView *adContainView;
@property (weak, nonatomic) IBOutlet UIButton *jump;
@property (nonatomic,weak) UIImageView *adView;
@property (nonatomic,strong) SKAdItem *adItem;
@property (nonatomic,weak) NSTimer *timer;
@end

@implementation SKADViewController

- (UIImageView *)adView{
    if(_adView == nil){
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.adContainView addSubview:imageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled = YES;
        _adView = imageView;
    }
    return _adView;
}

//点击广告界面
-(void)tap{
    SKFunc
    UIApplication *app =[UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:self.adItem.curl];
    if([app canOpenURL:url]){
        [app openURL:url];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置启动图片
    [self setupLauchImage];
    //加载广告数据
    [self loadAdData];
    //创建定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
}

-(void)timeChange{
    static int i = 3;
    if(i == 0){
        [self clickJump];
    }
    i--;
    [self.jump setTitle:[NSString stringWithFormat:@"跳转(%d)",i] forState:UIControlStateNormal];
}

- (IBAction)jumpOnClick:(UIButton *)sender {
    [self clickJump];
}

-(void)clickJump{
    //销毁广告界面
    SKTabViewController * sktabVC =  [[SKTabViewController alloc]init];
//    sktabVC.delegate = (id<UITabBarControllerDelegate>)[UIApplication sharedApplication].delegate;//监听tabbarbutton点击，不能用self，要用APPdelegate,不推荐（一种方法补充）
    SKKeyWindow.rootViewController = sktabVC;
    //销毁定时器
    [_timer invalidate];
}

-(void)loadAdData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSMutableDictionary *parameters  = [NSMutableDictionary dictionary];
    parameters[@"code2"] = code2;
    [manager GET:@"http://mobads.baidu.com/cpro/ui/mads.php" parameters:parameters headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *adDict = [responseObject[@"ad"] lastObject];
            self.adItem = [SKAdItem mj_objectWithKeyValues:adDict];
            self.adItem.w = 375;
            self.adItem.h = 562;
            CGFloat h = SKSCreenW/self.adItem.w *self.adItem.h;
            self.adView.frame =CGRectMake(0, 0, SKSCreenW, h);
            [self.adView sd_setImageWithURL:[NSURL URLWithString:self.adItem.w_picurl]];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error---%@",error);
        }];
}



-(void)setupLauchImage{
    if(iphone6p){//6p
        self.lauchImageView.image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h@3x"];
    }
    else if (iphone6){//6
        self.lauchImageView.image = [UIImage imageNamed:@"LaunchImage-800-667h@2x"];
    }
    else if (iphone5){//5
        self.lauchImageView.image = [UIImage imageNamed:@"LaunchImage-700-568h@2x"];
    }
    else if (iphone4){//4
        self.lauchImageView.image = [UIImage imageNamed:@"LaunchImage-700@2x"];
    }
    else if (iphone13){//13
        self.lauchImageView.image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h@3x"];
    }
}

@end
