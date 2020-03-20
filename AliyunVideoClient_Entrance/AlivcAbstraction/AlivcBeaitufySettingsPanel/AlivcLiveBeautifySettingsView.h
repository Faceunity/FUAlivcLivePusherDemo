//
//  AlivcLiveBeautifySettingsView.h
//  BeautifySettingsPanel
//
//  Created by 汪潇翔 on 2018/5/29.
//  Copyright © 2018 汪潇翔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlivcBeautySettingUIDefine.h"

@class AlivcLiveBeautifySettingsView;

@protocol AlivcLiveBeautifySettingsViewDataSource <NSObject>
@required
- (NSArray<NSDictionary *> *)detailItemsOfSettingsView:(AlivcLiveBeautifySettingsView *)settingsView;

@end

@protocol AlivcLiveBeautifySettingsViewDelegate <NSObject>
@required
- (void)settingsView:(AlivcLiveBeautifySettingsView *)settingsView didChangeLevel:(NSInteger)level;

- (void)settingsView:(AlivcLiveBeautifySettingsView *)settingsView didChangeValue:(NSDictionary *)info;
@optional
- (void)settingsView:(AlivcLiveBeautifySettingsView *)settingsView didChangeUIStyle:(AlivcBeautySettingViewStyle)style;
@end

@interface AlivcLiveBeautifySettingsView : UIView

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, weak) id<AlivcLiveBeautifySettingsViewDataSource> dataSource;

@property (nonatomic, weak) id<AlivcLiveBeautifySettingsViewDelegate> delegate;

@property (nonatomic, strong) NSArray<NSMutableDictionary *> *detailItems;

- (void)setUIStyle:(AlivcBeautySettingViewStyle)uiStyle;

- (AlivcBeautySettingViewStyle)currentUIStyle;

/**
 setUIStyle之后调用
 
 @param action 美颜视图导航栏左，中，右有3个透明按钮，用与响应事件，对应tag为0，1，2
 @param tag 0，1，2 =》 左，中，右
 */
- (void)setAction:(void (^)(void))action withTag:(NSInteger)tag;
@end
