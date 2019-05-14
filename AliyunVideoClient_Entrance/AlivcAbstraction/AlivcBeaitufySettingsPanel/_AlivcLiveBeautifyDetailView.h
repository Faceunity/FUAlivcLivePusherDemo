//
//  _AlivcLiveBeautifyDetailView.h
//  BeautifySettingsPanel
//
//  Created by 汪潇翔 on 2018/5/29.
//  Copyright © 2018 汪潇翔. All rights reserved.
//

#import <UIKit/UIKit.h>

@class _AlivcLiveBeautifyNavigationView, _AlivcLiveBeautifyDetailView;

@protocol _AlivcLiveBeautifyDetailViewDelegate <NSObject>
- (void)detailView:(_AlivcLiveBeautifyDetailView *)detailView didSelectItemAtIndex:(NSUInteger)index;
@end

@protocol _AlivcLiveBeautifyDetailViewDataSource <NSObject>
@required

/**
 get list of detailView
 @code
     @[
         @{
            @"title":@"磨皮",
            @"identifier" : @"mopi"
          },
         @{
            @"title":@"美白",
            @"identifier" : @"mopi"
         }
     ]
 @param detailView current detailView
 @return items of detailView
 */
- (NSArray<NSDictionary *> *)itemsOfDetailView:(_AlivcLiveBeautifyDetailView *)detailView;
@end

@interface _AlivcLiveBeautifyDetailView : UIView

@property (nonatomic, readonly) _AlivcLiveBeautifyNavigationView *navigationView;

@property (nonatomic, weak) id<_AlivcLiveBeautifyDetailViewDelegate> delegate;

@property (nonatomic, weak) id<_AlivcLiveBeautifyDetailViewDataSource> dataSource;

- (void)setDefaultValue;

- (void)reloadData;

@end
