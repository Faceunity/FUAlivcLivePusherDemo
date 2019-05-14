//
//  SampleHandler.m
//  AlivcLiveBroadcast
//
//  Created by 陈春光 on 2018/1/23.
//  Copyright © 2018年 TripleL. All rights reserved.
//


#import "SampleHandler.h"

#import <AlivcLivePusher/AlivcLivePusherHeader.h>

@interface SampleHandler(){
    CMSampleBufferRef lastSampleBuffer;
}

// SDK
@property (nonatomic, strong) AlivcLivePusher *livePusher;
@property (nonatomic, strong) AlivcLivePushConfig *pushConfig;
@property (nonatomic, copy)NSString *pushUrl;
@property (nonatomic, assign)NSInteger resolution;
@property (nonatomic, assign)NSInteger orientation;
@property (nonatomic, assign)bool isPushing;

@end

@implementation SampleHandler


- (instancetype) init {
    self = [super init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAlivcReplayKitStartPushNotification:) name:@"Alivc_Replaykit_Start_Push" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAlivcReplayKitStopPushNotification:) name:@"Alivc_Replaykit_Stop_Push" object:nil];

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    (__bridge const void *)(self),
                                    onDarwinReplayKit2PushStart,
                                    CFSTR("Alivc_Replaykit_Start_Push"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    (__bridge const void *)(self),
                                    onDarwinReplayKit2PushStop,
                                    CFSTR("Alivc_Replaykit_Stop_Push"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
    
    
    _isPushing = NO;
    
    
    return self;
}

static void onDarwinReplayKit2PushStart(CFNotificationCenterRef center,
                                        void *observer, CFStringRef name,
                                        const void *object, CFDictionaryRef
                                        userInfo)
{

   [[NSNotificationCenter defaultCenter] postNotificationName:@"Alivc_Replaykit_Start_Push" object:nil];
}

static void onDarwinReplayKit2PushStop(CFNotificationCenterRef center,
                                       void *observer, CFStringRef name,
                                       const void *object, CFDictionaryRef
                                       userInfo)
{
    
   [[NSNotificationCenter defaultCenter] postNotificationName:@"Alivc_Replaykit_Stop_Push" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    CFNotificationCenterRemoveObserver(CFNotificationCenterGetDarwinNotifyCenter(), (__bridge const void *)(self), CFSTR("Alivc_Replaykit_Start_Push"), NULL);
    CFNotificationCenterRemoveObserver(CFNotificationCenterGetDarwinNotifyCenter(), (__bridge const void *)(self), CFSTR("Alivc_Replaykit_Stop_Push"), NULL);
    
    
}

- (NSDictionary *)jsonData2Dictionary:(NSString *)jsonData
{
    if (jsonData == nil) {
        return nil;
    }
    NSData *data = [jsonData dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        NSLog(@"Json parse failed: %@", jsonData);
        return nil;
    }
    return dic;
}

- (void)broadcastStartedWithSetupInfo:(NSDictionary<NSString *,NSObject *> *)setupInfo {
    // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.

//    self.pushUrl = @"rtmp://push-demo-rtmp.aliyunlive.com/test/stream45";
//    self.resolution = AlivcLivePushResolution720P;
//    self.orientation = AlivcLivePushOrientationLandscapeLeft;
//    [self startLivePush];

}

- (void)handleAlivcReplayKitStartPushNotification:(NSNotification*)notification {
    
    UIPasteboard* pb = [UIPasteboard generalPasteboard];
    NSDictionary* pushInfo = [self jsonData2Dictionary:pb.string];
    
    if(notification && pushInfo) {
        NSDictionary *info = pushInfo;
        self.pushUrl = [info objectForKey:@"url"];
        self.resolution = [[info objectForKey:@"resolution"] integerValue];
        self.orientation = [[info objectForKey:@"orientation"] integerValue];
        
        if(self.pushUrl) {
            [self startLivePush];
        }

    }
    
}

- (void)handleAlivcReplayKitStopPushNotification:(NSNotification*)notification {
    if(self.livePusher) {
        [self.livePusher stopPush];
        [self.livePusher destory];
        self.livePusher = nil;
    }
}

- (void)startLivePush {
    @synchronized(self) {
        _pushConfig = [[AlivcLivePushConfig alloc]init];
        
        //设置外部数据推流
        _pushConfig.externMainStream = true;
        
        //设置视频输入格式
        _pushConfig.externVideoFormat = AlivcLivePushVideoFormatYUVNV12;
        
        //设置输出分辨率
        _pushConfig.resolution = self.resolution;
        
        //设置音频输出
        _pushConfig.audioSampleRate = 44100;
        _pushConfig.audioChannel = 1;
        
        //设置输出横屏,默认竖屏
        _pushConfig.orientation =  self.orientation;
        
        _livePusher = [[AlivcLivePusher alloc] initWithConfig:self.pushConfig];
        
        //设置推流地址
        [_livePusher startPushWithURL:self.pushUrl];

        if(lastSampleBuffer) {
            [self.livePusher sendVideoSampleBuffer:lastSampleBuffer];
        }

        _isPushing = YES;
        
        NSLog(@"AliVideoCloud startLivePush");
    }

}

- (void)broadcastFinished {
    @synchronized(self) {
        NSLog(@"AliVideoCloud broadcastFinished");
        
        self.isPushing = NO;
        if(self.livePusher) {
            [self.livePusher stopPush];
            [self.livePusher destory];
            self.livePusher = nil;
        }
        
        if (lastSampleBuffer) {
            CFRelease(lastSampleBuffer);
            lastSampleBuffer = nil;
        }
    }
}

- (void)processSampleBuffer:(CMSampleBufferRef)sampleBuffer withType:(RPSampleBufferType)sampleBufferType {
   
     @synchronized(self) {
        switch (sampleBufferType) {
            case RPSampleBufferTypeVideo:
                // Handle video sample buffer
                
                if (lastSampleBuffer) {
                    CFRelease(lastSampleBuffer);
                }
                lastSampleBuffer = sampleBuffer;
                CFRetain(lastSampleBuffer);
                
                NSLog(@"AliVideoCloud processSampleBuffer -- RPSampleBufferTypeVideo");
                if(self.isPushing) {
                    [self.livePusher sendVideoSampleBuffer:sampleBuffer];
                }

                break;
            case RPSampleBufferTypeAudioApp:
                NSLog(@"AliVideoCloud processSampleBuffer -- RPSampleBufferTypeAudioApp");
                // Handle audio sample buffer for app audio
                if (CMSampleBufferDataIsReady(sampleBuffer) != NO && self.isPushing) {
                    [self.livePusher sendAudioSampleBuffer:sampleBuffer withType:sampleBufferType];
                }
                break;
            case RPSampleBufferTypeAudioMic:
                NSLog(@"AliVideoCloud processSampleBuffer -- RPSampleBufferTypeAudioMic");
                // Handle audio sample buffer for mic audio
                if (CMSampleBufferDataIsReady(sampleBuffer) != NO && self.isPushing) {
                    [self.livePusher sendAudioSampleBuffer:sampleBuffer withType:sampleBufferType];
                }
                break;
                
            default:
                break;
        }
     }
}


@end

