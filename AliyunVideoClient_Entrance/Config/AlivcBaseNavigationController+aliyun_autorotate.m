//
//  AlivcBaseNavigationController+aliyun_autorotate.m
//  AliyunVideoClient_Entrance
//
//  Created by 王凯 on 2018/5/31.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcBaseNavigationController+aliyun_autorotate.h"

@implementation AlivcBaseNavigationController (aliyun_autorotate)

-(BOOL)shouldAutorotate {
    return [[self.viewControllers lastObject] shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations {
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

@end
