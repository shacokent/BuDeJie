//
//  SKSeeBigPictureVC.m
//  BuDeJie
//
//  Created by hongchen li on 2022/3/9.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKSeeBigPictureVC.h"
#import "SKTopicItem.h"
#import "SKPhotoTool.h"

@interface SKSeeBigPictureVC ()<UIScrollViewDelegate>
/// 保存按钮
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
//@property (nonatomic,weak) UIScrollView *scrollView;
/// 图片显示控件
@property (nonatomic,weak) UIImageView *imageView;
@end

@implementation SKSeeBigPictureVC
//- (UIScrollView *)scrollView{
//    if(_scrollView == nil){
//        UIScrollView *scrollView = [[UIScrollView alloc]init];
//        scrollView.backgroundColor = [UIColor redColor];
//        [self.view insertSubview:scrollView atIndex:0];
//        _scrollView = scrollView;
//    }
//    return _scrollView;
//}
#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.backgroundColor = [UIColor clearColor];
    [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)]];//点击返回
    //设置scroll覆盖全屏幕
//    方法一
//    scrollView.frame = self.view.bounds;
//    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;//scroll不会覆盖屏幕，因为在加载完毕之前他和xib显示的大小一样，所以需要手动设置
    //方法二
    scrollView.frame = [UIScreen mainScreen].bounds;
//    方法三，在viewDidLayoutSubviews中设置
//    _scrollView = scrollView;

    [self.view insertSubview:scrollView atIndex:0];//不能将scroll放在最上面，所以使用insert插入最底层0，避免挡住按钮
    
    //    方法四,viewDidLayoutSubviews+懒加载
    
    
    //设置图片位置
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.sk_width = scrollView.sk_width;
    imageView.sk_height = imageView.sk_width *self.rootbaseItem.imageHeight/self.rootbaseItem.imageWidth;
    imageView.sk_x = 0;
    if(self.rootbaseItem.isBigPicture){
        imageView.sk_y = 0;
        scrollView.contentSize = CGSizeMake(0, imageView.sk_height);
    }
    else{
        imageView.sk_centerY = scrollView.sk_height*0.5;
    }
    [imageView SK_setOriginImageWithURL:self.rootbaseItem.image andTuhumbImageWithURL:self.rootbaseItem.image andPlaceholderImageName:@"post_placeholderImage"completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if(!image) return;//如果图片下载失败，直接返回避免图片位置显示空白
        self.saveButton.enabled = YES;
    }];
    _imageView = imageView;
    [scrollView addSubview:imageView];
    
    //图片缩放
    //缩放比例
    CGFloat maxScale = self.rootbaseItem.imageWidth/imageView.sk_width;
    if(maxScale > 1){
        scrollView.maximumZoomScale = maxScale;
        scrollView.delegate = self;//设置缩放必须实现代理方法viewForZoomingInScrollView，告诉scroll要缩放哪个控件
    }
}

//- (void)viewDidLayoutSubviews{
//    [super viewDidLayoutSubviews];
////   设置scroll覆盖全屏幕
////    方法三,四
//    self.scrollView.frame = self.view.bounds;
//}
#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    //返回要缩放的view
    return self.imageView;
}

#pragma mark - 返回
- (IBAction)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 保存
- (IBAction)save{
    //判断权限
    [SKPhotoTool isHaveAuth:^{
//        保存图片到自定义相册
        [SKPhotoTool saveImageInfoAlbum:[SKPhotoTool createCollection] createAsset:[SKPhotoTool createAsset:self.imageView.image]];
    }fail:^{
        [SKAlert jumpPressionSet:self];
    }];
}

@end
