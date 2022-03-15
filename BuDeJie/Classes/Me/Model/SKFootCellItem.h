//
//  SKFootCellItem.h
//  BuDeJie
//
//  Created by hongchen li on 2022/2/24.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKFootCellItem : NSObject
@property (nonatomic,strong) NSString *icon;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *download;
@property (nonatomic,strong) NSString *jumpUrl;
@end

NS_ASSUME_NONNULL_END
