//
//  _AlivcLiveBeautifySliderView.h
//  BeautifySettingsPanel
//
//  Created by 汪潇翔 on 2018/5/30.
//  Copyright © 2018 汪潇翔. All rights reserved.
//

#import <UIKit/UIKit.h>

@class _AlivcLiveBeautifySliderView;

@protocol _AlivcLiveBeautifySliderViewDelegate <NSObject>
- (void)sliderView:(_AlivcLiveBeautifySliderView *)sliderView valueDidChange:(float)value;
- (void)sliderViewTouchDidCancel:(_AlivcLiveBeautifySliderView *)sliderView ;
@end

@interface _AlivcLiveBeautifySliderView : UIView

@property (nonatomic) float value;
@property (nonatomic) float minimumValue;
@property (nonatomic) float maximumValue;
@property (nonatomic) float originalValue;

@property (nonatomic, weak) id<_AlivcLiveBeautifySliderViewDelegate> delegate;

@end
