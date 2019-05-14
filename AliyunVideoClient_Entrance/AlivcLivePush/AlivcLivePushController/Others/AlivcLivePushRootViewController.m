//
//  AlivcLivePushRootViewController.m
//  AliyunVideoClient_Entrance
//
//  Created by 张璠 on 2018/10/11.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcLivePushRootViewController.h"
#import "AlivcLivePushConfigViewController.h"
#import "AlivcLivePushReplayKitConfigViewController.h"
#import "AlivcUIConfig.h"
@interface AlivcLivePushRootViewController ()
@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation AlivcLivePushRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self setupData];
    
    [self setupSubViews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //导航栏设置
    self.navigationController.navigationBar.hidden = NO;
}

- (void)setupSubViews {
    
    
    self.navigationItem.title = NSLocalizedString(@"live_scene_list", nil);
    
    self.listTableView = [[UITableView alloc] initWithFrame:(CGRectMake(0, 0, AlivcScreenWidth, AlivcScreenHeight))
                                                      style:(UITableViewStylePlain)];
    self.listTableView.backgroundColor = [AlivcUIConfig shared].kAVCBackgroundColor;
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.listTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ViewControllerListTableViewID"];
    self.listTableView.delegate = (id)self;
    self.listTableView.dataSource = (id)self;
    self.listTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.listTableView];
}

- (void)setupData {
    
    self.dataArray = [[NSArray alloc] initWithObjects:NSLocalizedString(@"live_basic_function", nil),
                      NSLocalizedString(@"screen_record_live", nil),
                      nil];
}


#pragma mark - TableViewdelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ViewControllerListTableViewID" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14.f];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        // 新接口 AlivcLivePusher
        AlivcLivePushConfigViewController *pushConfigVC = [[AlivcLivePushConfigViewController alloc] init];
        [self.navigationController pushViewController:pushConfigVC animated:YES];
        
    }else if (indexPath.row == 1) {
        
        // 新接口 AlivcLivePusher
        AlivcLivePushReplayKitConfigViewController *replayKitConfigVC = [[AlivcLivePushReplayKitConfigViewController alloc] init];
        [self.navigationController pushViewController:replayKitConfigVC animated:YES];
        
    }
}


@end
