//
//  AlivcAppServer.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/16.
//  Copyright © 2018年 Alibaba. All rights reserved.
//  网络请求

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface AlivcAppServer : NSObject

/**
 get请求的封装
 本应用所有的get请求最终都通过这个方法发起
 @param urlString 请求字符串
 @param handle 请求结果的处理代码块 errString不为空，则代表请求出错
 */
+ (void)getWithUrlString:(NSString *)urlString completionHandler:(void (^)(NSString *__nullable errString,NSDictionary *_Nullable resultDic))handle;


/**
 post请求的封装
 本应用所有的get请求最终都通过这个方法发起
 @param urlString 请求字符串
 @param parametersDic 参数
 @param handle 请求结果的处理代码块 errString不为空，则代表请求出错
 */
+ (void)postWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parametersDic completionHandler:(void (^)(NSString *__nullable errString,NSDictionary *_Nullable resultDic))handle;


/**
 统一处理返回的结果字典
 
 @param resultDic 结果字典
 @param success 结果字典表明请求成功，那么解析出数据字典让别人使用
 @param failure 失败
 */
+ (void)judgmentResultDic:(NSDictionary *)resultDic success:(void (^)(id dataObject))success doFailure:(void (^)(NSString *))failure;

/**
 根据视频id获取播放参数

 @param vidString 视频id
 @param sucess 回调里有三个视频参数
 @param failure 失败
 */
+ (void)getStsDataWithVid:(NSString *)vidString sucess:(void(^)(NSString *accessKeyId,NSString *accessKeySecret, NSString *securityToken))sucess failure:(void (^)(NSString *errorString))failure;




NS_ASSUME_NONNULL_END
@end
