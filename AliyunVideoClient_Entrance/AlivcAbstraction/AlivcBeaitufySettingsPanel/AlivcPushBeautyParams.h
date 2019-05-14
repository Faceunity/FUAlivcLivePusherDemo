//
//  AlivcPushBeautyParams.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/6/20.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 美颜档位

 - AlivcPushBeautyParamsLevel0: 0档
 - AlivcPushBeautyParamsLevel1: 1档
 - AlivcPushBeautyParamsLevel2: 2档
 - AlivcPushBeautyParamsLevel3: 3档
 - AlivcPushBeautyParamsLevel4: 4档
 - AlivcPushBeautyParamsLevel5: 5档
 */
typedef NS_ENUM(NSInteger,AlivcPushBeautyParamsLevel) {
    AlivcPushBeautyParamsLevel0 = 0,
    AlivcPushBeautyParamsLevel1,
    AlivcPushBeautyParamsLevel2,
    AlivcPushBeautyParamsLevel3,
    AlivcPushBeautyParamsLevel4,
    AlivcPushBeautyParamsLevel5
};

/**
 美颜参数分类设置

 - AlivcPushBeautyParamsTypeLive: 互动直播的美颜参数
 - AlivcPushBeautyParamsTypeShortVideo: 短视频的美颜参数
 */
typedef NS_ENUM(NSInteger,AlivcPushBeautyParamsType) {
    AlivcPushBeautyParamsTypeLive = 0,
    AlivcPushBeautyParamsTypeShortVideo,
};

@interface AlivcPushBeautyParams : NSObject
/**
 white
 
 default : 70
 value range : [0,100]
 */
@property (nonatomic, assign) int beautyWhite;

/**
 buffing
 
 default : 40
 value range : [0,100]
 */
@property (nonatomic, assign) int beautyBuffing;

/**
 ruddy
 
 default : 70
 value range : [0,100]
 */
@property (nonatomic, assign) int beautyRuddy;

/**
 pink
 
 default : 15
 value range : [0,100]
 */
@property (nonatomic, assign) int beautyCheekPink;

/**
 slim face
 
 default : 40
 value range : [0,100]
 */
@property (nonatomic, assign) int beautySlimFace;

/**
 shorten face
 
 default : 50
 value range : [0,100]
 */
@property (nonatomic, assign) int beautyShortenFace;

/**
 big eye
 
 default : 30
 value range : [0,100]
 */

@property (nonatomic, assign) int beautyBigEye;

/**
 init
 
 @return AlivcBeautyParams
 */
- (instancetype)init;

@end
