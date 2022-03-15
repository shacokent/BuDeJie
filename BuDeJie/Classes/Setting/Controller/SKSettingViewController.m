//
//  SKSettingViewController.m
//  BuDeJie
//
//  Created by hongchen li on 2022/2/21.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKSettingViewController.h"
//#import <SDImageCache.h>
#import "SKFileTool.h"

@interface SKSettingViewController ()
@property (nonatomic,strong) NSString * totalSize;
@end

@implementation SKSettingViewController
static NSString * const cid=@"setcell";
- (void)viewDidLoad {
    [super viewDidLoad];
    //注册Cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cid];
    //计算缓存大小
    [self sizeStr];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //创建cell
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cid];
    
    //计算应用程序的缓存数据=>数据缓存在沙盒里=>cache
//    NSInteger cacheSize = [SDImageCache sharedImageCache].totalDiskSize;//SDImageCache获取图片缓存大小
    
    //自己做缓存计算大小
    cell.textLabel.text = self.totalSize;
    
    return cell;
}

-(void)sizeStr{
    NSString  *cachePath =  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [SVProgressHUD showWithStatus:@"正在计算缓存大小......"];
    }];
    [SKFileTool getFileSize:cachePath completion:^(NSInteger cacheSize) {
        self.totalSize = [SKFileTool getFileSizeStr:cacheSize];
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString  *cachePath =  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    [SKFileTool removeSubDirs:cachePath];
    [SKFileTool getFileSize:cachePath completion:^(NSInteger cacheSize) {
        self.totalSize = [SKFileTool getFileSizeStr:cacheSize];
        [self.tableView reloadData];
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //销毁指示器SVProgressHUD
    [SVProgressHUD dismiss];
}

@end
