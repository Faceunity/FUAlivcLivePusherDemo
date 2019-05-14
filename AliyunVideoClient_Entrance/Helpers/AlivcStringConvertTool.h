//
//  AlivcStringConvertTool.h
//  AliyunVideoClient_Entrance
//
//  Created by jiangsongwen on 2018/6/5.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlivcStringConvertTool : NSObject
+ (NSString *)convertToJsonData:(NSDictionary *)dict;
+ (NSString *)base64StringFromText:(NSString *)text;
+ (NSString *)textFromBase64String:(NSString *)base64;
+ (NSString *)dictionaryToJson:(NSDictionary *)dic;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (BOOL)isEmpty:(NSString *)str;
+ (CGFloat)getStrTemp:(NSString*)strtemp;
@end
