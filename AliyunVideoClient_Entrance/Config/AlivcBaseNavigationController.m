//
//  AlivcBaceNavigationController.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/5/31.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcBaseNavigationController.h"
#import "AlivcBaseNavigationController+aliyun_autorotate.h"
@interface AlivcBaseNavigationController ()

@end

@implementation AlivcBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 横竖屏
//- (BOOL)shouldAutorotate{
//    return [self.visibleViewController shouldAutorotate];
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    return [self.visibleViewController supportedInterfaceOrientations];
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    return [self.visibleViewController preferredInterfaceOrientationForPresentation];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
