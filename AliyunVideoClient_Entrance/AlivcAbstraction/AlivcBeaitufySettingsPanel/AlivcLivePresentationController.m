//
//  AlivcLivePresentationController.m
//  AliyunVideoClient_Entrance
//
//  Created by 汪潇翔 on 2018/5/29.
//  Copyright © 2018 Alibaba. All rights reserved.
//

#import "AlivcLivePresentationController.h"

static const CGFloat AlivcLivePresentationMinimumWidth = 200.f;

static UIEdgeInsets AlivcLivePresentationEdgeInsets = {0.f, 0.f, 0.f, 0.f};

@interface AlivcLivePresentationController()
// View matching the container's bounds that dims the entire screen and catchs taps to dismiss.
@property(nonatomic) UIView *dimmingView;

// Tracking view that adds a shadow under the presented view. This view's frame should always match
// the presented view's.
@property(nonatomic) UIView *trackingView;
@end

@implementation AlivcLivePresentationController{
    UITapGestureRecognizer *_dismissGestureRecognizer;
}

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController
                       presentingViewController:(UIViewController *)presentingViewController {
    self = [super initWithPresentedViewController:presentedViewController
                         presentingViewController:presentingViewController];
    if (self) {
        _dimmingView = [[UIView alloc] initWithFrame:CGRectZero];
        _dimmingView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
        _dimmingView.alpha = 0.0f;
        _dismissGestureRecognizer =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
        [_dimmingView addGestureRecognizer:_dismissGestureRecognizer];
    }
    return self;
}

- (CGRect)frameOfPresentedViewInContainerView {
    CGRect containerBounds = CGRectStandardize(self.containerView.bounds);
    
    // For pre iOS 11 devices, we are assuming a safeAreaInset of UIEdgeInsetsZero
    UIEdgeInsets containerSafeAreaInsets = UIEdgeInsetsZero;
#if defined(__IPHONE_11_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0)
    if (@available(iOS 11.0, *)) {
//        containerSafeAreaInsets = self.containerView.safeAreaInsets; // 不需要排除safeArea,正常显示就好
    }
#endif
    
    // Take the larger of the Safe Area insets and the Material specified insets.
    containerSafeAreaInsets.top = MAX(containerSafeAreaInsets.top, AlivcLivePresentationEdgeInsets.top);
    containerSafeAreaInsets.left = MAX(containerSafeAreaInsets.left, AlivcLivePresentationEdgeInsets.left);
    containerSafeAreaInsets.right = MAX(containerSafeAreaInsets.right, AlivcLivePresentationEdgeInsets.right);
    containerSafeAreaInsets.bottom = MAX(containerSafeAreaInsets.bottom, AlivcLivePresentationEdgeInsets.bottom);
    
    // Take into account a visible keyboard
    
    // Area that the presented dialog can use.
    CGRect standardPresentableBounds = UIEdgeInsetsInsetRect(containerBounds, containerSafeAreaInsets);
    
    CGRect presentedViewFrame = CGRectZero;
    presentedViewFrame.size = [self sizeForChildContentContainer:self.presentedViewController
                                         withParentContainerSize:standardPresentableBounds.size];
    
    presentedViewFrame.origin.x =
    containerSafeAreaInsets.left + (standardPresentableBounds.size.width - presentedViewFrame.size.width) * 0.5f;
    presentedViewFrame.origin.y =
    standardPresentableBounds.size.height - presentedViewFrame.size.height - containerSafeAreaInsets.bottom;
    
    presentedViewFrame.origin.x = (CGFloat)floor(presentedViewFrame.origin.x);
    presentedViewFrame.origin.y = (CGFloat)floor(presentedViewFrame.origin.y);
    
    return presentedViewFrame;
}


- (void)containerViewWillLayoutSubviews {
    [super containerViewWillLayoutSubviews];
}

- (void)presentationTransitionWillBegin {
    self.dimmingView.frame = self.containerView.bounds;
    self.dimmingView.alpha = 0.0f;
    [self.containerView addSubview:self.dimmingView];
    
    id<UIViewControllerTransitionCoordinator> transitionCoordinator =
    [self.presentedViewController transitionCoordinator];
    if (transitionCoordinator) {
        [transitionCoordinator
         animateAlongsideTransition:
         ^(__unused id<UIViewControllerTransitionCoordinatorContext> context) {
             self.dimmingView.alpha = 1.0f;
         }
         completion:NULL];
    } else {
        self.dimmingView.alpha = 1.0f;
    }
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
    if (completed) {
        // Stop the presenting view from being tapped for voiceover while this view is up.
        // Setting @c accessibilityViewIsModal on the presented view (or its parent) should be enough,
        // but it's not.
        // b/19519321
        self.presentingViewController.view.accessibilityElementsHidden = YES;
        self.presentedView.accessibilityViewIsModal = YES;
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, [self presentedView]);
    } else {
        // Transition was cancelled.
        [self.dimmingView removeFromSuperview];
    }
}

- (void)dismissalTransitionWillBegin {
    id<UIViewControllerTransitionCoordinator> transitionCoordinator =
    [self.presentedViewController transitionCoordinator];
    if (transitionCoordinator != nil) {
        [transitionCoordinator
         animateAlongsideTransition:
         ^(__unused id<UIViewControllerTransitionCoordinatorContext> context) {
             self.dimmingView.alpha = 0.0f;
         }
         completion:NULL];
    } else {
        self.dimmingView.alpha = 0.0f;
    }
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    if (completed) {
        [self.dimmingView removeFromSuperview];
        // Re-enable accessibilityElements on the presenting view controller.
        self.presentingViewController.view.accessibilityElementsHidden = NO;
    }
    
    [super dismissalTransitionDidEnd:completed];
}

- (BOOL)shouldRemovePresentersView {
    return NO;
}

#pragma mark - UIContentContainer

/**
 Determines the size of the presented container's view based on available space and the preferred
 content size of the container.
 */
- (CGSize)sizeForChildContentContainer:(id<UIContentContainer>)container
               withParentContainerSize:(CGSize)parentSize {
    if (CGSizeEqualToSize(parentSize, CGSizeZero)) {
        return CGSizeZero;
    }
    
    CGSize targetSize = parentSize;
    
    const CGSize preferredContentSize = container.preferredContentSize;
    if (!CGSizeEqualToSize(preferredContentSize, CGSizeZero)) {
        targetSize = preferredContentSize;
        
        // If the targetSize.width is greater than 0.0 it must be at least MDCDialogMinimumWidth.
        if (0.0f < targetSize.width && targetSize.width < AlivcLivePresentationMinimumWidth) {
            targetSize.width = AlivcLivePresentationMinimumWidth;
        }
        // targetSize cannot exceed parentSize.
        targetSize.width = MIN(targetSize.width, parentSize.width);
        targetSize.height = MIN(targetSize.height, parentSize.height);
    }
    
    targetSize.width = (CGFloat)ceil(targetSize.width);
    targetSize.height = (CGFloat)ceil(targetSize.height);
    
    return targetSize;
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:
     ^(__unused id<UIViewControllerTransitionCoordinatorContext> context) {
         self.dimmingView.frame = self.containerView.bounds;
         CGRect presentedViewFrame = [self frameOfPresentedViewInContainerView];
         self.presentedView.frame = presentedViewFrame;
     }
                                 completion:NULL];
}

/**
 If the container's preferred content size has changed and we are able to accommidate the new size,
 update the frame of the presented view and the shadowing view.
 */
- (void)preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container {
    [super preferredContentSizeDidChangeForChildContentContainer:container];
    
    CGSize existingSize = self.presentedView.bounds.size;
    CGSize newSize = [self sizeForChildContentContainer:container
                                withParentContainerSize:self.containerView.bounds.size];
    
    if (!CGSizeEqualToSize(existingSize, newSize)) {
        CGRect presentedViewFrame = [self frameOfPresentedViewInContainerView];
        self.presentedView.frame = presentedViewFrame;
    }
}

#pragma mark - Internal

- (void)dismiss:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    }
}

@end
