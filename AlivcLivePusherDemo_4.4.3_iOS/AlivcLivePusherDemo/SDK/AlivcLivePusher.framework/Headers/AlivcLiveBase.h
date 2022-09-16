//
//  AlivcLiveBase.h
//  AlivcLivePusher
//
//  Created by aliyun on 2022/4/11.
//  Copyright © 2022 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlivcLivePushConstants.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AlivcLiveBaseObserver <NSObject>

/**
 * SDK Licence 校验接口回调
 *
 * @param result 校验 licence 结果 AlivcLiveLicenseCheckResultCodeSuccess 成功，其他表示失败
 * @param reason 校验 licence 失败原因
 */
- (void)onLicenceCheck:(AlivcLiveLicenseCheckResultCode)result Reason:(NSString *)reason;

@end


@interface AlivcLiveBase : NSObject

/**
 获取SDK版本号

 @return 版本号
 */
+ (NSString *)getSDKVersion;


/**
 * 设置 AlivcLiveBaseObserver 回调接口
 */
+ (void)setObserver:(id<AlivcLiveBaseObserver>)observer;

/**
 设置Log级别

 @param level Log级别 default:AlivcLivePushLogLevelError
 */
+ (void)setLogLevel:(AlivcLivePushLogLevel)level;

/**
 启用或禁用控制台日志打印
 
 @param enabled 指定是否启用
 */
+ (void)setConsoleEnable:(BOOL)enabled;

/**
 设置Log路径

 @param logPath Log路径
 @param maxPartFileSizeInKB 每个分片最大大小。最终日志总体积是 5*最大分片大小
 */
+ (void)setLogPath:(NSString *)logPath maxPartFileSizeInKB:(int)maxPartFileSizeInKB;

/**
 注册SDK
 
 请在工程的Info.plist中增加AlivcLicenseKey和AlivcLicenseFile字段
 * 在AlivcLicenseKey中填入您的LicenseKey
 * 在AlivcLicenseFile中填入您的LicenseFile路径（相对于mainBundle）；例如您的LicenseFile为"license.crt"放到mainBundle下，就填入license.crt
 
 LicenseKey和LicenseFile的获取请参考文档：
 */
+ (BOOL)registerSDK;

@end


NS_ASSUME_NONNULL_END
