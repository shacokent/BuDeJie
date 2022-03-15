//
//  SKBaseTableVC.h
//  BuDeJie
//
//  Created by hongchen li on 2022/2/28.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKTopicItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface SKBaseTableVC : UITableViewController
@property (nonatomic,assign) CellType loadVCtype;
@end

NS_ASSUME_NONNULL_END
