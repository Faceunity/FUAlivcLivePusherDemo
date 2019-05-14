//
//  AlivcAlertView.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/6/29.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcAlertView.h"
#import "AlivcUIConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlivcAlertView()

@property(strong, nonatomic) UIView *contentView;

//title
@property(strong, nonatomic) UIView *titleView;

@property(strong, nonatomic) UILabel *titleLabel;

//message
@property(strong, nonatomic) UIView *messageView;

@property(strong, nonatomic) UIImageView *showImageView;

@property(strong, nonatomic) UILabel *messageLabel;

//buttom
@property(strong, nonatomic) UIView *bottomView;

@property(strong, nonatomic) UIButton *confirmButton;

@property(strong, nonatomic) UIButton *cancelButton;

//store property
@property(strong, nonatomic, nullable) NSString *titleString;
@property(strong, nonatomic, nullable) NSString *messageString;
@property(strong, nonatomic, nullable) NSString *cancelString;
@property(strong, nonatomic) NSString *confirmString;
@property(strong, nonatomic, nullable) UIImage *showImage;

//size
@property(assign, nonatomic) CGFloat conWidth; //内容视图的宽度
@property(assign, nonatomic) CGFloat conHeight; //内容视图的高度
@property(assign, nonatomic) CGFloat titleConHeight; //标题的高度
@property(assign, nonatomic) CGFloat buttonHeight; //底部按钮的高度

@end



@implementation AlivcAlertView

#pragma mark - getter
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [AlivcUIConfig shared].kAVCBackgroundColor;
    }
    return _contentView;
}

- (UIView *)titleView{
    if (!_titleView) {
        _titleView = [[UIView alloc]init];
    }
    return _titleView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UIView *)messageView{
    if (!_messageView) {
        _messageView = [[UIView alloc]init];
    }
    return _messageView;
}

- (UIImageView *)showImageView{
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc]init];
    }
    return _showImageView;
}

- (UILabel *)messageLabel{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc]init];
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.numberOfLines = 10;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLabel;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
    }
    return _bottomView;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc]init];
        [_cancelButton setTitleColor:[AlivcUIConfig shared].kAVCThemeColor forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[AlivcUIConfig shared].kAVCThemeColor forState:UIControlStateSelected];
        [_cancelButton addTarget:self action:@selector(cancelButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton{
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc]init];
        [_confirmButton setTitleColor:[AlivcUIConfig shared].kAVCThemeColor forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[AlivcUIConfig shared].kAVCThemeColor forState:UIControlStateSelected];
        [_confirmButton addTarget:self action:@selector(confirmButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (instancetype)initWithAlivcTitle:(NSString *__nullable)title message:(NSString *__nullable)message delegate:(id)delegate cancelButtonTitle:(NSString *__nullable)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle{
    self = [super init];
    if (self) {
        self.titleString = title;
        self.messageString = message;
        self.cancelString = cancelButtonTitle;
        self.confirmString = confirmButtonTitle;
        self.showImage = [UIImage imageNamed:@"avcPromptWarning"];
        self.delegate = delegate;
        
        self.conWidth = 266;
        self.conHeight = 168;
        self.titleConHeight = 36;
        self.buttonHeight = 50;
        if (self.titleString) {
            self.conHeight = self.conHeight + self.titleConHeight;//让ui更好看
        }
        [self configBaseUI];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    CGFloat offsety = 0;
    if (ScreenWidth < ScreenHeight) {
        offsety = 66;
    }
    self.contentView.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2 - offsety);
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [self layoutSubviews];
}


#pragma mark - Public Method
- (void)setShowImage:(UIImage *__nullable)image{
    _showImage = image;
    [self.showImageView setImage:image];
    [self configBaseUI];
}

- (void)show{
    UIWindow *win = [UIApplication sharedApplication].windows.firstObject;
    if (win) {
        [win addSubview:self];
    }
}

- (void)setContemtSize:(CGSize)size{
    self.conWidth = size.width;
    self.conHeight = size.height;
    [self configBaseUI];
}

- (void)showInView:(UIView *)view{
    [view addSubview:self];
}
#pragma mark - UIConfig

- (void)configBaseUI{
    
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    
    [self addSubview:self.contentView];
    self.contentView.frame = CGRectMake(0, 0, self.conWidth, self.conHeight);
    self.contentView.layer.cornerRadius = 10;
    self.contentView.clipsToBounds = true;
    
    CGFloat messageOY = 0;
    
    //title
    if (self.titleString) {
        
        [self.contentView addSubview:self.titleView];
        self.titleView.frame = CGRectMake(0, 0, self.conWidth, self.titleConHeight);
        messageOY = self.titleView.frame.size.height;
        
        [self.titleView addSubview:self.titleLabel];
        self.titleLabel.text = self.titleString;
        [self.titleLabel sizeToFit];
        self.titleLabel.center = CGPointMake(self.conWidth / 2, self.titleConHeight / 2);
        
//        UIView *deviceView = [self deviceView];
//        deviceView.alpha = 0.5;
//        deviceView.frame = CGRectMake(16, self.titleView.frame.size.height - 1, self.conWidth - 32, 1);
//        [self.titleView addSubview:deviceView];
    }
    
    //message
    [self.contentView addSubview:self.messageView];
    if (self.titleString) {
        self.messageView.frame = CGRectMake(0, messageOY, self.conWidth, self.conHeight - self.titleConHeight - self.buttonHeight);
    }else{
        self.messageView.frame = CGRectMake(0, messageOY, self.conWidth, self.conHeight - self.buttonHeight);
    }
    
    [self.messageView addSubview:self.showImageView];
    self.showImageView.image = self.showImage;
    [self.showImageView sizeToFit];
    self.showImageView.center = CGPointMake(self.conWidth / 2, 8 + self.showImageView.frame.size.height / 2);
    if (self.messageString) {
        [self.messageView addSubview:self.messageLabel];
        self.messageLabel.text = self.messageString;
        
        CGFloat mLabely = 8 + self.showImageView.frame.size.height + 8;
        self.messageLabel.frame = CGRectMake(8, mLabely, self.conWidth - 8 * 2, self.messageView.frame.size.height - 8 - mLabely);
    }
    
    //bottom
    [self.contentView  addSubview:self.bottomView];
    self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.messageView.frame), self.conWidth, self.buttonHeight);
    [self.bottomView addSubview:[self deviceView]];
    if (self.cancelString) {
        [self.bottomView addSubview:self.cancelButton];
        self.cancelButton.frame = CGRectMake(0, 0, self.conWidth / 2, self.bottomView.frame.size.height);
        [self.cancelButton setTitle:self.cancelString forState:UIControlStateNormal];
        
        
        UIView *deviceMidView = [[UIView alloc]initWithFrame:CGRectMake(self.conWidth / 2, 0, 1, self.bottomView.frame.size.height)];
        deviceMidView.backgroundColor = [UIColor grayColor];
        deviceMidView.alpha = 0.6;
        [self.bottomView addSubview:deviceMidView];
        
        [self.bottomView addSubview:self.confirmButton];
        self.confirmButton.frame = CGRectMake(self.conWidth / 2, 0, self.conWidth / 2, self.bottomView.frame.size.height);
    }else{
        [self.bottomView addSubview:self.confirmButton];
        self.confirmButton.frame = CGRectMake(0, 0, self.bottomView.frame.size.width, self.bottomView.frame.size.height);
    }
    
    [self.confirmButton setTitle:self.confirmString forState:UIControlStateNormal];
    
}

- (UIView *)deviceView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.conWidth, 1)];
    view.backgroundColor = [UIColor grayColor];
    return view;
}

#pragma mark - Responce
- (void)cancelButtonTouched{
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [self.delegate alertView:self clickedButtonAtIndex:0];
    }
}
- (void)confirmButtonTouched{
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        NSInteger index = 1;
        if (!self.cancelString) {
            index = 0;
        }
        [self.delegate alertView:self clickedButtonAtIndex:index];
    }
}

@end

NS_ASSUME_NONNULL_END
