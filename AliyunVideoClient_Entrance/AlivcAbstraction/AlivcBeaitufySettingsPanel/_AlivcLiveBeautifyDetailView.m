//
//  _AlivcLiveBeautifyDetailView.m
//  BeautifySettingsPanel
//
//  Created by 汪潇翔 on 2018/5/29.
//  Copyright © 2018 汪潇翔. All rights reserved.
//

#import "_AlivcLiveBeautifyDetailView.h"
#import "_AlivcLiveBeautifyNavigationView.h"
#import "NSString+AlivcHelper.h"
static const CGFloat AlivcLiveButtonMaximumWidth = 45.0f;

static const CGFloat AlivcLiveItemViewMaximumWidth = 45.f;
static const CGFloat AlivcLiveItemViewMaximumHeight = 67.f;


#define ALIVC_LIVE_DEBUG_VIEW_FRAME_ENABLE 0

@interface _AlivcLiveBeautifyDetailItemView : UIView
+ (instancetype)itemViewWithText:(NSString *)text image:(UIImage *)image action:(void(^)(_AlivcLiveBeautifyDetailItemView *sender))action;
@property (nonatomic, assign) BOOL selected;
@end

@implementation _AlivcLiveBeautifyDetailItemView {
    UIButton *_button;
    UILabel *_textLabel;
    void(^_action)(_AlivcLiveBeautifyDetailItemView *sender);
}

- (instancetype)initWithText:(NSString *)text image:(UIImage *)image action:(void(^)(_AlivcLiveBeautifyDetailItemView *sender))action {
    if (self = [self initWithFrame:CGRectZero]) {
        _selected  = NO;
        _action = [action copy];
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2f];
        [_button setImage:image forState:UIControlStateNormal];
        [_button setBackgroundImage:[UIImage imageNamed:@"bg_btn_image"] forState:UIControlStateNormal];
        [_button setBackgroundImage:[UIImage imageNamed:@"bg_btn_image_selected"] forState:UIControlStateNormal | UIControlStateSelected];
        [_button addTarget:self action:@selector(_didTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.text = text;
        _textLabel.font = [UIFont systemFontOfSize:13.f];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.numberOfLines = 0;
        [self addSubview:_textLabel];
#if ALIVC_LIVE_DEBUG_VIEW_FRAME_ENABLE
        self.backgroundColor = [UIColor redColor];
        _button.backgroundColor = [UIColor greenColor];
        _textLabel.backgroundColor = [UIColor greenColor];
#endif
    }
    return self;
}

+ (instancetype)itemViewWithText:(NSString *)text image:(UIImage *)image action:(void(^)(_AlivcLiveBeautifyDetailItemView *sender))action  {
    return [[[self class] alloc] initWithText:text image:image action:action];
}

- (void)setSelected:(BOOL)selected {
    if (_selected != selected) {
        _selected = selected;
        _button.selected = selected;
    }
}

- (void)layoutSubviews {
    if (_button) {
        CGRect frame = _button.frame;
        frame.size.width = MIN(CGRectGetWidth(self.bounds), AlivcLiveButtonMaximumWidth);
        frame.size.height = frame.size.width;
        frame.origin.x = (CGRectGetWidth(self.bounds) - frame.size.width) * 0.5;
        frame.origin.y = 0;
        _button.frame = frame;
        _button.layer.cornerRadius = frame.size.width * 0.5;
    }
    
    if (_textLabel) {
        CGRect frame = _textLabel.frame;
        frame.size.width = CGRectGetWidth(self.bounds);
        frame.size.height =40.f;
        frame.origin.x = 0;
        frame.origin.y = CGRectGetHeight(self.bounds) - 15;
        _textLabel.frame = frame;
    }
}

- (void)_didTap:(UIButton *)sender {
    if (_action) {
        _action(self);
    }
}

@end


@implementation _AlivcLiveBeautifyDetailView {
    _AlivcLiveBeautifyNavigationView *_navigationView;
    NSArray<_AlivcLiveBeautifyDetailItemView *> *_itemViews;
    UIScrollView *_buttonsContentView;
    __weak _AlivcLiveBeautifyDetailItemView *_selectedView;
    NSArray *_items;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.text = [@"Makeup" localString];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        _navigationView = [_AlivcLiveBeautifyNavigationView navigationViewTitleView:titleLabel];
        [self addSubview:_navigationView];
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        
        _buttonsContentView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _buttonsContentView.showsVerticalScrollIndicator = NO;
        _buttonsContentView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_buttonsContentView];
        
#if ALIVC_LIVE_DEBUG_VIEW_FRAME_ENABLE
        _navigationView.backgroundColor = [UIColor blackColor];
        _buttonsContentView.backgroundColor = [UIColor darkGrayColor];
#endif
    }
    return self;
}

- (NSArray<_AlivcLiveBeautifyDetailItemView *> *)_itemViewsWithInfo:(NSArray *)info {
    __weak typeof(self) weakSelf = self;
    NSMutableArray<_AlivcLiveBeautifyDetailItemView *> *array = [NSMutableArray arrayWithCapacity:info.count];
    for (NSDictionary *item in info) {
        UIImage *image = [UIImage imageNamed:item[@"icon_name"]];
        _AlivcLiveBeautifyDetailItemView *view =
            [_AlivcLiveBeautifyDetailItemView itemViewWithText:item[@"title"]
                                                         image:image
                                                        action:^(_AlivcLiveBeautifyDetailItemView *sender) {
                                                            [weakSelf _aliDidSelectedView:sender];
                                                        }];
        view.frame = CGRectMake(0, 0, AlivcLiveItemViewMaximumWidth, AlivcLiveItemViewMaximumHeight);
        [array addObject:view];
        [_buttonsContentView addSubview:view];
    }
    return [array copy];
}

- (void)reloadData {
    if (self.dataSource) {
        _items = [self.dataSource itemsOfDetailView:self];
    }
    
    for (UIView *view in _itemViews) {
        [view removeFromSuperview];
    }
    if (_items) {
        _itemViews = [self _itemViewsWithInfo:_items];
        [self setNeedsLayout];
    }
    
}

- (void)setDefaultValue{
    if (_itemViews.count) {
        _AlivcLiveBeautifyDetailItemView *firstView = _itemViews.firstObject;
        [self _aliDidSelectedView:firstView];
    }
}

- (void)_aliDidSelectedView:(_AlivcLiveBeautifyDetailItemView *)sender {
    if (_selectedView == sender) {
        return;
    }
    
    if (_selectedView) {
        _selectedView.selected = NO;
    }
    _selectedView = sender;
    _selectedView.selected = YES;
    
    NSUInteger index = [_itemViews indexOfObject:_selectedView];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailView:didSelectItemAtIndex:)]) {
        [self.delegate detailView:self didSelectItemAtIndex:index];
    }
}

- (_AlivcLiveBeautifyNavigationView *)navigationView {
    return _navigationView;
}


- (void)layoutSubviews {
    _navigationView.frame =
    CGRectMake(0, 0, CGRectGetWidth(self.bounds), 44.f);
    
    _buttonsContentView.frame = CGRectMake(15.f,
                                           CGRectGetMaxY(_navigationView.frame),
                                           CGRectGetWidth(self.bounds) - 15 * 2,
                                           CGRectGetHeight(self.bounds) - CGRectGetMaxY(_navigationView.frame));
    
    CGFloat buttonsContentWidth = CGRectGetWidth(_buttonsContentView.bounds);
    CGFloat buttonsContentHeight =  CGRectGetHeight(_buttonsContentView.bounds);
    if (_items.count > 5) {
        //个数大于5个的布局，超出界面需要滑动
        CGFloat buttonsInterval = (buttonsContentWidth - AlivcLiveItemViewMaximumWidth * _itemViews.count) / (_itemViews.count - 1);
        CGFloat buttonY = (buttonsContentHeight - AlivcLiveItemViewMaximumHeight) * 0.5;
        CGFloat buttonX = 0;
        CGFloat width = (buttonsContentWidth - 5 * buttonsInterval) / 5.5; //显示5个半
        for (UIView *view in _itemViews) {
            CGRect frame = view.frame;
            frame.size.width = width;
            frame.origin.x = buttonX;
            frame.origin.y = buttonY;
            view.frame = frame;
            buttonX = CGRectGetMaxX(frame) + buttonsInterval;
        }
        _buttonsContentView.contentSize = CGSizeMake(_items.count * width + (_items.count - 1) * buttonsInterval, buttonsContentHeight);
    }else{
        //个数小于5个的布局，各区域动态居中
        CGFloat itemWidth = buttonsContentWidth / _items.count;
        for (_AlivcLiveBeautifyDetailItemView *view in _itemViews) {
            NSInteger index = [_itemViews indexOfObject:view];
            CGFloat cx = index * itemWidth + itemWidth / 2;
            CGFloat cy = (buttonsContentHeight - AlivcLiveItemViewMaximumHeight) * 0.5 + view.frame.size.height / 2;
            view.center = CGPointMake(cx, cy);
        }
        
    }
    
}

@end
