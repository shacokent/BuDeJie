//
//  SKPhotoTool.h
//  BuDeJie
//
//  Created by hongchen li on 2022/3/10.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <CTAssetsPickerController/CTAssetsPickerController.h>
//样式设置
//网址：https://gitee.com/mirrors/ctassetspickercontroller/blob/master/CTAssetsPickerDemo/Examples/CTApperanceViewController.m
//#import <CTAssetsPickerController/CTAssetCollectionViewCell.h>
//#import <CTAssetsPickerController/CTAssetsGridView.h>
//#import <CTAssetsPickerController/CTAssetsGridViewFooter.h>
//#import <CTAssetsPickerController/CTAssetsGridViewCell.h>
//#import <CTAssetsPickerController/CTAssetsGridSelectedView.h>
//#import <CTAssetsPickerController/CTAssetCheckmark.h>
//#import <CTAssetsPickerController/CTAssetSelectionLabel.h>
//#import <CTAssetsPickerController/CTAssetsPageView.h>

NS_ASSUME_NONNULL_BEGIN
@interface SKPhotoTool : NSObject
/// 判断相册权限
/// @param run 有权限执行
/// @param fail 无权限执行
+(void)isHaveAuth:(void(^ __nullable)(void))run fail:(void(^ __nullable)(void))fail;
/// 保存相片到相册
/// @param createCollection 相册
/// @param createAsset 相片
+(void)saveImageInfoAlbum:(PHAssetCollection *)createCollection createAsset:(PHAsset*)createAsset;
/// 获得相片
/// @param image 照片
+(PHAsset*)createAsset:(UIImage*)image;
/// 获取相册，没有创建App同名相册
+(PHAssetCollection*)createCollection;

///检测照相机权限
+(BOOL)isHaveCameraAuth;
///获取单张选择相册
+(UIImagePickerController *)openALbum;
///获取多张选择相册
+(CTAssetsPickerController*)openMultALbum;
///获取照相机
+(UIImagePickerController *)openCamera;
///通过asset获得图片
+(void)sk_requestImageForAsset:(PHAsset *)asset options:(PHImageRequestOptions*)options resultHandler:(void (^)(UIImage *_Nullable result, NSDictionary *_Nullable info))resultHandler;
@end

NS_ASSUME_NONNULL_END
