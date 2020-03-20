//
//  AlivcSplicingRequestParameter.h
//  AliyunVideoClient_Entrance
//
//  Created by 王凯 on 2018/5/19.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlivcSplicingRequestParameter : NSObject

@end


@interface AlivcSplicingRequestParameter(videoPlay)

- (NSString*)appendPlayListWithAccessKeyId:(NSString *)accessKeyId accessKeySecret:(NSString *)accessKeySecret securityToken:(NSString *)securityToken;

@end
