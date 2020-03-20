//
//  _AlivcLiveBeautifyNavigationView.m
//  BeautifySettingsPanel
//
//  Created by 汪潇翔 on 2018/5/29.
//  Copyright © 2018 汪潇翔. All rights reserved.
//

#import "_AlivcLiveBeautifyNavigationView.h"

static const CGFloat AlivcLiveViewInterval = 8.f;

@implementation _AlivcLiveBeautifyNavigationView {
    UIButton *_leftButton;
    UIImage *_leftImage;
    NSString *_leftTitle;
    UIImage *_rightImage;
    UIView *_titleView;
    
    void(^_leftAction)(_AlivcLiveBeautifyNavigationView *sender);
    void(^_rightAction)(_AlivcLiveBeautifyNavigationView *sender);
}


- (instancetype)initWithTitleView:(UIView *)titleView {
    self = [super initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 44.f)];
    if (self) {
        if (titleView) {
            _titleView = titleView;
            [self addSubview:titleView];
        }
    }
    return self;
}

+ (instancetype)navigationViewTitleView:(UIView *)titleView {
    return [[[self class] alloc] initWithTitleView:titleView];
}

- (void)setLeftImage:(UIImage *)leftImage title:(NSString *)title action:(void(^)(_AlivcLiveBeautifyNavigationView *sender))action {
    if (!leftImage || !action) {
        NSAssert(NO, @"leftImage or action must be not nil");
    }
    _leftAction = [action copy];
    _leftImage = leftImage;
    _leftButton = [[self class] _aliButtonWithIcon:leftImage title:title];
    [_leftButton sizeToFit];
    [self addSubview:_leftButton];
    [_leftButton addTarget:self action:@selector(_leftButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self setNeedsLayout];
}

- (void)setLeftImage:(UIImage *)leftImage action:(void(^)(_AlivcLiveBeautifyNavigationView *sender))action {
    [self setLeftImage:leftImage title:nil action:action];
}

- (void)setRightImage:(UIImage *)rightImage action:(void(^)(_AlivcLiveBeautifyNavigationView *sender))action {
    if (!rightImage || !action) {
        NSAssert(NO, @"rightImage or action must be not nil");
    }
    _rightAction = [action copy];
    _rightImage = rightImage;
    _rightButton = [[self class] _aliButtonWithIcon:rightImage];
    [self addSubview:_rightButton];
    [_rightButton addTarget:self action:@selector(_rightButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self setNeedsLayout];
}


- (void)layoutSubviews {
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat width = CGRectGetWidth(self.bounds);
    if (_leftButton) {
        CGRect frame = _leftButton.frame;
        frame.origin.x = AlivcLiveViewInterval;
        frame.origin.y = (height - CGRectGetHeight(frame)) * 0.5;
        _leftButton.frame = frame;
    }
    
    if (_rightButton) {
        //相对于父视图布局
        CGFloat superWidth = CGRectGetWidth(_rightButton.superview.bounds);
//        CGFloat superHeight = CGRectGetHeight(_rightButton.superview.bounds);
        CGRect frame = _rightButton.frame;
        frame.origin.x = superWidth - CGRectGetWidth(frame) - 4;
        frame.origin.y = 2;
        _rightButton.frame = frame;
    }
    
    if (_titleView) {
        CGRect frame = _titleView.frame;
        frame.origin.x = (width - CGRectGetWidth(frame)) * 0.5;
        frame.origin.y = (height - CGRectGetHeight(frame)) * 0.5;
        _titleView.frame = frame;
    }
}

#pragma mark - Action
- (void)_leftButtonOnClick:(UIButton *)sender {
    if (_leftAction) {
        _leftAction(self);
    }
}

- (void)_rightButtonOnClick:(UIButton *)sender {
    if (_rightAction) {
        _rightAction(self);
    }
}

#pragma mark - Private Helper
+ (UIButton *)_aliButtonWithIcon:(UIImage *)icon title:(NSString *)title {
    UIButton *button =
    [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 44, 100);
    [button setImage:icon forState:UIControlStateNormal];
    [button setTitle:title  forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10 )];
    button.tintColor = [UIColor whiteColor];
    return button;
    
}
+ (UIButton *)_aliButtonWithIcon:(UIImage *)icon {
    UIButton *button =
        [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setImage:icon forState:UIControlStateNormal];
    button.tintColor = [UIColor whiteColor];
    return button;
}




@end
