//
//  SKWebViewController.m
//  BuDeJie
//
//  Created by hongchen li on 2022/2/24.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKWebViewController.h"
#import <WebKit/WebKit.h>

@interface SKWebViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic,strong) WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBtnItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardBtnItem;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end

@implementation SKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加WebView
    WKWebView *webView = [[WKWebView alloc]init];
    _webView = webView;
    [self.contentView addSubview:webView];
    [webView loadRequest:[NSURLRequest requestWithURL:self.jumpurl]];
    
    //KVO 监听按钮状态
    //参数一：观察者
    //参数二：观察webView的哪个属性
    //参数三：NSKeyValueObservingOptionNew:观察新值改变
    
    //注意点：KVO用完一定要移除
    [webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
    [webView addObserver:self forKeyPath:@"canGoForward" options:NSKeyValueObservingOptionNew context:nil];
    //监听进度条
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"canGoBack"];
    [self.webView removeObserver:self forKeyPath:@"canGoForward"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

//观察属性只要有新值就会调用
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    self.backBtnItem.enabled = self.webView.canGoBack;
    self.forwardBtnItem.enabled = self.webView.canGoForward;
    self.progressView.progress = self.webView.estimatedProgress;
    self.progressView.hidden = self.webView.estimatedProgress >= 1;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.webView.frame = self.contentView.bounds;
}

//后退
- (IBAction)goBack:(id)sender {
    [self.webView goBack];
}

//前进
- (IBAction)goForward:(id)sender {
    [self.webView goForward];
}

//刷新
- (IBAction)reLoadView:(id)sender {
    [self.webView reload];
}



@end
