//
//  UITextField+SKPlaceHolder.h
//  BuDeJie
//
//  Created by hongchen li on 2022/2/24.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (SKPlaceHolder)
@property UIColor * placeholderColor;
- (void)setSK_Placeholder:(NSString *)placeholder;
@end

NS_ASSUME_NONNULL_END
