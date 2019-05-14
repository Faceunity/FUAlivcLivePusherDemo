//
//  AlivcPushBeautyDataManager.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/8/6.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlivcPushBeautyParams.h"

@interface AlivcPushBeautyDataManager : NSObject

/**
 美颜数据管理器

 @param type 美颜参数类型
 @param customSaveString 自定义存储字符串，一个字符串对应一个本地的美颜参数存储，为空:默认的本地存储器（@"AlivcPushBeautyParamsTypeLive"和@“AlivcPushBeautyParamsTypeShortVideo”是内置的默认的2个存储器），不为空：每个值对应一个存储器，别和默认存储的字符串值一样，那就是一个新的存储器，用于工程里有多个美颜界面，但是彼此间数据又想保持独立的需求
 @return 实例化对象
 */
- (instancetype)initWithType:(AlivcPushBeautyParamsType)type customSaveString:(NSString *__nullable)customSaveString;

/**
 default beauty AlivcBeautyParamsLevel
 
 @return AlivcBeautyParamsLevel
 */
- (AlivcPushBeautyParamsLevel)defaultBeautyLevel;

/**
 default beauty params
 
 @param level AlivcBeautyParamsLevel
 @return AlivcBeautyParams
 */
- (AlivcPushBeautyParams *)defaultBeautyParamsWithLevel:(AlivcPushBeautyParamsLevel)level;

/**
 获取当前的美颜等级
 
 @return 当前的美颜等级
 */
- (AlivcPushBeautyParamsLevel)getBeautyLevel;


/**
 存储当前的美颜等级
 
 @param level 当前的美颜等级
 */
- (void)saveBeautyLevel:(AlivcPushBeautyParamsLevel)level;


/**
 获取美颜等级对应的各美颜参数model
 
 @param level 美颜等级
 @return 美颜参数model
 */
- (AlivcPushBeautyParams *)getBeautyParamsOfLevel:(AlivcPushBeautyParamsLevel)level;


/**
 存储美颜参数
 
 @param beautyParams 美颜参数
 @param level 存储的美颜参数对应的美颜等级
 */
- (void)saveBeautyParams:(AlivcPushBeautyParams *)beautyParams level:(AlivcPushBeautyParamsLevel)level;


/**
 存储单个美颜项目的数值
 
 @param count 美颜的数值
 @param identifer 标记美颜项目的值
 @param level 美颜等级
 */
- (void)saveParam:(NSInteger)count identifer:(NSString *)identifer level:(AlivcPushBeautyParamsLevel)level;

/**
 存储美颜参数 - 当美颜某个值具体改变的时候
 
 @param info AlivcLiveBeautifySettingsViewControllerDelegate 回调里的info
 */
- (void)saveParamWithInfo:(NSDictionary *)info;


/**
 获取用于界面生成的各个等级的美颜数据 默认是7个，分别为
 0：磨皮 Skin Polishing
 1：美白  Skin Whitening
 2：红润 Skin Shining
 3：缩下巴  Chin Reducing
 4：大眼  Eye Widening
 5：瘦脸 Face Slimming
 6：腮红 beauty_cheekpink
 
 @return 各个等级的美颜数据
 */
- (NSArray<NSDictionary *> *)beautyDetailItems;

#pragma mark - 用于生成界面的各个参数的字典，供开发者自由组合

/**
 0：磨皮 Skin Polishing
 
 @return 0：磨皮 Skin Polishing
 */
- (NSDictionary *)SkinPolishingDic;

/**
 1：美白  Skin Whitening
 
 @return 1：美白  Skin Whitening
 */
- (NSDictionary *)SkinWhiteningDic;

/**
 2：红润 Skin Shining
 
 @return 2：红润 Skin Shining
 */
- (NSDictionary *)SkinShiningDic;

/**
 3：缩下巴  Chin Reducing
 
 @return 3：缩下巴  Chin Reducing
 */
- (NSDictionary *)ChinReducingDic;

/**
 4：大眼  Eye Widening
 
 @return 4：大眼  Eye Widening
 */
- (NSDictionary *)EyeWideningDic;

/**
 5：瘦脸 Face Slimming
 
 @return 5：瘦脸 Face Slimming
 */
- (NSDictionary *)FaceSlimmingDic;

/**
 6：腮红 beauty_cheekpink
 
 @return 6：腮红 beauty_cheekpink
 */
- (NSDictionary *)beautyCheekpinkDic;



@end
