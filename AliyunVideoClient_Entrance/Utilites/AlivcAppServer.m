//
//  AlivcAppServer.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/16.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcAppServer.h"
#import <AFNetworking/AFNetworking.h>
#import "NSString+AlivcHelper.h"

@implementation AlivcAppServer

+ (AFHTTPSessionManager*) manager
{
    static dispatch_once_t onceToken;
    static AFHTTPSessionManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html",@"text/plain",nil];
        manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    });
    
    return manager;
}

+ (void)getWithUrlString:(NSString *)urlString completionHandler:(void (^)(NSString * _Nullable, NSDictionary * _Nullable))handle{
    
    [[self manager] GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resultDic = (NSDictionary *)responseObject;
            handle(nil,resultDic);
        }else{
            handle(@"数据格式异常",nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        handle(error.description,nil);
    }];
}

+ (void)postWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parametersDic completionHandler:(void (^)(NSString * _Nullable, NSDictionary * _Nullable))handle{
    
    [[self manager] POST:urlString parameters:parametersDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resultDic = (NSDictionary *)responseObject;
            handle(nil,resultDic);
        }else{
            handle(@"数据格式异常",nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        handle(error.description,nil);
    }];
}

/**
 统一处理返回的结果字典
 
 @param resultDic 结果字典
 @param success 结果字典表明请求成功，那么解析出数据字典让别人使用
 @param failure 失败
 */
+ (void)judgmentResultDic:(NSDictionary *)resultDic success:(void (^)(id dataObject))success doFailure:(void (^)(NSString *))failure{
    BOOL isSucess = [resultDic[@"result"] boolValue];
    if (isSucess) {
        id dataObject = resultDic[@"data"];
        success(dataObject);
    }else{
        NSString *messageString = resultDic[@"message"];
        failure(messageString);
    }
}


+ (void)getStsDataWithVid:(NSString *)vidString sucess:(void (^)(NSString *, NSString *, NSString *))sucess failure:(void (^)(NSString *))failure{
    
    NSString *urlString = [NSString stringWithFormat:@"https://demo-vod.cn-shanghai.aliyuncs.com/voddemo/CreateSecurityToken?BusinessType=vodai&TerminalType=pc&DeviceModel=iPhone9,2&UUID=59ECA-4193-4695-94DD-7E1247288&AppVersion=1.0.0&VideoId=%@",vidString];
    NSURLRequest *requst = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:requst completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSError *jsonError;
            if (data) {
                NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&jsonError];
                NSDictionary *resultDic = responseDic[@"SecurityTokenInfo"];
                NSLog(@"%@",resultDic);
                //AccessKeyId
                NSString *keyIDString = resultDic[@"AccessKeyId"];
                //AccessKeySecret
                NSString *accessKeySecret = resultDic[@"AccessKeySecret"];
                //SecurityToken
                NSString *securityToken = resultDic[@"SecurityToken"];
                if (keyIDString && accessKeySecret && securityToken) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        sucess(keyIDString,accessKeySecret,securityToken);
                    });
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure([@"数据解析错误" localString]);
                    });
                    
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure([@"返回数据为空" localString]);
                });
                
            }
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error.code == -1009) {
                    failure([@"当前无网络,请检查网络连接" localString]);
                }else{
                    failure(error.description);
                }
                
            });
        }
    }];
    [task resume];
}

@end
