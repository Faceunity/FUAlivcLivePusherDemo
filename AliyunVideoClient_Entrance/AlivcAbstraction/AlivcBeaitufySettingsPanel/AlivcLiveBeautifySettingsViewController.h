//
//  AlivcLiveBeautifySettingsViewController.h
//  AliyunVideoClient_Entrance
//
//  Created by 汪潇翔 on 2018/5/29.
//  Copyright © 2018 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlivcLiveBeautifySettingsView.h"

@class AlivcLiveBeautifySettingsViewController;

@protocol AlivcLiveBeautifySettingsViewControllerDelegate <NSObject>

@required

- (void)settingsViewController:(AlivcLiveBeautifySettingsViewController *)viewController didChangeLevel:(NSInteger)level;

- (void)settingsViewController:(AlivcLiveBeautifySettingsViewController *)viewController didChangeValue:(NSDictionary *)info;

@optional

- (void)settingsViewController:(AlivcLiveBeautifySettingsViewController *)viewController didChangeUIStyle:(AlivcBeautySettingViewStyle)uiStyle;
@end

@interface AlivcLiveBeautifySettingsViewController : UIViewController

+ (instancetype)settingsViewControllerWithLevel:(NSInteger)level detailItems:(NSArray<NSDictionary *> *)detailItems;

- (void)updateDetailItems:(NSArray<NSDictionary *> *)detailItems;

/**
 更新UI上的档位

 @param level 档位
 */
- (void)updateLevel:(NSInteger )level;

@property (nonatomic, weak) id<AlivcLiveBeautifySettingsViewControllerDelegate> delegate;
@property (nonatomic, copy) dispatch_block_t dispearCompletion;


#pragma mark - 短视频对于美颜界面的调整
/**
 短视频专用

 @param uiStyle 界面风格
 */
- (void)setUIStyle:(AlivcBeautySettingViewStyle)uiStyle;


/**
 当前的界面风格

 @return 界面风格
 */
- (AlivcBeautySettingViewStyle )currentStyle;

/**
 setUIStyle之后调用

 @param action 美颜视图导航栏左，中，右有3个透明按钮，用与响应事件，对应tag为0，1，2
 @param tag 0，1，2 =》 左，中，右
 */
- (void)setAction:(void (^)(void))action withTag:(NSInteger)tag;
@end
