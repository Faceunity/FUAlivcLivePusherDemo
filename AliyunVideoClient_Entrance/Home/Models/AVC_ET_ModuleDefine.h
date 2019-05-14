//
//  AVC_ET_ModuleDefine.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/3/22.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
  模块的定义与分类分类

 - AVC_ET_ModuleType_ApsaraV: apsaraV
 - AVC_ET_ModuleType_VideoShooting: 视频拍摄
 - AVC_ET_ModuleType_VideoEdit: 视频编辑
 - AVC_ET_ModuleType_VideoUpload: 视频上传
 - AVC_ET_ModuleType_VideoLive: 视频直播
 - AVC_ET_ModuleType_VideoPaly: 视频播放
 - AVC_ET_ModuleType_LiveAnswer: 直播答题
 - AVC_ET_ModuleType_MagicCamera:魔法相机
 - AVC_ET_ModuleType_VideoClip:视频裁剪
 AVC_ET_ModuleType_Temp_ShortVideo_Demo:原先短视频的demo
 */
typedef NS_ENUM(NSInteger,AVC_ET_ModuleType){
    
    AVC_ET_ModuleType_VideoShooting = 1 << 0,
    AVC_ET_ModuleType_VideoEdit = 1 << 1,
    AVC_ET_ModuleType_VideoClip = 1 << 2,
    AVC_ET_ModuleType_MagicCamer = 1 << 3,
    AVC_ET_ModuleType_VideoLive = 1 << 4,
    AVC_ET_ModuleType_PushFlow = 1 << 5,//推流的demo（直播推流）
    
    AVC_ET_ModuleType_VideoUpload = 1 << 6,
    AVC_ET_ModuleType_VideoPaly = 1 << 7,
    AVC_ET_ModuleType_ApsaraV = 1 << 8,
    

    AVC_ET_ModuleType_LiveAnswer = 1 << 13,
    AVC_ET_ModuleType_Alympic = 1 << 10,
    AVC_ET_ModuleType_Temp_VideoPlay_Demo = 1 << 11, //视频播放的demo
    AVC_ET_ModuleType_Temp_VideoUpload_Demo = 1 << 12, //视频上传的demo
    AVC_ET_ModuleType_Temp_ShortVideo_Demo = 1 << 9,
    AVC_ET_ModuleType_Temp_ShortVideoBasic_Demo = 1 << 14, //原先短视频的基础版demo

};


@interface AVC_ET_ModuleDefine : NSObject


/**
 指定初始化方法

 @param type 模块类型
 @return 实例变量
 */
- (instancetype)initWithModuleType:(AVC_ET_ModuleType )type;


/**
 类型
 */
@property (assign, nonatomic) AVC_ET_ModuleType type;

/**
 描述
 */
@property (strong, nonatomic, readonly) NSString *name;

/**
 图片
 */
@property (strong, nonatomic, readonly) UIImage *image;


#pragma mark - 类方法
/**
 模块功能对应的描述

 @param type 模块功能
 @return 描述
 */
+ (NSString *)nameWithModuleType:(AVC_ET_ModuleType )type;


/**
 模块功能对应的图片

 @param type 模块功能
 @return 图片
 */
+ (UIImage *__nullable)imageWithModuleType:(AVC_ET_ModuleType )type;

/**
 返回创建好的所有的功能模块

 @return 排列好的所有的功能模块
 */
+ (NSArray <AVC_ET_ModuleDefine *>*)allModules;


/**
 返回创建好的所有的demo模块
 
 @return 排列好的所有的功能模块
 */
+ (NSArray <AVC_ET_ModuleDefine *>*)allDemos;



@end

NS_ASSUME_NONNULL_END
