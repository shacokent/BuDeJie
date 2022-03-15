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
/// 加载页面类型
//@property (nonatomic,assign) CellType loadVCtype;
//避免父类属性暴露，写成get方法，然后再子类重写，达到给loadVCtype负值的效果
-(CellType)loadVCtype;

//get方法补充。这样写还可以带参数，可以实现子类和父类互相传参数
//-(CellType)loadVCtype:(NSString*)string;
//父类调用：[self loadVCtype:@"abc"];
//子类实现：
//-(CellType)loadVCtype:(NSString*)string{
//    if(string == @"abc") return CellType;
//    return CellType;
//}

@end

NS_ASSUME_NONNULL_END
