//
//  SKPhotoTool.m
//  BuDeJie
//
//  Created by hongchen li on 2022/3/10.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKPhotoTool.h"
//#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
/**
 一、从相册选择照片到App中
 1.选择单张
 （1）UIImagePickerController,自带界面
 （2）AssetsLibrary（界面需要自定义）
 （3）Photos（界面需要自定义）
 2.选择多张
 （1）AssetsLibrary（界面需要自定义）
 （2）Photos（界面需要自定义）
 二、拍照保存到App
 1.UIImagePickerController,自带界面
 2.AVCaptureSession（界面需要自定义）
 */

@implementation SKPhotoTool
+(void)isHaveAuth:(void(^ __nullable)(void))run fail:(void(^ __nullable)(void))fail{
    //判断权限
    PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];//当前状态
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case PHAuthorizationStatusAuthorized:
                case PHAuthorizationStatusLimited:
                    if(run){
                        run();
                    }
                    break;
                case PHAuthorizationStatusDenied:
                    if(oldStatus != PHAuthorizationStatusNotDetermined){//防止刚点完拒绝就跳转
                        if(fail){
                            fail();
                        }
                    }
                    break;
                default:
                    break;
            }
        });
    }];
}




#pragma mark - 保存图片到自定义相册
+(void)saveImageInfoAlbum:(PHAssetCollection *)createCollection createAsset:(PHAsset*)createAsset{
    //1.保存照片到相机交卷（1、c语言，2、AssetsLibrary框架AssetsLibrary.h IOS9废弃，3、Photos框架IOS8.0后可用）
        //1.C:注意@selector方法需要遵守格式- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
        //    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    //2.自定义相册（1、AssetsLibrary，2、Photos）
    //3.从相机交卷保存到自定义相册（1、AssetsLibrary，2、Photos）
        
    //Photos(须知：
    //    需要在info.plist加入NSPhotoLibraryUsageDescription
    //增删改操作都需要放在PHPhotoLibrary的(异步)performChanges或（同步）performChangesAndWait中使用
    //PHAsset:一个PHAsset代表相册中的一个图片或视频；
    //  查：  [PHAsset fetchAssets.....];
    //增删改：PHAssetChangeRequest(所有图片视频相关的改动操作)
    //PHAssetCollection:一个PHAssetCollection代表一个相册；)
    //  查：  [PHAssetCollection fetchAssetCollections.....];
    //增删改：PHAssetCollectionChangeRequest(所有相册相关的改动操作)
        
        if(createAsset == nil){
            [SVProgressHUD showErrorWithStatus:@"保存失败"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            return;
        }
        if(createCollection == nil){
            [SVProgressHUD showErrorWithStatus:@"创建相册失败"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            return;
        }
        //3.从相机交卷保存到自定义相册
        NSError * error = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            PHAssetCollectionChangeRequest * request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createCollection];//告诉PHAssetCollection要改哪个相册
            //向相册中添加照片数组，这里可以传入相片的placeholderForCreatedAsset或者PHAsset
    //            [request addAssets:@[createAsset]];//会把图片放在相册的最后
            [request insertAssets:@[createAsset] atIndexes:[NSIndexSet indexSetWithIndex:0]];//把图片放在第0位
        } error:&error];
        if(error){
            [SVProgressHUD showErrorWithStatus:@"保存失败"];
        }
        else{
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    
}

//- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
//    if(error){
//        [SVProgressHUD showErrorWithStatus:@"保存失败"];
//    }
//    else{
//        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
//
//    }
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [SVProgressHUD dismiss];
//    });
//}

#pragma mark - 获取已经保存到相机胶卷的图片
+(PHAsset*)createAsset:(UIImage*)image{
    NSError * error = nil;
    __block NSString * PHAssetId = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetId = [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
        
    } error:&error];
    
    if(error){
        return nil;
    }
    return [PHAsset fetchAssetsWithLocalIdentifiers:@[PHAssetId] options:nil].firstObject;
}

#pragma mark - 获取APP自定义相册
+(PHAssetCollection*)createCollection{
    //1.创建自定义相册
    //获取软件名字(注意Foundation和CoreFoundation的数据类型可以互相转换，如NSString*和CFStringRef,NSArray*和CFArrayRef)
    NSString* appname = [NSBundle mainBundle].infoDictionary[(__bridge NSString*)kCFBundleNameKey];
    //判断是否已创建同名相册，查询
    PHFetchResult * results = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    for(PHAssetCollection * collection in results){
        if([collection.localizedTitle isEqualToString:appname]){
            return collection;
        }
    }
    
    NSError * error = nil;
    __block NSString * PHAssetCollectionId = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        //创建相册，获取相册标识
        PHAssetCollectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:appname].placeholderForCreatedAssetCollection.localIdentifier;
        
    } error:&error];
    if(error){
        return nil;
    }
    //获取创建的相册
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[PHAssetCollectionId] options:nil].firstObject;
}

#pragma mark - 检测照相机权限
+(BOOL)isHaveCameraAuth{
    //拍照需要在info.plist中设置NSCameraUsageDescription
    AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
        return NO;
    }
    else{
        return YES;
    }
}

#pragma mark - 获取单张选择相册
+(UIImagePickerController *)openALbum{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    return picker;
}

#pragma mark - 获取多张选择相册
+(CTAssetsPickerController*)openMultALbum{
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.showsEmptyAlbums = NO;//不显示空相册
    picker.showsSelectionIndex = YES;//显示选中序号
    picker.showsNumberOfAssets = YES;//显示照片数量
//    picker.assetCollectionSubtypes = @[@(PHAssetCollectionSubtypeSmartAlbumUserLibrary),@(PHAssetCollectionSubtypeAlbumRegular)];//显示指定相册
//    控制可选张数，需通过代理方法
    return picker;
}



#pragma mark - 获取照相机
+(UIImagePickerController *)openCamera{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    return picker;
}

#pragma mark - 通过asset获得图片
+(void)sk_requestImageForAsset:(PHAsset *)asset options:(PHImageRequestOptions*)options resultHandler:(void (^)(UIImage *_Nullable result, NSDictionary *_Nullable info))resultHandler{
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight) contentMode:PHImageContentModeDefault options:options resultHandler:resultHandler];
}

@end
