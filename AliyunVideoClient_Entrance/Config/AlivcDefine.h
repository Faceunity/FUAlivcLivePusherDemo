//
//  AlivcDefine.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/5/9.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

//extern NSString *const AlivcAppServer_UrlPreString;

extern NSString * AlivcAppServer_UrlPreString;
extern NSString * AlivcAppServer_AppID;

extern NSString *const AlivcAppServer_StsAccessKey;
extern NSString *const AlivcAppServer_StsSecretKey;
extern NSString *const AlivcAppServer_StsSecurityToken;
extern NSString *const AlivcAppServer_StsExpiredTime;
extern NSString *const AlivcAppServer_Mode;

@interface AlivcDefine : NSObject
+ (void) AlivcAppServerSetTestEnvMode:(int)mode;
+ (int)mode;
@end
