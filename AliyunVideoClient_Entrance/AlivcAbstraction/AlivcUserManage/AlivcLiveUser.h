//  直播间的用户信息
//  AlivcLiveUser.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/5/2.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlivcLiveUser : NSObject

/**
 头像
 */
@property (nonatomic, strong) UIImage *avatar;

/**
 用户昵称
 */
@property (nonatomic, strong) NSString *nickname;

/**
 用户id
 */
@property (nonatomic, strong) NSString *userId;

/**
 头像的url
 */
@property (nonatomic, strong) NSString *avatarUrlString;

/**
 是否被禁言
 */
@property (nonatomic, assign) BOOL forbided;

/**
 是否被拉黑
 */
@property (nonatomic, assign) BOOL blackList;

/**
 是否被踢出
 */
@property (nonatomic, assign,) BOOL kickedout;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
