//
//  SKEssenceViewController.m
//  BuDeJie
//
//  Created by hongchen li on 2022/2/18.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKEssenceViewController.h"

#import "SKAllViewController.h"
#import "SKMovieViewController.h"
#import "SKSoundViewController.h"
#import "SKPictureViewController.h"
#import "SKTopicViewController.h"

#import "SKTitleButton.h"

@interface SKEssenceViewController ()<UIScrollViewDelegate>
/// 存放所有TableViewController控制器
@property (nonatomic,weak) UIScrollView *scrollView;
/// 标题栏
@property (nonatomic,strong) UIView *titlesView;
/// 记录上一次点击的标题按钮
@property (nonatomic,weak) SKTitleButton *prevTitleBtn;
/// 标题按钮下划线
@property (nonatomic,weak) UIView *underTitleView;
@end

@implementation SKEssenceViewController

#pragma mark - 初始化

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化子控制器
    [self setupAllChileVcs];
    //设置导航条
    [self setupNavBar];
    //添加内容滚动视图
    [self setupScrollView];
    //添加标题视图
    [self setupTitlesView];
    //添加第0个子控制器
    [self addChildVCWithIndex:0];
}

#pragma mark - 初始化子控制器
-(void)setupAllChileVcs{
    SKAllViewController * allVc =[[SKAllViewController alloc]init];
    allVc.loadVCtype = AllType;
    [self addChildViewController:allVc];
    
    SKMovieViewController * movieVc =[[SKMovieViewController alloc]init];
    movieVc.loadVCtype = MovieType;
    [self addChildViewController:movieVc];
    
    SKSoundViewController * soundVc =[[SKSoundViewController alloc]init];
    soundVc.loadVCtype = SoundType;
    [self addChildViewController:soundVc];
    
    SKPictureViewController * pictureVc =[[SKPictureViewController alloc]init];
    pictureVc.loadVCtype = PictureType;
    [self addChildViewController:pictureVc];
    
    SKTopicViewController * topicVc =[[SKTopicViewController alloc]init];
    topicVc.loadVCtype = TopicType;
    [self addChildViewController:topicVc];
}

#pragma mark - 设置导航条
-(void)setupNavBar{
    //游戏
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"nav_item_game_icon"] highImage:[UIImage imageNamed:@"nav_item_game_click_icon"] target:self action:@selector(game)];
    //随机
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"navigationButtonRandom"] highImage:[UIImage imageNamed:@"navigationButtonRandomClick"] target:self action:@selector(random)];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
}

#pragma mark - 添加内容滚动视图
-(void)setupScrollView{
    //不允许自动修UIScrollView的内边距,解决向上滑动到最后显示不全问题
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    //点击状态栏的时候，这个scrollView不会滚动，scrollsToTop属性，如果设为YES才会滚动并且只有一个被设置的时候，如果存在多个scrollView(包括使用了scrollViewd的tableView，collectionView)的scrollsToTop都设为YES，则不会滚动，之后的子控制器如果让谁滚动就把谁设置成YES，其他设置为NO，（还可以通过AppDelegate监听状态栏的点击事件）（IOS12.4已经不需要设置）这里为了实现重复点击刷新功能用到这个属性
    scrollView.scrollsToTop = NO;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    CGFloat scrollViewW = scrollView.sk_width;
//    CGFloat scrollViewH = scrollView.sk_height;
    NSInteger count = self.childViewControllers.count;
    //初始化直接添加5个子控制器
//    for(NSInteger i = 0; i < count; i++){
//        UIView *childView = self.childViewControllers[i].view;
////        childView.frame = CGRectMake(i * scrollViewW, 0-SKTitleViewH-SKNAVIHeight, scrollViewW, scrollViewH+SKTitleViewH+SKNAVIHeight);
//        childView.frame = CGRectMake(i * scrollViewW, 0, scrollViewW, scrollViewH);
//        [scrollView addSubview:childView];
//    }
    scrollView.contentSize = CGSizeMake(count * scrollViewW, 0);
    self.scrollView = scrollView;
}

#pragma mark - 添加标题视图
-(void)setupTitlesView{
    UIView *titleView = [[UIScrollView alloc]init];
//    titleView.backgroundColor = SKColor(255, 255, 255, 0.6);
    titleView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];//给颜色添加透明度
    titleView.frame = CGRectMake(0, SKNAVIHeight, SKSCreenW, SKTitleViewH);
    [self.view addSubview:titleView];
    _titlesView = titleView;
    //添加标题栏内容
    [self setupTitleBtns];
    //添加标题栏下划线
    [self setupTitleUnderline];
    
}

#pragma mark - 添加标题栏按钮
-(void)setupTitleBtns{
    NSArray *titlearr = @[@"全部",@"视频",@"声音",@"图片",@"段子"];
    NSInteger count = titlearr.count;
    CGFloat btnW = self.titlesView.sk_width/count;
    CGFloat btnH = self.titlesView.sk_height;
    
    for(NSInteger i = 0 ;i < count; i++){
        SKTitleButton *titleBtn = [SKTitleButton  buttonWithType:UIButtonTypeCustom];
        titleBtn.frame = CGRectMake(i * btnW, 0, btnW, btnH);
//        titleBtn.backgroundColor = SKRandomColor;
        [titleBtn setTitle:titlearr[i] forState:UIControlStateNormal];
        titleBtn.tag = i;
        [titleBtn addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_titlesView addSubview:titleBtn];
    }
}

#pragma mark - 添加标题栏下划线
-(void)setupTitleUnderline{
    SKTitleButton *titleBtn = self.titlesView.subviews.firstObject;
    UIView *underView = [[UIView alloc] init];
    underView.backgroundColor = [titleBtn titleColorForState:UIControlStateSelected];
    underView.sk_height = 2;
    underView.sk_y = self.titlesView.sk_height - underView.sk_height;
    [self.titlesView addSubview:underView];
    self.underTitleView = underView;
    
    //初始化进入界面时候，下划线宽度为0 ，因为setupTitleUnderline是在viewDidLoad中调用的这个时候文子还没有显示，所以view强制调用sizeToFit根据文字计算尺寸
    [titleBtn.titleLabel sizeToFit];
    titleBtn.selected = YES;
    self.prevTitleBtn = titleBtn;
    self.underTitleView.sk_width = titleBtn.titleLabel.sk_width+10;
    self.underTitleView.sk_centerX = titleBtn.sk_centerX;
}

#pragma mark - 添加标题栏按钮点击事件
-(IBAction)titleButtonClick:(SKTitleButton*)titleBtn{
    
    if(self.prevTitleBtn == titleBtn){//判断是否重复点击事件
        //发出通知，告诉外界按钮被重复点击了
        [[NSNotificationCenter defaultCenter] postNotificationName:SKTitleButtonDidRepeatClickNSNotification object:nil];
    }
    [self dealTitleButtonClick:titleBtn];
    
}

#pragma mark - 处理标题按钮点击
-(void)dealTitleButtonClick:(SKTitleButton*)titleBtn{
    self.prevTitleBtn.selected = NO;
    titleBtn.selected = YES;
    self.prevTitleBtn = titleBtn;
    NSInteger index = titleBtn.tag;
    
    [UIView animateWithDuration:0.25 animations:^{
//        self.underTitleView.sk_width = [titleBtn.currentTitle sizeWithFont:titleBtn.titleLabel.font].width;//方法过期
//        self.underTitleView.sk_width = [titleBtn.currentTitle sizeWithAttributes:@{NSFontAttributeName:titleBtn.titleLabel.font}].width;//困难方法
        self.underTitleView.sk_width = titleBtn.titleLabel.sk_width+10;//简单方法
        self.underTitleView.sk_centerX = titleBtn.sk_centerX;
        //滚动scrollview
//        CGFloat offsetX = self.scrollView.sk_width * [self.titlesView.subviews indexOfObject:titleBtn];
        CGFloat offsetX = self.scrollView.sk_width * index;
        self.scrollView.contentOffset  = CGPointMake(offsetX, self.scrollView.contentOffset.y);
        
    }completion:^(BOOL finished) {
//        懒加载添加子控制器
        [self addChildVCWithIndex:index];
    }];
    
//    设置选中的scrollsToTop为YES，其他为NO（IOS12.4已经不需要设置）这里为了实现重复点击刷新功能用到这个属性
    NSInteger count = self.childViewControllers.count;
    for(NSInteger i = 0; i < count; i++){
        UIViewController *childVc = self.childViewControllers[i];
        if(!childVc.isViewLoaded) continue;//如果View没有被创建就不处理，防止，初始化创建了所有的View
        UIScrollView *scrollView = (UIScrollView *)childVc.view;
        if(![scrollView isKindOfClass:[UIScrollView class]]) continue;//防止非UIScrollView类型被设置
        scrollView.scrollsToTop = (i == index);
    }
}

#pragma mark - 添加指定控制器到ScrollView
-(void)addChildVCWithIndex:(NSInteger)i{
    //判断View是否已被加到过屏幕上
//    UIViewController *childVc = self.childViewControllers[i];
//    if(childVc.isViewLoaded) return;//方法一
    
    UIView *childView = self.childViewControllers[i].view;
    //判断View是否已被加到过屏幕上
    if(childView.superview) return;//方法二
//    if(childView.window) return;//方法三
    CGFloat scrollViewW = self.scrollView.sk_width;
    CGFloat scrollViewH = self.scrollView.sk_height;
    childView.frame = CGRectMake(i * scrollViewW, 0, scrollViewW, scrollViewH);
    [self.scrollView addSubview:childView];
}

#pragma mark - 点击游戏
-(void)game{
    
}

#pragma mark - 点击随机
-(void)random{
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //获取按钮的角标
    NSInteger i = scrollView.contentOffset.x/SKSCreenW;

    //获取按钮的两种方法
    SKTitleButton *btn = self.titlesView.subviews[i];//方法一
//    SKTitleButton *btn = [self.titlesView viewWithTag:i];//方法二，递归查找，包括自己和所有的子控件，还会查找子控件的子控件，由于任何控件默认的tag都是0，所以当是0时传入titleButtonClick崩溃，因为把自己传了（UIView）进去，导致UIView找不到setSelected方法，所以使用viewWithTag时候添加btn的tag时候加一个值让他不等于0
    //    1、选中标题
    [self dealTitleButtonClick:btn];
}

@end
