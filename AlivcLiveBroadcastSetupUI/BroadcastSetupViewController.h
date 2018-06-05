//
//  BroadcastSetupViewController.h
//  AlivcLiveBroadcastSetupUI
//
//  Created by 陈春光 on 2018/1/24.
//  Copyright © 2018年 TripleL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReplayKit/ReplayKit.h>

@interface BroadcastSetupViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *rtmpUrl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *pushRotation;
@property (weak, nonatomic) IBOutlet UILabel *resolutionText;
@property (weak, nonatomic) IBOutlet UISlider *resolutionBar;

@end
