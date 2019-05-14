//
//  AlivcLivePresentationController.h
//  AliyunVideoClient_Entrance
//
//  Created by 汪潇翔 on 2018/5/29.
//  Copyright © 2018 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlivcLivePresentationController : UIPresentationController


/**
 点击背景消失页面
 */
@property(nonatomic, assign) BOOL dismissOnBackgroundTap;

- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container
               withParentContainerSize:(CGSize)parentSize;

@end
