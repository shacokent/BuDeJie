//
//  UIBarButtonItem+SKBarButtonItem.h
//  BuDeJie
//
//  Created by hongchen li on 2022/2/21.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (SKBarButtonItem)
+(UIBarButtonItem*)itemWithImage:(UIImage*)image highImage:(UIImage*)highImage target:(id)target action:(SEL)action;
+(UIBarButtonItem*)itemWithImage:(UIImage*)image selImage:(UIImage*)selImage target:(id)target action:(SEL)action;
+(UIBarButtonItem*)backItemWithImage:(UIImage*)image highImage:(UIImage*)highImage target:(id)target action:(SEL)action title:(NSString*)title;
@end

NS_ASSUME_NONNULL_END
