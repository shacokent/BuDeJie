//
//  SKAdItem.h
//  BuDeJie
//
//  Created by hongchen li on 2022/2/22.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKAdItem : NSObject
@property (nonatomic,strong) NSString *w_picurl;//广告地址
@property (nonatomic,strong) NSString *curl;//点击广告跳转界面
@property (nonatomic,assign) NSInteger w;//宽
@property (nonatomic,assign) NSInteger h;//高
@end

NS_ASSUME_NONNULL_END
