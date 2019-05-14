//
//  UIResponder+AlivcHelper.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/9.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "UIResponder+AlivcHelper.h"

@implementation UIResponder (AlivcHelper)

static id __weak currentFristResponder;

- (id)currentFirstResponder {
    currentFristResponder = nil;
    BOOL isFind = [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return isFind ? currentFristResponder : nil;
}

- (void)findFirstResponder:(id)sender {
    currentFristResponder = self;
}

@end
