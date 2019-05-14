//
//  AlivcBeautySettingUIDefine.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/7/26.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,AlivcBeautySettingViewStyle){
    AlivcBeautySettingViewStyle_Default = 0, //正常的，默认的界面
    AlivcBeautySettingViewStyle_ShortVideo_BeautyFace_Base = 1, //短视频里的基础美颜
    AlivcBeautySettingViewStyle_ShortVideo_BeautyFace_Advanced = 2, //短视频里的高级美颜
    AlivcBeautySettingViewStyle_ShortVideo_BeautySkin = 3, //短视频里的美肌，没有高级普通的区分
};

@interface AlivcBeautySettingUIDefine : NSObject

@end
