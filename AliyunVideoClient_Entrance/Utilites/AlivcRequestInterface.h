//
//  AlivcRequestInterface.h
//  AliyunVideoClient_Entrance
//
//  Created by 王凯 on 2018/5/19.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AlivcRequestInterface : NSObject

@end


@interface AlivcRequestInterface(AlivcRequestVideoPlay)

+ (NSArray *)requestPlayList;

@end
