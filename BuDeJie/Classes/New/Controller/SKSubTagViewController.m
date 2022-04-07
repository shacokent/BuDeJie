//
//  SKSubTagViewController.m
//  BuDeJie
//
//  Created by hongchen li on 2022/2/22.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKSubTagViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "SKSubTagItem.h"
#import "SKSubTagCell.h"
//#import <MJRefresh/MJRefresh.h>//下拉刷新第三方控件
#import "SKRefreshHeader.h"//继承第三方控件MJRefresh的MJRefreshGifHeader自定义样式
#import "SKDIYRefreshHeader.h"////继承第三方控件MJRefresh完全自定义样式

static NSString * const cid=@"cell";
@interface SKSubTagViewController ()
@property (nonatomic,strong) NSMutableArray *subTags;
//@property (nonatomic,strong) AFHTTPSessionManager *manager;
@end

@implementation SKSubTagViewController

//界面即将消失
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //销毁指示器SVProgressHUD
    [SVProgressHUD dismiss];
    //取消网络请求
    //数组中所有的元素都执行makeObjectsPerformSelector方法
//    [_manager.tasks makeObjectsPerformSelector:@selector(cancel)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title = NSLocalizedStringFromTable(@"RecommendSignature", @"AppLocalString", nil);
    self.title = title;
    [self setupRefresh];
    //注册Cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SKSubTagCell class]) bundle:nil] forCellReuseIdentifier:cid];
    //处理分割线设置内边距,去掉边距，1.自定义分割线，2.用系统设置属性
//    self.tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);//设置左右距离20
//    self.tableView.separatorInset =  UIEdgeInsetsZero;
//    3.万能方式，重写cell的setFrame(了解tableview底层实现)
//    (1)取消系统自带分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    (2)把tableview背景色设置成分割线的背景色
    self.tableView.backgroundColor = SKColor(220,220,221,1);
//    (3)cell中重写setFrame方法
}

-(void)setupRefresh{
    //header
    //设置刷新执行方法，无自定义
//    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
//        [self loadData];
//    }];
    //继承MJRefreshGifHeader自定义
//    self.tableView.mj_header = [SKRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    //完全自定义DIY
    self.tableView.mj_header = [SKDIYRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.tableView.mj_header beginRefreshing];//beginRefreshing可以直接触发刷新

}

-(void)loadData{
    //提示用户当前正在加载数据 可以用SVProgressHUD
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];//黑色蒙版
    [SVProgressHUD showWithStatus:@"正在加载中..."];
//   AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
//    _manager = manager;
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    NSMutableDictionary *parameters  = [NSMutableDictionary dictionary];
//    parameters[@"a"] = @"tag_recommend";
//    parameters[@"action"] = @"sub";
//    parameters[@"c"] = @"topic";
    
//    [manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            SKLog(@"responseObject---%@",responseObject);
//            [self.tableView reloadData];
//            [SVProgressHUD dismiss];
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSLog(@"error---%@",error);
//            [SVProgressHUD dismiss];
//        }];
    
    _subTags = [SKSubTagItem mj_objectArrayWithFilename:@"subtag.plist"];
    [self.tableView reloadData];
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];//结束刷新
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subTags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //创建cell
    SKSubTagCell *cell=[tableView dequeueReusableCellWithIdentifier:cid];
    
    SKSubTagItem * item = self.subTags[indexPath.row];
    cell.item = item;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

@end
