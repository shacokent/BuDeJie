//
//  UIImageView+SK.h
//  BuDeJie
//
//  Created by hongchen li on 2022/3/8.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIImageView (SK)
-(void)SK_setOriginImageWithURL:(NSString*)originImageURL andTuhumbImageWithURL:(NSString*)tuhumbImageURL andPlaceholderImageName:(NSString*)placeholderImageName completed:(nullable SDExternalCompletionBlock)completedBlock;
@end

NS_ASSUME_NONNULL_END
