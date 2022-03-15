//
//  SKMeViewController.m
//  BuDeJie
//
//  Created by hongchen li on 2022/2/18.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKMeViewController.h"
#import "SKSettingViewController.h"
#import "SKSquareCell.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "SKFootCellItem.h"
#import <SafariServices/SafariServices.h>
#import "SKWebViewController.h"

static NSString * const cid=@"footcell";
static NSInteger const cols =4;
static float const margin =1;
#define itemWH (SKSCreenW - (cols-1) * margin)/cols

@interface SKMeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,SFSafariViewControllerDelegate>
@property (nonatomic,strong) NSMutableArray *footCells;
@property (nonatomic,weak) UICollectionView *collectView;
//@property (nonatomic,strong) AFHTTPSessionManager *manager;
@end

@implementation SKMeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    //提示用户当前正在加载数据 可以用SVProgressHUD
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];//黑色蒙版
    [SVProgressHUD showWithStatus:@"正在加载中..."];
    //设置导航条
    [self setupNavBar];
    //设置tableview底部是图
    [self setupFootView];
    //展示数据
    [self loadData];
    
    //处理cell间距，默认tableview分组样式,有额外的头部和尾部间距,重新设置
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 10;
    
    //向下10
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarBtnRepeatClick) name:SKTabBarButtonDidRepeatClickNSNotification object:nil];
}

-(void)tabBarBtnRepeatClick{
    //重复点击不是我的按钮，那么我的不再window上,所以return
    if(self.view.window == nil) return;
    SKFunc;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //销毁指示器SVProgressHUD
    [SVProgressHUD dismiss];
    //取消网络请求
    //数组中所有的元素都执行makeObjectsPerformSelector方法
//    [_manager.tasks makeObjectsPerformSelector:@selector(cancel)];
}

#pragma mark - 请求数据
-(void)loadData{
//   AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
//    _manager = manager;
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    NSMutableDictionary *parameters  = [NSMutableDictionary dictionary];
//    parameters[@"a"] = @"square";
//    parameters[@"c"] = @"topic";
//
//    [manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            SKLog(@"responseObject---%@",responseObject);
//            [self resoveData];
        //    collectview计算高度
        //    rows *itemWH
        //    rows =int((总数 -1)/列数) +1
    //        NSInteger rows = (int)((_footCells.count-1)/cols) +1;
    //        self.collectView.sk_height = rows * itemWH;
    //        //collectview设置完还需要设置tableview的滚动范围
    //        //tableview是自己计算的，所以直接重新设置底部视图就好了
    //        self.tableView.tableFooterView = self.collectView;
//            [self.collectView reloadData];
//            [SVProgressHUD dismiss];
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSLog(@"error---%@",error);
//            [SVProgressHUD dismiss];
//        }];
    
    _footCells = [SKFootCellItem mj_objectArrayWithFilename:@"subtag.plist"];
    for(SKFootCellItem *item in _footCells){
        item.jumpUrl = @"https://www.baidu.com";
    }
    [self resoveData];
//    collectview计算高度
//    rows *itemWH
//    rows =int((总数 -1)/列数) +1
    NSInteger rows = (int)((_footCells.count-1)/cols) +1;
    self.collectView.sk_height = rows * itemWH;
    //collectview设置完还需要设置tableview的滚动范围
    //tableview是自己计算的，所以直接重新设置底部视图就好了
    self.tableView.tableFooterView = self.collectView;
    [self.collectView reloadData];
    [SVProgressHUD dismiss];
}

#pragma mark - 处理获取的数据
-(void)resoveData{
    //处理数据，判断数据是不是刚好够一行，补充白板占位
    NSInteger count = self.footCells.count;
    NSInteger exter = count % cols;
    if(exter){
        exter = cols - exter;
        for(int i =0; i <exter; i++){
            SKFootCellItem *item = [[SKFootCellItem alloc]init];
            [self.footCells addObject:item];
        }
    }
}

#pragma mark - 设置tableview底部是图条
-(void)setupFootView{
    /**
     1.初始化必须要设置流水视图
     2.cell必须要注册
     3.cell必须自定义
     */
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    layout.minimumLineSpacing = margin;
    layout.minimumInteritemSpacing = margin;
    UICollectionView *collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 300) collectionViewLayout:layout];
    collectView.backgroundColor = self.tableView.backgroundColor;
    collectView.dataSource = self;
    collectView.delegate = self;
    self.tableView.tableFooterView = collectView;
    collectView.scrollEnabled = NO;
    //注册Cell
    [collectView registerNib:[UINib nibWithNibName:@"SKSquareCell" bundle:nil]  forCellWithReuseIdentifier:cid];
    _collectView = collectView;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.footCells.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //创建cell
    SKSquareCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cid forIndexPath:indexPath];
    
    SKFootCellItem * item = self.footCells[indexPath.row];
    cell.item = item;
    return cell;
}

#pragma mark - 设置导航条
-(void)setupNavBar{
    //设置
    UIBarButtonItem *mineSetting=[UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-setting-icon"] highImage:[UIImage imageNamed:@"mine-setting-icon-click"] target:self action:@selector(mineSettingClick)];
    //夜间模式
    UIBarButtonItem *mineMoon=[UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-moon-icon"] selImage:[UIImage imageNamed:@"mine-moon-icon-click"] target:self action:@selector(mineMoonClick:)];
    
    
    self.navigationItem.rightBarButtonItems = @[mineSetting,mineMoon];
    
    self.navigationItem.title = @"我的";
}

-(void)mineMoonClick:(UIButton*)btn{
    btn.selected = !btn.selected;
}

-(void)mineSettingClick{
    SKSettingViewController *settingVc = [[SKSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVc animated:YES];
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //展示网页 push
    /**
     1.safari openURL:自带很多功能（进度条，网址，前进，倒退，刷新...），但会跳出APP
     2.UIWebView：（不跳出当前APP），自己去实现功能，但是不能实现进度条功能，已废弃
     3.倒入框架SFSafariViewController框架#import <SafariServices/SafariServices.h>:既不跳出应用，又有safari的功能,IOS 9才能用
     3.WKWebView：#import <WebKit/WebKit.h>,UIWebView的升级版，IOS8才能用（可以监听进度条，缓存）
     */
    SKFootCellItem *item = self.footCells[indexPath.row];
    if(![item.jumpUrl containsString:@"http"]) return;
    NSURL * jumpurl = [NSURL URLWithString:item.jumpUrl];
    
//    SFSafariViewController
//    SFSafariViewController *safariVc = [[SFSafariViewController alloc] initWithURL:jumpurl];
//    safariVc.delegate = self;
    //使用pushViewController需要设置代理，实现DONE方法，才能返回当前页面
//    [self.navigationController pushViewController:safariVc animated:YES];
    //推荐：使用presentViewController不需要设置代理，DONE方法会自动调用dismissViewControllerAnimated
//    [self presentViewController:safariVc animated:YES completion:nil];
    
    //WKWebView
    SKWebViewController *webVc = [[SKWebViewController alloc]init];
    webVc.jumpurl = jumpurl;
    [self.navigationController pushViewController:webVc animated:YES];
}

//#pragma mark - SFSafariViewControllerDelegate
//- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller{
//    [self.navigationController popViewControllerAnimated:YES];
//}

@end
