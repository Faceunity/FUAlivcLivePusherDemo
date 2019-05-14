//  
//  AlivcUserInfoManager.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/24.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcUserInfoManager.h"
#import "AlivcDefine.h"
#import "AlivcAppServer.h"

@implementation AlivcUserInfoManager

+ (void)randomAUserSuccess:(void (^)(AlivcLiveUser *))success failure:(void (^)(NSString *))failure{
    
    NSString *urlString = @"/appserver/newguest";
    NSString *allUrlString = [NSString stringWithFormat:@"%@%@",AlivcAppServer_UrlPreString,urlString];
    [AlivcAppServer postWithUrlString:allUrlString parameters:@{} completionHandler:^(NSString * _Nullable errString, NSDictionary * _Nullable resultDic) {
        if (errString) {
            failure(errString);
            NSLog(@"%@ error:%@", allUrlString, errString);
        }else{
            [AlivcAppServer judgmentResultDic:resultDic success:^(id dataObject) {
                NSDictionary *dataDic = (NSDictionary *)dataObject;
                AlivcLiveUser *user = [[AlivcLiveUser alloc]initWithDic:dataDic];
                if (success) {
                    success(user);
                }
                NSLog(@"%@ %@", allUrlString, dataDic);
            } doFailure:^(NSString * errorStr) {
                if (failure) {
                    failure(errString);
                }
                NSLog(@"%@ error:%@", allUrlString, errorStr);
            }];
            
        }
        
    }];
    
}

+ (void)updateUserInfoWithNickName:(NSString *)nickName userId:(NSString *)userId success:(void (^)(void))success failure:(void (^)(NSString *))failure{
    NSString *urlString = @"/appserver/updateuser";
    NSString *allUrlString = [NSString stringWithFormat:@"%@%@",AlivcAppServer_UrlPreString,urlString];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
    [paramDic setObject:nickName forKey:@"nickname"];
    [paramDic setObject:userId forKey:@"user_id"];
    [AlivcAppServer postWithUrlString:allUrlString parameters:paramDic completionHandler:^(NSString * _Nullable errString, NSDictionary * _Nullable resultDic) {
        if (errString) {
            if (failure) {
                failure(errString);
            }
            NSLog(@"%@ error:%@", allUrlString, errString);
        }else{
            [AlivcAppServer judgmentResultDic:resultDic success:^(id dataObject) {
                if (success) {
                    success();
                }
                NSLog(@"%@ %@", allUrlString, dataObject);
            } doFailure:^(NSString * errorStr) {
                if (failure) {
                    failure(errString);
                }
                NSLog(@"%@ error:%@", allUrlString, errorStr);
            }];
        }
    }];
}

+ (void)getUserInfoWithIds:(NSString *)userIds success:(void (^)(NSArray<AlivcLiveUser *> * _Nonnull))success failure:(void (^)(NSString * _Nonnull))failure{
    //暂时以get的方式
    NSString *urlString = @"/appserver/getusers";
    NSString *allUrlString = [NSString stringWithFormat:@"%@%@",AlivcAppServer_UrlPreString,urlString];
    [AlivcAppServer postWithUrlString:allUrlString parameters:@{@"user_id" : userIds} completionHandler:^(NSString * _Nullable errString, NSDictionary * _Nullable resultDic) {
        if (errString) {
            if (failure) {
                failure(errString);
            }
            NSLog(@"%@ error:%@", allUrlString, errString);
        }else{
            [AlivcAppServer judgmentResultDic:resultDic success:^(id dataObject) {
                if ([dataObject isKindOfClass:[NSArray class]]) {
                    NSArray *dataArray = (NSArray *)dataObject;
                    NSMutableArray *userArray = [[NSMutableArray alloc]init];
                    for (NSDictionary *dic in dataArray) {
                        AlivcLiveUser *user = [[AlivcLiveUser alloc]initWithDic:dic];
                        [userArray addObject:user];
                    }
                    NSArray *resultArray = (NSArray *)userArray;
                    if (success) {
                        success(resultArray);
                    }
                    NSLog(@"%@ %@", allUrlString, dataObject);
                }
            } doFailure:^(NSString * errorStr) {
                if (failure) {
                    failure(errString);
                }
                NSLog(@"%@ error:%@", allUrlString, errorStr);
            }];
        }

    }];
}

@end
