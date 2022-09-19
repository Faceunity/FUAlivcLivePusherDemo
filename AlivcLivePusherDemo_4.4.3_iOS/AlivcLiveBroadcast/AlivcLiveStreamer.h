//
//  AlivcLiveStreamer.h
//  AlivcLiveBroadcast
//
//  Created by 陈春光 on 2018/1/23.
//  Copyright © 2018年 TripleL. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <ReplayKit/ReplayKit.h>


@class AlivcLivePushConfig;

@interface AlivcLiveStreamer : NSObject

// URL
@property (nonatomic, strong) NSString *pushURL;
// SDK
@property (nonatomic, strong) AlivcLivePushConfig *pushConfig;

/** 单例 */
+ (AlivcLiveStreamer*) sharedInstance;

- (void) start:(NSString*)url;
- (void) stop;
- (void) pause;
- (void) resume;

- (void)processAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer withType:(RPSampleBufferType)sampleBufferType;
- (void)processVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;


@end
