//
//  SKLoginRegisterViewController.m
//  BuDeJie
//
//  Created by hongchen li on 2022/2/23.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKLoginRegisterViewController.h"
#import "SKLoginRegisterView.h"
#import "SKFastLoginView.h"

@interface SKLoginRegisterViewController ()
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadCons;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation SKLoginRegisterViewController
//1.划分结构（顶部、中间、底部），2.用View占位（占位视图思想）
- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     屏幕适配
     1.一个view从xib中加载，一定要重新固定尺寸
     2.设置frame不要再viewDidLoad中设置，要在viewDidLayoutSubviews中设置,viewDidLayoutSubviews才会根据布局调整尺寸
     */
    //添加中间view,
    SKLoginRegisterView *loginV = [SKLoginRegisterView loginView];
    [self.middleView addSubview:loginV];
    SKLoginRegisterView *registerV = [SKLoginRegisterView registerView];
    [self.middleView addSubview:registerV];
    
    //加载底部View
    SKFastLoginView *fastLogV = [SKFastLoginView fastLoginView];
    [self.bottomView addSubview:fastLogV];
}


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    SKLoginRegisterView *loginV = self.middleView.subviews[0];
    loginV.frame = CGRectMake(0, 0, self.middleView.sk_width*0.5, self.middleView.sk_height);
    SKLoginRegisterView *registerV = self.middleView.subviews[1];
    registerV.frame = CGRectMake(self.middleView.sk_width*0.5, 0, self.middleView.sk_width*0.5, self.middleView.sk_height);
    SKFastLoginView *fastLogV = self.bottomView.subviews[0];
    fastLogV.frame = self.bottomView.bounds;
}

- (IBAction)close:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickRegister:(UIButton *)sender {
    sender.selected = !sender.selected;
    _leadCons.constant = _leadCons.constant == 0? -self.middleView.sk_width*0.5:0;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}


@end
