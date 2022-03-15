//
//  SKTopicItem.h
//  BuDeJie
//
//  Created by hongchen li on 2022/3/2.
//  Copyright © 2022 shacokent. All rights reserved.
//
/**
 1.weak
 1>OC对象
 
 2.assign
 1>基本数据类型
 2>OC对象
 
 3.strong
 1>OC对象
 2>block
 
 4.copy
 1>NSString *
 2>block
 
 
 使用weak和assign修饰OC对象的区别
 1>成员变量
 1）weak是用__weak修饰的
 2）assign是用__unsafe_unretained修饰的
 2>__weak和__unsafe_unretained
 1）都不是强指针（不是强引用）不能保住对象的命
 2）__weak指向的对象销毁后会自动变成nil指针（空指针）
 3）__unsafe_unretained所指向的对象销毁后仍指向已经销毁的对象
 */


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//加载cell类型的枚举
//typedef enum{
//    MovieType = 1,
//    SoundType = 2,
//    PictureType = 3,
//    TopicType = 4,
//} CellType;

typedef NS_ENUM(NSUInteger, CellType){
    AllType = 0,
    MovieType = 1,
    SoundType = 2,
    PictureType = 3,
    TopicType = 4,
};

@interface SKTopicItem : NSObject
/// 分享
@property (nonatomic,strong) NSString *share;
/// 回复
@property (nonatomic,strong) NSString *reply;
/// 踩
@property (nonatomic,strong) NSString *low;
/// 图片或音乐背景图
@property (nonatomic,strong) NSString *image;
/// 图片宽度(像素)
@property (nonatomic,assign) NSInteger imageWidth;
/// 图片高度(像素)
@property (nonatomic,assign) NSInteger imageHeight;
/// 日期
@property (nonatomic,strong) NSString *date;
/// 顶
@property (nonatomic,strong) NSString *top;
/// 声音
@property (nonatomic,strong) NSString *sound;
/// 视频
@property (nonatomic,strong) NSString *movie;
/// 类型
@property (nonatomic,assign) NSInteger type;
/// 段子
@property (nonatomic,strong) NSString *topic;
/// 名字
@property (nonatomic,strong) NSString *name;
/// 头像
@property (nonatomic,strong) NSString *icon;
/// 播放量
@property (nonatomic,strong) NSString *download;
/// 最热评论
@property (nonatomic,strong) NSString *hotReplay;

//非服务器返回的数据，需要计算cell高度
@property (nonatomic,assign) CGFloat cellHeight;
//非服务器返回的数据，中间控件的的Rect
@property (nonatomic,assign) CGRect middleFrame;
//是否是长图
@property (nonatomic,assign,getter=isBigPicture) BOOL bigPictureTag;
@end

NS_ASSUME_NONNULL_END
