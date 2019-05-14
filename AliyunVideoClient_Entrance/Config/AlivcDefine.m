//
//  AlivcDefine.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/5/9.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcDefine.h"
#import "AlivcProfile.h"
#import "AlivcUserInfoManager.h"
#import "MBProgressHUD+AlivcHelper.h"
//#import <AlivcInteractiveLiveRoomSDK/AlivcInteractiveLiveRoomSDK.h>
//#import "AlivcLiveRoomManager.h"

NSString * AlivcAppServer_UrlPreString = @"http://live-appserver-sh.alivecdn.com";
NSString * AlivcAppServer_AppID = @"sh-hrjbxns6";

NSString *const AlivcAppServer_StsAccessKey = @"com.alivc.sts.stsAccessKey";
NSString *const AlivcAppServer_StsSecretKey = @"com.alivc.sts.stsSecretKey";
NSString *const AlivcAppServer_StsSecurityToken = @"com.alivc.sts.stsSecurityToken";
NSString *const AlivcAppServer_StsExpiredTime = @"com.alivc.sts.stsExpiredTime";

NSString *const AlivcAppServer_Mode = @"com.alivc.app.mode";

@implementation AlivcDefine

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        int mode = [[[NSUserDefaults standardUserDefaults] objectForKey:AlivcAppServer_Mode] intValue];
        [AlivcDefine AlivcAppServerSetTestEnvMode:0]; // 默认是上海环境
    });
}

+ (void) AlivcAppServerSetTestEnvMode:(int)mode {
    
    if(mode == 0) { // 上海
        
        AlivcAppServer_UrlPreString = @"http://live-appserver-sh.alivecdn.com";
        AlivcAppServer_AppID = @"sh-hrjbxns6";
        
    }else if(mode == 1) { //新加坡
        AlivcAppServer_UrlPreString = @"http://live-appserver-sig.alivecdn.com";
        AlivcAppServer_AppID = @"sg-becvqlqr";
       
    }else if (mode == 2){//预发
        AlivcAppServer_UrlPreString = @"http://100.67.146.142";
        AlivcAppServer_AppID = @"sh-4zf93fr7";
        
    }else if (mode == 3){//日常
        AlivcAppServer_UrlPreString = @"http://11.239.168.59:8080";
        AlivcAppServer_AppID = @"sh-l6h3x42a";
    }
    
    // 记录环境
    [[NSUserDefaults standardUserDefaults] setObject:@(mode) forKey:AlivcAppServer_Mode];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //更换用户
    AlivcProfile *profile = [AlivcProfile shareInstance];
    [AlivcUserInfoManager randomAUserSuccess:^(AlivcLiveUser *liveUser) {
        profile.userId = liveUser.userId;
        profile.avatarUrlString = liveUser.avatarUrlString;
        profile.nickname = liveUser.nickname;
//        [AlivcLiveRoomManager stsWithAppUid:liveUser.userId success:NULL failure:NULL];
    } failure:^(NSString * _Nonnull errDes) {
        
    }];
    
}

+ (int)mode{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:AlivcAppServer_Mode] intValue];
}

@end

