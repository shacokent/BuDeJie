//
//  SKFileTool.m
//  BuDeJie
//
//  Created by hongchen li on 2022/2/25.
//  Copyright © 2022 shacokent. All rights reserved.
//  处理文件缓存

#import "SKFileTool.h"

@implementation SKFileTool

+(void)removeSubDirs:(NSString*)directoryPath{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    for (NSString *subDirName in [fileManager contentsOfDirectoryAtPath:directoryPath error:nil]){
        NSString * subDirPath = [directoryPath stringByAppendingPathComponent:subDirName];
        [fileManager removeItemAtPath:subDirPath error:nil];
    }
}

+(NSString *)getFileSizeStr:(NSInteger)fileSize{
    //    手机1MB=1000kb
        NSString *fileSizeStr = @"";
        CGFloat fileSizef = 0;
        if(fileSize > 1000 * 1000 * 1000){
            //GB
            fileSizef = fileSize*1.0/(1000 * 1000 * 1000);
            fileSizeStr = @"GB";
        }
        if(fileSize > 1000 * 1000){
            //MB
            fileSizef = fileSize*1.0/(1000 * 1000);
            fileSizeStr = @"MB";
        }
        else if(fileSize > 1000){
            //KB
            fileSizef = fileSize*1.0/1000;
            fileSizeStr = @"KB";
        }
        else if(fileSize > 0){
            //B
            fileSizeStr = @"B";
        }
        return [NSString stringWithFormat:@"清除缓存(%0.1f%@)",fileSizef,fileSizeStr];
}

//计算缓存
+(void)getFileSize:(NSString*)directoryPath completion:(void(^)(NSInteger cacheSize))completion{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL isDirectory;
    BOOL isExist = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    if(!isExist || !isDirectory){
        //抛异常
        NSException *excp = [NSException exceptionWithName:@"异常名称：Path" reason:@"报错原因：需要传入文件夹，并且文件要存在" userInfo:nil];
        [excp raise];
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSInteger filesize = 0;
    //    方法一
        for(NSString * fileName in [fileManager enumeratorAtPath:directoryPath]){
            NSString * filePath = [directoryPath stringByAppendingPathComponent:fileName];
            if([filePath containsString:@".DS"]){
                continue;
            }
            BOOL isDirectory;
            BOOL isExist = [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
            if(!isExist || isDirectory) continue;
            NSDictionary * attrs = [fileManager attributesOfItemAtPath:filePath error:nil];
            filesize += [attrs fileSize];
        }

        //方法二
    //    for(NSString * fileName in [fileManager subpathsAtPath:directoryPath]){
    //        NSString * filePath = [directoryPath stringByAppendingPathComponent:fileName];
    //        if([filePath containsString:@".DS"]){
    //            continue;
    //        }
    //        BOOL isDirectory;
    //        BOOL isExist = [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
    //        if(!isExist || isDirectory) continue;
    //        NSDictionary * attrs = [fileManager attributesOfItemAtPath:filePath error:nil];
    //        filesize += [attrs fileSize];
    //    }
        
        //计算完成block回调
        dispatch_sync(dispatch_get_main_queue(), ^{
            if(completion){
                completion(filesize);
            }
        });
    });
}

@end
