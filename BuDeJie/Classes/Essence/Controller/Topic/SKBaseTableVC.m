//
//  SKBaseTableVC.m
//  BuDeJie
//
//  Created by hongchen li on 2022/2/25.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKBaseTableVC.h"
#import <MJExtension/MJExtension.h>
#import "SKRootBaseCell.h"
#import <SDImageCache.h>

/**
 ////创建多个cell类的写法，纯代码实现，比较繁琐
 #import "SKMovieCell.h"
 #import "SKSoundCell.h"
 #import "SKPictureCell.h"
 #import "SKTopicCell.h"
 */


@interface SKBaseTableVC ()
/// 全部cell的模型数组
@property (nonatomic,strong) NSMutableArray * topicAllCells;
/// 加载的cell的模型数组
@property (nonatomic,strong) NSMutableArray<SKTopicItem*> * topicCells;
/// 模拟数据增加刷新
@property (nonatomic,assign) NSInteger dataCount;
/// 下拉刷新控件
@property (nonatomic,weak) UIView *dropDownRefreshView;
/// 下拉刷新控件文字
@property (nonatomic,weak) UILabel *dropDownRefreshLab;
/// 广告控件
@property (nonatomic,weak) UIView *header;
/// 广告控件文字
@property (nonatomic,weak) UILabel *headerLab;
/// 上拉刷新控件
@property (nonatomic,weak) UIView *footer;
/// 上拉刷新控件文字
@property (nonatomic,weak) UILabel *footerLab;
/// 是否正在刷新
@property (nonatomic,assign) BOOL refreshing;
@end

@implementation SKBaseTableVC


/**
 ////创建多个cell类的写法，纯代码实现，比较繁琐
 static NSString* const SKMovieCellId = @"SKMovieCellId";
 static NSString* const SKSoundCellId = @"SKSoundCellId";
 static NSString* const SKPictureCellId = @"SKPictureCellId";
 static NSString* const SKTopicCellId = @"SKTopicCellId";
 */
static NSString* const SKRootBaseCellId = @"SKRootBaseCellId";
- (NSMutableArray *)topicAllCells{
    if(_topicAllCells == nil){
        _topicAllCells = [NSMutableArray array];
    }
    return _topicAllCells;
}

- (NSMutableArray *)topicCells{
    if(_topicCells == nil){
        _topicCells = [NSMutableArray array];
    }
    return _topicCells;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //避免标题栏挡住cell0
    //    self.tableView.contentInset = UIEdgeInsetsMake(SKNAVIHeight+SKAdaptNaviHeight+SKTitleViewH, 0, SKTABBARHeight+SKAdaptTabHeight+SKAdaptNaviHeight+SKTitleViewH, 0);
    self.tableView.contentInset = UIEdgeInsetsMake(SKTitleViewH, 0, 0, 0);
    //设置滚动条内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去掉原有cell分割线
    self.tableView.backgroundColor = SKColor(220,220,221,1);
//    self.tableView.estimatedRowHeight = 100;//估算高度，估算高度会影响cellForRowAtIndexPath和heightForRowAtIndexPath的执行顺序，加估算高度会限制性所有的heightForRowAtIndexPath，不加会先调用cellForRowAtIndexPath，所以设置了估算高度会影响模型赋值，影响bigPictureTag属性
    //注册Cell
    [self registerCells];
    //启动监听通知
    [self startNotificationObserver];
    //加载刷新控件
    [self setupRefresh];
    //进入自动下拉刷新,加载数据
    [self dropDownBeginRefreshing];
}

#pragma mark - //注册Cell
-(void)registerCells{
    //注册Cell
    /**
     ////创建多个cell类的写法，纯代码实现，比较繁琐
     [self.tableView registerClass:[SKMovieCell class] forCellReuseIdentifier:SKMovieCellId];
     [self.tableView registerClass:[SKSoundCell class] forCellReuseIdentifier:SKSoundCellId];
     [self.tableView registerClass:[SKPictureCell class] forCellReuseIdentifier:SKPictureCellId];
     [self.tableView registerClass:[SKTopicCell class] forCellReuseIdentifier:SKTopicCellId];
     */
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SKRootBaseCell class]) bundle:nil] forCellReuseIdentifier:SKRootBaseCellId];
    
}

#pragma mark - 启动监听通知
-(void)startNotificationObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarBtnRepeatClick) name:SKTabBarButtonDidRepeatClickNSNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleBtnRepeatClick) name:SKTitleButtonDidRepeatClickNSNotification object:nil];
}
-(void)tabBarBtnRepeatClick{
    //重复点击不是精华按钮，那么精华不再window上,所以return
    if(self.view.window == nil) return;
    //重复点击精华，但选中的不是AllView return
    if(self.tableView.scrollsToTop == NO) return;
    //进入下拉刷新
    [self dropDownBeginRefreshing];
}

-(void)titleBtnRepeatClick{
    [self tabBarBtnRepeatClick];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 加载刷新控件
-(void)setupRefresh{
    //添加下拉加载更多
    [self setupDropDownRefresh];
    //添加广告位
    [self setupAdView];
    //添加上拉加载更多
    [self setupDropUpRefresh];
}

#pragma mark - 添加下拉加载更多
-(void)setupDropDownRefresh{
    UIView *dropDownRefreshView = [[UIView alloc]init];
    dropDownRefreshView.frame =  CGRectMake(0, -44, SKSCreenW, 44);
    self.dropDownRefreshView = dropDownRefreshView;
    UILabel * dropDownRefreshLab = [[UILabel alloc]init];
    dropDownRefreshLab.frame = dropDownRefreshView.bounds;
    dropDownRefreshLab.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:SKTabBar_Nav_ColorAlpha];
    dropDownRefreshLab.text = @"下拉可以刷新";
    dropDownRefreshLab.textColor = [UIColor lightGrayColor];
    dropDownRefreshLab.textAlignment = NSTextAlignmentCenter;
    [dropDownRefreshView addSubview:dropDownRefreshLab];
    self.dropDownRefreshLab = dropDownRefreshLab;
    [self.tableView addSubview:dropDownRefreshView];
}
#pragma mark - 添加广告位
-(void)setupAdView{
    UIView *header = [[UIView alloc]init];
    header.frame =  CGRectMake(0, 0, SKSCreenW, 44);
    self.header = header;
    UILabel * headerLab = [[UILabel alloc]init];
    headerLab.frame = header.bounds;
    headerLab.backgroundColor = [[UIColor systemYellowColor] colorWithAlphaComponent:SKTabBar_Nav_ColorAlpha];
    headerLab.text = @"广告";
    headerLab.textColor = [UIColor whiteColor];
    headerLab.textAlignment = NSTextAlignmentCenter;
    [header addSubview:headerLab];
    self.tableView.tableHeaderView = header;
    self.headerLab = headerLab;
}
#pragma mark - 添加上拉加载更多
-(void)setupDropUpRefresh{
    UIView *footer = [[UIView alloc]init];
    footer.frame =  CGRectMake(0, 0, SKSCreenW, 44);
    self.footer = footer;
    UILabel * footerLab = [[UILabel alloc]init];
    footerLab.frame = footer.bounds;
    footerLab.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:SKTabBar_Nav_ColorAlpha];
    footerLab.text = @"上拉可以加载更多";
    footerLab.textColor = [UIColor lightGrayColor];
    footerLab.textAlignment = NSTextAlignmentCenter;
    [footer addSubview:footerLab];
    self.tableView.tableFooterView = footer;
    self.footerLab = footerLab;
}

#pragma mark - Table view Delegate
//监听scrollView滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //处理dropDown
    [self dealHeader];
    //处理footer
    [self dealFooter];
//    //清除内存缓存，频繁
//    [[SDImageCache sharedImageCache] clearMemory];
}

//监听手指松开scrollView
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat offsetY = -(SKTitleViewH+SKNAVIHeight+44);
    if(self.tableView.contentOffset.y <= offsetY){
        //模拟进入时延迟加载数据
        [self dropDownBeginRefreshing];
    }
}

//停止滑动
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    //清除SD内存缓存
    [[SDImageCache sharedImageCache] clearMemory];
}

//处理dropDown
-(void)dealHeader{
    //如果正在刷新，直接返回
    if(self.refreshing) return;
    CGFloat offsetY = -(SKTitleViewH+SKNAVIHeight+44);
    if(self.tableView.contentOffset.y <= offsetY){
        self.dropDownRefreshLab.text = @"松开立即刷新";
    }
    else{
        self.dropDownRefreshLab.text = @"下拉可以刷新";
    }
}

//处理footer
-(void)dealFooter{
    
    if(self.tableView.contentSize.height <= 88) return;//没有内容不需要判断(注意没有内容==0，因为添加了header,footer,dropdown所以是44+44+44)
    if((self.tableView.contentSize.height)<=(SKSCreenH-SKTABBARHeight-SKNAVIHeight)) return;//总内容高度小于显示区域高度，return
//   tableFooterView完全出现时刷新
    CGFloat offsetY = SKTABBARHeight+ self.tableView.contentSize.height+self.tableView.contentInset.bottom-self.tableView.frame.size.height;
    if(self.tableView.contentOffset.y >= offsetY){
        //模拟进入时延迟加载数据
        [self footerBeginRefreshing];
    }
}

#pragma mark - 下拉加载新数据
-(void)loadNewData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray * topicAllCellsTmp = [SKTopicItem mj_objectArrayWithFilename:@"subtag.plist"];
        SKLog(@"%@",self);
        for(NSInteger i = 0 ;i<topicAllCellsTmp.count; i++){
            NSInteger typeTag =((SKTopicItem*)topicAllCellsTmp[i]).type;
            if(self.loadVCtype == AllType){
                if((typeTag == MovieType)|(typeTag == SoundType)|(typeTag == PictureType)|(typeTag == TopicType)){
                    [self.topicAllCells addObject:topicAllCellsTmp[i]];
                }
            }
            else{
                if(typeTag == self.loadVCtype){
                    [self.topicAllCells addObject:topicAllCellsTmp[i]];
                }
            }   
        }
        self.dataCount = 15;
        [self.topicCells removeAllObjects];
        for(NSInteger i = 0 ;i<self.dataCount; i++){
            [self.topicCells addObject:self.topicAllCells[i]];
        }
        [self.tableView reloadData];
        [self dropDownEndRefreshing];
    });
}

#pragma mark - 上拉加载更多数据
-(void)loadMoreData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSInteger prvei = self.dataCount;
        self.dataCount += (self.topicAllCells.count - prvei) > 5 ? 5:(self.topicAllCells.count - prvei);
        for(NSInteger i = prvei ;i<self.dataCount; i++){
            [self.topicCells addObject:self.topicAllCells[i]];
        }
        [self.tableView reloadData];
        [self footerEndRefreshing];
    });
}


#pragma mark - 下拉刷新
-(void)dropDownBeginRefreshing{
    //如果正在刷新，直接返回
    if(self.refreshing) return;
    self.refreshing = YES;
    self.dropDownRefreshLab.text = @"正在刷新数据";
    
    [UIView animateWithDuration:0.25 animations:^{
        UIEdgeInsets inset = self.tableView.contentInset;
        inset.top += self.dropDownRefreshView.sk_height;
        self.tableView.contentInset = inset;
        //修改偏移量，重复点精华或者全部时候，可以自动回到最上方
        self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x,-(inset.top+SKNAVIHeight));
    }];
    [self loadNewData];
}

-(void)dropDownEndRefreshing{
    self.refreshing = NO;
    self.dropDownRefreshLab.text = @"下拉可以刷新";
    [UIView animateWithDuration:0.25 animations:^{
        UIEdgeInsets inset = self.tableView.contentInset;
        inset.top -= self.dropDownRefreshView.sk_height;
        self.tableView.contentInset = inset;
    }];
}

#pragma mark - 上拉刷新
-(void)footerBeginRefreshing{
    //如果正在刷新，直接返回
    if(self.refreshing) return;
    self.refreshing = YES;
    self.footerLab.text = @"正在加载更多数据...";
    [self loadMoreData];
}

-(void)footerEndRefreshing{
    self.refreshing = NO;
    self.footerLab.text = @"上拉可以加载更多";
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.footer.hidden = (self.dataCount == 0)||((self.tableView.contentSize.height)<=(SKSCreenH-SKTABBARHeight-SKNAVIHeight));//没有数据时隐藏上拉刷新控件
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topicCells.count;
}


//一个Cell实现多种cell类型的方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SKTopicItem *item = self.topicCells[indexPath.row];
    SKRootBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:SKRootBaseCellId];
    cell.rootbaseItem = item;
    return cell;
}



//创建多个cell类的写法，纯代码实现，比较繁琐
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    SKTopicItem *item = self.topicCells[indexPath.row];
//    SKBaseCell *cell = nil;
//    if(item.type == MovieType){
//        cell = [tableView dequeueReusableCellWithIdentifier:SKMovieCellId];
//        cell.backgroundColor = [UIColor redColor];
//    }
//    else if(item.type == SoundType){
//        cell = [tableView dequeueReusableCellWithIdentifier:SKSoundCellId];
//        cell.backgroundColor = [UIColor blueColor];
//    }
//    else if(item.type == PictureType){
//        cell = [tableView dequeueReusableCellWithIdentifier:SKPictureCellId];
//        cell.backgroundColor = [UIColor yellowColor];
//    }
//    else if(item.type == TopicType){
//        cell = [tableView dequeueReusableCellWithIdentifier:SKTopicCellId];
//        cell.backgroundColor = [UIColor greenColor];
//    }
//
//    cell.baseItem = self.topicCells[indexPath.row];
//
//    return cell;
//}

/**
 默认情况，每次刷新表格，有多少数据就会一次性调用多少次（浪费资源，如果有00条数据，每次reloadData时，就会一次性调用100次)
 每当CELL进入屏幕范围时，就会调用一次这个方法
 解决方法：
 降低这个方法的调用频率：将计算的东西放在模型中，避免重复计算，利用估算高度方法（利用代理，或者属性self.tableView.estimatedRowHeight），但是滚动条会不稳定，跳跃
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //topicCells字典要设置范型，否则是ID类型，无法使用点语法获得cellHeight
    return self.topicCells[indexPath.row].cellHeight;
}


//估算高度
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 100;
//}

@end
