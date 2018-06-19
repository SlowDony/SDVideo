//
//  SDMediaTool.m
//  SDVideo
//
//  Created by slowdony on 2018/6/12.
//  Copyright © 2018年 slowdony. All rights reserved.
//

#import "SDMediaTool.h"
#import <Photos/Photos.h>
@implementation SDMediaTool

+(void )accessAudioFromVideoUrl:(NSURL *)videoUrl
{
//    AVAsset *asset = [AVAsset assetWithURL:videoUrl];
////    NSURL *assetUrl = [NSURL URLWithString:videoPath];
//    NSURL *assetUrl = [NSURL fileURLWithPath:videoPath];
    AVAsset *asset = [AVAsset assetWithURL:videoUrl];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    
    NSString *audioPath = [NSTemporaryDirectory() stringByAppendingFormat:@"%@.mp3",str];
    CMTime start = CMTimeMakeWithSeconds(0, asset.duration.timescale);
    CMTime duration = asset.duration;
    CMTimeRange range = CMTimeRangeMake(start, duration);
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:asset presetName:AVAssetExportPresetAppleM4A];
    exportSession.outputURL = [NSURL fileURLWithPath:audioPath];
    exportSession.outputFileType = AVFileTypeAppleM4A;
    exportSession.timeRange = range;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        if(exportSession.status == AVAssetExportSessionStatusFailed){
            NSLog(@"错误:%@",exportSession.error);
        }else if (exportSession.status == AVAssetExportSessionStatusCompleted){
            NSLog(@"提取成功:%@",audioPath);
        }
    }];
}

/**
 提取视频中的音频
 
 @param videoPath 视频路径
 @param completionHandle 完成回调
 */
+(void)accessAudioFromVideo:(NSString *)videoPath completion:(void (^)(NSURL *outputPath,BOOL isSucceed)) completionHandle{
    
    AVAsset *videoAsset = [AVAsset assetWithURL:[NSURL fileURLWithPath:videoPath]];
    //1创建一个AVMutableComposition
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc]init];
    //2 创建一个轨道,类型为AVMediaTypeAudio
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    //获取videoPath的音频插入轨道
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    //4创建输出路径
    NSURL *outputURL = [SDMediaTool exporterPath:@"mp4"];
    
    //5创建输出对象
   AVAssetExportSession *exporter = [[AVAssetExportSession alloc]initWithAsset:mixComposition presetName:AVAssetExportPresetAppleM4A];
    exporter.outputURL = outputURL ;
    exporter.outputFileType = AVFileTypeAppleM4A;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        if (exporter.status == AVAssetExportSessionStatusCompleted) {
            NSURL *outputURL = exporter.outputURL;
            completionHandle(outputURL,YES);
        }else {
            NSLog(@"失败%@",exporter.error.description);
            completionHandle(outputURL,NO);
        }
    }];
    
}
/**
 合并视频和背景音乐
 
 @param videoPath 视频路径
 @param audioPath 背景音乐路径
 @param isNeedVideoVoice 是否需要原声
 @param videoVolume 视频音量
 @param audioVolume 背景音乐音量
 @param completionHandle 回调
 */
+(void)mergeAudioAndVideoFromVideoPath:(NSString *)videoPath audioPath:(NSString *)audioPath isNeedVideoVoice:(BOOL)isNeedVideoVoice videoVolume:(CGFloat )videoVolume audioVolume:(CGFloat)audioVolume  completion:(void (^)(NSURL *outputPath,BOOL isSucceed)) completionHandle{
    
    AVAsset *videoAsset = [AVAsset assetWithURL:[NSURL fileURLWithPath:videoPath]];
    AVAsset *audioAsset = [AVAsset assetWithURL:[NSURL fileURLWithPath:audioPath]];
    CMTime duration = videoAsset.duration;
    CMTimeRange video_timeRange = CMTimeRangeMake(kCMTimeZero, duration);
    ///视频素材
    AVAssetTrack *videoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo]objectAtIndex:0];
    ///背景音乐素材
    AVAssetTrack *audioTrack = [[audioAsset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0];
    
    ///创建编辑composition
    AVMutableComposition *composition = [[AVMutableComposition alloc]init];
    ///将视频素材添加到视频轨道里
    AVMutableCompositionTrack *videoCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [videoCompositionTrack insertTimeRange:video_timeRange ofTrack:videoTrack atTime:kCMTimeZero error:nil];
    
    ///将音频素材添加到音频轨道里
    AVMutableCompositionTrack *audioCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [audioCompositionTrack insertTimeRange:video_timeRange ofTrack:audioTrack atTime:kCMTimeZero error:nil];
    
    ///是否添加视频原生
    AVMutableCompositionTrack *orginCompositionTrack = nil;
    if (isNeedVideoVoice){
        AVAssetTrack *orginTrack = [[videoAsset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0];
        orginCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [orginCompositionTrack insertTimeRange:video_timeRange ofTrack:orginTrack atTime:kCMTimeZero error:nil];
    }
    
    //创建输出路径
    NSURL *exporturl = [SDMediaTool exporterPath:@"mp4"];
    
    //创建输出对象
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:composition presetName:AVAssetExportPresetHighestQuality];
    exportSession.outputURL = exporturl;
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.audioMix = [self mergeAudioMixWithVideoTrack:orginCompositionTrack videoVolume:videoVolume audioTrack:audioCompositionTrack audioVolume:audioVolume atTime:kCMTimeZero];
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        if(exportSession.status == AVAssetExportSessionStatusCompleted){
            completionHandle(exporturl,YES);
        }else{
             completionHandle(exporturl,NO);
        }
    }];
    
    
}


/**
 截取音频

 @param audioPath 音频路径
 @param startTime 开始时间
 @param endTime 结束时间
 @param completionHandle 回调
 */
+ (void)interceptionAudioFromAudioPath:(NSString *)audioPath startTime:(CMTime)startTime endTime:(CMTime)endTime completion:(void (^)(NSURL *outPutUrl ,BOOL isSuccessed )) completionHandle{
    NSURL *audioUrl = [NSURL fileURLWithPath:audioPath];
    
    AVAsset *avasset = [AVAsset assetWithURL:audioUrl];
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avasset];
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avasset presetName:AVAssetExportPresetAppleM4A];
//        CMTime startTime = CMTimeMake(startTime, 1);
//        CMTime endTime = CMTimeMake(startTime+playTime, 1);
        CMTimeRange exportTimeRange = CMTimeRangeFromTimeToTime(startTime, endTime);
        NSURL *exprotUrl = [self exporterPath:@"m4a"];
        exportSession.outputURL = exprotUrl;
        exportSession.outputFileType = AVFileTypeAppleM4A;
        exportSession.timeRange = exportTimeRange;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            if (exportSession.status ==AVAssetExportSessionStatusCompleted) {
                completionHandle (exportSession.outputURL ,YES);
                
            }else{
                NSLog(@"失败:%@",exportSession.error);
                completionHandle (exportSession.outputURL ,NO);
            }
            
            
        }];
        
    }
}


/**
 设置背景音乐和视频音乐合成

 @param videoTrack 视频轨道
 @param videoVolume 视频音量
 @param audioTrack 背景音频轨道
 @param audioVolume 背景音频音量
 @param timeRange 时间范围
 @return 返回值
 */
+ (AVAudioMix *)mergeAudioMixWithVideoTrack:(AVCompositionTrack *)videoTrack videoVolume:(CGFloat )videoVolume audioTrack:(AVCompositionTrack *)audioTrack audioVolume:(CGFloat)audioVolume atTime:(CMTime )timeRange
{
    //创建音配混合类
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    //拿到视频音轨设置音量
    AVMutableAudioMixInputParameters * videoParameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:videoTrack];
    [videoParameters setVolume:videoVolume atTime:timeRange];
    //设置背景音乐音量
    AVMutableAudioMixInputParameters *audioParameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:audioTrack];
    [audioParameters setVolume:audioVolume atTime:timeRange];
    
    audioMix.inputParameters = @[videoParameters,audioParameters];
    return audioMix;
    
}





///输出路径
+ (NSURL *)exporterPath:(NSString *)filename{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"output%@.%@",str,filename];
    
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    
    NSString *outputFilePath =[documentsDirectory stringByAppendingPathComponent:fileName];
    
    if([[NSFileManager defaultManager]fileExistsAtPath:outputFilePath]){
        
        [[NSFileManager defaultManager]removeItemAtPath:outputFilePath error:nil];
    }
    
    return [NSURL fileURLWithPath:outputFilePath];
}

/**
 保存视频
 
 @param videoUrl 视频路径
 @param completionHandle 完成回调
 */
+ (void)saveEditVideo:(NSURL *)videoUrl completion:(void (^)(NSString *response ,BOOL isSuccessed)) completionHandle{
    [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
        PHAssetChangeRequest *request = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:videoUrl];
        NSLog(@"requset:%@",request.placeholderForCreatedAsset.localIdentifier);
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if(success){
            completionHandle(@"sussess",YES);
        }
        else{
            completionHandle([NSString stringWithFormat:@"error:%@",error],NO);
        }
    }];
    
    
}











@end
