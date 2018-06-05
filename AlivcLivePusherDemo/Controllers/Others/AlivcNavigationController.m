//
//  AlivcNavigationController.m
//  AlivcLivePusherTest
//
//  Created by lyz on 2017/10/13.
//  Copyright © 2017年 TripleL. All rights reserved.
//

#import "AlivcNavigationController.h"

@interface AlivcNavigationController ()

@end

@implementation AlivcNavigationController



+ (void)initialize {
    
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    [navigationBar setBarTintColor:AlivcRGBA(240, 240, 240, 1)];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = nil;
    }
    
}

- (void)backBarButtonAction:(id)sender {
    
    [self popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (viewController.navigationItem.leftBarButtonItem ==nil && self.viewControllers.count >=1) {
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftBarButtonAction:)];
    }
    
    [super pushViewController:viewController animated:animated];
}


- (void)leftBarButtonAction:(id)sender {
    
    [self popViewControllerAnimated:YES];
}


- (BOOL)shouldAutorotate {
    return YES;
}

// 设备支持方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

// 默认方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}


@end
