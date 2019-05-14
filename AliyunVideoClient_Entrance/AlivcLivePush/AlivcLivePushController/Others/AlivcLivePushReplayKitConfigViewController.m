//
//  AlivcLivePushReplayKitConfigViewController.m
//  AlivcLiveCaptureDev
//
//  Created by lyz on 2017/9/20.
//  Copyright © 2017年 Alivc. All rights reserved.
//

#import "AlivcLivePushReplayKitConfigViewController.h"
#import "AlivcParamTableViewCell.h"
#import "AlivcParamModel.h"
#import "AlivcWatermarkSettingView.h"
#import "AlivcLivePusherViewController.h"
#import "AlivcUIConfig.h"
#import "AlivcQRCodeView.h"
#import "AlivcScanViewController.h"
static const NSString *AlivcTextPushURL = @"rtmp://push-demo-rtmp.aliyunlive.com/test/stream";
static const NSString *AlivcTextPullUrl = @"rtmp://push-demo.aliyunlive.com/test/stream";

#import <AlivcLivePusher/AlivcLivePusherHeader.h>

@interface AlivcLivePushReplayKitConfigViewController () <UITableViewDelegate, UITableViewDataSource,AlivcScanViewControllerDelegate>

@property (nonatomic, strong) UITextField *publisherURLTextField;
@property (nonatomic, strong) UIButton *QRCodeButton;
@property (nonatomic, strong) UIButton *urlCopyButton;
@property (nonatomic, strong) UITableView *paramTableView;
@property (nonatomic, strong) UIButton *publisherButton;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) AlivcWatermarkSettingView *waterSettingView;

@property (nonatomic, assign) BOOL isUseOriginResolution; // 是否使用原始分辨率


@property (nonatomic, strong) AlivcLivePushConfig *pushConfig;


@property (nonatomic, assign) BOOL isKeyboardShow;
@property (nonatomic, assign) CGRect tableViewFrame;

@property (nonatomic, strong) UILabel *infoLabel;


@property (nonatomic, assign) BOOL isPushing;
@property (nonatomic, strong) AlivcQRCodeView *qrCodeView; //二维码生成view
@property (nonatomic, copy) NSString *playUrl;
@end

@implementation AlivcLivePushReplayKitConfigViewController

- (void)viewDidLoad {
    
    _isPushing = NO;
    [super viewDidLoad];
    
    [self setupParamData];
    [self setupSubviews];
    [self setupInfoLabel];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - UI
- (void)setupSubviews {
    
    self.view.backgroundColor = [AlivcUIConfig shared].kAVCBackgroundColor;
    
    self.navigationItem.title = NSLocalizedString(@"pusher_setting", nil);
    
    CGFloat retractX = 10;
    CGFloat viewWidth = AlivcScreenWidth - retractX * 2;
    
    self.publisherURLTextField = [[UITextField alloc] init];
    
    if(IS_IPHONEX) {
        self.publisherURLTextField.frame = CGRectMake(retractX, 36, viewWidth - 100, AlivcSizeHeight(40));
    }else {
        self.publisherURLTextField.frame = CGRectMake(retractX, 6, viewWidth - 100, AlivcSizeHeight(40));
    }
    
    self.publisherURLTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.publisherURLTextField.backgroundColor = rgba(255, 255, 255, 0.1);
    self.publisherURLTextField.placeholder = NSLocalizedString(@"input_tips", nil);
    self.publisherURLTextField.font = [UIFont systemFontOfSize:14.f];
    self.publisherURLTextField.textColor = [UIColor whiteColor];
    self.publisherURLTextField.clearsOnBeginEditing = NO;
    self.publisherURLTextField.clearButtonMode = UITextFieldViewModeAlways;
    //随机推流地址
    int tempI = arc4random()%10000;
    NSString *tempUrl = [NSString stringWithFormat:@"%@%d",AlivcTextPushURL,tempI];
    self.publisherURLTextField.text = tempUrl;
    self.playUrl = [NSString stringWithFormat:@"%@%d",AlivcTextPullUrl,tempI];
    
    UILabel *noticeLabel = [[UILabel alloc] init];
    noticeLabel.frame = CGRectMake(retractX,
                                   CGRectGetMaxY(self.publisherURLTextField.frame) + 2,
                                   CGRectGetWidth(self.view.frame),
                                   AlivcSizeHeight(25));
    noticeLabel.textAlignment = NSTextAlignmentLeft;
    noticeLabel.font = [UIFont systemFontOfSize:12.f];
    noticeLabel.textColor = [UIColor whiteColor];
    noticeLabel.numberOfLines = 0;
    noticeLabel.text = NSLocalizedString(@"push_url_notice_text", nil);
    
    self.QRCodeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.QRCodeButton.frame = CGRectMake(CGRectGetMaxX(self.publisherURLTextField.frame)+5,
                                         CGRectGetMinY(self.publisherURLTextField.frame),
                                         CGRectGetHeight(self.publisherURLTextField.frame),
                                         CGRectGetHeight(self.publisherURLTextField.frame));
    [self.QRCodeButton setImage:[UIImage imageNamed:@"avcScan"] forState:(UIControlStateNormal)];
    self.QRCodeButton.layer.masksToBounds = YES;
    self.QRCodeButton.layer.cornerRadius = 10;
    [self.QRCodeButton addTarget:self action:@selector(QRCodeButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.urlCopyButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.urlCopyButton.frame = CGRectMake(CGRectGetMaxX(self.QRCodeButton.frame), CGRectGetMinY(self.QRCodeButton.frame), CGRectGetWidth(self.QRCodeButton.frame), CGRectGetWidth(self.QRCodeButton.frame));
    [self.urlCopyButton setImage:[UIImage imageNamed:@"generateQCode"] forState:(UIControlStateNormal)];
    self.urlCopyButton.layer.masksToBounds = YES;
    self.urlCopyButton.layer.cornerRadius = 10;
    [self.urlCopyButton addTarget:self action:@selector(newQRCodeButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];

    
    self.publisherButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.publisherButton.frame = CGRectMake(0, 0, 150, 50);
    self.publisherButton.center = CGPointMake(AlivcScreenWidth / 2, AlivcScreenHeight - 110);
    self.publisherButton.backgroundColor = [AlivcUIConfig shared].kAVCThemeColor;
    [self.publisherButton setTitle:NSLocalizedString(@"start_button", nil) forState:(UIControlStateNormal)];
    self.publisherButton.layer.masksToBounds = YES;
    self.publisherButton.layer.cornerRadius = 10;
    [self.publisherButton addTarget:self action:@selector(publiherButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.paramTableView = [[UITableView alloc] init];
    self.paramTableView.frame = CGRectMake(retractX,
                                           CGRectGetMaxY(noticeLabel.frame) + 5,
                                           viewWidth,
                                           100);
    self.paramTableView.backgroundColor = [AlivcUIConfig shared].kAVCBackgroundColor;
    self.paramTableView.scrollEnabled = NO;
    self.paramTableView.delegate = (id)self;
    self.paramTableView.dataSource = (id)self;
    self.paramTableView.separatorStyle = NO;
    
    UILabel *screenRecordnoticeLabel = [[UILabel alloc] init];
    screenRecordnoticeLabel.frame = CGRectMake(retractX,
                                               CGRectGetMaxY(self.paramTableView.frame) + 5,
                                               CGRectGetWidth(self.view.frame) - 10,
                                               AlivcSizeHeight(150));
    screenRecordnoticeLabel.textAlignment = NSTextAlignmentLeft;
    screenRecordnoticeLabel.font = [UIFont systemFontOfSize:18.f];
    screenRecordnoticeLabel.textColor = [UIColor whiteColor];
    screenRecordnoticeLabel.numberOfLines = 0;
    screenRecordnoticeLabel.text = NSLocalizedString(@"screen_record_notice_text", nil);
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.paramTableView reloadData];
        [self updateBitrateAndFPSCell];
    });

    
    [self.view addSubview:self.publisherURLTextField];
    [self.view addSubview:noticeLabel];
    [self.view addSubview:self.QRCodeButton];
    [self.view addSubview:self.urlCopyButton];
    [self.view addSubview:self.publisherButton];
    [self.view addSubview:self.paramTableView];
    [self.view addSubview:screenRecordnoticeLabel];
    self.isKeyboardShow = false;
    self.tableViewFrame = self.paramTableView.frame;
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self.view addGestureRecognizer:recognizer];
}



#pragma mark - Data
- (void)setupParamData {
    self.isUseOriginResolution = NO;
    
    self.pushConfig = [[AlivcLivePushConfig alloc] init];
    
    AlivcParamModel *resolutionModel = [[AlivcParamModel alloc] init];
    resolutionModel.title = NSLocalizedString(@"resolution_label", nil);
    resolutionModel.placeHolder = @"540P";
    resolutionModel.infoText = @"540P";
    resolutionModel.defaultValue = 4.0/6.0;
    resolutionModel.reuseId = AlivcParamModelReuseCellSlider;
    resolutionModel.sliderBlock = ^(int value){
        self.pushConfig.resolution = value;
        [self updateBitrateAndFPSCell];
    };
    
    AlivcParamModel *orientationModel = [[AlivcParamModel alloc] init];
    orientationModel.title = NSLocalizedString(@"landscape_model", nil);
    orientationModel.segmentTitleArray = @[@"Portrait",@"HomeLeft",@"HomeRight"];
    orientationModel.defaultValue = 0;
    orientationModel.reuseId = AlivcParamModelReuseCellSegment;
    orientationModel.segmentBlock = ^(int value) {
        self.pushConfig.orientation = value;
        
        if(self.pushConfig.pauseImg) {
            if(self.pushConfig.orientation == AlivcLivePushOrientationPortrait) {
                self.pushConfig.pauseImg = [UIImage imageNamed:@"background_push.png"];
            } else{
                self.pushConfig.pauseImg = [UIImage imageNamed:@"background_push_land.png"];
            }
        }
        
        if(self.pushConfig.networkPoorImg) {
            if(self.pushConfig.orientation == AlivcLivePushOrientationPortrait) {
                self.pushConfig.networkPoorImg = [UIImage imageNamed:@"poor_network.png"];
            } else{
                self.pushConfig.networkPoorImg = [UIImage imageNamed:@"poor_network_land.png"];
            }
        }
        
    };
    
    

    self.dataArray = [NSMutableArray arrayWithObjects:resolutionModel, orientationModel, nil];
  
    // Demo 中pushConfig初始值设置
    // 默认支持背景图片和弱网图片推流
    self.pushConfig.pauseImg = [UIImage imageNamed:@"background_push.png"];
    self.pushConfig.networkPoorImg = [UIImage imageNamed:@"poor_network.png"];
}


- (void)updateBitrateAndFPSCell {
    
    int targetBitrate = 0;
    int minBitrate = 0;
    int initBitrate = 0;
    BOOL enable = NO;
    
    if (self.pushConfig.qualityMode == AlivcLivePushQualityModeFluencyFirst) {
        // 流畅度优先模式，bitrate 固定值不可修改
        enable = NO;
        switch (self.pushConfig.resolution) {
            case AlivcLivePushResolution180P:
                targetBitrate = 250;
                minBitrate = 80;
                initBitrate = 200;
                break;
            case AlivcLivePushResolution240P:
                targetBitrate = 350;
                minBitrate = 120;
                initBitrate = 300;
                break;
            case AlivcLivePushResolution360P:
                targetBitrate = 600;
                minBitrate = 200;
                initBitrate = 400;
                break;
            case AlivcLivePushResolution480P:
                targetBitrate = 800;
                minBitrate = 300;
                initBitrate = 600;
                break;
            case AlivcLivePushResolution540P:
                targetBitrate = 1000;
                minBitrate = 300;
                initBitrate = 800;
                break;
            case AlivcLivePushResolution720P:
                targetBitrate = 1200;
                minBitrate = 300;
                initBitrate = 1000;
                break;
            default:
                break;
        }
    }
    
    if (self.pushConfig.qualityMode == AlivcLivePushQualityModeResolutionFirst) {
        // 清晰度优先模式，bitrate 固定值不可修改
        enable = NO;
        switch (self.pushConfig.resolution) {
            case AlivcLivePushResolution180P:
                targetBitrate = 350;
                minBitrate = 120;
                initBitrate = 300;
                break;
            case AlivcLivePushResolution240P:
                targetBitrate = 550;
                minBitrate = 180;
                initBitrate = 450;
                break;
            case AlivcLivePushResolution360P:
                targetBitrate = 800;
                minBitrate = 300;
                initBitrate = 600;
                break;
            case AlivcLivePushResolution480P:
                targetBitrate = 1000;
                minBitrate = 300;
                initBitrate = 800;
                break;
            case AlivcLivePushResolution540P:
                targetBitrate = 1200;
                minBitrate = 600;
                initBitrate = 1000;
                break;
            case AlivcLivePushResolution720P:
                targetBitrate = 1800;
                minBitrate = 600;
                initBitrate = 1500;
                break;
            default:
                break;
        }
    }
    
    if (self.pushConfig.qualityMode == AlivcLivePushQualityModeCustom) {
        // 自定义模式，bitrate 固定值可修改
        enable = YES;
        targetBitrate = self.pushConfig.targetVideoBitrate;
        minBitrate = self.pushConfig.minVideoBitrate;
        initBitrate = self.pushConfig.initialVideoBitrate;
    }
    
    AlivcParamTableViewCell *targetCell = [self.paramTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    [targetCell updateDefaultValue:targetBitrate enable:enable];
    
    AlivcParamTableViewCell *minCell = [self.paramTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    [minCell updateDefaultValue:minBitrate enable:enable];
    
    AlivcParamTableViewCell *initCell = [self.paramTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    [initCell updateDefaultValue:initBitrate enable:enable];
}

- (NSString *)getWatermarkPathWithIndex:(NSInteger)index {
    
    NSString *watermarkBundlePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"watermark"] ofType:@"png"];
    
    return watermarkBundlePath;
}

#pragma mark - TableViewdelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AlivcParamModel *model = self.dataArray[indexPath.row];
    if (model) {
        NSString *cellIdentifier = [NSString stringWithFormat:@"AlivcLivePushTableViewIdentifier%ld", (long)indexPath.row];
        AlivcParamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[AlivcParamTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            [cell configureCellModel:model];
            cell.backgroundColor = [AlivcUIConfig shared].kAVCBackgroundColor;
        }
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![self.waterSettingView isEditing]) {
        [self.waterSettingView removeFromSuperview];
    }
    [self.view endEditing:YES];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}

#pragma mark - TO PublisherVC
- (void)publiherButtonAction:(UIButton *)sender {
 
    
    if(!_isPushing) {
        NSString *pushURLString = self.publisherURLTextField.text;
        if (!pushURLString) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入推流地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        NSInteger resolution = self.pushConfig.resolution;
        
        if(self.isUseOriginResolution){
            resolution = AlivcLivePushResolutionPassThrough;
        }
        
        UIPasteboard* pb = [UIPasteboard generalPasteboard];
        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:pushURLString,@"url", [[NSNumber alloc]initWithInt:resolution],@"resolution",[[NSNumber alloc]initWithInt:self.pushConfig.orientation],@"orientation",nil];
        
        NSString* transString = [self dictionary2JsonString:dict];
        pb.string = transString;
        
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),
                                                  CFSTR("Alivc_Replaykit_Start_Push"),
                                                  NULL,
                                                  nil,
                                                  YES);
        
        [self.publisherButton setTitle:NSLocalizedString(@"stop_button", nil) forState:(UIControlStateNormal)];
        
        _isPushing = YES;
        
        
    }else {
        
        
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),CFSTR("Alivc_Replaykit_Stop_Push"),NULL,nil,YES);
        
        NSNotification* notification = [NSNotification notificationWithName:@"Alivc_Replaykit_Stop_Push"
                                                                     object:self
                                                                   userInfo:nil];
        
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        [self.publisherButton setTitle:NSLocalizedString(@"start_button", nil) forState:(UIControlStateNormal)];
        _isPushing = NO;
    }
    
}


- (NSString *)dictionary2JsonString:(NSDictionary *)dict
{
    if ([NSJSONSerialization isValidJSONObject:dict])
    {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    return nil;
}


#pragma mark - TO QRCodeVC
- (void)newQRCodeButtonAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    self.qrCodeView.frame = self.view.bounds;
    
    if (self.publisherURLTextField.text.length) {
        
    }else{
        int tempI = arc4random()%10000;
        NSString *tempUrl = [NSString stringWithFormat:@"%@%d",AlivcTextPushURL,tempI];
        self.publisherURLTextField.text = tempUrl;
        self.playUrl = [NSString stringWithFormat:@"%@%d",AlivcTextPullUrl,tempI];
    }
    self.qrCodeView.qrCodeString = self.playUrl;
    [self.view addSubview:self.qrCodeView];
}
#pragma mark - AVC_VP_ScanDelegate
- (void)scanViewController:(id)vc scanResult:(NSString *)resultString{
    self.publisherURLTextField.text = resultString;
}
#pragma mark -
- (void)urlCopyButtonAction:(UIButton *)sender {

    [self.view endEditing:YES];
    self.qrCodeView.frame = self.view.bounds;
    
    if (self.publisherURLTextField.text.length) {
        
    }else{
        int tempI = arc4random()%10000;
        NSString *tempUrl = [NSString stringWithFormat:@"%@%d",AlivcTextPushURL,tempI];
        self.publisherURLTextField.text = tempUrl;
        self.playUrl = [NSString stringWithFormat:@"%@%d",AlivcTextPullUrl,tempI];
    }
    self.qrCodeView.qrCodeString = self.playUrl;
    [self.view addSubview:self.qrCodeView];
    

}

- (void)QRCodeButtonAction {
    
    [self.view endEditing:YES];
    AlivcScanViewController *targetVC = [[AlivcScanViewController alloc]init];
    targetVC.style = [AlivcScanViewController ZhiFuBaoStyle];
    targetVC.isOpenInterestRect = true;
    targetVC.libraryType = SLT_Native;
    targetVC.scanCodeType = SCT_QRCode;
    targetVC.delegate = self;
    [self.navigationController pushViewController:targetVC animated:true];
    
}
- (AlivcQRCodeView *)qrCodeView{
    if (!_qrCodeView) {
        _qrCodeView = [[AlivcQRCodeView alloc] init];
    }
    return _qrCodeView;
}

- (void)setupInfoLabel {
    
    self.infoLabel = [[UILabel alloc] init];
    self.infoLabel.frame = CGRectMake(20, 100, self.view.bounds.size.width - 40, 100);
    self.infoLabel.textColor = [UIColor blackColor];
    self.infoLabel.backgroundColor = AlivcRGBA(255, 255, 255, 1.0);
    self.infoLabel.font = [UIFont systemFontOfSize:14.f];
    self.infoLabel.layer.masksToBounds = YES;
    self.infoLabel.layer.cornerRadius = 10;
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.infoLabel];
    self.infoLabel.hidden = YES;
}

- (void)updateInfoText:(NSString *)text {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.infoLabel setHidden:NO];
        self.infoLabel.text = text;
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(hiddenInfoLabel) withObject:nil afterDelay:2.0];
        
    });
}

- (void)handleTap{
    [self.view endEditing:YES];
}

- (void)hiddenInfoLabel {
    
    [self.infoLabel setHidden:YES];
}


@end

