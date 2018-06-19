//
//  SDMediaTool.h
//  SDVideo
//
//  Created by slowdony on 2018/6/12.
//  Copyright © 2018年 slowdony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
@interface SDMediaTool : NSObject


+(void )accessAudioFromVideoUrl:(NSURL *)videoUrl;

/**
 提取视频中的音频

 @param videoPath 视频路径
 @param completionHandle 完成回调
 */
+(void)accessAudioFromVideo:(NSString *)videoPath completion:(void (^)(NSURL *outputPath,BOOL isSucceed)) completionHandle;


/**
 合并视频和背景音乐

 @param videoPath 视频路径
 @param audioPath 背景音乐路径
 @param isNeedVideoVoice 是否需要原声
 @param videoVolume 视频音量
 @param audioVolume 背景音乐音量
 @param completionHandle 回调
 */
+(void)mergeAudioAndVideoFromVideoPath:(NSString *)videoPath audioPath:(NSString *)audioPath isNeedVideoVoice:(BOOL)isNeedVideoVoice videoVolume:(CGFloat )videoVolume audioVolume:(CGFloat)audioVolume  completion:(void (^)(NSURL *outputPath,BOOL isSucceed)) completionHandle;


/**
 截取音频
 
 @param audioPath 音频路径
 @param startTime 开始时间
 @param endTime 结束时间
 @param completionHandle 回调
 */
+ (void)interceptionAudioFromAudioPath:(NSString *)audioPath startTime:(CMTime)startTime endTime:(CMTime)endTime completion:(void (^)(NSURL *outPutUrl ,BOOL isSuccessed )) completionHandle;


/**
 保存视频

 @param videoUrl 视频路径
 @param completionHandle 完成回调
 */
+ (void)saveEditVideo:(NSURL *)videoUrl completion:(void (^)(NSString *response ,BOOL isSuccessed)) completionHandle;
@end
