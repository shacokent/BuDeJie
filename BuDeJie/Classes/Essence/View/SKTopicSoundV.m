//
//  SKTopicSoundV.m
//  BuDeJie
//
//  Created by hongchen li on 2022/3/7.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKTopicSoundV.h"
#import "SKTopicItem.h"
#import "SKSeeBigPictureVC.h"

@interface SKTopicSoundV()
@property (weak, nonatomic) IBOutlet UIImageView *soundBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *soundPlayButton;
@end

@implementation SKTopicSoundV

- (void)awakeFromNib{
    [super awakeFromNib];
    //因为从XIB加载的View会设置这个属性位Yes,避免从XIB加载的view自动改变大小设置为NO
    self.autoresizingMask = UIViewAutoresizingNone;
    self.soundBackgroundImageView.userInteractionEnabled = YES;
    [self.soundBackgroundImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigPucture)]];
}

- (void)setRootbaseItem:(SKTopicItem *)rootbaseItem{
    _rootbaseItem = rootbaseItem;
    
    [self.soundBackgroundImageView SK_setOriginImageWithURL:rootbaseItem.image andTuhumbImageWithURL:rootbaseItem.image andPlaceholderImageName:@"post_placeholderImage"completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if(!image) return;//如果图片下载失败，直接返回避免图片位置显示空白
    }];
}

-(void)seeBigPucture{
    SKSeeBigPictureVC *seeBigVc = [[SKSeeBigPictureVC alloc]init];
    seeBigVc.rootbaseItem = self.rootbaseItem;
    [self.window.rootViewController presentViewController:seeBigVc animated:YES completion:nil];
}

@end
