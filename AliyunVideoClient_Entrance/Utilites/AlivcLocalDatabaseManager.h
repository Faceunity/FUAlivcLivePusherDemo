//  本地数据的管理
//  AlivcLocalDatabaseManager.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/6/12.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

@interface AlivcLocalDatabaseManager : NSObject


/**
 本地的数据库

 @return    唯一的本地数据库
 */
+ (FMDatabase *)localDatabase;

@end
