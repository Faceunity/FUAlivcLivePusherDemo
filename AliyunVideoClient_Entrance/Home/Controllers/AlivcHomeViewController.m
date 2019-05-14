//
//  AVC_ET_HomeViewController.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/3/22.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcHomeViewController.h"

#import "AVC_ET_ModuleItemCCell.h"
#import "AVC_ET_ModuleDefine.h"
#import "AlivcUserInfoViewController.h"
#import "ELCVFlowLayout.h"
#import "AlivcDefine.h"

//helper
#import "UIImage+AlivcHelper.h"
#import "MBProgressHUD+AlivcHelper.h"



NS_ASSUME_NONNULL_BEGIN

static CGFloat deviceInCollectionView = 12; //两个item之间的距离
static CGFloat besise = 16; //collectionView的边距
static CGFloat lableDevideToTop = 44; //阿里云视频label距离顶部的距离


@interface AlivcHomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>


/**
 模块描述字符串集合
 */
@property (strong, nonatomic) NSArray <AVC_ET_ModuleDefine *>*dataArray;


/**
 阿里云视频的label
 */
@property (strong, nonatomic) UILabel *aliLabel;

/**
 欢迎label
 */
@property (strong, nonatomic) UILabel *welcomeLabel;

/**
 用户设置按钮
 */
@property (strong, nonatomic) UIButton *userSettingButton;

/**
 展示列表
 */
@property (strong, nonatomic) UICollectionView *collectionView;

/**
 列表的页数
 */
@property (strong, nonatomic, nullable) UIPageControl *pageController;

@property (assign, nonatomic) BOOL isClipConfig;


/**
 环境
 */
@property (strong, nonatomic) UIButton *envButton;
@property (nonatomic, assign) int envMode;
/**
 环境
 */
@property (nonatomic, assign) BOOL isChangedRow;


@end

@implementation AlivcHomeViewController


#pragma mark - System

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.isChangedRow = NO;
    
    [self configBaseData];
    [self configBaseUI];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //导航栏设置
    self.navigationController.navigationBar.hidden = true;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = false;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 旋转
- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

#pragma mark - Lazy init
- (UILabel *)aliLabel{
    if (!_aliLabel) {
        _aliLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        _aliLabel.font = [UIFont systemFontOfSize:26];
        _aliLabel.textColor = [UIColor whiteColor];
        _aliLabel.text = [@"alivc_yun_video" localString];
        [_aliLabel sizeToFit];
        CGFloat heightAliLabel = CGRectGetHeight(_aliLabel.frame);
        CGFloat widthAlilabel = CGRectGetWidth(_aliLabel.frame);
        _aliLabel.center = CGPointMake(besise + widthAlilabel / 2,lableDevideToTop + heightAliLabel / 2);
    }
    return _aliLabel;
}

- (UILabel *)welcomeLabel{
    if (!_welcomeLabel) {
        _welcomeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        _welcomeLabel.font = [UIFont systemFontOfSize:14];
        _welcomeLabel.textColor = [UIColor whiteColor];
        _welcomeLabel.text = [@"WELCOME TO START THE VIDEO JOURNEY" localString];
        [_welcomeLabel sizeToFit];
        CGFloat heightWLabel = CGRectGetHeight(_welcomeLabel.frame);
        CGFloat widthWLabel = CGRectGetWidth(_welcomeLabel.frame);
        _welcomeLabel.center = CGPointMake(besise + widthWLabel / 2, lableDevideToTop + self.aliLabel.frame.size.height + 16 + heightWLabel / 2);
    }
    return _welcomeLabel;
}

- (UIButton *)userSettingButton{
    if (!_userSettingButton) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(PortraitScreenWidth - 66, lableDevideToTop, 36, 46)];
        [button setBackgroundImage:nil forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"avcUserIcon"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"avcUserIcon"] forState:UIControlStateSelected];
        [button sizeToFit];
        [button addTarget:self action:@selector(userSetting) forControlEvents:UIControlEventTouchUpInside];
        button.center = CGPointMake(PortraitScreenWidth - besise - button.frame.size.width / 2, lableDevideToTop + button.frame.size.height / 2);
        _userSettingButton = button;
    }
    return _userSettingButton;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        CGFloat cWidth = PortraitScreenWidth - 2 * besise;
        CGFloat cItemWidth = (cWidth - deviceInCollectionView) / 2;
        CGFloat cItemHeight = 120;
        CGFloat cHeight = cItemHeight * 3 + deviceInCollectionView * 2;
        CGFloat cDevideToTop = ((ScreenHeight-CGRectGetMaxY(_welcomeLabel.frame)-30)-cHeight)/2.0+CGRectGetMaxY(_welcomeLabel.frame);
        CGRect cFrame = CGRectMake(besise, cDevideToTop, cWidth, cHeight);
        ELCVFlowLayout *layout = [[ELCVFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(cItemWidth, cItemHeight);
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        UICollectionView *cView = [[UICollectionView alloc]initWithFrame:cFrame collectionViewLayout:layout];
        [cView registerNib:[UINib nibWithNibName:@"AVC_ET_ModuleItemCCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"AVC_ET_ModuleItemCCell"];
        cView.dataSource = self;
        cView.delegate = self;
        cView.pagingEnabled = true;
        cView.scrollEnabled = YES;
        cView.backgroundColor = [UIColor clearColor];
        cView.showsVerticalScrollIndicator = false;
        cView.showsHorizontalScrollIndicator = false;
        _collectionView = cView;
    }
    return _collectionView;
}

- (UIPageControl *__nullable)pageController{
    if (!_pageController && self.dataArray.count > 6) {
        _pageController = [[UIPageControl alloc]init];
        NSInteger shang = self.dataArray.count / 6;
        NSInteger yushu = self.dataArray.count % 6;
        if (yushu) {
            shang += 1;
        }
        _pageController.numberOfPages = shang;
        CGFloat cx = PortraitScreenWidth / 2;
        CGFloat cy = PortraitScreenHeight - 20;
        _pageController.center = CGPointMake(cx, cy);
    }
    return _pageController;
}

- (UIButton *)envButton{
    if (!_envButton) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 50, lableDevideToTop+50, 60, 46)];
        button.titleLabel.font = [UIFont systemFontOfSize:10];
        [button setTitle:[@"note_city_Shanghai" localString] forState:UIControlStateNormal];
//        [button setTitle:[@"note_city_Shanghai" localString] forState:UIControlStateSelected];
//        button.selected = [AlivcDefine mode];
        _envMode = 0;
        [button sizeToFit];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        CGRect rect = button.frame;
        rect.size.width += 10;
        button.frame = rect;
        [button addTarget:self action:@selector(env) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.pageController.center.y > 0) {
            button.center = CGPointMake(ScreenWidth - besise - button.frame.size.width / 2,
                                        self.pageController.center.y);
        }else{
            button.center = CGPointMake(ScreenWidth - besise - button.frame.size.width / 2,
                                        ScreenHeight - button.bounds.size.height - 20);
        }
        
        _envButton = button;
    }
    return _envButton;
}
- (void)env{
    _envMode = _envMode+1;
    if (_envMode == 2) {
        _envMode = 0;
    }
    if (_envMode == 0) {
        [_envButton setTitle:[@"note_city_Shanghai" localString] forState:UIControlStateNormal];
    }else if (_envMode == 1){
        [_envButton setTitle:[@"note_city_Singapore" localString] forState:UIControlStateNormal];
    }
//    else if (_envMode == 2){
//        [_envButton setTitle:[@"note_city_PreRelease" localString] forState:UIControlStateNormal];
//    }else if (_envMode == 3){
//        [_envButton setTitle:[@"note_city_Daily" localString] forState:UIControlStateNormal];
//    }
//    _envButton.selected = !_envButton.selected;
//    if (_envButton.selected) {
        [AlivcDefine AlivcAppServerSetTestEnvMode:_envMode];
//    }else{
//        [AlivcDefine AlivcAppServerSetTestEnvMode:0];
//    }
}


#pragma mark - BaseSet
/**
 适配基本的数据
 */
- (void)configBaseData{
    
    NSMutableArray *mArray = [[NSMutableArray alloc]init];
    
    //功能配置:想要哪个功能请在使用|运算并接上对应的模块的值
    NSInteger shouldAddValue = 0b100000;    
//    NSArray *languages = [NSLocale preferredLanguages];
//    NSString *currentLanguage = [languages objectAtIndex:0];
//    if([currentLanguage containsString:@"en"]){
//        shouldAddValue = 0b00010000;
//    }
    
    for (int i = 0; i < 16; i ++) {
        NSInteger typeValue = 1 << i;
        BOOL shouldAdd = shouldAddValue & typeValue;
        if (shouldAdd) {
            AVC_ET_ModuleType type = (AVC_ET_ModuleType)typeValue;
            AVC_ET_ModuleDefine *module = [[AVC_ET_ModuleDefine alloc]initWithModuleType:type];
            [mArray addObject:module];
        }
    }
    self.dataArray = (NSArray *)mArray;
}

/**
 适配基本的UI
 */
- (void)configBaseUI{
    
    // 背景图
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(60, 0, ScreenWidth-60, (ScreenWidth-60)*378/644.0)];
    bg.image = [UIImage imageNamed:@"bg_home"];
    [self.view addSubview:bg];
    
    //导航栏设置
    [self setBaseNavigationBar];
    
    //ali label
    [self.view addSubview:self.aliLabel];
    
    //welcome label
    [self.view addSubview:self.welcomeLabel];
    
    //user setting
    [self.view addSubview:self.userSettingButton];
    
    //env
    [self.view addSubview:self.envButton];
    
    //CollectionView
    [self.view addSubview:self.collectionView];
    
    //pageController
    if (self.pageController) {
        [self.view addSubview:self.pageController];
    }
}

/**
 导航栏设置，全局有效
 */
- (void)setBaseNavigationBar{
    //
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage avc_imageWithColor:[AlivcUIConfig shared].kAVCBackgroundColor] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

#pragma mark - Response

- (void)userSetting{
    AlivcUserInfoViewController *targetVC = [[AlivcUserInfoViewController alloc]init];
    [self.navigationController pushViewController:targetVC animated:true];
}


#pragma mark - Custom Method
- (void)pushTargetVCWithClassString:(NSString *)classString{
    Class viewControllerClass = NSClassFromString(classString);
    if (viewControllerClass) {
        UIViewController *targetVC = [[viewControllerClass alloc]init];
        if (targetVC) {
            [self.navigationController pushViewController:targetVC animated:true];
        }
    }
    
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return deviceInCollectionView;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return deviceInCollectionView;
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AVC_ET_ModuleItemCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AVC_ET_ModuleItemCCell" forIndexPath:indexPath];
    if (self.dataArray.count > indexPath.row) {
        AVC_ET_ModuleDefine *define = self.dataArray[indexPath.row];
        [cell configWithModule:define];
    }
    return cell;
}



#pragma mark - UICollectionViewDelegate

- (void)repeatDelay{
    self.isChangedRow = false;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isChangedRow == NO) {
        self.isChangedRow = YES;
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(repeatDelay) object:nil];
        [self performSelector:@selector(repeatDelay) withObject:nil afterDelay:0.5];
        
        if (indexPath.row < self.dataArray.count) {
            AVC_ET_ModuleDefine *module = self.dataArray[indexPath.row];
            switch (module.type) {
                    
                    
                    
                    
                    
                    // 直播推流
                case AVC_ET_ModuleType_PushFlow:[self pushTargetVCWithClassString:@"AlivcLivePushRootViewController"];break;
                    
                    
                    // 视频播放
                case AVC_ET_ModuleType_VideoPaly:[self pushTargetVCWithClassString:@"AVC_VP_VideoPlayViewController"];break;
                    
                default:
                    break;
            }
        }else{
            NSAssert(false, @"数组越界test");
        }
    }else{
        return;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    NSInteger currentPage = offset.x / scrollView.frame.size.width;
    if (currentPage < self.pageController.numberOfPages) {
        self.pageController.currentPage = currentPage;
    }
}

- (void)dealloc{
    if ([self respondsToSelector:@selector(repeatDelay)]) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(repeatDelay) object:nil];
    }
}

@end

NS_ASSUME_NONNULL_END
