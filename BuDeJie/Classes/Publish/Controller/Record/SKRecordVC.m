//
//  SKRecordVC.m
//  BuDeJie
//
//  Created by hongchen li on 2022/3/29.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKRecordVC.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface SKRecordVC ()<AVAudioPlayerDelegate>
@property (nonatomic,strong) AVAudioRecorder *record;
@property (nonatomic,strong) AVAudioPlayer *player;
@property (nonatomic,strong) AVAudioSession *session;
@property (nonatomic,strong) AVPlayer *playerRemote;
@property (nonatomic,strong) AVPlayerViewController *avplayerVC;
@end

@implementation SKRecordVC

- (AVAudioRecorder *)record{
    if(_record == nil){
        NSURL *url = [NSURL URLWithString:@"/Users/hongchenli/Desktop/test.wav"];
        NSDictionary * configDic = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithFloat:16000.0],AVSampleRateKey, //采样率
            [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,// 录音格式 (仅支持苹果自己的格式)
            [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数默认 16
            [NSNumber numberWithInt:1], AVNumberOfChannelsKey,//通道的数目
            [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,//大端还是小端是内存的组织方式
            [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,//采样信号是整数还是浮点数
            [NSNumber numberWithInt:AVAudioQualityMax],AVEncoderAudioQualityKey,nil];//采样编码
        
        NSError *error = nil;
        AVAudioRecorder *record = [[AVAudioRecorder alloc] initWithURL:url settings:configDic error:&error];
        if(error == nil){
            _record = record;
            [record prepareToRecord];
        }
    }
    return _record;
}

//只能是本地URL地址，远程音乐不能使用这个类播放
- (AVAudioPlayer *)player{
    if(_player == nil){
        NSError * error = nil;
        NSURL *url = [NSURL URLWithString:@"/Users/hongchenli/Desktop/test.wav"];
        AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        if(error == nil){
            player.enableRate = YES;//设置可以倍速播放
            player.delegate = self;
            [player prepareToPlay];
            _player = player;
        }
    }
    return _player;
}

#pragma mark - 支持后台播放
- (AVAudioSession *)session{
    if(_session == nil){
        //后台播放，需要在后台模式中设置，并且设置音频回话
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *error = nil;
        [session setCategory:AVAudioSessionCategoryPlayback error:&error];
        if(error == nil){
            [session setActive:YES error:&error];
            if(error == nil){
                _session = session;
            }
        }
    }
    return _session;
}

- (AVPlayer *)playerRemote{
    if(_playerRemote == nil){
        NSURL *url = [NSURL URLWithString:@"https://vod.ruotongmusic.com/sv/16ad771a-179cd1b2509/16ad771a-179cd1b2509.wav"];
        //不可以切换数据源URL
//        AVPlayer *playerRemote = [[AVPlayer alloc] initWithURL:url];
        //可以切换数据源url
        AVPlayerItem * item = [[AVPlayerItem alloc] initWithURL:url];
        AVPlayer *playerRemote = [[AVPlayer alloc] initWithPlayerItem:item];
        _playerRemote = playerRemote;
    }
    return _playerRemote;
}

- (AVPlayerViewController *)avplayerVC{
    if(_avplayerVC == nil){
        AVPlayerViewController *avplayerVC = [[AVPlayerViewController alloc] init];
        NSURL *url = [NSURL URLWithString:@"https://vod.ruotongmusic.com/sv/16ad771a-179cd1b2509/16ad771a-179cd1b2509.wav"];
        AVPlayerItem * item = [[AVPlayerItem alloc] initWithURL:url];
        AVPlayer *playerRemote = [[AVPlayer alloc] initWithPlayerItem:item];
        avplayerVC.player = playerRemote;
        _avplayerVC = avplayerVC;
    }
    return _avplayerVC;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self playerVCRun];
}


#pragma mark - 录音
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //开始录音,需要在Info.plist添加NSMicrophoneUsageDescription
    [self.record record];
//        [self.record recordAtTime:record.deviceCurrentTime + 10];//未来某个时间点开始录音，注意要拿到当前系统时间加上一个时间
//        [self.record recordForDuration:10];//现在开始录录多久
//        [self.record recordAtTime:record.deviceCurrentTime + 10 forDuration:10];//从哪个时间点开始录，录多久，，注意要拿到当前系统时间加上一个时间
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //结束录音
//    根据当前的录音时间做处理，录音时间不超过2S就提示录音时间短柄删除，超过2S就正常处理
    if(self.record.currentTime < 2){
        [self.record stop];
        [self.record deleteRecording];
        [SVProgressHUD showErrorWithStatus:@"录音时间短"];
    }
    else{
        [self.record stop];
        
#pragma mark - 根据soundid播放音效
        NSURL *url = [NSURL URLWithString:@"/Users/hongchenli/Desktop/test.wav"];
        SystemSoundID soundId = 0;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(url), &soundId);
//        AudioServicesPlayAlertSound(soundId);//带震动播放
//        AudioServicesPlaySystemSound(soundId);//不带震动播放
        AudioServicesPlaySystemSoundWithCompletion(soundId, ^{
            //播放完释放
            AudioServicesDisposeSystemSoundID(soundId);
            SKLog(@"AudioServicesPlaySystemSoundWithCompletion");
            [self playRemateSound];
        });//不带震动播放，带block
        
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self switchSong];
}

#pragma mark - 本地音频播放
- (IBAction)playSound:(UIButton *)sender {
    [self session];
    [self.player play];
}

- (IBAction)pauseSound:(UIButton *)sender {
    if(self.player.isPlaying){
        [self.player pause];
    }
}

- (IBAction)stopSound:(UIButton *)sender {
    if(self.player.isPlaying){
        [self.player stop];
    }
}

- (IBAction)forward:(UIButton *)sender {
    if(self.player.isPlaying){
        //注意：这个值自动会做好容错适配，不需要我们处理负数或超出最大播放时长
        self.player.currentTime += 2;
    }
}

- (IBAction)rewind:(UIButton *)sender {
    if(self.player.isPlaying){
        //注意：这个值自动会做好容错适配，不需要我们处理负数或超出最大播放时长
        self.player.currentTime -= 2;
    }
}

- (IBAction)doublSpeed:(UIButton *)sender {
//        在prepareToPlay之前必须设置enableRate = true
    self.player.rate = 2.0;//2倍
}

- (IBAction)volumChange:(UISlider *)sender {
    self.player.volume = sender.value;
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    //播放完成
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    //解码错误
}

#pragma mark - 远程音乐播放
-(void)playRemateSound{
    self.playerRemote = nil;
    [self.playerRemote play];
}

-(void)switchSong{
    //切换数据源
    NSURL *url = [NSURL URLWithString:@"https://vod.ruotongmusic.com/sv/2b3b3c09-179ccc9e2b8/2b3b3c09-179ccc9e2b8.wav"];
    AVPlayerItem * item = [[AVPlayerItem alloc] initWithURL:url];
    [self.playerRemote replaceCurrentItemWithPlayerItem:item];
    [self.playerRemote play];
}


#pragma mark - 使用AVplayerViewController播放,依赖AVKit
-(void)playerVCRun{
    self.avplayerVC = nil;
    [self presentViewController:self.avplayerVC animated:YES completion:^{
        [self.avplayerVC.player play];
    }];
}


@end
