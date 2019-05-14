
//
//  AlivcPushBeautyParams.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/6/20.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcPushBeautyParams.h"


@implementation AlivcPushBeautyParams

- (instancetype)init {
    self = [super init];
    if(self) {
        self.beautyWhite = 70;
        self.beautyBuffing = 40;
        self.beautyRuddy = 40;
        self.beautyCheekPink = 15;
        self.beautySlimFace = 40;
        self.beautyShortenFace = 50;
        self.beautyBigEye = 30;
    }
    return self;
}


@end
