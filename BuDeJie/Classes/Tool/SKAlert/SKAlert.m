//
//  SKAlert.m
//  BuDeJie
//
//  Created by hongchen li on 2022/3/11.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKAlert.h"

@implementation SKAlert

#pragma mark - 权限提示框
+(void)jumpPressionSet:(UIViewController*)controller
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"开启相册/相机权限才可以继续操作" message:@"" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];
    UIAlertAction * setAction = [UIAlertAction actionWithTitle:@"跳转" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url];
        });
    }];

    [alert addAction:cancelAction];
    [alert addAction:setAction];

    [controller.navigationController presentViewController:alert animated:YES completion:nil];
}

@end
