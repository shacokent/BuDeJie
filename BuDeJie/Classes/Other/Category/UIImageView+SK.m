//
//  UIImageView+SK.m
//  BuDeJie
//
//  Created by hongchen li on 2022/3/8.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "UIImageView+SK.h"
#import <AFNetworking/AFNetworking.h>
#import <SDImageCache.h>

@implementation UIImageView (SK)
-(void)SK_setOriginImageWithURL:(NSString*)originImageURL andTuhumbImageWithURL:(NSString*)tuhumbImageURL andPlaceholderImageName:(NSString*)placeholderImageName completed:(nullable SDExternalCompletionBlock)completedBlock {
    //如果沙盒已经缓存就加载沙盒中的图片
//    默认Key是图片的URL，传入原图URL
    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:originImageURL];
    if(cacheImage){//原图已经下载过
        self.image = cacheImage;
        if(completedBlock){
            completedBlock(cacheImage, nil,SDImageCacheTypeNone, nil);
        }
    }else{//根据网络下载
        //    使用AFN判断网络环境,来加载图片，原图，小图，还是缩略图
            //注意必须开启网络监控，startMonitoring,一般在AppDelgate中开启，这里开启过于频繁
        AFNetworkReachabilityManager *Manager = [AFNetworkReachabilityManager sharedManager];
        if(Manager.isReachableViaWiFi){//wifi下载原图
            [self sd_setImageWithURL:[NSURL URLWithString:originImageURL] placeholderImage:[UIImage imageWithRenderOriginalName:placeholderImageName] options:0 completed:completedBlock];
        }
        else if(Manager.isReachableViaWWAN){//手机网络，下载小图
            [self sd_setImageWithURL:[NSURL URLWithString:tuhumbImageURL] placeholderImage:[UIImage imageWithRenderOriginalName:placeholderImageName] options:0 completed:completedBlock];
        }
        else{//没有网络,占位图
            UIImage *image =[UIImage imageWithRenderOriginalName:placeholderImageName];
            self.image = image;
            if(completedBlock){
                completedBlock(image, nil, SDImageCacheTypeNone, nil);
            }
        }
    }
}
@end
