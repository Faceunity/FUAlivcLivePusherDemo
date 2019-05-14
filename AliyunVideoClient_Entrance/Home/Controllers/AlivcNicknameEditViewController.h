//
//  AlivcNicknameEditViewController.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/5/11.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcBaseViewController.h"

@interface AlivcNicknameEditViewController : AlivcBaseViewController

@property(nonatomic, copy)void(^updateNickNameCompltion)(NSString *errorStr);

@end
