//
//  SKRootBaseCell.m
//  BuDeJie
//
//  Created by hongchen li on 2022/3/4.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKRootBaseCell.h"
#import "SKTopicItem.h"
#import <UIImageView+WebCache.h>
#import "SKTopicMovieV.h"
#import "SKTopicSoundV.h"
#import "SKTopicPictureV.h"

@interface SKRootBaseCell()
/// 头像
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
/// 名字
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;
/// 创建时间
@property (weak, nonatomic) IBOutlet UILabel *creatTimeLab;
/// 发布文字内容
@property (weak, nonatomic) IBOutlet UILabel *topicTextLab;
/// 顶
@property (weak, nonatomic) IBOutlet UIButton *upBtn;
/// 踩
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
/// 分享
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
/// 评论
@property (weak, nonatomic) IBOutlet UIButton *replyBtn;
@property (weak, nonatomic) IBOutlet UIView *hotReplayView;
@property (weak, nonatomic) IBOutlet UILabel *hoReplayLab;

@property (nonatomic,weak) SKTopicMovieV *topicMovieV;
@property (nonatomic,weak) SKTopicSoundV *topicSoundV;
@property (nonatomic,weak) SKTopicPictureV *topicPictureV;
@end

@implementation SKRootBaseCell

- (SKTopicMovieV *)topicMovieV{
    if(_topicMovieV == nil){
        SKTopicMovieV * topicMovieV = [SKTopicMovieV SK_viewFromXib];
        [self.contentView addSubview:topicMovieV];
        _topicMovieV = topicMovieV;
    }
    return _topicMovieV;
}

- (SKTopicSoundV *)topicSoundV{
    if(_topicSoundV == nil){
        SKTopicSoundV * topicSoundV = [SKTopicSoundV SK_viewFromXib];
        [self.contentView addSubview:topicSoundV];
        _topicSoundV = topicSoundV;
    }
    return _topicSoundV;
}

- (SKTopicPictureV *)topicPictureV{
    if(_topicPictureV == nil){
        SKTopicPictureV * topicPictureV = [SKTopicPictureV SK_viewFromXib];
        [self.contentView addSubview:topicPictureV];
        _topicPictureV = topicPictureV;
    }
    return _topicPictureV;
}

- (void)awakeFromNib {
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    _userIconImageView.layer.cornerRadius  = 25;
    _userIconImageView.layer.masksToBounds = YES;
    
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    [super awakeFromNib];
}

- (void)setFrame:(CGRect)frame{
//    frame.origin.x +=5;
//    frame.size.width -=10;
    frame.size.height -= 10;
    [super setFrame:frame];
}

- (void)setRootbaseItem:(SKTopicItem *)rootbaseItem{
    _rootbaseItem = rootbaseItem;
    //options:0表示放在沙盒中缓存
    [self.userIconImageView sd_setImageWithURL:[NSURL URLWithString:rootbaseItem.icon] placeholderImage:[UIImage imageWithRenderOriginalName:@"defaultUserIcon"] options:0 completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if(!image) return;//如果图片下载失败，直接返回避免图片位置显示空白
    }];
    self.userNameLab.text = rootbaseItem.name;
    self.creatTimeLab.text = rootbaseItem.date;
    self.topicTextLab.text = rootbaseItem.topic;
    
    [self setTitleBtnsText:self.upBtn number:rootbaseItem.top.intValue placeholder:@"顶"];
    [self setTitleBtnsText:self.downBtn number:rootbaseItem.low.intValue placeholder:@"踩"];
    [self setTitleBtnsText:self.shareBtn number:rootbaseItem.share.intValue placeholder:@"分享"];
    [self setTitleBtnsText:self.replyBtn number:rootbaseItem.reply.intValue placeholder:@"回复"];
    
    if(rootbaseItem.hotReplay.length){
        self.hotReplayView.hidden = NO;
        self.hoReplayLab.text = rootbaseItem.hotReplay;
    }
    else{
        self.hotReplayView.hidden = YES;
    }
    
    //懒加载避免重复添加控件
    if(rootbaseItem.type == MovieType){//视频
        //避免循环利用时段子显示出错
        self.topicMovieV.hidden = NO;
        self.topicSoundV.hidden = YES;
        self.topicPictureV.hidden = YES;
        self.topicMovieV.rootbaseItem = rootbaseItem;
    }
    else if(rootbaseItem.type == SoundType){//声音
        //避免循环利用时段子显示出错
        self.topicMovieV.hidden = YES;
        self.topicSoundV.hidden = NO;
        self.topicPictureV.hidden = YES;
        self.topicSoundV.rootbaseItem = rootbaseItem;
    }
    else if(rootbaseItem.type == PictureType){//图片
        //避免循环利用时段子显示出错
        self.topicMovieV.hidden = YES;
        self.topicSoundV.hidden = YES;
        self.topicPictureV.hidden = NO;
        self.topicPictureV.rootbaseItem = rootbaseItem;
    }
    else{
        //避免循环利用时段子显示出错
        self.topicMovieV.hidden = YES;
        self.topicSoundV.hidden = YES;
        self.topicPictureV.hidden = YES;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //设置中间控件的frame
    if(self.rootbaseItem.type == MovieType){//视频
        self.topicMovieV.frame = self.rootbaseItem.middleFrame;
    }
    else if(self.rootbaseItem.type == SoundType){//声音
        self.topicSoundV.frame = self.rootbaseItem.middleFrame;
    }
    else if(self.rootbaseItem.type == PictureType){//图片
        self.topicPictureV.frame = self.rootbaseItem.middleFrame;
    }
}

-(void)setTitleBtnsText:(UIButton*)btn number:(NSInteger)number placeholder:(NSString*)placeholder{
    if(number >=10000){
        [btn setTitle:[NSString stringWithFormat:@"%.1f万",number/10000.0] forState:UIControlStateNormal];
    }
    else if(number >0){
        [btn setTitle:[NSString stringWithFormat:@"%zd",number] forState:UIControlStateNormal];
    }
    else{
        [btn setTitle:placeholder forState:UIControlStateNormal];
    }
}

- (IBAction)moreClick:(UIButton *)sender {
    SKFunc;
}

@end
