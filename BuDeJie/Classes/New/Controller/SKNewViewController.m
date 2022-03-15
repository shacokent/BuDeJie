//
//  SKNewViewController.m
//  BuDeJie
//
//  Created by hongchen li on 2022/2/18.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKNewViewController.h"
#import "SKSubTagViewController.h"
#import "SKCollectionCell.h"

@interface SKNewViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSArray *models;
@end

@implementation SKNewViewController
static NSString * const ID = @"SKCollectionCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SKRandomColor;
    //设置导航条
    [self setupNavBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarBtnRepeatClick) name:SKTabBarButtonDidRepeatClickNSNotification object:nil];
    
    
    //用UICollectionView添加UITableView，实现循环利用
    self.models = @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v"];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize =self.view.frame.size;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor redColor];
    collectionView.pagingEnabled = YES;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SKCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
    [self.view addSubview:collectionView];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.models.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SKCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.model = self.models[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    SKLog(@"%d",(int)(scrollView.contentOffset.x/scrollView.frame.size.width));
}

-(void)tabBarBtnRepeatClick{
    //重复点击不是新帖按钮，那么新帖不再window上,所以return
    if(self.view.window == nil) return;
    SKFunc;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 设置导航条
-(void)setupNavBar{
    //订阅
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"MainTagSubIcon"] highImage:[UIImage imageNamed:@"MainTagSubIconClick"] target:self action:@selector(tagClick)];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
}

-(void)tagClick{
    //进入推荐标签界面
    SKSubTagViewController *subTagVc = [[SKSubTagViewController alloc]init];
    [self.navigationController pushViewController:subTagVc animated:YES];
}


@end
