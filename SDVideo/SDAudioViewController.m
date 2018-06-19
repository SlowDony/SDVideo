//
//  SDAudioViewController.m
//  SDVideo
//
//  Created by slowdony on 2018/6/12.
//  Copyright © 2018年 slowdony. All rights reserved.
//

#import "SDAudioViewController.h"
#import "SDHeader.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "SDMediaTool.h"
@interface SDAudioViewController ()

@property (nonatomic,strong)  AVPlayer *player;
@end

@implementation SDAudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
    // Do any additional setup after loading the view.
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
    [completebtn setTitle:@"保存" forState:UIControlStateNormal];
    completebtn.backgroundColor = UIColorFormRandom;
    [completebtn  addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: completebtn];
    
   
}

- (void)setUrl:(NSURL *)url{
    _url = url;
    [self playVideo];
}


- (void)playVideo{
    
    UIView *playView = [[UIView alloc] init];
    playView.frame = CGRectMake(0, 120, SCREEN_WIDTH, 300);
    playView.backgroundColor = UIColorFormRandom;
    [self.view addSubview:playView];
    
    //1 创建AVPlayerItem
    AVPlayerItem *playerItem = [[AVPlayerItem alloc]initWithURL:self.url];
    
    //2.把AVPlayerItem放在AVPlayer上
    self.player = [[AVPlayer alloc]initWithPlayerItem:playerItem];
    
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



- (void)closeBtn:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)playerVideoBtn:(UIButton *)sender{
    [self.player play];
}

- (void)pauseVideoBtn:(UIButton *)sender{
    [self.player pause];
}

- (void)repeatPlay:(NSNotification *)notify{
    [self.player seekToTime:CMTimeMake(0, 1)];
    [self.player play];
}

- (void)saveBtnClick:(UIButton *)sender{
    [SDMediaTool saveEditVideo:self.url completion:^(NSString *response, BOOL isSuccessed) {
        if(isSuccessed){
            NSLog(@"保存成功");
        }else{
            NSLog(@"保存失败response:%@",response);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
