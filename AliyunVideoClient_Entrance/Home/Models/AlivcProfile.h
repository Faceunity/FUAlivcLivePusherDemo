//
//  AlivcProfile.h
//  AliyunVideoClient_Entrance
//
//  Created by Charming04 on 2018/5/31.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlivcLiveUser.h"
@interface AlivcProfile : AlivcLiveUser

@property(nonatomic, strong)NSString *roomId; // 切换用户，roomId则改变

+(instancetype)shareInstance;

@end
