//
//  SKRootBaseCell.h
//  BuDeJie
//
//  Created by hongchen li on 2022/3/4.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SKTopicItem;
@interface SKRootBaseCell : UITableViewCell
@property (nonatomic,strong) SKTopicItem *rootbaseItem;
@end

NS_ASSUME_NONNULL_END
