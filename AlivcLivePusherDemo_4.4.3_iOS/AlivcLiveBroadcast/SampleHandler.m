//
//  SampleHandler.m
//  AlivcLiveBroadcast
//
//  Created by 陈春光 on 2018/1/23.
//  Copyright © 2018年 TripleL. All rights reserved.
//


#import "SampleHandler.h"
#import "AlivcLiveReplayKitDefine.h"
#import <AlivcLibReplayKitExt/AlivcLibReplayKitExt.h>



@implementation SampleHandler

- (void)broadcastStartedWithSetupInfo:(NSDictionary<NSString *,NSObject *> *)setupInfo {
    // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.
    [[AlivcReplayKitExt sharedInstance] setAppGroup:kAPPGROUP];
}


- (void)processSampleBuffer:(CMSampleBufferRef)sampleBuffer withType:(RPSampleBufferType)sampleBufferType {
    if (sampleBufferType != RPSampleBufferTypeAudioMic) {
        //声音由主APP采集发送
        [[AlivcReplayKitExt sharedInstance] sendSampleBuffer:sampleBuffer withType:sampleBufferType];
    }
}

- (void)broadcastFinished {
    [[AlivcReplayKitExt sharedInstance] finishBroadcast];
}

@end

