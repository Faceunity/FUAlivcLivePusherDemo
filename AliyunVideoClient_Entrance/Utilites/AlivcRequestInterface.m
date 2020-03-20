//
//  AlivcRequestInterface.m
//  AliyunVideoClient_Entrance
//
//  Created by 王凯 on 2018/5/19.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcRequestInterface.h"
#import "AlivcAppServer.h"
#import "AlivcSplicingRequestParameter.h"



@implementation AlivcRequestInterface

@end

@implementation AlivcRequestInterface(AlivcRequestVideoPlay)

static NSString *defaultUrlString = @"http://player.alicdn.com/video/aliyunmedia.mp4";
+ (NSArray *)requestPlayList{
    [AlivcAppServer getStsDataWithVid:defaultUrlString sucess:^(NSString *accessKeyId, NSString *accessKeySecret, NSString *securityToken) {
        
        AlivcSplicingRequestParameter *paramUrl = [[AlivcSplicingRequestParameter alloc] init];
        NSString *str = [paramUrl appendPlayListWithAccessKeyId:accessKeyId accessKeySecret:accessKeySecret securityToken:securityToken];
        
//        NSURL *url = [NSURL URLWithString:str]; //蔡泽坚修改
        [AlivcAppServer getWithUrlString:str completionHandler:^(NSString * _Nullable errString, NSDictionary * _Nullable resultDic) {
            NSLog(@"123");
        }];
        
    } failure:^(NSString *errorString) {
        
    }];
    
    return nil;
    
}

@end
