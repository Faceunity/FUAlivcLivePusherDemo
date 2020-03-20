//
//  AlivcLocalDatabaseManager.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/6/12.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcLocalDatabaseManager.h"

static NSString *AlivcLocalDatabase = @"AlivcLocalDatabase.db";

@implementation AlivcLocalDatabaseManager

+ (FMDatabase *)localDatabase{
    NSString *docuPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath = [docuPath stringByAppendingPathComponent:AlivcLocalDatabase];
    FMDatabase *base = [FMDatabase databaseWithPath:dbPath];
    return base;
}
@end
