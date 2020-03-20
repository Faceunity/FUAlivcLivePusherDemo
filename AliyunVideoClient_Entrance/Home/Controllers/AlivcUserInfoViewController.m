//
//  AlivcUserInfoViewController.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/5/11.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcUserInfoViewController.h"
#import "AlivcNicknameEditViewController.h"
#import "AlivcUserInfoManager.h"
#import "AlivcProfile.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+AlivcHelper.h"

@interface AlivcUserInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeAvatorButton;
@property (weak, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UIButton *changeUserButton;
@property (weak, nonatomic) IBOutlet UIImageView *avaterBackImageView;
@property (weak, nonatomic) IBOutlet UIView *gridentView;
@end

@implementation AlivcUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = [@"User Setting" localString];
    self.containView.backgroundColor = [UIColor clearColor];
    self.avatorImageView.layer.cornerRadius = self.avatorImageView.frame.size.width / 2;
    self.avatorImageView.clipsToBounds = true;
    
    self.changeAvatorButton.layer.cornerRadius = self.changeAvatorButton.frame.size.width / 2;
    self.changeAvatorButton.clipsToBounds = true;
    [self.changeUserButton setBackgroundColor:[UIColor colorWithHexString:@"#373d41"]];
    [self.changeUserButton setTitle:[@"Switch User" localString] forState:UIControlStateNormal];
    [self.changeUserButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"user_pic_0%d",arc4random() % 4 + 1]];
    self.avaterBackImageView.image = image;
    
    CAGradientLayer *layer = [[CAGradientLayer alloc] init];
    layer.colors = @[(id)[UIColor colorWithHexString:@"#1e222d" alpha:0].CGColor,
                     (id)[UIColor colorWithHexString:@"#1d212c" alpha:0.53].CGColor,
                     (id)[UIColor colorWithHexString:@"#1e222d" alpha:1].CGColor];
    layer.startPoint = CGPointMake(0.5, 0);
    layer.endPoint = CGPointMake(0.5, 1);
    layer.frame = self.view.bounds;
    [self.gridentView.layer addSublayer:layer];
    
    if (![AlivcProfile shareInstance].userId) {
        [self changeUser];
    }else{
        [self loadUserData];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = false;
}

- (void)loadUserData{
    [self.avatorImageView sd_setImageWithURL:[NSURL URLWithString:[AlivcProfile shareInstance].avatarUrlString] placeholderImage:[UIImage imageNamed:@"test_avator_boy"]];
    self.nameLabel.text = [AlivcProfile shareInstance].nickname;
    self.idLabel.text = [AlivcProfile shareInstance].userId;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeAvator:(id)sender {
    
}

- (IBAction)changeName:(id)sender {
    AlivcNicknameEditViewController *targetVC = [[AlivcNicknameEditViewController alloc]init];
    __weak typeof(self)weakSelf = self;
    [targetVC setUpdateNickNameCompltion:^(NSString *errorStr) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf) return;
        if (errorStr) {
            [MBProgressHUD showMessage:errorStr inView:strongSelf.view];
        }else{
            [strongSelf loadUserData];
        }
    }];
    [self.navigationController pushViewController:targetVC animated:true];
}

- (IBAction)changeUser:(id)sender {
    NSLog(@"更换用户");
    [self changeUser];
}


- (void)changeUser{
    __weak typeof(self)weakSelf = self;
    [AlivcUserInfoManager randomAUserSuccess:^(AlivcLiveUser * _Nonnull liveUser) {
        AlivcProfile *profile = [AlivcProfile shareInstance];
        profile.userId = liveUser.userId;
        profile.avatarUrlString = liveUser.avatarUrlString;
        profile.nickname = liveUser.nickname;
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf)return;
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf loadUserData];
            [MBProgressHUD showMessage:[@"change_new_user" localString] inView:strongSelf.view];
        });
        
    } failure:^(NSString * _Nonnull errDes) {

        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf)return;
        dispatch_async(dispatch_get_main_queue(), ^{
             [MBProgressHUD showMessage:errDes inView:strongSelf.view];
        });
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
