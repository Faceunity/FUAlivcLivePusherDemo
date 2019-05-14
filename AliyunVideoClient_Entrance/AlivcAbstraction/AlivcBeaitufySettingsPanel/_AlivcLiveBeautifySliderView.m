//
//  _AlivcLiveBeautifySliderView.m
//  BeautifySettingsPanel
//
//  Created by 汪潇翔 on 2018/5/30.
//  Copyright © 2018 汪潇翔. All rights reserved.
//

#import "_AlivcLiveBeautifySliderView.h"

static CGFloat AlivcLiveArrowHeight =  6.f;
static CGFloat AlivcLiveArrowWidth = 6.f;
static CGFloat AlivcLiveArrowCornerRadius = 0.f;


@interface _AlivcLiveBeautifySlider : UISlider

@property (nonatomic, copy) void(^ aliViewDidLayout)(_AlivcLiveBeautifySlider *slider);

@property (nonatomic, assign) float originalValue;

@property (nonatomic, strong) UIImageView *originalValueImageView;

@end

@implementation _AlivcLiveBeautifySlider

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _originalValueImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        _originalValueImageView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setOriginalValue:(float)originalValue {
    if (_originalValue != originalValue) {
        _originalValue = originalValue;
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // setMinimumTrackImage
    if (self.subviews.count > 2) {
        UIView *trackView = self.subviews[1];
        if (trackView && !_originalValueImageView.superview) {
            [self insertSubview:_originalValueImageView aboveSubview:trackView];
        }

        CGPoint point = _originalValueImageView.center;
        point.y = trackView.center.y;
        
        UIView *thumbView = self.subviews.lastObject;
        CGFloat leftInset = CGRectGetMidX(thumbView.bounds);
        CGFloat width = CGRectGetWidth(self.bounds);
        point.x = leftInset + ((width - leftInset * 2) * (_originalValue / self.maximumValue));
        
        _originalValueImageView.center = point;
        
        _originalValueImageView.hidden = _originalValue <= self.minimumValue;
    }
    
    
    if (_aliViewDidLayout) {
        _aliViewDidLayout(self);
    }
}
@end



@interface _AlivcLiveBeautifySliderTooltip : UIView

@end

@implementation _AlivcLiveBeautifySliderTooltip {
    UILabel *_textLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.font = [UIFont systemFontOfSize:12.f];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.text = @"0";
        _textLabel.textColor = [UIColor whiteColor];
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)setText:(NSString *)text {
    _textLabel.text = text;
}

- (void)layoutSubviews {
    _textLabel.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - AlivcLiveArrowHeight);
}

- (void)drawRect:(CGRect)rect {
    
    rect = CGRectMake(0, 0, rect.size.width, rect.size.height - AlivcLiveArrowHeight);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    // 三角形箭头顶点的位置
    CGPoint arrowHead = CGPointMake(self.bounds.size.width / 2, rect.size.height + AlivcLiveArrowHeight);
    // 矩形的各个顶点
    CGPoint bottomLeftCorner = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGPoint topLeftCorner = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPoint topRightCorner = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGPoint buttomRightCorner = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    // 从箭头开始
    [path moveToPoint:CGPointMake(arrowHead.x + AlivcLiveArrowWidth / 2, arrowHead.y - AlivcLiveArrowHeight)];
    [path addLineToPoint:CGPointMake(arrowHead.x, arrowHead.y)];
    [path addLineToPoint:CGPointMake(arrowHead.x - AlivcLiveArrowWidth / 2, arrowHead.y - AlivcLiveArrowHeight)];
    // 画到左下角 圆弧开始的位置
    [path addLineToPoint:CGPointMake(bottomLeftCorner.x + AlivcLiveArrowCornerRadius,bottomLeftCorner.y)];
    // 画弧线
    // iOS中坐标系y轴的正方向是向下的，下面的startAngle和endAngle要注意
    [path addArcWithCenter:CGPointMake(bottomLeftCorner.x + AlivcLiveArrowCornerRadius,
                                    bottomLeftCorner.y - AlivcLiveArrowCornerRadius)
                 radius:AlivcLiveArrowCornerRadius startAngle:M_PI / 2 endAngle:M_PI clockwise:YES];
    // 左上角
    [path addLineToPoint:CGPointMake(topLeftCorner.x, topLeftCorner.y + AlivcLiveArrowCornerRadius)];
    [path addArcWithCenter:CGPointMake(topLeftCorner.x + AlivcLiveArrowCornerRadius,
                                    topLeftCorner.y + AlivcLiveArrowCornerRadius)
                 radius:AlivcLiveArrowCornerRadius startAngle:M_PI endAngle:3 * M_PI / 2 clockwise:YES];

    // 右上角
    [path addLineToPoint:CGPointMake(topRightCorner.x - AlivcLiveArrowCornerRadius, topRightCorner.y)];
    [path addArcWithCenter:CGPointMake(topRightCorner.x - AlivcLiveArrowCornerRadius,
                                    topRightCorner.y + AlivcLiveArrowCornerRadius)
                 radius:AlivcLiveArrowCornerRadius startAngle:3 * M_PI / 2 endAngle:2 * M_PI clockwise:YES];

    // 右下角
    [path addLineToPoint:CGPointMake(topRightCorner.x, topRightCorner.y - AlivcLiveArrowCornerRadius)];
    [path addArcWithCenter:CGPointMake(buttomRightCorner.x - AlivcLiveArrowCornerRadius,
                                    buttomRightCorner.y - AlivcLiveArrowCornerRadius)
                 radius:AlivcLiveArrowCornerRadius startAngle:0 endAngle:M_PI / 2 clockwise:YES];
    
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithWhite:0 alpha:0.5].CGColor);
    CGContextAddPath(ctx, path.CGPath);
    CGContextFillPath(ctx);
    
}


@end

@implementation _AlivcLiveBeautifySliderView {
    _AlivcLiveBeautifySlider *_slider;
    _AlivcLiveBeautifySliderTooltip *_toolTip;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.2f];
        __weak typeof(self) weakSelf = self;
        _slider = [[_AlivcLiveBeautifySlider alloc] initWithFrame:
                        CGRectMake(15,
                                   29,
                                   CGRectGetWidth(self.bounds) - 15 * 2.f,
                                   CGRectGetHeight(_slider.bounds))];
        _slider.aliViewDidLayout = ^(_AlivcLiveBeautifySlider *slider) {
            [weakSelf _layoutToolTip:slider];
        };
        _slider.minimumTrackTintColor = [UIColor whiteColor];
        _slider.maximumTrackTintColor = [UIColor colorWithWhite:1 alpha:0.3];
        _slider.value = 50.f;
        _slider.minimumValue = 0.f;
        _slider.maximumValue = 100.f;
        [_slider addTarget:self
                    action:@selector(_didChange:)
            forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self
                    action:@selector(_didCancel:)
            forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        [self addSubview:_slider];
        [_slider sizeToFit];
        
        _toolTip = [[_AlivcLiveBeautifySliderTooltip alloc] initWithFrame:CGRectMake(0, 0, 44, 29)];
//        _toolTip.hidden = YES;
        [self addSubview:_toolTip];
        _toolTip.hidden = YES;
    }
    return self;
}

- (void)setValue:(float)value {
    _slider.value = value;
    [self setNeedsLayout];
}

- (float)value {
    return _slider.value;
}


- (void)setMaximumValue:(float)maximumValue {
    _slider.maximumValue = maximumValue;
    [self setNeedsLayout];
}

- (float)maximumValue {
    return _slider.maximumValue;
}

- (void)setMinimumValue:(float)minimumValue {
    _slider.minimumValue = minimumValue;
    [self setNeedsLayout];
}

- (float)minimumValue {
    return _slider.minimumValue;
}

- (void)setOriginalValue:(float)originalValue {
    _slider.originalValue = originalValue;
}

- (float)originalValue {
    return _slider.originalValue;
}

- (void)sizeToFit {
    CGRect frame = CGRectZero;
    frame.origin = CGPointZero;
    frame.size = [self sizeThatFits:CGSizeMake(100.f, 100.f)];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(size.width, 78.f);
}

- (void)layoutSubviews {
    _slider.frame =
        CGRectMake(15,
                   29,
                   CGRectGetWidth(self.bounds) - 15 * 2.f,
                   CGRectGetHeight(_slider.bounds));
    
//    [self _layoutToolTip:_slider];
    
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
}

- (void)_didChange:(UISlider *)sender {
    _toolTip.hidden = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderView:valueDidChange:)]) {
        [self.delegate sliderView:self valueDidChange:sender.value];
    }
}

- (void)_layoutToolTip:(UISlider *)sender {
    UIView *view = sender.subviews.lastObject;
    if (view) {
        CGPoint point = [self convertPoint:view.center fromView:sender];
        CGPoint _toolTipPoint = _toolTip.center;
        _toolTipPoint.x = point.x;
        _toolTip.center = _toolTipPoint;
        [_toolTip setText:[NSString stringWithFormat:@"%.0f",sender.value]];
    }
}

- (void)_didCancel:(UISlider *)sender {
    _toolTip.hidden = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderViewTouchDidCancel:)]) {
        [self.delegate sliderViewTouchDidCancel:self];
    }
}

@end
