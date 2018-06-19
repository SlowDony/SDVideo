//
//  SDVideoViewController.m
//  SDVideo
//
//  Created by slowdony on 2018/5/11.
//  Copyright © 2018年 slowdony. All rights reserved.
//

#import "SDVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "SDHeader.h"
@interface SDVideoViewController ()

@property (nonatomic,strong)  AVPlayer *player;
@end

@implementation SDVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUI{
    //返回
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 100, 100);
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [btn  addTarget:self action:@selector(closeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: btn];
    
    //播放
    UIButton *playerVideo = [UIButton buttonWithType:UIButtonTypeCustom];
    playerVideo.frame = CGRectMake(102, 0, 100, 100);
    [playerVideo setTitle:@"播放" forState:UIControlStateNormal];
    playerVideo.backgroundColor = [UIColor redColor];
    [playerVideo  addTarget:self action:@selector(playerVideoBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: playerVideo];
    
    //返回
    UIButton *pauseVideo = [UIButton buttonWithType:UIButtonTypeCustom];
    pauseVideo.frame = CGRectMake(206, 0, 100, 100);
    [pauseVideo setTitle:@"停止" forState:UIControlStateNormal];
    pauseVideo.backgroundColor = [UIColor redColor];
    [pauseVideo  addTarget:self action:@selector(pauseVideoBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: pauseVideo];
    
    [self playVideo];
}

- (void)playVideo{
    //1 创建AVPlayerItem
    NSString *loc = [[NSBundle mainBundle] pathForResource:@"IMG_0596" ofType:@"mp4"];
    
    NSURL *url = [NSURL fileURLWithPath:loc];
    AVPlayerItem *playerItem = [[AVPlayerItem alloc]initWithURL:url];
    
    //2.把AVPlayerItem放在AVPlayer上
    self.player = [[AVPlayer alloc]initWithPlayerItem:playerItem];
    
    //3 再把AVPlayer放到 AVPlayerLayer上
    AVPlayerLayer *avplayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    avplayerLayer.frame = CGRectMake(0, 100, 414, 300);
    
    //4 最后把 AVPlayerLayer放到self.view.layer上(也就是需要放置的视图的layer层上)
    [self.view.layer addSublayer:avplayerLayer];
    
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
