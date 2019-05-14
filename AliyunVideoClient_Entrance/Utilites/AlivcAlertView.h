//
//  AlivcAlertView.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/6/29.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface AlivcAlertView : UIAlertView

- (instancetype)initWithAlivcTitle:(NSString *__nullable)title message:(NSString *__nullable)message delegate:(id)delegate cancelButtonTitle:(NSString *__nullable)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle;

- (void)setShowImage:(UIImage *__nullable)image;

- (void)setContemtSize:(CGSize)size;

- (void)showInView:(UIView *)view;

@end
NS_ASSUME_NONNULL_END
