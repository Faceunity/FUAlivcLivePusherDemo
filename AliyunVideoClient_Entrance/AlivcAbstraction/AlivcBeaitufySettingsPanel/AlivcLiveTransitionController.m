//
//  AlivcLiveTransitionController.m
//  AliyunVideoClient_Entrance
//
//  Created by 汪潇翔 on 2018/5/29.
//  Copyright © 2018 Alibaba. All rights reserved.
//

#import "AlivcLiveTransitionController.h"
#import "AlivcLivePresentationController.h"

static const NSTimeInterval AlivcLiveTransitionDuration = 0.27f;

@implementation AlivcLiveTransitionController

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return AlivcLiveTransitionDuration;
}


- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    
    // 获取 fromview 和 fromViewController
    UIViewController *fromViewController =
    [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    if (fromView == nil) {
        fromView = fromViewController.view;
    }
    
    // 获取 toView 和 toViewController
    UIViewController *toViewController =
    [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    if (toView == nil) {
        toView = toViewController.view;
    }
    
    UIViewController *toPresentingViewController = toViewController.presentingViewController;
    BOOL presenting = (toPresentingViewController == fromViewController) ? YES : NO;
    
    UIViewController *animatingViewController = presenting ? toViewController : fromViewController;
    UIView *animatingView = presenting ? toView : fromView;
    
    UIView *containerView = transitionContext.containerView;
    
    if (presenting) {
        [containerView addSubview:toView];
    }
    
    CGFloat startingAlpha = presenting ? 0.0f : 1.0f;
    CGFloat endingAlpha = presenting ? 1.0f : 0.0f;
    
    animatingView.frame = [transitionContext finalFrameForViewController:animatingViewController];
    animatingView.alpha = startingAlpha;
    
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    UIViewAnimationOptions options =
    UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState;
    
    [UIView animateWithDuration:transitionDuration
                          delay:0.0
                        options:options
                     animations:^{
                         animatingView.alpha = endingAlpha;
                     }
                     completion:^(__unused BOOL finished) {
                         // If we're dismissing, remove the presented view from the hierarchy
                         if (!presenting) {
                             [fromView removeFromSuperview];
                         }
                         
                         // From ADC : UIViewControllerContextTransitioning
                         // When you do create transition animations, always call the
                         // completeTransition: from an appropriate completion block to let UIKit know
                         // when all of your animations have finished.
                         [transitionContext completeTransition:YES];
                     }];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (UIPresentationController *)
presentationControllerForPresentedViewController:(UIViewController *)presented
presentingViewController:(UIViewController *)presenting
sourceViewController:(__unused UIViewController *)source {
    return [[AlivcLivePresentationController alloc] initWithPresentedViewController:presented
                                                           presentingViewController:presenting];
}

- (id<UIViewControllerAnimatedTransitioning>)
animationControllerForPresentedController:(__unused UIViewController *)presented
presentingController:(__unused UIViewController *)presenting
sourceController:(__unused UIViewController *)source {
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:
(__unused UIViewController *)dismissed {
    return self;
}

@end
