//
//  AlivcKeyboardManageViewController.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/9.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcKeyboardManageViewController.h"
#import "AlivcKeyboardManager.h"
#import "UIResponder+AlivcHelper.h"

@interface AlivcKeyboardManageViewController ()<AVCKeyboardObserver>

@end

@implementation AlivcKeyboardManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //添加键盘观察
    [[AlivcKeyboardManager defaultManager]addObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AVCKeyboardObserve

- (void)keyboardChangedWithTransition:(AVCKeyboardTransition)transition {
    UIWindow *keyboardWindow = [[AlivcKeyboardManager defaultManager] keyboardWindow];
    CGRect toFrame = [[AlivcKeyboardManager defaultManager] convertRect:transition.toFrame toView:keyboardWindow];
    UIView *firstResponder = [self.view currentFirstResponder];
    if (firstResponder &&
        ([firstResponder isKindOfClass:[UITextField class]] ||
         [firstResponder isKindOfClass:[UITextView class]])) {
            BOOL willShow = [[AlivcKeyboardManager defaultManager] isKeyboardVisible];
            //firstResponder在整个view的位置
            CGFloat locationBYInView = firstResponder.frame.size.height; //在整个view当中tf的底部距离顶端的距离
            UIView *resultView = firstResponder;
            do {
                locationBYInView += resultView.frame.origin.y;
                resultView = resultView.superview;
            } while (resultView != self.view && resultView != nil);
            
            if(willShow){
                if (locationBYInView > CGRectGetMinY(toFrame)) {
                    //使输入框不被遮挡
                    CGFloat device = locationBYInView - CGRectGetMinY(toFrame) + 8;
                    CGFloat buttomY = self.view.frame.size.height - device;
                    [self adjustFirstResponderWithBy:buttomY duration:transition.animationDuration];
                }
            }else{
                if (CGRectGetMaxY(self.view.frame) < self.view.frame.size.height) {
                    [self adjustFirstResponderWithFrame:toFrame duration:transition.animationDuration];
                }
            }
        }
}

- (void)adjustFirstResponderWithFrame:(CGRect)toFrame duration:(NSTimeInterval)duration {
    
    [self adjustFirstResponderWithBy:CGRectGetMinY(toFrame) duration:duration];
}

- (void)adjustFirstResponderWithBy:(CGFloat)bottomY duration:(NSTimeInterval)duration {
    if (duration == 0) {
        CGRect frame = self.view.frame;
        frame.origin.y = bottomY - frame.size.height;
        self.view.frame = frame;
    } else {
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = bottomY - frame.size.height;
            self.view.frame = frame;
        } completion:nil];
    }
}
@end
