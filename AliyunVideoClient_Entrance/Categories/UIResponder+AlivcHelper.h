//
//  UIResponder+AlivcHelper.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/9.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (AlivcHelper)
/**
 Gets current first responder. e.g. UITextField
 */
- (id)currentFirstResponder;

@end

NS_ASSUME_NONNULL_END
