//
//  AlivcBaseViewController.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/3/22.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcBaseViewController.h"

CGFloat PortraitScreenWidth = 0;
CGFloat PortraitScreenHeight = 0;

@interface AlivcBaseViewController ()

@end

@implementation AlivcBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(ScreenWidth > ScreenHeight){
        PortraitScreenWidth = ScreenHeight;
        PortraitScreenHeight = ScreenWidth;
    }else{
        PortraitScreenWidth = ScreenWidth;
        PortraitScreenHeight = ScreenHeight;
    }
    self.view.backgroundColor = [AlivcUIConfig shared].kAVCBackgroundColor;
    //自定义返回按钮
    UIImage *returnImage = [UIImage imageNamed:@"avcBackIcon"];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:returnImage style:UIBarButtonItemStylePlain target:self action:@selector(returnAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)returnAction{
    [self.navigationController popViewControllerAnimated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 默认竖屏
//- (BOOL)shouldAutorotate{
//    return NO;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskPortrait;
//}


//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    return UIInterfaceOrientationPortrait;
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
