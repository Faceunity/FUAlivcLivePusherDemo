//
//  AlivcLiveUserCountTool.m
//  AliyunVideoClient_Entrance
//
//  Created by jiangsongwen on 2018/6/13.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcLiveUserCountTool.h"

@implementation AlivcLiveUserCountTool
+ (NSString*)shortNumberCount:(long long )count {
    if(count >= 100000000L) {
        
        if(count % 100000000L != 0) {
            double value = (double)count / 100000000L;
            return [NSString stringWithFormat:@"%.1f亿", value];
        }
        else
            return [NSString stringWithFormat:@"%lld亿", count / 100000000L];
    }
    else if(count >= (10000*1000)) {
        if(count % 10000*1000 != 0) {
            double value = (double)count / (10000*1000);
            return [NSString stringWithFormat:@"%.1f千万", value];
        }
        else
            return [NSString stringWithFormat:@"%lld千万", count / (10000*1000)];
    }
    
    else if(count >= 10000) {
        if(count % 10000 != 0) {
            double value = (double)count / 10000;
            return [NSString stringWithFormat:@"%.1f万", value];
        }
        else
            return [NSString stringWithFormat:@"%lld万", count / 10000];
    }
    else {
        return [NSString stringWithFormat:@"%lld", count];
    }
}

@end
