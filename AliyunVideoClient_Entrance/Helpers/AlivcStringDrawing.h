//
//  AlivcStringDrawing.h
//  LTMToolbox
//
//  Created by user on 16/8/1.
//  Copyright © 2016年 Youku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlivcStringDrawing : NSObject


@end


@interface  NSParagraphStyle (AlivcStringDrawing)

+ (NSParagraphStyle *)alivc_paragraphStyleWithMode:(NSLineBreakMode)lineBreakMode;

@end

@interface NSString (AlivcStringDrawing)


/**
 计算字符串对应绘制大小
 [NSParagraphStyle defaultParagraphStyle];
 CGSizeMake(MAXFLOAT, MAXFLOAT);

 @param font 字体
 @return 大小
 */
- (CGSize)alivc_boundingSizeWithFont:(nullable UIFont *)font;

/**
 计算字符串对应绘制矩形
 [NSParagraphStyle defaultParagraphStyle];
 CGSizeMake(MAXFLOAT, MAXFLOAT);
 
 @param font 字体
 @return 矩形
 */
- (CGRect)alivc_boundingRectWithFont:(nullable UIFont *)font;

- (CGRect)alivc_boundingRectWithSize:(CGSize)size
                              font:(nullable UIFont *)font;

- (CGRect)alivc_boundingRectWithSize:(CGSize)size
                              font:(nullable UIFont *)font
                             style:(nullable NSParagraphStyle *)paragraphStyle;

- (CGRect)alivc_boundingRectWithSize:(CGSize)size
                              font:(nullable UIFont *)font
                             style:(nullable NSParagraphStyle *)paragraphStyle
                           context:(nullable NSStringDrawingContext *)context;

- (CGRect)alivc_boundingRectWithSize:(CGSize)size
                           options:(NSStringDrawingOptions)options
                              font:(nullable UIFont *)font
                             style:(nullable NSParagraphStyle *)paragraphStyle
                           context:(nullable NSStringDrawingContext *)context;

@end


@interface NSAttributedString (AlivcStringDrawing)

- (CGRect)alivc_boundingRectWithSize:(CGSize)size;
- (CGRect)alivc_boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options;
- (CGRect)alivc_boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options context:(nullable NSStringDrawingContext *)context;
@end


NS_ASSUME_NONNULL_END
