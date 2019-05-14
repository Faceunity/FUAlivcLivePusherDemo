//
//  _AlivcLiveBeautifyLevelView.h
//  BeautifySettingsPanel
//
//  Created by 汪潇翔 on 2018/5/29.
//  Copyright © 2018 汪潇翔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlivcBeautySettingUIDefine.h"

@class _AlivcLiveBeautifyNavigationView,_AlivcLiveBeautifyLevelView;

@protocol _AlivcLiveBeautifyLevelViewDelegate <NSObject>
@required
- (void)levelView:(_AlivcLiveBeautifyLevelView *)levelView didChangeLevel:(NSInteger)level;
@optional
- (void)levelView:(_AlivcLiveBeautifyLevelView *)levelView didChangeUIStyle:(AlivcBeautySettingViewStyle)style;
@end

@interface _AlivcLiveBeautifyLevelView : UIView

@property (nonatomic, readonly) _AlivcLiveBeautifyNavigationView *navigationView;

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, weak) id<_AlivcLiveBeautifyLevelViewDelegate> delegate;
@property (nonatomic, weak) UIButton *titleButton;

- (void)setUIStyle:(AlivcBeautySettingViewStyle)uiStyle;

- (AlivcBeautySettingViewStyle)currentUIStyle;

@end
