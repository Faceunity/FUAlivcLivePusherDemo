//
//  AlivcQRCodeView.m
//  AliyunVideoClient_Entrance
//
//  Created by 王凯 on 2018/6/14.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcQRCodeView.h"
#import <CoreImage/CoreImage.h>
#import "AlivcUIConfig.h"
@interface AlivcQRCodeView()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *qrImageView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *btn;

@end
@implementation AlivcQRCodeView

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = RGBToColor(55, 61, 65);
    }
    return _contentView;
}

- (UIImageView *)qrImageView{
    if (!_qrImageView) {
        _qrImageView = [[UIImageView alloc] init];
        _qrImageView.layer.masksToBounds = YES;
        _qrImageView.layer.cornerRadius = 5;
        _qrImageView.layer.borderWidth = 2;
        _qrImageView.layer.borderColor = [UIColor blackColor].CGColor;
    }
    return _qrImageView;
}

- (UILabel *)messageLabel{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.numberOfLines = 999;
        _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        UIFont* font = [UIFont systemFontOfSize:14];
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.font = font;
        _messageLabel.textAlignment = NSTextAlignmentLeft;
        _messageLabel.text = @"播放地址已拷贝到剪切板，请粘贴到播放器或扫描以上二维码观看直播";
    }
    return _messageLabel;
}

- (UIButton *)btn{
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn setTitle:@"确定" forState:UIControlStateNormal];
        [_btn setTitleColor:[AlivcUIConfig shared].kAVCThemeColor forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}

- (void)onClicked:(UIButton *)sender{
    NSLog(@"onClicked");
    [self removeFromSuperview];
}

- (instancetype)init{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame: frame]) {
        _qrCodeString = nil;
        
        [self addSubview:self.contentView];
        [_contentView addSubview:self.qrImageView];
        [_contentView addSubview:self.messageLabel];
        [_contentView addSubview:self.btn];
        
    }
    return self;
}

- (void)layoutSubviews{
    _contentView.frame = CGRectMake(0, 0, self.frame.size.width-20, self.frame.size.width-20+40);
    _contentView.center = self.center;
    
    _qrImageView.frame = CGRectMake(50, 30, CGRectGetWidth(_contentView.frame)-100, CGRectGetWidth(_contentView.frame)-100);
    
    _messageLabel.frame = CGRectMake(5, CGRectGetMaxY(_qrImageView.frame)+10, CGRectGetWidth(_contentView.frame)-10, 50);
    _btn.frame = CGRectMake(10, CGRectGetMaxY(_messageLabel.frame)+10, CGRectGetWidth(_contentView.frame)-20, 20);
}

- (void)setQrCodeString:(NSString *)qrCodeString{
    _qrCodeString = qrCodeString;
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [qrCodeString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    CIImage *image = [filter outputImage];
    self.qrImageView.image = [self createNonInterpolatedUIImageFormCIImage:image withSize:CGRectGetWidth(self.frame)-140];
    
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    pb.string = qrCodeString;
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
