//
//  AlivcProfile.m
//  AliyunVideoClient_Entrance
//
//  Created by Charming04 on 2018/5/31.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcProfile.h"

@interface AlivcProfile()
@property(nonatomic, strong) UIImage *currentAvaterImage;
@end

@implementation AlivcProfile
@synthesize roomId = _roomId;

static NSString *kNicknameKey = @"com.aliyun.alivc.profile.nickname";
static NSString *kUserId = @"com.aliyun.alivc.profile.userId";
static NSString *kAvatarUrlString = @"com.aliyun.alivc.profile.avatarUrlString";
static NSString *kAvatarImage = @"com.aliyun.alivc.profile.avaterImage";
static NSString *kRoomId = @"com.aliyun.alivc.profile.roomId";

static AlivcProfile *_manager = nil;
+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[AlivcProfile alloc] init];
    });
    return _manager;
}

- (NSString *)nickname{
    [[NSUserDefaults standardUserDefaults] synchronize];
    return [[NSUserDefaults standardUserDefaults] objectForKey:kNicknameKey];
}

- (void)setNickname:(NSString *)nickname{
    if (nickname && [nickname isKindOfClass:[NSString class]]) {
        [[NSUserDefaults standardUserDefaults] setObject:nickname forKey:kNicknameKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [super setNickname:nickname];
}

- (NSString *)userId{
    [[NSUserDefaults standardUserDefaults] synchronize];
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
}

- (void)setUserId:(NSString *)userId{
    if (!userId || ![userId isKindOfClass:[NSString class]]) return;
    if ([userId isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:kUserId]]) return;
    
    [self setRoomId:nil]; //切换用户，清空roomId
    
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:kUserId];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super setUserId:userId];
}

- (NSString *)avatarUrlString{
    [[NSUserDefaults standardUserDefaults] synchronize];
    return [[NSUserDefaults standardUserDefaults] objectForKey:kAvatarUrlString];
}

- (void)setAvatarUrlString:(NSString *)avatarUrlString{
    if (avatarUrlString && [avatarUrlString isKindOfClass:[NSString class]]) {
        [[NSUserDefaults standardUserDefaults] setObject:avatarUrlString forKey:kAvatarUrlString];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [super setAvatarUrlString:avatarUrlString];
}

- (void)setAvatar:(UIImage *)avatar{
    if (avatar && [avatar isKindOfClass:[UIImage class]]) {
        NSData *imageData = [NSKeyedArchiver archivedDataWithRootObject:avatar];
        [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:kAvatarImage];
    }
    _currentAvaterImage = avatar;
    [super setAvatar:avatar];
}

- (UIImage *)avatar{
    if (_currentAvaterImage) {
        return _currentAvaterImage;
    }
    NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:kAvatarImage];
    if(imageData != nil)
    {
        return [NSKeyedUnarchiver unarchiveObjectWithData: imageData];
    }
    return nil;
}

- (void)setRoomId:(NSString *)roomId{
    
    if (!roomId || ![roomId isKindOfClass:[NSString class]]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kRoomId];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:roomId forKey:kRoomId];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSString *)roomId{
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    return [[NSUserDefaults standardUserDefaults] objectForKey:kRoomId];
}

@end
