//
//  SKTopicPictureV.m
//  BuDeJie
//
//  Created by hongchen li on 2022/3/7.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKTopicPictureV.h"
#import "SKTopicItem.h"
#import "SKSeeBigPictureVC.h"

@interface SKTopicPictureV()
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UIImageView *gifTagView;
@property (weak, nonatomic) IBOutlet UIButton *bigImageView;

@end

@implementation SKTopicPictureV

- (void)awakeFromNib{
    [super awakeFromNib];
    //因为从XIB加载的View会设置这个属性位Yes,避免从XIB加载的view自动改变大小设置为NO
    self.autoresizingMask = UIViewAutoresizingNone;
    self.pictureImageView.userInteractionEnabled = YES;
    [self.pictureImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigPucture)]];
    //设置点击查看大图方法，还可以直接设置xib的按钮为“无法用户交互”时间就会传递到下一层被imageView执行，也可以实现
    [self.bigImageView addTarget:self action:@selector(seeBigPucture) forControlEvents:UIControlEventTouchUpInside];
    //改变按钮内部子控件位置
//    方法一：
//    self.bigImageView.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
//    self.bigImageView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //方法二：
//    self.bigImageView.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
//    self.bigImageView.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
//    self.bigImageView.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
//    方法三：XIB里面属性设置
}

- (void)setRootbaseItem:(SKTopicItem *)rootbaseItem{
    _rootbaseItem = rootbaseItem;
    [self.pictureImageView SK_setOriginImageWithURL:rootbaseItem.image andTuhumbImageWithURL:rootbaseItem.image andPlaceholderImageName:@"post_placeholderImage" completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if(!image) return;//如果图片下载失败，直接返回避免图片位置显示空白
        //处理超长图片的大小
        if(rootbaseItem.isBigPicture){
            CGFloat imageW = rootbaseItem.middleFrame.size.width;
            CGFloat imageH = rootbaseItem.middleFrame.size.width*rootbaseItem.imageHeight/rootbaseItem.imageWidth;
            CGSize size = CGSizeMake(imageW,imageH);
            UIGraphicsBeginImageContext(size);
            [self.pictureImageView.image drawInRect:CGRectMake(0, 0,imageW, imageH)];
            self.pictureImageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //gif
        //图片链接以gif结尾,就显示gif标志
    //    if([rootbaseItem.image.lowercaseString hasSuffix:@"gif"]){
        if([[rootbaseItem.image.lowercaseString pathExtension] isEqualToString:@"gif"]){
            self.gifTagView.hidden = NO;
        }
        else{
            self.gifTagView.hidden = YES;
        }
        
        //点击大图
        if(rootbaseItem.isBigPicture){
            self.bigImageView.hidden = NO;
            self.pictureImageView.contentMode = UIViewContentModeTop;
            self.pictureImageView.clipsToBounds = YES;//裁剪超出部分
        }
        else{
            self.bigImageView.hidden = YES;
            self.pictureImageView.contentMode = UIViewContentModeScaleToFill;
            self.pictureImageView.clipsToBounds = NO;
        }
    });
}

-(void)seeBigPucture{
    SKSeeBigPictureVC *seeBigVc = [[SKSeeBigPictureVC alloc]init];
    seeBigVc.rootbaseItem = self.rootbaseItem;
    [self.window.rootViewController presentViewController:seeBigVc animated:YES completion:nil];
}

@end
