//
//  ViewController.m
//  SDVideo
//
//  Created by slowdony on 2018/5/11.
//  Copyright © 2018年 slowdony. All rights reserved.
//

#import "ViewController.h"
#import "SDVideoViewController.h"
#import "SDAudioViewController.h"
#import "SDAudioAndVideoViewController.h"
#import "SDHeader.h"
#import "SDMediaTool.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)setupUI{
    //
    UIButton *orginVideo = [UIButton buttonWithType:UIButtonTypeCustom];
    orginVideo.frame = CGRectMake(0, 10, 100, 100);
    [orginVideo setTitle:@"原视频" forState:UIControlStateNormal];
    [orginVideo  addTarget:self action:@selector(orginVideoClick:) forControlEvents:UIControlEventTouchUpInside];
    orginVideo.backgroundColor = UIColorFormRandom;
    [self.view addSubview: orginVideo];
    
    //
    UIButton * accessAudio = [UIButton buttonWithType:UIButtonTypeCustom];
    accessAudio.frame = CGRectMake(100, 10, 100, 100);
    [accessAudio setTitle:@"提取音频" forState:UIControlStateNormal];
    [accessAudio  addTarget:self action:@selector(accessAudioClick:) forControlEvents:UIControlEventTouchUpInside];
    accessAudio.backgroundColor = UIColorFormRandom;
    [self.view addSubview: accessAudio];
    
    //音频视频合成
    UIButton * finallyVideo = [UIButton buttonWithType:UIButtonTypeCustom];
    finallyVideo.frame = CGRectMake(200, 10, 100, 100);
    [finallyVideo setTitle:@"音视频合成" forState:UIControlStateNormal];
    [finallyVideo  addTarget:self action:@selector(finallyVideoClick:) forControlEvents:UIControlEventTouchUpInside];
    finallyVideo.backgroundColor = UIColorFormRandom;
    [self.view addSubview: finallyVideo];
    
    
}

- (void)orginVideoClick:(UIButton *)sender{
    SDVideoViewController *vc = [[SDVideoViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)accessAudioClick:(UIButton *)sender{
    //1 创建AVPlayerItem
    NSString *loc = [[NSBundle mainBundle] pathForResource:@"IMG_0596" ofType:@"mp4"];
   
    [SDMediaTool accessAudioFromVideo:loc completion:^(NSURL *outputPath, BOOL isSucceed) {
        if (isSucceed) {
        dispatch_async(dispatch_get_main_queue(), ^{
                SDAudioViewController *vc = [[SDAudioViewController alloc]init];
                vc.url = outputPath;
                [self.navigationController pushViewController:vc animated:YES];
        });
        }
    }];
    
}

- (void)finallyVideoClick:(UIButton *)sender{
    
    SDAudioAndVideoViewController *vc = [[SDAudioAndVideoViewController alloc]init];
    NSString *loc = [[NSBundle mainBundle] pathForResource:@"IMG_0596" ofType:@"mp4"];
    NSString *audioPath = [[NSBundle mainBundle]pathForResource:@"HigherBrothers" ofType:@"mp3"];
    vc.videoUrl = loc;
    vc.audioUrl = audioPath;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
