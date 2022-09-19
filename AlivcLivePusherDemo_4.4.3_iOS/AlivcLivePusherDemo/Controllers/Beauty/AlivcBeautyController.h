//
//  AlivcBeautyController.h
//  AlivcLivePusherDemo
//
//  Created by zhangjc on 2022/5/7.
//  Copyright © 2022 TripleL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlivcLivePusher/AlivcLivePushConstants.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlivcBeautyController : NSObject

+ (AlivcBeautyController *)sharedInstance;

- (void)setupBeautyController;
- (void)detectVideoBuffer:(long)buffer withWidth:(int)width withHeight:(int)height withVideoFormat:(AlivcLivePushVideoFormat)videoFormat withPushOrientation:(AlivcLivePushOrientation)pushOrientation;
- (int)processGLTextureWithTextureID:(int)textureID withWidth:(int)width withHeight:(int)height;
- (void)destroyBeautyController;

- (void)setupBeautyControllerUIWithView:(UIView *)view;
- (void)showPanel:(BOOL)animated;
- (void)destroyBeautyControllerUI;

@end

NS_ASSUME_NONNULL_END
