//
//  SKAlert.h
//  BuDeJie
//
//  Created by hongchen li on 2022/3/11.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKAlert : NSObject
///权限提示框
/// @param controller 当前控制器
+(void)jumpPressionSet:(UIViewController*)controller;
@end

NS_ASSUME_NONNULL_END
