//
//  SKPublichViewController.m
//  BuDeJie
//
//  Created by hongchen li on 2022/2/18.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKPublichViewController.h"
#import "SKPhotoTool.h"
@interface SKPublichViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,CTAssetsPickerControllerDelegate>

@end

@implementation SKPublichViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)]];
    
    //设置选中相片角标
//    CTAssetSelectionLabel *assetSelectionLabel = [CTAssetSelectionLabel appearance];
//       assetSelectionLabel.borderWidth = 1.0;
//       assetSelectionLabel.borderColor = SKRandomColor;
//       [assetSelectionLabel setSize:CGSizeMake(24.0, 24.0)];
//       [assetSelectionLabel setCornerRadius:12.0];
//       [assetSelectionLabel setMargin:4.0 forVerticalEdge:NSLayoutAttributeRight horizontalEdge:NSLayoutAttributeTop];
//       [assetSelectionLabel setTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0],
//                                                NSForegroundColorAttributeName :SKRandomColor,
//                                                NSBackgroundColorAttributeName :SKRandomColor}];
}

#pragma mark - 点击单张/多张/拍照
- (IBAction)onClickSoloPicture:(UIButton *)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"单张相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openALbum];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"多张相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openMultALbum];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openCamera];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - 打开单张选择相册
-(void)openALbum{
    [SKPhotoTool isHaveAuth:^{
        UIImagePickerController *picker = [SKPhotoTool openALbum];
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }fail:^{
        [SKAlert jumpPressionSet:self];
    }];
}

#pragma mark - 打开多张选择相册
-(void)openMultALbum{
    [SKPhotoTool isHaveAuth:^{
        CTAssetsPickerController *picker = [SKPhotoTool openMultALbum];
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }fail:^{
        [SKAlert jumpPressionSet:self];
    }];
}

#pragma mark - 打开照相机
-(void)openCamera{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;//判断UIImagePickerControllerSourceTypeCamera这个类型是否可以用，照相功能在模拟器上无法用
    if([SKPhotoTool isHaveCameraAuth]){
        [SKPhotoTool openCamera];
    }
    else{
        [SKAlert jumpPressionSet:self];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
//    UIImage * image = info[UIImagePickerControllerOriginalImage];
    SKFunc;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CTAssetsPickerControllerDelegate
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    SKFunc;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    for(NSInteger i =0 ; i<assets.count;i++){
        PHAsset *asset = assets[i];
        [SKPhotoTool sk_requestImageForAsset:asset options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            SKLog(@"%@",result);
        }];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//控制可选张数，需通过代理方法CTAssetsPickerControllerDelegate
- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(PHAsset *)asset{
    return picker.selectedAssets.count < 9 ;
}

//设置显示照片选择界面照片的大小
//- (UICollectionViewLayout *)assetsPickerController:(CTAssetsPickerController *)picker collectionViewLayoutForContentSize:(CGSize)contentSize traitCollection:(UITraitCollection *)trait
//{
//    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
//    layout.itemSize = CGSizeMake(175, 175);
//    layout.minimumInteritemSpacing = 8;
//    layout.minimumLineSpacing = 8;
//    layout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
//
//    layout.footerReferenceSize = CGSizeMake(contentSize.width, 60);
//
//    return (UICollectionViewLayout *)layout;
//}

-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
