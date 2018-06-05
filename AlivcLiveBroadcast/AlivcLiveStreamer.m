//
//  AlivcLiveStreamer.m
//  AlivcLiveBroadcast
//
//  Created by 陈春光 on 2018/1/23.
//  Copyright © 2018年 TripleL. All rights reserved.
//

#import "AlivcLiveStreamer.h"

#import <AlivcLivePusher/AlivcLivePusherHeader.h>


@interface AlivcLiveStreamer ()

// SDK
@property (nonatomic, strong) AlivcLivePusher *livePusher;

@end

@implementation AlivcLiveStreamer

+ (AlivcLiveStreamer*)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[AlivcLiveStreamer alloc] initWithDefaultCfg];
    });
    return _sharedObject;
}

- (id) initWithDefaultCfg {
    self = [super init];
    
    self.pushConfig = [[AlivcLivePushConfig alloc] init];
    
   
    return self;
}
- (void)dealloc {
    NSLog(@"dealloc AlivcLiveStreamer");
    
    //[self.livePusher destoryStreaming];
    [self.livePusher destory];
}

- (void) start:(NSString*)url {
    
    //self.livePusher = [[AlivcLivePusher alloc] initWithStreamingConfig:self.pushConfig];
    //[self.livePusher startStreaming:url];
    
    self.livePusher = [[AlivcLivePusher alloc] initWithConfig:self.pushConfig];
    [self.livePusher startPushWithURL:url];
    
}
- (void) stop {
    
    //[self.livePusher stopStreaming];
    //[self.livePusher destoryStreaming];
    
    [self.livePusher stopPush];
    [self.livePusher destory];
    self.livePusher = nil;
}
- (void) pause {
     //[self.livePusher pauseStreaming];
    [self.livePusher pause];
}
- (void) resume {
    //[self.livePusher resumeStreaming];
    [self.livePusher resume];
}

- (void)processAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer withType:(RPSampleBufferType)sampleBufferType {
    
    [self.livePusher sendAudioSampleBuffer:sampleBuffer withType:sampleBufferType];
    
}

- (void)processVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    [self.livePusher sendVideoSampleBuffer:sampleBuffer];
    
}

@end
