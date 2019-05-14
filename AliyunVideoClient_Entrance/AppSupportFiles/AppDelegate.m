//
//  AppDelegate.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/3/22.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AppDelegate.h"
#import "AlivcHomeViewController.h"
#import "AlivcBaseNavigationController.h"
//#import "AlivcUIConfig.h"
//#import "AlivcDefine.h"
//#import "AlivcUserInfoManager.h"
//#import "AlivcAppServer.h"
//#import "AlivcProfile.h"
//#import <AliHAAdapter4Internal/AliHAAdapter.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarHidden:NO]; 
    // 初始化根视图控制器
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    AlivcHomeViewController *vc_root = [[AlivcHomeViewController alloc]init];
    AlivcBaseNavigationController *nav_root = [[AlivcBaseNavigationController alloc]initWithRootViewController:vc_root];
    self.window.rootViewController = nav_root;
    [self.window makeKeyAndVisible];
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
    return YES;
}

void UncaughtExceptionHandler(NSException *exception) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:0 forKey:@"shortVideo_fiterSelectIndex"];
    [defaults setInteger:0 forKey:@"shortVideo_gifSelectIndex"];
    [defaults setInteger:0 forKey:@"shortVideo_MVSelectIndex"];
    [defaults setInteger:0 forKey:@"shortVideo_beautyType"];
    [defaults synchronize];
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    
    UINavigationController *navigationController = (id)self.window.rootViewController;
    if ([navigationController isKindOfClass:[UINavigationController class]]) {
        return [navigationController.visibleViewController supportedInterfaceOrientations];
    }
    return navigationController.supportedInterfaceOrientations;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:0 forKey:@"shortVideo_fiterSelectIndex"];
    [defaults setInteger:0 forKey:@"shortVideo_gifSelectIndex"];
    [defaults setInteger:0 forKey:@"shortVideo_MVSelectIndex"];
    [defaults setInteger:0 forKey:@"shortVideo_beautyType"];
    [defaults synchronize];
}


@end
