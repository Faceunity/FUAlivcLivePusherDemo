//
//  AlivcLiveBeautifySettingsViewController.m
//  AliyunVideoClient_Entrance
//
//  Created by 汪潇翔 on 2018/5/29.
//  Copyright © 2018 Alibaba. All rights reserved.
//

#import "AlivcLiveBeautifySettingsViewController.h"
#import "AlivcLiveTransitionController.h"


@interface AlivcLiveBeautifySettingsViewController ()
<AlivcLiveBeautifySettingsViewDelegate,
AlivcLiveBeautifySettingsViewDataSource>

@property (nonatomic, strong) AlivcLiveTransitionController *transitionController;

@property (nonatomic, strong) AlivcLiveBeautifySettingsView *view;

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, strong) NSArray<NSDictionary *> *detailItems;


@end



@implementation AlivcLiveBeautifySettingsViewController
@dynamic view;

+ (instancetype)settingsViewControllerWithLevel:(NSInteger)level detailItems:(NSArray<NSDictionary *> *)detailItems {
    AlivcLiveBeautifySettingsViewController *vc =
        [[AlivcLiveBeautifySettingsViewController alloc] initWithLevel:level detailItems:detailItems];
    return vc;
}


- (instancetype)initWithLevel:(NSInteger)level detailItems:(NSArray *)detailItems {
    if (self = [self init]) {
        self.level = level;
        self.detailItems = detailItems;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _transitionController =  [[AlivcLiveTransitionController alloc] init];
        super.transitioningDelegate = _transitionController;
        super.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)updateDetailItems:(NSArray<NSDictionary *> *)detailItems{
    if (detailItems) {
        self.detailItems = detailItems;
    }
}

- (void)updateLevel:(NSInteger)level{
    self.view.level = level;
}

- (void)setDetailItems:(NSArray<NSDictionary *> *)detailItems{
    _detailItems = detailItems;
    NSMutableArray<NSMutableDictionary *> *items = [[NSMutableArray alloc] init];
    [detailItems enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [items addObject:[obj mutableCopy]];
    }];
    self.view.detailItems = [items copy];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.dispearCompletion) {
        self.dispearCompletion();
    }
}

- (void)setUIStyle:(AlivcBeautySettingViewStyle)uiStyle{
    //短视频顶部标题隐藏，微调按钮下移
    [self.view setUIStyle:uiStyle];
}

- (AlivcBeautySettingViewStyle )currentStyle{
    return self.view.currentUIStyle;
}

- (void)setAction:(void (^)(void))action withTag:(NSInteger)tag{
    [self.view setAction:action withTag:tag];
}


/* Disable setter. Always use internal transition controller */
- (void)setTransitioningDelegate:
(__unused id<UIViewControllerTransitioningDelegate>)transitioningDelegate {
    NSAssert(NO, @"AlivcLiveBeautifySettingsPanelViewController.transitioningDelegate cannot be changed.");
    return;
}

/* Disable setter. Always use custom presentation style */
- (void)setModalPresentationStyle:(__unused UIModalPresentationStyle)modalPresentationStyle {
    NSAssert(NO, @"AlivcLiveBeautifySettingsPanelViewController.modalPresentationStyle cannot be changed.");
    return;
}

- (void)loadView {
    AlivcLiveBeautifySettingsView *view =
        [[AlivcLiveBeautifySettingsView alloc] initWithFrame:CGRectZero];
    view.level = _level;
    view.delegate = self;
    view.dataSource = self;
    self.view  = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    self.preferredContentSize = CGSizeMake(CGRectGetWidth(self.view.superview.bounds), 273.f);
    NSLog(@"preferredContentSize : %@", NSStringFromCGSize(self.preferredContentSize));
}

- (void)settingsView:(AlivcLiveBeautifySettingsView *)settingsView didChangeLevel:(NSInteger)level {
    if (self.delegate && [self.delegate respondsToSelector:@selector(settingsViewController:didChangeLevel:)]) {
        [self.delegate settingsViewController:self didChangeLevel:level];
    }
}

- (void)settingsView:(AlivcLiveBeautifySettingsView *)settingsView didChangeValue:(NSDictionary *)info {
    if (self.delegate && [self.delegate respondsToSelector:@selector(settingsViewController:didChangeValue:)]) {
        [self.delegate settingsViewController:self didChangeValue:info];
    }
}

- (void)settingsView:(AlivcLiveBeautifySettingsView *)settingsView didChangeUIStyle:(AlivcBeautySettingViewStyle)style{
    if (self.delegate && [self.delegate respondsToSelector:@selector(settingsViewController:didChangeUIStyle:)]) {
        [self.delegate settingsViewController:self didChangeUIStyle:style];
    }
}

- (NSArray<NSDictionary *> *)detailItemsOfSettingsView:(AlivcLiveBeautifySettingsView *)settingsView {
    return self.detailItems;
}
#pragma mark - 转屏
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
@end
