//
//  AlivcStringDrawing.m
//  LTMToolbox
//
//  Created by user on 16/8/1.
//  Copyright © 2016年 Youku. All rights reserved.
//

#import "AlivcStringDrawing.h"

@implementation AlivcStringDrawing

@end


@implementation NSParagraphStyle (AlivcStringDrawing)

+ (NSParagraphStyle *)alivc_paragraphStyleWithMode:(NSLineBreakMode)lineBreakMode {
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = lineBreakMode;
    return paragraphStyle;
}

@end

@implementation NSString (AlivcStringDrawing)

- (CGSize)alivc_boundingSizeWithFont:(nullable UIFont *)font {
    return [self alivc_boundingRectWithFont:font].size;
}

- (CGRect)alivc_boundingRectWithFont:(UIFont *)font {
    return [self alivc_boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) font:font style:nil context:nil];
}

- (CGRect)alivc_boundingRectWithSize:(CGSize)size font:(UIFont *)font {
    return [self alivc_boundingRectWithSize:size font:font style:nil context:nil];
}

- (CGRect)alivc_boundingRectWithSize:(CGSize)size font:(UIFont *)font style:(NSParagraphStyle *)paragraphStyle {
    return [self alivc_boundingRectWithSize:size font:font style:paragraphStyle context:nil];
}

- (CGRect)alivc_boundingRectWithSize:(CGSize)size font:(UIFont *)font style:(NSParagraphStyle *)paragraphStyle context:(NSStringDrawingContext *)context {
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    return [self alivc_boundingRectWithSize:size options:options font:font style:paragraphStyle context:context];
}

- (CGRect)alivc_boundingRectWithSize:(CGSize)size
                           options:(NSStringDrawingOptions)options
                              font:(UIFont *)font
                             style:(NSParagraphStyle *)paragraphStyle
                           context:(NSStringDrawingContext *)context {
#if DEBUG
    NSAssert(CGSizeEqualToSize(size, CGSizeZero) == NO, @"size must not be CGSizeZero,by 🚀");
    NSAssert(font != nil, @"font must not be nil, if font equal nil default Helvetica(Neue) 12,by 🚀");
#endif
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    if (font) {
        attributes[NSFontAttributeName] = font;
    }
    
    if (paragraphStyle && ![paragraphStyle isEqual:[NSParagraphStyle defaultParagraphStyle]]) {
        attributes[NSParagraphStyleAttributeName] = paragraphStyle;
    }
    CGRect boundingRect = [self boundingRectWithSize:size
                                             options:options
                                          attributes:attributes
                                             context:context];
    return boundingRect;
}

@end


@implementation NSAttributedString (AlivcStringDrawing)

- (CGRect)alivc_boundingRectWithSize:(CGSize)size {
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    return [self alivc_boundingRectWithSize:size options:options context:nil];
}

- (CGRect)alivc_boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options {
    return [self alivc_boundingRectWithSize:size options:options context:nil];
}

- (CGRect)alivc_boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options context:(nullable NSStringDrawingContext *)context {
    CGRect boundingRect = [self boundingRectWithSize:size options:options context:context];
    return boundingRect;
}

@end
