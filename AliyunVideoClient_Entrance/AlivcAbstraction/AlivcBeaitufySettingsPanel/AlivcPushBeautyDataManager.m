//
//  AlivcPushBeautyDataManager.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/8/6.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcPushBeautyDataManager.h"
#import "NSString+AlivcHelper.h"

static const int AlivcBeautyWhiteDefault = 70;
static const int AlivcBeautyBuffingDefault = 40;
static const int AlivcBeautyRuddyDefault = 40;
static const int AlivcBeautyCheekPinkDefault = 15;
static const int AlivcBeautyThinFaceDefault = 40;
static const int AlivcBeautyShortenFaceDefault = 50;
static const int AlivcBeautyBigEyeDefault = 30;

@interface AlivcPushBeautyDataManager()

@property (assign, nonatomic) AlivcPushBeautyParamsType type;

@property (strong, nonatomic) NSString *levelKey;

@property (strong, nonatomic) NSString *customSaveString;

@property (assign, nonatomic) BOOL haveSavedDefaultValue; //存储过默认值

@end


@implementation AlivcPushBeautyDataManager

- (instancetype)initWithType:(AlivcPushBeautyParamsType)type customSaveString:(NSString * _Nullable)customSaveString{
    self = [super init];
    if (self) {
        _type = type;
        switch (_type) {
            case AlivcPushBeautyParamsTypeLive:
                _customSaveString = @"AlivcPushBeautyParamsTypeLive";
                break;
            case AlivcPushBeautyParamsTypeShortVideo:
                _customSaveString = @"AlivcPushBeautyParamsTypeShortVideo";
                break;
                
            default:
                break;
        }
        if (customSaveString) {
            _customSaveString = customSaveString;
        }
        _levelKey = [NSString stringWithFormat:@"levelKey_%@",_customSaveString];
        [self saveDefaultParams];
    }
    return self;
}

- (AlivcPushBeautyParams *)defaultBeautyParamsWithLevel:(AlivcPushBeautyParamsLevel)level{
    AlivcPushBeautyParams *params = [[AlivcPushBeautyParams alloc] init];
    switch (self.type) {
        case AlivcPushBeautyParamsTypeLive:{
            CGFloat scale = 1;
            if (level == AlivcPushBeautyParamsLevel0) {
                scale = 0;
            }else if(level == AlivcPushBeautyParamsLevel1){
                scale = 0.3;
            }else if(level == AlivcPushBeautyParamsLevel2){
                scale = 0.6;
            }else if(level == AlivcPushBeautyParamsLevel3){
                scale = 1;
            }else if(level == AlivcPushBeautyParamsLevel4){
                scale = 1.2;
            }else if(level == AlivcPushBeautyParamsLevel5){
                scale = 1.5;
            }
            params.beautyWhite = AlivcBeautyWhiteDefault * scale > 100 ? 100 : AlivcBeautyWhiteDefault * scale;
            params.beautyBuffing = AlivcBeautyBuffingDefault * scale > 100 ? 100 : AlivcBeautyBuffingDefault * scale;
            params.beautyRuddy = AlivcBeautyRuddyDefault * scale > 100 ? 100 : AlivcBeautyRuddyDefault * scale;
            params.beautyCheekPink = AlivcBeautyCheekPinkDefault * scale > 100 ? 100 : AlivcBeautyCheekPinkDefault * scale;
            params.beautySlimFace = AlivcBeautyThinFaceDefault * scale > 100 ? 100 : AlivcBeautyThinFaceDefault * scale;
            params.beautyShortenFace = AlivcBeautyShortenFaceDefault * scale > 100 ?  100 : AlivcBeautyShortenFaceDefault * scale;
            params.beautyBigEye = AlivcBeautyBigEyeDefault * scale > 100 ? 100 : AlivcBeautyBigEyeDefault * scale;
        }
            break;
            
        case AlivcPushBeautyParamsTypeShortVideo:{
            //短视频的参数没有规律可言，这里统一定死赋值吧，清晰明了
            switch (level) {
                case 0:
                {
                    params.beautyWhite = 0;
                    params.beautyBuffing = 0;
                    params.beautyRuddy = 0;
                    params.beautyCheekPink = 0;
                    params.beautySlimFace = 0;
                    params.beautyShortenFace = 0;
                    params.beautyBigEye = 0;
                }
                    break;
                case 1:
                {
                    params.beautyWhite = 20;
                    params.beautyBuffing = 10;
                    params.beautyRuddy = 20;
                    params.beautyCheekPink = 20;
                    params.beautySlimFace = 20;
                    params.beautyShortenFace = 20;
                    params.beautyBigEye = 20;
                }
                    break;
                case 2:
                {
                    params.beautyWhite = 40;
                    params.beautyBuffing = 30;
                    params.beautyRuddy = 40;
                    params.beautyCheekPink = 40;
                    params.beautySlimFace = 40;
                    params.beautyShortenFace = 40;
                    params.beautyBigEye = 40;
                }
                    break;
                case 3:
                {
                    params.beautyWhite = 60;
                    params.beautyBuffing = 60;
                    params.beautyRuddy = 60;
                    params.beautyCheekPink = 60;
                    params.beautySlimFace = 60;
                    params.beautyShortenFace = 60;
                    params.beautyBigEye = 60;
                }
                    break;
                case 4:
                {
                    params.beautyWhite = 80;
                    params.beautyBuffing = 85;
                    params.beautyRuddy = 80;
                    params.beautyCheekPink = 80;
                    params.beautySlimFace = 80;
                    params.beautyShortenFace = 80;
                    params.beautyBigEye = 80;
                }
                    break;
                case 5:
                {
                    params.beautyWhite = 100;
                    params.beautyBuffing = 100;
                    params.beautyRuddy = 100;
                    params.beautyCheekPink = 100;
                    params.beautySlimFace = 100;
                    params.beautyShortenFace = 100;
                    params.beautyBigEye = 100;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    return params;
    
}

- (AlivcPushBeautyParamsLevel)defaultBeautyLevel{
    switch (self.type) {
        case AlivcPushBeautyParamsTypeLive:
            return AlivcPushBeautyParamsLevel4;
            break;
        case AlivcPushBeautyParamsTypeShortVideo:
            return AlivcPushBeautyParamsLevel3;
            break;
        default:
            break;
    }
    
}


- (AlivcPushBeautyParamsLevel)getBeautyLevel{
    
    NSString *beautyLevelString = [[NSUserDefaults standardUserDefaults] objectForKey:_levelKey];
    if(beautyLevelString){
        AlivcPushBeautyParamsLevel level = [beautyLevelString integerValue];
        return level;
    }
    return [self defaultBeautyLevel];
}

- (void)saveBeautyLevel:(AlivcPushBeautyParamsLevel)level{
    
    [[NSUserDefaults standardUserDefaults] setObject:@(level).stringValue forKey:_levelKey];
}
    
- (void)saveDefaultParams{
    _haveSavedDefaultValue = [[NSUserDefaults standardUserDefaults]boolForKey:_customSaveString];
    if (!_haveSavedDefaultValue) {
        for(int i = 0;i < 6;i ++){
            AlivcPushBeautyParams *params = [self defaultBeautyParamsWithLevel:i];
            [self saveBeautyParams:params level:i];
        }
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:_customSaveString];
    }
   

}


- (AlivcPushBeautyParams *)getBeautyParamsOfLevel:(AlivcPushBeautyParamsLevel)level{
    AlivcPushBeautyParams *parames = [[AlivcPushBeautyParams alloc]init];
    
    NSString *beautyWhiteStr = [[NSUserDefaults standardUserDefaults]objectForKey:[self beautyWhiteSaveKeyStringWithLevel:level]];
    
    if (!beautyWhiteStr) { //说明还没有存储过，取默认值
        parames = [self defaultBeautyParamsWithLevel:level];
        [self saveBeautyParams:parames level:level]; // 做一次存储
        return parames;
    }
    
    
    int beautyWhite= [beautyWhiteStr intValue];
    parames.beautyWhite = beautyWhite;
    
    NSString *beautyBuffingString = [[NSUserDefaults standardUserDefaults]objectForKey:[self beautyBuffingSaveKeyStringWithLevel:level]];
    int beautyBuffing= [beautyBuffingString intValue];
    parames.beautyBuffing = beautyBuffing;
    
    NSString *beautyRuddyStr = [[NSUserDefaults standardUserDefaults]objectForKey:[self beautyRuddySaveKeyStringWithLevel:level]];
    int beautyRuddy= [beautyRuddyStr intValue];
    parames.beautyRuddy = beautyRuddy;
    
    NSString *beautyCheekPinkStr = [[NSUserDefaults standardUserDefaults]objectForKey:[self beautyCheekPinkSaveKeyStringWithLevel:level]];
    int beautyCheekPink= [beautyCheekPinkStr intValue];
    parames.beautyCheekPink = beautyCheekPink;
    
    NSString *beautySlimFaceStr = [[NSUserDefaults standardUserDefaults]objectForKey:[self beautySlimFaceSaveKeyStringWithLevel:level]];
    int beautySlimFace= [beautySlimFaceStr intValue];
    parames.beautySlimFace = beautySlimFace;
    
    NSString *beautyShortenFaceStr = [[NSUserDefaults standardUserDefaults]objectForKey:[self beautyShortenFaceSaveKeyStringWithLevel:level]];
    int beautyShortenFace= [beautyShortenFaceStr intValue];
    parames.beautyShortenFace = beautyShortenFace;
    
    NSString *beautyBigEyeStr = [[NSUserDefaults standardUserDefaults]objectForKey:[self beautyBigEyeSaveKeyStringWithLevel:level]];
    int beautyBigEye= [beautyBigEyeStr intValue];
    parames.beautyBigEye = beautyBigEye;
    
  
    return parames;
}

- (void)saveBeautyParams:(AlivcPushBeautyParams *)beautyParams level:(AlivcPushBeautyParamsLevel)level{
    
    NSString *beautyWhite = [NSString stringWithFormat:@"%ld",(long)beautyParams.beautyWhite];
    [[NSUserDefaults standardUserDefaults]setObject:beautyWhite forKey:[self beautyWhiteSaveKeyStringWithLevel:level]];
    
    NSString *beautyBuffing = [NSString stringWithFormat:@"%ld",(long)beautyParams.beautyBuffing];
    [[NSUserDefaults standardUserDefaults]setObject:beautyBuffing forKey:[self beautyBuffingSaveKeyStringWithLevel:level]];
    
    NSString *beautyRuddy = [NSString stringWithFormat:@"%ld",(long)beautyParams.beautyRuddy];
    [[NSUserDefaults standardUserDefaults]setObject:beautyRuddy forKey:[self beautyRuddySaveKeyStringWithLevel:level]];
    
    NSString *beautySlimFace = [NSString stringWithFormat:@"%ld",(long)beautyParams.beautySlimFace];
    [[NSUserDefaults standardUserDefaults]setObject:beautySlimFace forKey:[self beautySlimFaceSaveKeyStringWithLevel:level]];
    
    NSString *beautyShortenFace = [NSString stringWithFormat:@"%ld",(long)beautyParams.beautyShortenFace];
    [[NSUserDefaults standardUserDefaults]setObject:beautyShortenFace forKey:[self beautyShortenFaceSaveKeyStringWithLevel:level]];
    
    NSString *beautyBigEye = [NSString stringWithFormat:@"%ld",(long)beautyParams.beautyBigEye];
    [[NSUserDefaults standardUserDefaults]setObject:beautyBigEye forKey:[self beautyBigEyeSaveKeyStringWithLevel:level]];
    
    NSString *beautyCheekPink = [NSString stringWithFormat:@"%ld",(long)beautyParams.beautyCheekPink];
    [[NSUserDefaults standardUserDefaults]setObject:beautyCheekPink forKey:[self beautyCheekPinkSaveKeyStringWithLevel:level]];
}


- (void)saveParam:(NSInteger)count identifer:(NSString *)identifer level:(AlivcPushBeautyParamsLevel)level{
    
    if ([identifer isEqualToString:@"0"]) {
        
        [[NSUserDefaults standardUserDefaults]setObject:@(count).stringValue forKey:[self beautyBuffingSaveKeyStringWithLevel:level]];
        
    }else if ([identifer isEqualToString:@"1"]) {
        
        [[NSUserDefaults standardUserDefaults]setObject:@(count).stringValue forKey:[self beautyWhiteSaveKeyStringWithLevel:level]];
    }else if ([identifer isEqualToString:@"2"]) {
        
        [[NSUserDefaults standardUserDefaults]setObject:@(count).stringValue forKey:[self beautyRuddySaveKeyStringWithLevel:level]];
    }else if ([identifer isEqualToString:@"3"]) {
        
        [[NSUserDefaults standardUserDefaults]setObject:@(count).stringValue forKey:[self beautyShortenFaceSaveKeyStringWithLevel:level]];
    }else if ([identifer isEqualToString:@"4"]) {
        
        [[NSUserDefaults standardUserDefaults]setObject:@(count).stringValue forKey:[self beautyBigEyeSaveKeyStringWithLevel:level]];
    }else if ([identifer isEqualToString:@"5"]) {
        
        [[NSUserDefaults standardUserDefaults]setObject:@(count).stringValue forKey:[self beautySlimFaceSaveKeyStringWithLevel:level]];
    }else if ([identifer isEqualToString:@"6"]){
        
        [[NSUserDefaults standardUserDefaults]setObject:@(count).stringValue forKey:[self beautyCheekPinkSaveKeyStringWithLevel:level]];
    }
}

- (void)saveParamWithInfo:(NSDictionary *)info{
    [self saveParam:[info[@"value"] integerValue] identifer:info[@"identifier"] level:[self getBeautyLevel]];
    //都存储一遍
    
}




- (NSArray<NSDictionary *> *)beautyDetailItems{
    AlivcPushBeautyParamsLevel level = [self getBeautyLevel];
    AlivcPushBeautyParams *params = [self getBeautyParamsOfLevel:level];
    AlivcPushBeautyParams *defaultParams = [self defaultBeautyParamsWithLevel:level];
    
    NSArray<NSDictionary *> *detailItems =
    @[
      @{
          @"title":[@"Skin Polishing" localString],
          @"identifier":@"0",
          @"icon_name":@"ic_buffing",
          @"value":@(params.beautyBuffing),
          @"originalValue":@(defaultParams.beautyBuffing),
          @"minimumValue":@(0),
          @"maximumValue":@(100),
          },
      @{
          @"title":[@"Skin Whitening" localString],
          @"identifier":@"1",
          @"icon_name":@"ic_beauty_white",
          @"value":@(params.beautyWhite),
          @"originalValue":@(defaultParams.beautyWhite),
          @"minimumValue":@(0),
          @"maximumValue":@(100)
          },
      @{
          @"title":[@"Skin Shining" localString],
          @"identifier":@"2",
          @"icon_name":@"ic_Ruddy",
          @"value":@(params.beautyRuddy),
          @"originalValue":@(defaultParams.beautyRuddy),
          @"minimumValue":@(0),
          @"maximumValue":@(100)
          },
      @{
          @"title":[@"Chin Reducing" localString],
          @"identifier":@"3",
          @"icon_name":@"ic_shorface",
          @"value":@(params.beautyShortenFace),
          @"originalValue":@(defaultParams.beautyShortenFace),
          @"minimumValue":@(0),
          @"maximumValue":@(100)
          },
      @{
          @"title":[@"Eye Widening" localString],
          @"identifier":@"4",
          @"icon_name":@"ic_bigeye",
          @"value":@(params.beautyBigEye),
          @"originalValue":@(defaultParams.beautyBigEye),
          @"minimumValue":@(0),
          @"maximumValue":@(100)
          },
      @{
          @"title":[@"Face Slimming" localString],
          @"identifier":@"5",
          @"icon_name":@"ic_slimface",
          @"value":@(params.beautySlimFace),
          @"originalValue":@(defaultParams.beautySlimFace),
          @"minimumValue":@(0),
          @"maximumValue":@(100)
          },
      @{
          @"title":[@"beauty_cheekpink" localString],
          @"identifier":@"6",
          @"icon_name":@"ic_face_red",
          @"value":@(params.beautyRuddy),
          @"originalValue":@(defaultParams.beautyRuddy),
          @"minimumValue":@(0),
          @"maximumValue":@(100)
          }
      ];
    return detailItems;
}

#pragma mark - 用于生成界面的各个参数的字典，供开发者自由组合

/**
 0：磨皮 Skin Polishing
 
 @return 0：磨皮 Skin Polishing
 */
- (NSDictionary *)SkinPolishingDic{
    AlivcPushBeautyParamsLevel level = [self getBeautyLevel];
    AlivcPushBeautyParams *params = [self getBeautyParamsOfLevel:level];
    AlivcPushBeautyParams *defaultParams = [self defaultBeautyParamsWithLevel:level];
    return  @{
              @"title":[@"Skin Polishing" localString],
              @"identifier":@"0",
              @"icon_name":@"ic_buffing",
              @"value":@(params.beautyBuffing),
              @"originalValue":@(defaultParams.beautyBuffing),
              @"minimumValue":@(0),
              @"maximumValue":@(100),
              };
}

/**
 1：美白  Skin Whitening
 
 @return 1：美白  Skin Whitening
 */
- (NSDictionary *)SkinWhiteningDic{
    AlivcPushBeautyParamsLevel level = [self getBeautyLevel];
    AlivcPushBeautyParams *params = [self getBeautyParamsOfLevel:level];
    AlivcPushBeautyParams *defaultParams = [self defaultBeautyParamsWithLevel:level];
    return @{
             @"title":[@"Skin Whitening" localString],
             @"identifier":@"1",
             @"icon_name":@"ic_beauty_white",
             @"value":@(params.beautyWhite),
             @"originalValue":@(defaultParams.beautyWhite),
             @"minimumValue":@(0),
             @"maximumValue":@(100)
             };
}

/**
 2：红润 Skin Shining
 
 @return 2：红润 Skin Shining
 */
- (NSDictionary *)SkinShiningDic{
    AlivcPushBeautyParamsLevel level = [self getBeautyLevel];
    AlivcPushBeautyParams *params = [self getBeautyParamsOfLevel:level];
    AlivcPushBeautyParams *defaultParams = [self defaultBeautyParamsWithLevel:level];
    return @{
             @"title":[@"Skin Shining" localString],
             @"identifier":@"2",
             @"icon_name":@"ic_Ruddy",
             @"value":@(params.beautyRuddy),
             @"originalValue":@(defaultParams.beautyRuddy),
             @"minimumValue":@(0),
             @"maximumValue":@(100)
             };
}

/**
 3：缩下巴  Chin Reducing
 
 @return 3：缩下巴  Chin Reducing
 */
- (NSDictionary *)ChinReducingDic{
    AlivcPushBeautyParamsLevel level = [self getBeautyLevel];
    AlivcPushBeautyParams *params = [self getBeautyParamsOfLevel:level];
    AlivcPushBeautyParams *defaultParams = [self defaultBeautyParamsWithLevel:level];
    return   @{
               @"title":[@"Chin Reducing" localString],
               @"identifier":@"3",
               @"icon_name":@"ic_shorface",
               @"value":@(params.beautyShortenFace),
               @"originalValue":@(defaultParams.beautyShortenFace),
               @"minimumValue":@(0),
               @"maximumValue":@(100)
               };
}

/**
 4：大眼  Eye Widening
 
 @return 4：大眼  Eye Widening
 */
- (NSDictionary *)EyeWideningDic{
    AlivcPushBeautyParamsLevel level = [self getBeautyLevel];
    AlivcPushBeautyParams *params = [self getBeautyParamsOfLevel:level];
    AlivcPushBeautyParams *defaultParams = [self defaultBeautyParamsWithLevel:level];
    return  @{
              @"title":[@"Eye Widening" localString],
              @"identifier":@"4",
              @"icon_name":@"ic_bigeye",
              @"value":@(params.beautyBigEye),
              @"originalValue":@(defaultParams.beautyBigEye),
              @"minimumValue":@(0),
              @"maximumValue":@(100)
              };
}

/**
 5：瘦脸 Face Slimming
 
 @return 5：瘦脸 Face Slimming
 */
- (NSDictionary *)FaceSlimmingDic{
    AlivcPushBeautyParamsLevel level = [self getBeautyLevel];
    AlivcPushBeautyParams *params = [self getBeautyParamsOfLevel:level];
    AlivcPushBeautyParams *defaultParams = [self defaultBeautyParamsWithLevel:level];
    return @{
             @"title":[@"Face Slimming" localString],
             @"identifier":@"5",
             @"icon_name":@"ic_slimface",
             @"value":@(params.beautySlimFace),
             @"originalValue":@(defaultParams.beautySlimFace),
             @"minimumValue":@(0),
             @"maximumValue":@(100)
             };
    
}

/**
 6：腮红 beauty_cheekpink
 
 @return 6：腮红 beauty_cheekpink
 */
- (NSDictionary *)beautyCheekpinkDic{
    AlivcPushBeautyParamsLevel level = [self getBeautyLevel];
    AlivcPushBeautyParams *params = [self getBeautyParamsOfLevel:level];
    AlivcPushBeautyParams *defaultParams = [self defaultBeautyParamsWithLevel:level];
    return @{
             @"title":[@"beauty_cheekpink" localString],
             @"identifier":@"6",
             @"icon_name":@"ic_face_red",
             @"value":@(params.beautyRuddy),
             @"originalValue":@(defaultParams.beautyRuddy),
             @"minimumValue":@(0),
             @"maximumValue":@(100)
             };
}

#pragma mark - keyStringManager
- (NSString *)beautyWhiteSaveKeyStringWithLevel:(AlivcPushBeautyParamsLevel )level{
    NSString *levelString = @(level).stringValue;
    NSString *keyString = [NSString stringWithFormat:@"beautyWhite_%@_%@",levelString,self.customSaveString];
    return keyString;
}

- (NSString *)beautyBuffingSaveKeyStringWithLevel:(AlivcPushBeautyParamsLevel )level{
    NSString *levelString = @(level).stringValue;
    NSString *keyString = [NSString stringWithFormat:@"beautyBuffing_%@_%@",levelString,self.customSaveString];
    return keyString;
}

- (NSString *)beautyRuddySaveKeyStringWithLevel:(AlivcPushBeautyParamsLevel )level{
    NSString *levelString = @(level).stringValue;
    NSString *keyString = [NSString stringWithFormat:@"beautyRuddy_%@_%@",levelString,self.customSaveString];
    return keyString;
}

- (NSString *)beautyCheekPinkSaveKeyStringWithLevel:(AlivcPushBeautyParamsLevel )level{
    NSString *levelString = @(level).stringValue;
    NSString *keyString = [NSString stringWithFormat:@"beautyCheek_%@_%@",levelString,self.customSaveString];
    return keyString;
}

- (NSString *)beautySlimFaceSaveKeyStringWithLevel:(AlivcPushBeautyParamsLevel )level{
    NSString *levelString = @(level).stringValue;
    NSString *keyString = [NSString stringWithFormat:@"beautySlimFace_%@_%@",levelString,self.customSaveString];
    return keyString;
}

- (NSString *)beautyShortenFaceSaveKeyStringWithLevel:(AlivcPushBeautyParamsLevel )level{
    NSString *levelString = @(level).stringValue;
    NSString *keyString = [NSString stringWithFormat:@"beautyShortenFace_%@_%@",levelString,self.customSaveString];
    return keyString;
}

- (NSString *)beautyBigEyeSaveKeyStringWithLevel:(AlivcPushBeautyParamsLevel )level{
    NSString *levelString = @(level).stringValue;
    NSString *keyString = [NSString stringWithFormat:@"beautyBigEye_%@_%@",levelString,self.customSaveString];
    return keyString;
}
@end
