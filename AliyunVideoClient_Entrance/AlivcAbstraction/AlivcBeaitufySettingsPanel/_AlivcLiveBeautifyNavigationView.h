//
//  _AlivcLiveBeautifyNavigationView.h
//  BeautifySettingsPanel
//
//  Created by 汪潇翔 on 2018/5/29.
//  Copyright © 2018 汪潇翔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface _AlivcLiveBeautifyNavigationView : UIView

+ (instancetype)navigationViewTitleView:(UIView *)titleView;

- (void)setLeftImage:(UIImage *)leftImage action:(void(^)(_AlivcLiveBeautifyNavigationView *sender))action;

- (void)setLeftImage:(UIImage *)leftImage title:(NSString *)title action:(void(^)(_AlivcLiveBeautifyNavigationView *sender))action;

- (void)setRightImage:(UIImage *)rightImage action:(void(^)(_AlivcLiveBeautifyNavigationView *sender))action;

@property (strong, nonatomic) UIButton *rightButton;

@end
