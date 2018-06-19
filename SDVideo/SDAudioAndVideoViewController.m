//
//  SDAudioAndVideoViewController.m
//  SDVideo
//
//  Created by slowdony on 2018/6/13.
//  Copyright © 2018年 slowdony. All rights reserved.
//

#import "SDAudioAndVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "SDHeader.h"
#import "SDAudioViewController.h"
#import "SDMediaTool.h"
@interface SDAudioAndVideoViewController ()
@property (nonatomic,strong)  AVPlayer *player;
@property (nonatomic,strong)  AVAudioPlayer *audioPlayer;
@property (nonatomic,strong) UISlider *originalSlider;
@property (nonatomic,strong) UISlider *audioSlider;
@end

@implementation SDAudioAndVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setUI];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.audioPlayer stop];
    [self.player pause];
}

- (void)setUI{
    
    CGFloat width = SCREEN_WIDTH/4;
    CGFloat height = 50;
    
    //返回
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, width, height);
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    btn.backgroundColor = UIColorFormRandom;
    [btn  addTarget:self action:@selector(closeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: btn];
    
    //播放
    UIButton *playerVideo = [UIButton buttonWithType:UIButtonTypeCustom];
    playerVideo.frame = CGRectMake(width, 0, width, height);
    [playerVideo setTitle:@"播放" forState:UIControlStateNormal];
    playerVideo.backgroundColor = UIColorFormRandom;
    [playerVideo  addTarget:self action:@selector(playerVideoBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: playerVideo];
    
    //返回
    UIButton *pauseVideo = [UIButton buttonWithType:UIButtonTypeCustom];
    pauseVideo.frame = CGRectMake(width*2, 0, width, height);
    [pauseVideo setTitle:@"停止" forState:UIControlStateNormal];
    pauseVideo.backgroundColor = UIColorFormRandom;
    [pauseVideo  addTarget:self action:@selector(pauseVideoBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: pauseVideo];
    
    //合成
    UIButton *completebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    completebtn.frame = CGRectMake(width*3, 0, width, height);
    [completebtn setTitle:@"合成" forState:UIControlStateNormal];
    completebtn.backgroundColor = UIColorFormRandom;
    [completebtn  addTarget:self action:@selector(completebtnBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: completebtn];
    //
    UILabel *originalLabel = [[UILabel alloc] init];
    originalLabel.frame = CGRectMake(20, SCREEN_HEIGHT-100, 80, 30);
    originalLabel.backgroundColor = [UIColor clearColor];
    originalLabel.textColor = [UIColor blackColor];
    originalLabel.text = @"原声";
    originalLabel.textAlignment = NSTextAlignmentLeft;
    originalLabel.font = [UIFont systemFontOfSize:14];
    originalLabel.numberOfLines = 1;
    [self.view addSubview:originalLabel];
    
    UISlider *originalSlider = [[UISlider alloc]initWithFrame:CGRectMake(100, SCREEN_HEIGHT-100, SCREEN_WIDTH-120, 30)];
    originalSlider.value = 5;
    originalSlider.maximumValue = 10;
    originalSlider.minimumValue = 0;
    [originalSlider addTarget:self action:@selector(orginalSliderClick:) forControlEvents:UIControlEventValueChanged];
    self.originalSlider = originalSlider;
    [self.view addSubview:originalSlider];
    
    
    UILabel *audiolLabel = [[UILabel alloc] init];
    audiolLabel.frame = CGRectMake(20, SCREEN_HEIGHT-50, 80, 30);
    audiolLabel.backgroundColor = [UIColor clearColor];
    audiolLabel.textColor = [UIColor blackColor];
    audiolLabel.text = @"配乐";
    audiolLabel.textAlignment = NSTextAlignmentLeft;
    audiolLabel.font = [UIFont systemFontOfSize:14];
    audiolLabel.numberOfLines = 1;
    [self.view addSubview:audiolLabel];
    
    UISlider *audioSlider = [[UISlider alloc]initWithFrame:CGRectMake(100,SCREEN_HEIGHT-50 , SCREEN_WIDTH-120, 30)];
    audioSlider.value = 5;
    audioSlider.maximumValue = 10;
    audioSlider.minimumValue = 0;
    [audioSlider  addTarget:self action:@selector(audioSliderClick:) forControlEvents:UIControlEventValueChanged];
    self.audioSlider = audioSlider;
    [self.view addSubview:audioSlider];
    
    
}

-(void)setVideoUrl:(NSString *)videoUrl{
    _videoUrl = videoUrl;
    [self playVideo];
}

- (void)setAudioUrl:(NSString *)audioUrl{
    _audioUrl = audioUrl;
    [self setAudioPlayer];
}


- (void)playVideo{
    
    UIView *playView = [[UIView alloc] init];
    playView.frame = CGRectMake(0, 120, SCREEN_WIDTH, 300);
    playView.backgroundColor = UIColorFormRandom;
    [self.view addSubview:playView];
    
    //1 创建AVPlayerItem
    //    NSString *loc = [[NSBundle mainBundle] pathForResource:@"HigherBrothers" ofType:@"mp3"];
    //
    NSURL *url = [NSURL fileURLWithPath:self.videoUrl];
    AVPlayerItem *playerItem = [[AVPlayerItem alloc]initWithURL:url];
    
    //2.把AVPlayerItem放在AVPlayer上
    self.player = [[AVPlayer alloc]initWithPlayerItem:playerItem];
    self.player.volume = 5.0f;
    //3 再把AVPlayer放到 AVPlayerLayer上
    AVPlayerLayer *avplayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    avplayerLayer.frame = CGRectMake(0,0,SCREEN_WIDTH, 300);
    
    //4 最后把 AVPlayerLayer放到self.view.layer上(也就是需要放置的视图的layer层上)
    [playView.layer addSublayer:avplayerLayer];
   
    [self.player play];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(repeatPlay:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)setAudioPlayer{
    
    NSError *error;
    NSURL *url = [NSURL fileURLWithPath:self.audioUrl];
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    if (!error){
        self.audioPlayer.numberOfLoops = -1;//循环播放
        [self.audioPlayer prepareToPlay]; //准备播放
        [self.audioPlayer play];
    }else{
        NSLog(@"error:%@",error);
    }
}

#pragma mark - clicks

- (void)closeBtn:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)playerVideoBtn:(UIButton *)sender{
    [self.player play];
    [self.audioPlayer play];
}

- (void)pauseVideoBtn:(UIButton *)sender{
    [self.player pause];
    [self.audioPlayer pause];
}

///合成
- (void)completebtnBtn:(UIButton *)sender{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [SDMediaTool mergeAudioAndVideoFromVideoPath:self.videoUrl audioPath:self.audioUrl isNeedVideoVoice:YES videoVolume:self.originalSlider.value audioVolume:self.audioSlider.value completion:^(NSURL *outputPath, BOOL isSucceed) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(isSucceed){
                    
                    SDAudioViewController *vc = [[SDAudioViewController alloc]init];
                    vc.url = outputPath;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            });
        }];
    });
    
    
    
    
    
}

- (void)orginalSliderClick:(UISlider *)slider{
    NSLog(@"slider:%f",slider.value);
    self.player.volume = slider.value;
}

- (void)audioSliderClick:(UISlider *)slider{
    
    self.audioPlayer.volume = slider.value;
}


#pragma mark -
-(void)repeatPlay:(NSNotification *)notify{
    [self.player seekToTime:CMTimeMake(0, 1)];
    [self.player play];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
