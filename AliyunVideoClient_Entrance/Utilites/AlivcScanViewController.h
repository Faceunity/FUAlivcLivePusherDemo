//
//  AVC_VP_ScanViewController.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/9.
//  Copyright © 2018年 Alibaba. All rights reserved.
//  通过扫描二维码获取URL界面

#import "LBXScanViewController.h"

@class AlivcScanViewController;
@protocol AlivcScanViewControllerDelegate <NSObject>

@required

- (void)scanViewController:(AlivcScanViewController *)vc scanResult:(NSString *)resultString;

@end

@interface AlivcScanViewController : LBXScanViewController

+ (LBXScanViewStyle*)ZhiFuBaoStyle;

@property (weak, nonatomic) id <AlivcScanViewControllerDelegate> delegate;

@end
