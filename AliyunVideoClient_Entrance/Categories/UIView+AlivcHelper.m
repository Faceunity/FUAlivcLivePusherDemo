//
//  UIView+AlivcHelper.m
//  MaoBoli
//
//  Created by Zejian Cai on 2018/7/19.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "UIView+AlivcHelper.h"

@implementation UIView (AlivcHelper)

- (void)addVisualEffect{
    self.backgroundColor = [UIColor clearColor];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    visualEffectView.frame =CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:visualEffectView];
    [self sendSubviewToBack:visualEffectView];
}


@end
