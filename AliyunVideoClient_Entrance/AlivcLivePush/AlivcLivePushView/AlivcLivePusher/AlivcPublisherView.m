//
//  AlivcPublisherView.m
//  AlivcLiveCaptureDev
//
//  Created by TripleL on 17/7/10.
//  Copyright © 2017年 Alivc. All rights reserved.
//

#import "AlivcPublisherView.h"
#import "AlivcDebugChartView.h"
#import "AlivcDebugTextView.h"
#import "AlivcGuidePageView.h"
#import "AlivcMusicSettingView.h"
#import "AlivcAnswerGameView.h"
#import "AlivcPushViewsProtocol.h"
#import "AlivcUIConfig.h"
#import <AlivcLivePusher/AlivcLivePusherHeader.h>
#import "AlivcLiveBeautifySettingsViewController.h"
#import "NSString+AlivcHelper.h"
#import "UIColor+AlivcHelper.h"
//#if __has_include(<AlivcInteractiveLiveRoomSDK/AlivcInteractiveLiveRoomSDK.h>)
//#import <AlivcInteractiveLiveRoomSDK/AlivcInteractiveLiveRoomSDK.h>
//#else
//#import "AlivcInteractiveLiveRoomSDK.h"
//#endif
#define viewWidth AlivcSizeWidth(58)
#define viewHeight viewWidth/4*3
#define topViewButtonSize AlivcSizeWidth(35)

static const int moreSettingViewHeightcount = 5;

@interface AlivcPublisherView () <UIGestureRecognizerDelegate,AlivcLiveBeautifySettingsViewControllerDelegate>{
    NSMutableArray * dynamicWatermarkArr;
}

@property (nonatomic, weak) id<AlivcPublisherViewDelegate> delegate;

@property (nonatomic, strong) AlivcGuidePageView *guideView;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *switchButton;
@property (nonatomic, strong) UIButton *flashButton;
@property (nonatomic, strong) UIButton *musicButton;
@property (nonatomic, strong) UIButton *muteButton;
@property (nonatomic, strong) UIButton *answerGameButton;
@property (nonatomic, strong) UIButton *beautySettingButton;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *previewButton;
@property (nonatomic, strong) UIButton *pushButton;
@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic, strong) UIButton *restartButton;
@property (nonatomic, strong) UIButton *moreSettingButton;

@property (nonatomic, strong) UISwitch *previewMirrorSwitch;
@property (nonatomic, strong) UISwitch *pushMirrorSwitch;

@property (nonatomic, strong) UIView *beautySettingView;
@property (nonatomic, strong) UIView *moreSettingView;
@property (nonatomic, strong) AlivcMusicSettingView *musicSettingView;
@property (nonatomic, strong) AlivcAnswerGameView *answerGameView;


@property (nonatomic, strong) AlivcDebugChartView *debugChartView;
@property (nonatomic, strong) AlivcDebugTextView *debugTextView;

@property (nonatomic, assign) BOOL isBeautySettingShow;
@property (nonatomic, assign) BOOL isMoreSettingShow;
@property (nonatomic, assign) BOOL isMusicSettingShow;
@property (nonatomic, assign) BOOL isAnswerGameViewShow;
@property (nonatomic, assign) BOOL isKeyboardEdit;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UILabel *infoLabel;

@property (nonatomic, strong) AlivcLivePushConfig *config;

@end

@implementation AlivcPublisherView


- (instancetype)initWithFrame:(CGRect)frame config:(AlivcLivePushConfig *)config {
    
    self = [super initWithFrame:frame];
    if (self) {
        _config = config;
        [self setupSubviews];
        [self addNotifications];
        dynamicWatermarkArr = [[NSMutableArray alloc]init];
    }
    return self;
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)setPushViewsDelegate:(id)delegate {
    
    self.delegate = delegate;
    [self.musicSettingView setMusicDelegate:delegate];
    [self.answerGameView setAnswerDelegate:delegate];

}

#pragma mark - UI

- (void)setupSubviews {
    
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:AlivcUserDefaultsIndentifierFirst]) {
//        [self setupGuideView];
//    }
    
    [self setupTopViews];
    
    [self setupBottomViews];
    
    [self setupInfoLabel];
    
//    [self setupDebugViews];
    
    [self addGesture];
    
    if (self.config.audioOnly) {
        [self hiddenVideoViews];
    }
    
    self.currentIndex = 1;
}


- (void)setupGuideView {
    
    self.guideView = [[AlivcGuidePageView alloc] initWithFrame:CGRectMake(20, 0, self.bounds.size.width - 40, self.bounds.size.height/6)];
    self.guideView.center = self.center;
    [self addSubview:self.guideView];
}


- (void)setupTopViews {
    
    self.topView = [[UIView alloc] init];
    self.topView.frame = CGRectMake(0, 20, CGRectGetWidth(self.frame), viewHeight);
    [self addSubview: self.topView];
    
    CGFloat retractX = 5;
    
    self.backButton = [self setupButtonWithFrame:(CGRectMake(retractX, 0, topViewButtonSize, topViewButtonSize))
                                     normalImage:[UIImage imageNamed:@"back"]
                                     selectImage:nil
                                          action:@selector(backButtonAction:)];
    [self.topView addSubview: self.backButton];
    
    self.switchButton = [self setupButtonWithFrame:(CGRectMake(CGRectGetWidth(self.frame) - retractX - topViewButtonSize, 0, topViewButtonSize, topViewButtonSize))
                                       normalImage:[UIImage imageNamed:@"camera_id"]
                                       selectImage:nil
                                            action:@selector(switchButtonAction:)];
    [self.topView addSubview:self.switchButton];
    
    self.flashButton = [self setupButtonWithFrame:(CGRectMake(CGRectGetMinX(self.switchButton.frame) - retractX - topViewButtonSize, 0, topViewButtonSize, topViewButtonSize))
                                                   normalImage:[UIImage imageNamed:@"camera_flash_close"]
                                                   selectImage:[UIImage imageNamed:@"camera_flash_on"]
                                                   action:@selector(flashButtonAction:)];
    [self.topView addSubview:self.flashButton];
    [self.flashButton setSelected:self.config.flash];
    [self.flashButton setEnabled:self.config.cameraType==AlivcLivePushCameraTypeFront?NO:YES];
    
    self.musicButton = [self setupButtonWithFrame:(CGRectMake(CGRectGetMinX(self.flashButton.frame) - retractX - topViewButtonSize, 0, topViewButtonSize, topViewButtonSize))
                                     normalImage:[UIImage imageNamed:@"music_button"]
                                     selectImage:nil
                                          action:@selector(musicButtonAction:)];
    [self.topView addSubview: self.musicButton];
    
    if (self.config.videoOnly) {
        [self.musicButton setHidden:YES];
    }
    
    self.beautySettingButton = [self setupButtonWithFrame:(CGRectMake(CGRectGetMinX(self.musicButton.frame) - retractX - topViewButtonSize, 0, topViewButtonSize, topViewButtonSize))
                                              normalImage:[UIImage imageNamed:@"record_beauty_on"]
                                              selectImage:nil
                                                   action:@selector(beautySettingButtonAction:)];
    [self.topView addSubview: self.beautySettingButton];

//    self.answerGameButton = [self setupButtonWithFrame:(CGRectMake(CGRectGetMinX(self.beautySettingButton.frame) - retractX - topViewButtonSize, 0, topViewButtonSize, topViewButtonSize))
//                                           normalTitle:NSLocalizedString(@"答题", nil)
//                                           selectTitle:nil
//                                                action:@selector(answerGameButtonAction:)];
//    self.answerGameButton.layer.masksToBounds = YES;
//    self.answerGameButton.layer.cornerRadius = topViewButtonSize/2;
//    [self.topView addSubview: self.answerGameButton];

    //[self setupMusicSettingView];
    self.isBeautySettingShow = NO;
    self.isMusicSettingShow = NO;
    self.isAnswerGameViewShow = NO;
}


- (void)setupBottomViews {
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.frame = CGRectMake(0,
                                       CGRectGetHeight(self.frame) - viewHeight,
                                       CGRectGetWidth(self.frame),
                                       viewHeight);
    self.bottomView.backgroundColor = rgba(0, 0, 0, 0.03);

    [self addSubview: self.bottomView];
    
    CGFloat buttonCount = 5;
    CGFloat retractX = (CGRectGetWidth(self.bottomView.frame) - viewWidth * 5) / (buttonCount + 1);
    
    self.previewButton = [self setupButtonWithFrame:(CGRectMake(retractX, 0, viewWidth, viewHeight))
                                        normalTitle:NSLocalizedString(@"start_preview_button", nil)
                                        selectTitle:NSLocalizedString(@"stop_preview_button", nil)
                                             action:@selector(previewButtonAction:)];
    [self.bottomView addSubview: self.previewButton];
    [self.previewButton setSelected:YES];
    
    self.pushButton = [self setupButtonWithFrame:(CGRectMake(retractX * 2 + viewWidth, 0, viewWidth, viewHeight))
                                     normalTitle:NSLocalizedString(@"start_button", nil)
                                     selectTitle:NSLocalizedString(@"stop_button", nil)
                                          action:@selector(pushButtonAction:)];
    [self.bottomView addSubview: self.pushButton];
    
    self.pauseButton = [self setupButtonWithFrame:(CGRectMake(retractX * 3 + viewWidth * 2, 0, viewWidth, viewHeight))
                                      normalTitle:NSLocalizedString(@"pause_button", nil)
                                      selectTitle:NSLocalizedString(@"resume_button", nil)
                                           action:@selector(pauseButtonAction:)];
    [self.bottomView addSubview:self.pauseButton];
    
    self.restartButton = [self setupButtonWithFrame:(CGRectMake(retractX * 4 + viewWidth * 3, 0, viewWidth, viewHeight))
                                      normalTitle:NSLocalizedString(@"repush_button", nil)
                                      selectTitle:nil
                                           action:@selector(restartButtonAction:)];
    [self.bottomView addSubview:self.restartButton];

    
    self.moreSettingButton = [self setupButtonWithFrame:(CGRectMake(retractX * 5 + viewWidth * 4, 0, viewWidth, viewHeight))
                                              normalTitle:NSLocalizedString(@"more_setting_button", nil)
                                              selectTitle:nil
                                                   action:@selector(moreSettingButtonAction:)];
    [self.bottomView addSubview: self.moreSettingButton];
    
    self.isMoreSettingShow = NO;
    
}


- (void)setupInfoLabel {
    
    self.infoLabel = [[UILabel alloc] init];
    self.infoLabel.frame = CGRectMake(20, 100, self.bounds.size.width - 40, 40);
    self.infoLabel.textColor = [UIColor blackColor];
    self.infoLabel.backgroundColor = AlivcRGBA(255, 255, 255, 0.5);
    self.infoLabel.font = [UIFont systemFontOfSize:14.f];
    self.infoLabel.layer.masksToBounds = YES;
    self.infoLabel.layer.cornerRadius = 10;
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.infoLabel];
    self.infoLabel.hidden = YES;
}


//- (void)setupBeautySettingViews {
//
//    CGFloat retractX = 7;
//
//    CGFloat sliderCount = 7;
//
//    CGFloat height = viewHeight;
//    if (self.bounds.size.width > self.bounds.size.height) {
//        height = 18.0/375*self.bounds.size.width;
//    }
//
//    self.beautySettingView = [[UIView alloc] init];
//    self.beautySettingView.frame = CGRectMake(retractX,
//                                              CGRectGetMinY(self.bottomView.frame) - height * sliderCount,
//                                              CGRectGetWidth(self.frame) - retractX * 2,
//                                              height * sliderCount);
//
//    self.beautySettingView.backgroundColor = AlivcRGBA(1, 1, 1, 0.3);
//    self.beautySettingView.layer.masksToBounds = YES;
//    self.beautySettingView.layer.cornerRadius = 10;
//
//    UIButton *beautyButton = [self setupButtonWithFrame:(CGRectMake(0, 0, viewWidth, height))
//                                       normalTitle:NSLocalizedString(@"beauty_on", nil)
//                                       selectTitle:NSLocalizedString(@"beauty_off", nil)
//                                            action:@selector(beautyButtonAction:)];
//    beautyButton.center = CGPointMake(retractX + viewWidth / 2, CGRectGetHeight(self.beautySettingView.frame) / 2);
//    [beautyButton setSelected:YES];
//    [self.beautySettingView addSubview:beautyButton];
//    [beautyButton setSelected:self.config.beautyOn];
//
//
//    CGFloat labelX = CGRectGetMaxX(beautyButton.frame) + retractX;
//    CGFloat labelWidth = viewWidth / 2 + 20;
//    CGFloat sliderX = CGRectGetMaxX(beautyButton.frame) + labelWidth + retractX * 2;
//    CGFloat sliderWidth = CGRectGetWidth(self.beautySettingView.frame) - sliderX - retractX;
//    CGFloat adjustHeight = (CGRectGetHeight(self.beautySettingView.frame) - retractX * (sliderCount - 1)) / sliderCount                                                                                                                                                                               ;
//
//
//    NSArray *labelNameArray = @[NSLocalizedString(@"beauty_skin_smooth", nil),NSLocalizedString(@"beauty_white", nil),NSLocalizedString(@"beauty_ruddy", nil),NSLocalizedString(@"beauty_cheekpink", nil),NSLocalizedString(@"beauty_thinface", nil),NSLocalizedString(@"beauty_shortenface", nil),NSLocalizedString(@"beauty_bigeye", nil)];
//    NSArray *sliderActionArray = @[@"buffingValueChange:",@"whiteValueChange:", @"ruddyValueChange:",@"cheekPinkValueChange:",@"thinfaceValueChange:",@"shortenfaceValueChange:",@"bigeyeValueChange:"];
//    NSArray *beautyDefaultValueArray = @[@(self.config.beautyBuffing),@(self.config.beautyWhite),@(self.config.beautyRuddy),@(self.config.beautyCheekPink),@(self.config.beautyThinFace),@(self.config.beautyShortenFace),@(self.config.beautyBigEye)];
//
//
//    for (int index = 0; index < sliderCount; index++) {
//        UILabel *label = [[UILabel alloc] init];
//        label.frame = CGRectMake(labelX, retractX * (index + 1) + adjustHeight * index, labelWidth, adjustHeight);
//        label.font = [UIFont systemFontOfSize:14.f];
//        label.text = labelNameArray[index];
//        label.lineBreakMode = NSLineBreakByWordWrapping;
//        label.numberOfLines = 0;
//        label.textColor = [UIColor whiteColor];
//        [self.beautySettingView addSubview:label];
//
//        UISlider *slider = [[UISlider alloc] init];
//        slider.frame = CGRectMake(sliderX, retractX * (index + 1) + adjustHeight * index, sliderWidth, adjustHeight);
//        [slider addTarget:self action:NSSelectorFromString(sliderActionArray[index]) forControlEvents:(UIControlEventValueChanged)];
//        slider.maximumValue = 100;
//        slider.minimumValue = 0;
//        slider.value = [beautyDefaultValueArray[index] intValue];
//        [self.beautySettingView addSubview:slider];
//    }
//}

- (void)setupMoreSettingViews {
    
    self.moreSettingView = [[UIView alloc] init];
    
    CGFloat retractX = 5;
    
    CGFloat height = viewHeight;
    if (self.bounds.size.width > self.bounds.size.height) {
        height = 45;
    }

    
    self.moreSettingView.frame = CGRectMake(retractX,
                                              CGRectGetHeight(self.frame) - height * moreSettingViewHeightcount,
                                              CGRectGetWidth(self.frame) - retractX * 2,
                                              height * moreSettingViewHeightcount);
    self.moreSettingView.backgroundColor = [AlivcUIConfig shared].kAVCBackgroundColor;
    self.moreSettingView.layer.masksToBounds = YES;
    self.moreSettingView.layer.cornerRadius = 10;

    
    CGFloat buttonY = CGRectGetHeight(self.moreSettingView.frame) - height * 2;
    CGFloat middleX = CGRectGetMidX(self.moreSettingView.frame);
    
    NSArray *array = [NSArray arrayWithObjects:NSLocalizedString(@"tile", nil),NSLocalizedString(@"fit", nil),NSLocalizedString(@"cut", nil), nil];
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
//    segment.backgroundColor = [UIColor whiteColor];
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:10.f], NSFontAttributeName,RGBToColor(245, 245, 246),NSForegroundColorAttributeName, nil];
    
    [segment setTitleTextAttributes:attr
                                forState:UIControlStateNormal];
    [segment setTitleTextAttributes:attr
                                forState:UIControlStateSelected];
    segment.tintColor = [AlivcUIConfig shared].kAVCThemeColor;
    segment.frame = CGRectMake(retractX, buttonY - height, self.moreSettingView.frame.size.width - 2*retractX, height);
    segment.selectedSegmentIndex = _config.previewDisplayMode;
    [segment addTarget:self action:@selector(previewDisplayModeChange:) forControlEvents:UIControlEventValueChanged];
    [self.moreSettingView addSubview:segment];
    
    UIButton *sharedButton = [self setupButtonWithFrame:(CGRectMake(retractX, buttonY, viewWidth, height))
                                        normalTitle:NSLocalizedString(@"share_button", nil)
                                        selectTitle:nil
                                             action:@selector(sharedButtonAction:)];
//    [self.moreSettingView addSubview:sharedButton];
   
    self.previewMirrorSwitch = [[UISwitch alloc] init];
    UIView *previewMirrorView = [self setupSwitchViewsWithFrame:(CGRectMake(middleX, buttonY, middleX, height)) title:NSLocalizedString(@"preview_mirror", nil) switchView:self.previewMirrorSwitch switchOn:self.config.previewMirror switchAction:@selector(previewMirrorSwitchAction:)];
    [self.moreSettingView addSubview:previewMirrorView];
    
    self.pushMirrorSwitch = [[UISwitch alloc] init];
    
    UIView *pushMirrorView = [self setupSwitchViewsWithFrame:(CGRectMake(retractX, buttonY, middleX, height)) title:NSLocalizedString(@"push_mirror", nil) switchView:self.pushMirrorSwitch switchOn:self.config.pushMirror switchAction:@selector(pushMirrorSwitchAction:)];
    [self.moreSettingView addSubview:pushMirrorView];
    
    UISwitch *autoFocusSwitch = [[UISwitch alloc] init];
    UIView *autoFocusView = [self setupSwitchViewsWithFrame:(CGRectMake(retractX, buttonY+height, middleX, height)) title:NSLocalizedString(@"auto_focus", nil) switchView:autoFocusSwitch switchOn:self.config.autoFocus switchAction:@selector(autoFocusSwitchAction:)];
    [self.moreSettingView addSubview:autoFocusView];
    
    
    UIButton *addButton = [self setupButtonWithFrame:(CGRectMake(middleX, buttonY+height, viewWidth, height))
                                         normalTitle:NSLocalizedString(@"add_button", nil)
                                         selectTitle:nil
                                              action:@selector(addButtonAction:)];
    [self.moreSettingView addSubview:addButton];
    
    UIButton *removeButton = [self setupButtonWithFrame:(CGRectMake(middleX + viewWidth + 5, buttonY+height, viewWidth, height))
                                            normalTitle:NSLocalizedString(@"remove_button", nil)
                                            selectTitle:nil
                                                 action:@selector(removeButtonAction:)];
    [self.moreSettingView addSubview:removeButton];
    

    
    int labelCount = 2;
    CGFloat retract = 5;
    CGFloat labelWidth = 30;
    NSArray *nameArray = @[NSLocalizedString(@"target_bitrate", nil),NSLocalizedString(@"min_bitrate", nil)];
    NSArray *textFieldActionArray = @[@"maxBitrateTextFieldValueChanged:", @"minBitrateTextFieldValueChanged:"];
    NSArray *value =@[@(self.config.targetVideoBitrate),@(self.config.minVideoBitrate)];
    
    for (int index = 0; index < labelCount; index++) {
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(retract,
                                     10 +(retract*(index+1))+(labelWidth*index),
                                     labelWidth * 2,
                                     labelWidth);
        nameLabel.textAlignment = NSTextAlignmentRight;
        nameLabel.font = [UIFont systemFontOfSize:14.f];
        nameLabel.text = nameArray[index];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        nameLabel.numberOfLines = 0;
        
        UITextField *textField = [[UITextField alloc] init];
        textField.frame = CGRectMake(CGRectGetMaxX(nameLabel.frame) + retract,
                                     CGRectGetMinY(nameLabel.frame),
                                     CGRectGetWidth(self.moreSettingView.frame) - AlivcSizeWidth(110),
                                     30);
        textField.textColor = RGBToColor(245, 245, 246);
        textField.backgroundColor = rgba(255, 255, 255, 0.1);
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.placeholder = [NSString stringWithFormat:@"%@", value[index]];
        textField.text = [NSString stringWithFormat:@"%@", value[index]];
        textField.font = [UIFont systemFontOfSize:14.f];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.clearsOnBeginEditing = YES;
        [textField addTarget:self action:NSSelectorFromString(textFieldActionArray[index]) forControlEvents:(UIControlEventEditingDidEnd)];
        
        UILabel *unitLabel = [[UILabel alloc] init];
        unitLabel.frame = CGRectMake(CGRectGetMaxX(textField.frame) + retract,
                                     CGRectGetMinY(nameLabel.frame),
                                     labelWidth * 2,
                                     labelWidth);
        unitLabel.textAlignment = NSTextAlignmentLeft;
        unitLabel.font = [UIFont systemFontOfSize:14.f];
        unitLabel.textColor = [UIColor whiteColor];
        unitLabel.text = @"Kbps";
        
        [self.moreSettingView addSubview:nameLabel];
        [self.moreSettingView addSubview:textField];
        [self.moreSettingView addSubview:unitLabel];
        
        if (self.config.qualityMode != AlivcLivePushQualityModeCustom) {
            // 非自定义模式下，不允许更改码率
            nameLabel.alpha = 0.5;
            [textField setEnabled:NO];
            textField.alpha = 0.5;
            unitLabel.alpha = 0.5;
        }

    }
}


- (void)setupMusicSettingView {
    
    CGRect frame = CGRectMake(0, self.frame.size.height/2-30, self.frame.size.width, self.frame.size.height/2+30);
    if (self.bounds.size.width > self.bounds.size.height) {
        frame = CGRectMake(0, self.frame.size.height/3-30, self.frame.size.width, self.frame.size.height/3*2+30);
    }
    self.musicSettingView = [[AlivcMusicSettingView alloc] initWithFrame:frame];
    [self.musicSettingView setMusicDelegate:(id)self.delegate];

}


- (void)setupAnswerGameView {
    
    CGRect frame = CGRectMake(20, self.frame.size.height/4, self.frame.size.width-40, self.frame.size.height/2);
    if (self.bounds.size.width > self.bounds.size.height) {
        frame = CGRectMake(self.frame.size.width/4, self.frame.size.height/3, self.frame.size.width/2, self.frame.size.height/3*2);
    }
    self.answerGameView = [[AlivcAnswerGameView alloc] initWithFrame:frame];
    self.answerGameView.center = self.center;
    [self.answerGameView setAnswerDelegate:(id)self.delegate];

}


- (UIView *)setupSwitchViewsWithFrame:(CGRect)viewFrame title:(NSString *)labelTitle switchView:(UISwitch *)switcher switchOn:(BOOL)switchOn switchAction:(SEL)switchAction{
    
    UIView *view = [[UIView alloc] initWithFrame:viewFrame];
    
    UILabel *viewLabel = [[UILabel alloc] init];
    viewLabel.frame = CGRectMake(0, 0, CGRectGetWidth(viewFrame)/2, CGRectGetHeight(viewFrame));
    viewLabel.text = labelTitle;
    viewLabel.font = [UIFont systemFontOfSize:14.f];
    viewLabel.numberOfLines = 0;
    viewLabel.textColor = [UIColor whiteColor];
    [viewLabel sizeToFit];
    viewLabel.center = CGPointMake(viewLabel.center.x, viewFrame.size.height/2);

    [view addSubview:viewLabel];
    
    switcher.frame = CGRectMake(CGRectGetMaxX(viewLabel.frame), 0, CGRectGetWidth(viewFrame)/2, CGRectGetHeight(viewFrame));
    switcher.center = CGPointMake(switcher.center.x, viewFrame.size.height/2);
    switcher.on = switchOn;
    switcher.onTintColor = [AlivcUIConfig shared].kAVCThemeColor;
    switcher.tintColor = [AlivcUIConfig shared].kAVCThemeColor;
    [switcher addTarget:self action:switchAction forControlEvents:(UIControlEventValueChanged)];
    [view addSubview:switcher];
    
    return view;
}


- (void)setupDebugViews {
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    self.debugChartView = [[AlivcDebugChartView alloc] initWithFrame:(CGRectMake(width, 0, width, height))];
    self.debugChartView.backgroundColor = AlivcRGBA(255, 255, 255, 0.8);
    [self addSubview:self.debugChartView];
    
    
    self.debugTextView = [[AlivcDebugTextView alloc] initWithFrame:(CGRectMake(-width, 0, width, height))];
    self.debugTextView.backgroundColor = AlivcRGBA(255, 255, 255, 0.8);
    [self addSubview:self.debugTextView];
}


- (void)addGesture {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tap.delegate = self;
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
    
    UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe:)];
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;

    UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe:)];
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self addGestureRecognizer:pinch];
    [self addGestureRecognizer:tap];
//    [self addGestureRecognizer:leftSwipeGestureRecognizer];
//    [self addGestureRecognizer:rightSwipeGestureRecognizer];
}



- (UIButton *)setupButtonWithFrame:(CGRect)rect normalTitle:(NSString *)normal selectTitle:(NSString *)select action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = rect;
    [button addTarget:self action:action forControlEvents:(UIControlEventTouchUpInside)];
    [button setTitle:normal forState:(UIControlStateNormal)];
    [button setTitle:select forState:(UIControlStateSelected)];
    [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont systemFontOfSize:15.f];
//    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = rect.size.height / 5;
    return button;
}


- (UIButton *)setupButtonWithFrame:(CGRect)rect normalImage:(UIImage *)normal selectImage:(UIImage *)select action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = rect;
    [button addTarget:self action:action forControlEvents:(UIControlEventTouchUpInside)];
    [button setImage:normal forState:(UIControlStateNormal)];
    [button setImage:select forState:(UIControlStateSelected)];
    return button;
}


#pragma mark - Button Actions

- (void)backButtonAction:(UIButton *)sender {
    
    if (self.delegate) {
        [self.delegate publisherOnClickedBackButton];
    }
}


- (void)previewButtonAction:(UIButton *)sender {
    
    [sender setSelected:!sender.selected];
    
    if (self.delegate) {
        [self.delegate publisherOnClickedPreviewButton:sender.selected button:sender];
    }
    
    self.pushMirrorSwitch.enabled = sender.selected;
    self.previewMirrorSwitch.enabled = sender.selected;
}


- (void)pushButtonAction:(UIButton *)sender {
    
    [sender setSelected:!sender.selected];
    if (self.delegate) {
        BOOL ret = [self.delegate publisherOnClickedPushButton:sender.selected button:sender];
        if (ret) {
            [self.pauseButton setSelected:NO];
        }
    }
}


- (void)musicButtonAction:(UIButton *)sender {
    
    if (!self.musicSettingView) {
        [self setupMusicSettingView];
    }
    [self addSubview:self.musicSettingView];
    self.isMusicSettingShow = YES;
}


- (void)answerGameButtonAction:(UIButton *)sender {
    
    if (!self.answerGameView) {
        [self setupAnswerGameView];
    }
    [self addSubview:self.answerGameView];
    self.isAnswerGameViewShow = YES;
}


- (void)beautySettingButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(publisherOnClickBeautyButton)]) {
        [self.delegate publisherOnClickBeautyButton];
    }
}


- (UIViewController *)viewController{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


- (void)moreSettingButtonAction:(UIButton *)sender {
    
    if (!self.moreSettingView) {
        [self setupMoreSettingViews];
    }
    [self addSubview:self.moreSettingView];
    [AlivcLivePusher hideDebugView];
    self.isMoreSettingShow = YES;
}

- (void)switchButtonAction:(UIButton *)sender {
    
    if (self.delegate) {
        [self.delegate publisherOnClickedSwitchCameraButton];
    }
    
    [self.flashButton setEnabled:!self.flashButton.enabled];
}


- (void)flashButtonAction:(UIButton *)sender {
    
    [sender setSelected:!sender.selected];
    if (self.delegate) {
        [self.delegate publisherOnClickedFlashButton:sender.selected button:sender];
    }
}


- (void)pauseButtonAction:(UIButton *)sender {
    
    [sender setSelected:!sender.selected];
    if (self.delegate) {
        [self.delegate publisherOnClickedPauseButton:sender.selected button:sender];
    }
}


- (void)restartButtonAction:(UIButton *)sender {
    
    if (self.delegate) {
        [self.delegate publisherOnClickedRestartButton];
    }
}

- (void)beautyButtonAction:(UIButton *)sender {
    
    [sender setSelected:!sender.selected];
//    if (self.delegate) {
//        [self.delegate publisherOnClickedBeautyButton:sender.selected];
//    }
}


- (void)sharedButtonAction:(UIButton *)sender {
    
    if (self.delegate) {
        [self.delegate publisherOnClickSharedButon];
    }
}

- (int)addButtonAction:(UIButton *)sender {
    
    if (self.delegate) {
        
        NSString *resourceBundle = [[NSBundle mainBundle] pathForResource:@"AlivcLibDynamicWaterMark" ofType:@"bundle"];

        char filePath[188] = {0};
        const char *doc_path = 0;
        {
            NSString *docPath = [resourceBundle stringByAppendingFormat:@"/Resources"];
            doc_path = [docPath UTF8String];
            strncpy((char*)filePath, doc_path, 187);
        }

        NSString * bundleAddOnPath = [NSString stringWithUTF8String:filePath];
        
        int count = [dynamicWatermarkArr count];
        
        int index = [self.delegate publisherOnClickAddDynamically:bundleAddOnPath  x:0.3+count*0.1 y:0.3+count*0.1 w:0.5 h:0.5];
        
        NSNumber *num = [NSNumber numberWithInt:index];
        [dynamicWatermarkArr addObject: num];
        return index;
        
    }
    return -1;
}

-(void)previewDisplayModeChange:(UISegmentedControl *)sender {
   
    if (self.delegate) {
        [self.delegate publisherOnSelectPreviewDisplayMode:sender.selectedSegmentIndex];
    }
  
}

- (void)removeButtonAction:(UIButton *)sender {
    
    if (self.delegate) {
    
        int count = [dynamicWatermarkArr count];
        
        if(count > 0) {
            NSNumber *num = [dynamicWatermarkArr objectAtIndex:0];
            
            int index = [num intValue];
            
            [dynamicWatermarkArr removeObjectAtIndex:0];
            
            [self.delegate publisherOnClickRemoveDynamically:index];
        }
       
    }
}

- (void)autoFocusSwitchAction:(UISwitch *)sender {
    
    if (self.delegate) {
        [self.delegate publisherOnClickAutoFocusButton:sender.on];
    }
}

- (void)pushMirrorSwitchAction:(UISwitch *)sender {
    
    if (self.delegate) {
        [self.delegate publisherOnClickPushMirrorButton:sender.on];
    }
}

- (void)previewMirrorSwitchAction:(UISwitch *)sender {
    
    if (self.delegate) {
        [self.delegate publisherOnClickPreviewMirrorButton:sender.on];
    }
}


#pragma mark - Gesture

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([[touch.view class] isEqual:[self class]]) {
        return YES;
    }
    return  NO;
}


- (void)tapGesture:(UITapGestureRecognizer *)gesture{

    if (self.isBeautySettingShow) {
        
        [self.beautySettingView removeFromSuperview];
        self.isBeautySettingShow = NO;
    } else if (self.isKeyboardEdit) {
        
        [self endEditing:YES];
    } else if (self.isMoreSettingShow) {
        
        [self.moreSettingView removeFromSuperview];
        self.isMoreSettingShow = NO;
//        [AlivcLivePusher showDebugView];
    } else if (self.isMusicSettingShow) {
        
        [self.musicSettingView removeFromSuperview];
        self.isMusicSettingShow = NO;
    } else if (self.isAnswerGameViewShow) {
        
        [self.answerGameView removeFromSuperview];
        self.isAnswerGameViewShow = NO;
    } else {
        
        CGPoint point = [gesture locationInView:self];
        CGPoint percentPoint = CGPointZero;
        percentPoint.x = point.x / CGRectGetWidth(self.bounds);
        percentPoint.y = point.y / CGRectGetHeight(self.bounds);
//        NSLog(@"聚焦点  - x:%f y:%f", percentPoint.x, percentPoint.y);
        if (self.delegate) {
            [self.delegate publisherOnClickedFocus:percentPoint];
        }
    }
    
}

static CGFloat lastPinchDistance = 0;
- (void)pinchGesture:(UIPinchGestureRecognizer *)gesture {
    
    if (gesture.numberOfTouches != 2) {
        return;
    }
    CGPoint p1 = [gesture locationOfTouch:0 inView:self];
    CGPoint p2 = [gesture locationOfTouch:1 inView:self];
    CGFloat dx = (p2.x - p1.x);
    CGFloat dy = (p2.y - p1.y);
    CGFloat dist = sqrt(dx*dx + dy*dy);
    if (gesture.state == UIGestureRecognizerStateBegan) {
        lastPinchDistance = dist;
    }
    
    CGFloat change = dist - lastPinchDistance;

    NSLog(@"zoom - %f", change);

    if (self.delegate) {
        [self.delegate publisherOnClickedZoom:change/3000];
    }
}


- (void)leftSwipe:(UISwipeGestureRecognizer *)swipe {
    
    if (self.guideView) {
        [self.guideView removeFromSuperview];
        self.guideView = nil;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:AlivcUserDefaultsIndentifierFirst];
    }
    
    if (self.currentIndex == 0) {
        if (self.delegate) {
            [self.delegate publisherOnClickedShowDebugTextInfo:NO];
            [self animationWithView:self.debugTextView x:-self.bounds.size.width];
        }
        self.currentIndex++;
        return;
    }
    
    if (self.currentIndex == 1) {
        if (self.delegate) {
            [self.delegate publisherOnClickedShowDebugChartInfo:YES];
            [self animationWithView:self.debugChartView x:0];
        }
        self.currentIndex++;
        return;
    }
    
    if (self.currentIndex == 2) {
        // 无效
        return;
    }
}


- (void)rightSwipe:(UISwipeGestureRecognizer *)swipe {
    
    if (self.guideView) {
        [self.guideView removeFromSuperview];
        self.guideView = nil;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:AlivcUserDefaultsIndentifierFirst];
    }
    
    if (self.currentIndex == 0) {
        // 无效
        return;
    }
    
    if (self.currentIndex == 1) {
        if (self.delegate) {
            [self.delegate publisherOnClickedShowDebugTextInfo:YES];
            [self animationWithView:self.debugTextView x:0];
        }
        self.currentIndex--;
        return;
    }
    
    if (self.currentIndex == 2) {
        if (self.delegate) {
            [self.delegate publisherOnClickedShowDebugChartInfo:NO];
            [self animationWithView:self.debugChartView x:self.bounds.size.width];
        }
        self.currentIndex--;
        return;
    }

}


#pragma mark - Slider Actions
//
//- (void)buffingValueChange:(UISlider *)slider {
//
//    if (self.delegate) {
//        [self.delegate publisherSliderBeautyBuffingValueChanged:(int)slider.value];
//    }
//}
//
//- (void)whiteValueChange:(UISlider *)slider {
//
//    if (self.delegate) {
//        [self.delegate publisherSliderBeautyWhiteValueChanged:(int)slider.value];
//    }
//}
//
//
//
//- (void)ruddyValueChange:(UISlider *)slider {
//
//    if (self.delegate) {
//        [self.delegate publisherSliderBeautyRubbyValueChanged:(int)slider.value];
//    }
//}
//
//- (void)cheekPinkValueChange:(UISlider *)slider {
//
//    if (self.delegate) {
//        [self.delegate publisherSliderBeautyCheekPinkValueChanged:(int)slider.value];
//    }
//}
//
//- (void)thinfaceValueChange:(UISlider *)slider {
//
//    if (self.delegate) {
//        [self.delegate publisherSliderBeautyThinFaceValueChanged:(int)slider.value];
//    }
//}
//
//- (void)shortenfaceValueChange:(UISlider *)slider {
//
//    if (self.delegate) {
//        [self.delegate publisherSliderBeautyShortenFaceValueChanged:(int)slider.value];
//    }
//}
//
//- (void)bigeyeValueChange:(UISlider *)slider {
//
//    if (self.delegate) {
//        [self.delegate publisherSliderBeautyBigEyeValueChanged:(int)slider.value];
//    }
//}

#pragma mark - Animation

- (void)animationWithView:(UIView *)view x:(CGFloat)x {
    
    [UIView animateWithDuration:0.5 animations:^{
       
        CGRect frame = view.frame;
        frame.origin.x = x;
        view.frame = frame;
    }];
    
}


#pragma mark - TextField Actions

- (void)maxBitrateTextFieldValueChanged:(UITextField *)sender {
    
    if (!sender.text.length) {
        sender.text = sender.placeholder;
    }
    
    if (self.delegate) {
        [self.delegate publisherOnBitrateChangedTargetBitrate:[sender.text intValue]];
    }
}

- (void)minBitrateTextFieldValueChanged:(UITextField *)sender {
    
    if (!sender.text.length) {
        sender.text = sender.placeholder;
    }

    if (self.delegate) {
        [self.delegate publisherOnBitrateChangedMinBitrate:[sender.text intValue]];
    }
}


#pragma mark - Public

- (void)updateInfoText:(NSString *)text {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.infoLabel setHidden:NO];
        self.infoLabel.text = text;
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(hiddenInfoLabel) withObject:nil afterDelay:2.0];

    });
}

- (void)hiddenInfoLabel {
    
    [self.infoLabel setHidden:YES];
}


- (void)updateDebugChartData:(AlivcLivePushStatsInfo *)info {
    
    [self.debugChartView updateData:info];
}

- (void)updateDebugTextData:(AlivcLivePushStatsInfo *)info {
    
    [self.debugTextView updateData:info];
}


- (void)hiddenVideoViews {
    
    self.beautySettingButton.hidden = YES;
    self.flashButton.hidden = YES;
    self.switchButton.hidden = YES;
    self.moreSettingButton.hidden = YES;
}

- (void)updateMusicDuration:(long)currentTime totalTime:(long)totalTime {
    
    [self.musicSettingView updateMusicDuration:currentTime totalTime:totalTime];
}

- (void)resetMusicButtonTypeWithPlayError {
    
    [self.musicSettingView resetButtonTypeWithPlayError];
}


- (BOOL)getPushButtonType {
    
    return self.pushButton.selected;
}

#pragma mark - Notification

- (void)addNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidEnterBackGround:) name:UIApplicationDidEnterBackgroundNotification object:nil];

}

- (void)keyboardWillShow:(NSNotification *)sender {
    
    if(self.isKeyboardEdit){
        return;
    }
    self.isKeyboardEdit = YES;
    CGRect keyboardFrame = [sender.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:0.2f animations:^{
        CGRect frame = self.moreSettingView.frame;
        frame.origin.y = frame.origin.y - keyboardFrame.size.height;
        self.moreSettingView.frame = frame;
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)sender {
    self.isKeyboardEdit = NO;
    [UIView animateWithDuration:0.2f animations:^{
        CGRect frame = self.moreSettingView.frame;
        frame.origin.y = self.bounds.size.height - frame.size.height;
        self.moreSettingView.frame = frame;
    }];
}

- (void)onAppDidEnterBackGround:(NSNotification *)notification
{
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        
    }];

}


@end
