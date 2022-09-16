//
//  BroadcastSetupViewController.m
//  AlivcLiveBroadcastSetupUI
//
//  Created by 陈春光 on 2018/1/24.
//  Copyright © 2018年 TripleL. All rights reserved.
//

#import "BroadcastSetupViewController.h"

@implementation BroadcastSetupViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSString * devCode = [[[[[UIDevice currentDevice] identifierForVendor] UUIDString] substringToIndex:3] lowercaseString];
    
    NSString *rtmpSrv = @"rtmp://video-center.alivecdn.com/test/stream45?vhost=push-demo.aliyunlive.com";
    _rtmpUrl.text = rtmpSrv;
    
    [self.resolutionBar addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.resolutionBar.value = 4;
    self.resolutionBar.continuous = NO;
    self.resolutionText.text = @"540P";
    
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.rtmpUrl resignFirstResponder];
}

// Call this method when the user has finished interacting with the view controller and a broadcast stream can start
- (void)userDidFinishSetup {
    
    // Broadcast url that will be returned to the application
    NSURL *broadcastURL = [NSURL URLWithString: _rtmpUrl.text];
    // Service specific broadcast data example which will be supplied to the process extension during broadcast
    NSString *userID = @"user1";
    NSString *endpointURL = _rtmpUrl.text;
    
    NSInteger idx = _pushRotation.selectedSegmentIndex;
    
    NSString *pushRotation    = [_pushRotation titleForSegmentAtIndex:idx];
    
    
    NSDictionary *setupInfo = @{ @"userID" : userID,
                                 @"endpointURL" : endpointURL,
                                 @"pushRotation" : pushRotation,
                                 @"pushResolution" : self.resolutionText.text};
    
    
    // Set broadcast settings
    RPBroadcastConfiguration *broadcastConfig = [[RPBroadcastConfiguration alloc] init];
    // Tell ReplayKit that the extension is finished setting up and can begin broadcasting
    [self.extensionContext completeRequestWithBroadcastURL:broadcastURL broadcastConfiguration:broadcastConfig setupInfo:setupInfo];
}

- (void)userDidCancelSetup {
    // Tell ReplayKit that the extension was cancelled by the user
    [self.extensionContext cancelRequestWithError:[NSError errorWithDomain:@"YourAppDomain" code:-1 userInfo:nil]];
}

- (void)sliderValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    
    if(slider.value < 1){
        self.resolutionText.text = @"180P";
    }else  if(slider.value < 2){
        self.resolutionText.text = @"240P";
    }
    else  if(slider.value < 3){
        self.resolutionText.text = @"360P";
    }
    else  if(slider.value  < 4){
        self.resolutionText.text = @"480P";
    }
    else  if(slider.value  < 5){
        self.resolutionText.text = @"540P";
    }
    else {
        self.resolutionText.text = @"720P";
    }
}

- (IBAction)onStartBtn:(id)sender {
    
    [self userDidFinishSetup];
}

- (IBAction)onCancelBtn:(id)sender {
    
    [self userDidCancelSetup];
}



@end
