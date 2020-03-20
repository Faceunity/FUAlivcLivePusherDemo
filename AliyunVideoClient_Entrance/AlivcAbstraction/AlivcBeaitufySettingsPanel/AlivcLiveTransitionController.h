//
//  AlivcLiveTransitionController.h
//  AliyunVideoClient_Entrance
// In order to use a custom modal transition, the UIViewController to be presented must set two
// properties. The UIViewControllers transitioningDelegate should be set to an instance of this class.
// myDialogViewController.modalPresentationStyle = UIModalPresentationCustom;
// myDialogViewController.transitioningDelegate = dialogTransitionController;

// The presenting UIViewController then calls presentViewController:animated:completion:
// [rootViewController presentViewController:myDialogViewController animated:YES completion:...];
//  Created by 汪潇翔 on 2018/5/29.
//  Copyright © 2018 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface AlivcLiveTransitionController : NSObject<UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>

@end
