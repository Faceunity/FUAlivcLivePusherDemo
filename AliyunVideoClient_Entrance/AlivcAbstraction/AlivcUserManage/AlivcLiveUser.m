//
//  AlivcLiveUser.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/5/2.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcLiveUser.h"
#import "AlivcDefine.h"

@implementation AlivcLiveUser
- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.userId = [dic[@"user_id"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        self.nickname = dic[@"nick_name"];
        NSString *avatar = dic[@"avatar"];
        if ([avatar containsString:@"http://"] || [avatar containsString:@"https://"]) {
            self.avatarUrlString =  avatar;
        }else{
            if ([avatar hasPrefix:@"/"]) {
                self.avatarUrlString =  [AlivcAppServer_UrlPreString stringByAppendingString:avatar];
            }else{
                self.avatarUrlString =  [AlivcAppServer_UrlPreString stringByAppendingFormat:@"/%@",avatar];
            }
        }
    }
    return self;
}

@end

