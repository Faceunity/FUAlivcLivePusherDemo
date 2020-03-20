//  用户信息管理类
//  AlivcUserInfoManager.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/24.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlivcLiveUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlivcUserInfoManager : NSObject

/**
 获取一个随机的用户信息

 @param success 成功
 @param failure 失败
 */
+ (void)randomAUserSuccess:(void(^)(AlivcLiveUser *liveUser))success failure:(void (^)(NSString *errDes))failure;

/**
 更新用户信息

 @param nickName 新的用户昵称
 @param userId 用户ID
 @param success 成功
 @param failure 失败
 */
+ (void)updateUserInfoWithNickName:(NSString *)nickName userId:(NSString *)userId success:(void(^)(void))success failure:(void (^)(NSString *errDes))failure;

/**
 查询一组用户的信息

 @param userIds 用户id的集合，以逗号分隔
 @param success 成功
 @param failure 失败
 */
+ (void)getUserInfoWithIds:(NSString *)userIds success:(void(^)(NSArray <AlivcLiveUser *>*liveUsers))success failure:(void (^)(NSString *errDes))failure;

@end

NS_ASSUME_NONNULL_END
