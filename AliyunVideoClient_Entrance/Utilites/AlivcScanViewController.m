//
//  AVC_VP_ScanViewController.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/9.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcScanViewController.h"
#import <LBXScanViewStyle.h>
#import "AlivcUIConfig.h"
#import "NSString+AlivcHelper.h"

@interface AlivcScanViewController ()

@end

@implementation AlivcScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.cameraInvokeMsg = [@"相机启动中" localString];
    
    self.view.backgroundColor = [AlivcUIConfig shared].kAVCBackgroundColor;
    
    self.title = @"";
}

#pragma mark -实现类继承该方法，作出对应处理

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if (!array ||  array.count < 1)
    {
        NSLog(@"扫码失败");
        
        return;
    }
    
    //经测试，可以ZXing同时识别2个二维码，不能同时识别二维码和条形码
    //    for (LBXScanResult *result in array) {
    //
    //        NSLog(@"scanResult:%@",result.strScanned);
    //    }
    
    LBXScanResult *scanResult = array[0];
    
    NSString *strResult = scanResult.strScanned;
    
    self.scanImage = scanResult.imgScanned;
    
    if (!strResult) {
        
        return;
    }
    
    //TODO: 这里可以根据需要自行添加震动或播放声音提示相关代码
    //...
    NSLog(@"scanResult:%@",scanResult);
    [self.navigationController popViewControllerAnimated:true];
    if (self.delegate && [self.delegate respondsToSelector:@selector(scanViewController:scanResult:)]) {
        [self.delegate scanViewController:self scanResult:strResult];
    }
}

- (void)pushToPalyVCWithUrlString:(NSString *)urlString{
    
}

#pragma mark --模仿支付宝
+ (LBXScanViewStyle*)ZhiFuBaoStyle
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 60;
    style.xScanRetangleOffset = 30;
    
    if ([UIScreen mainScreen].bounds.size.height <= 480 )
    {
        //3.5inch 显示的扫码缩小
        style.centerUpOffset = 40;
        style.xScanRetangleOffset = 20;
    }
    
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 2.0;
    style.photoframeAngleW = 16;
    style.photoframeAngleH = 16;
    
    style.isNeedShowRetangle = NO;
    style.anmiationStyle = LBXScanViewAnimationStyle_NetGrid;
    
    style.notRecoginitonArea = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    
    //使用的支付宝里面网格图片
    UIImage *imgFullNet = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_full_net"];
    style.animationImage = imgFullNet;
    
    return style;
}

@end
