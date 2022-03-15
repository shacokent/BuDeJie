//
//  SKFileTool.h
//  BuDeJie
//
//  Created by hongchen li on 2022/2/25.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKFileTool : NSObject

/// 删除文件夹下的字文件夹
/// @param directoryPath 文件夹路径
+(void)removeSubDirs:(NSString*)directoryPath;

/// 返回缓存大小显示的字符串（18MB）
/// @param fileSize 文件大小 和getFileSize，连用
+(NSString *)getFileSizeStr:(NSInteger)fileSize;

/// 返回文件大小字节
/// @param directoryPath 文件夹路径
+(void)getFileSize:(NSString*)directoryPath completion:(void(^)(NSInteger cacheSize))completion;
@end

NS_ASSUME_NONNULL_END
