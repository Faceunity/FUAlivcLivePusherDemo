//
//  SampleHandler.m
//  AlivcLiveBroadcast
//
//  Created by 陈春光 on 2018/1/23.
//  Copyright © 2018年 TripleL. All rights reserved.
//


#import "SampleHandler.h"
#import "AlivcLiveStreamer.h"

#import <AlivcLivePusher/AlivcLivePusherHeader.h>

@implementation SampleHandler

- (void)broadcastStartedWithSetupInfo:(NSDictionary<NSString *,NSObject *> *)setupInfo {
    // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.

    AlivcLiveStreamer* liveStream =[AlivcLiveStreamer sharedInstance];
    NSString * url = (NSString*)[setupInfo valueForKey:@"endpointURL"];
    [liveStream setPushURL:url];
    
    NSString* resolutionStr = (NSString*)[setupInfo valueForKey:@"pushResolution"];
    
    if([resolutionStr isEqualToString:@"180P"]) {
        liveStream.pushConfig.resolution = AlivcLivePushResolution180P;
    }else if([resolutionStr isEqualToString:@"240P"]) {
        liveStream.pushConfig.resolution = AlivcLivePushResolution240P;
    }else if([resolutionStr isEqualToString:@"360P"]) {
        liveStream.pushConfig.resolution = AlivcLivePushResolution360P;
    }else if([resolutionStr isEqualToString:@"480P"]) {
        liveStream.pushConfig.resolution = AlivcLivePushResolution480P;
    }else if([resolutionStr isEqualToString:@"540P"]) {
        liveStream.pushConfig.resolution = AlivcLivePushResolution540P;
    }else if([resolutionStr isEqualToString:@"720P"]) {
        liveStream.pushConfig.resolution = AlivcLivePushResolution720P;
    }
    
    liveStream.pushConfig.audioSampleRate = 44100;
    liveStream.pushConfig.audioChannel = 1;
    
    liveStream.pushConfig.targetVideoBitrate = 800;
    liveStream.pushConfig.minVideoBitrate = 200;
    liveStream.pushConfig.initialVideoBitrate = 600;
    liveStream.pushConfig.qualityMode = AlivcLivePushQualityModeResolutionFirst;
    liveStream.pushConfig.externMainStream = true;
    liveStream.pushConfig.videoEncoderMode = AlivcLivePushVideoEncoderModeHard;
    liveStream.pushConfig.externVideoFormat = AlivcLivePushVideoFormatYUVNV12;
    
    
    
    NSString* orientationStr = (NSString*)[setupInfo valueForKey:@"pushRotation"];
    
    if([orientationStr isEqualToString:@"Portrait"]) {
        liveStream.pushConfig.orientation =  AlivcLivePushOrientationPortrait;
    }else if([orientationStr isEqualToString:@"HomeLeft"]) {
        liveStream.pushConfig.orientation =  AlivcLivePushOrientationLandscapeLeft;
    }else if([orientationStr isEqualToString:@"HomeRight"]) {
        liveStream.pushConfig.orientation =  AlivcLivePushOrientationLandscapeRight;
    }

    [liveStream start:url];
}

- (void)broadcastPaused {
    // User has requested to pause the broadcast. Samples will stop being delivered.
    
    AlivcLiveStreamer* liveStream =[AlivcLiveStreamer sharedInstance];
    [liveStream pause];
}

- (void)broadcastResumed {
    // User has requested to resume the broadcast. Samples delivery will resume.
    AlivcLiveStreamer* liveStream =[AlivcLiveStreamer sharedInstance];
    [liveStream resume];
}

- (void)broadcastFinished {
    // User has requested to finish the broadcast.
    AlivcLiveStreamer* liveStream =[AlivcLiveStreamer sharedInstance];
    [liveStream stop];
}

- (void)processSampleBuffer:(CMSampleBufferRef)sampleBuffer withType:(RPSampleBufferType)sampleBufferType {
    
    AlivcLiveStreamer* liveStream =[AlivcLiveStreamer sharedInstance];
    
    switch (sampleBufferType) {
        case RPSampleBufferTypeVideo:
            // Handle video sample buffer
            [liveStream processVideoSampleBuffer:sampleBuffer];
            break;
        case RPSampleBufferTypeAudioApp:
            // Handle audio sample buffer for app audio
             [liveStream processAudioSampleBuffer:sampleBuffer withType:sampleBufferType];
            break;
        case RPSampleBufferTypeAudioMic:
            // Handle audio sample buffer for mic audio
            [liveStream processAudioSampleBuffer:sampleBuffer withType:sampleBufferType];
            break;
            
        default:
            break;
    }
}

@end

