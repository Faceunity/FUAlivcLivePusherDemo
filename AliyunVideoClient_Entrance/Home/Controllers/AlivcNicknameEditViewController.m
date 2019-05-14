//
//  AlivcNicknameEditViewController.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/5/11.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcNicknameEditViewController.h"
#import "AlivcProfile.h"
#import "AlivcUserInfoManager.h"
#import "MBProgressHUD+AlivcHelper.h"

@interface AlivcNicknameEditViewController ()
@property (strong, nonatomic) UITextField *nameTF;
@property (strong, nonatomic) UIView *backgroundView;
@end

@implementation AlivcNicknameEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //右上角的完成
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = doneItem;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    //昵称
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    label.text = [@"Nickname" localString];
    [label sizeToFit];
    label.center = CGPointMake(20 + label.frame.size.width / 2, 36);
    [self.view addSubview:label];
    
    //textField
    self.nameTF = [[UITextField alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(label.frame) + 10, ScreenWidth - 30, 50)];
    self.nameTF.textColor = [UIColor whiteColor];
    self.nameTF.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:0.15];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    self.nameTF.leftView = leftView;
    self.nameTF.leftViewMode = UITextFieldViewModeAlways;
    self.nameTF.layer.cornerRadius = 5;
    self.nameTF.clipsToBounds = true;
    self.nameTF.layer.borderColor = [UIColor colorWithHexString:@"#00c1de"].CGColor;
    self.nameTF.layer.borderWidth = 1;
    self.nameTF.tintColor = [UIColor colorWithHexString:@"#00c1de"];
    [self.view addSubview:self.nameTF];
    [self.nameTF becomeFirstResponder];
    self.nameTF.text = [AlivcProfile shareInstance].nickname;
    [self.nameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    CAGradientLayer *layer = [[CAGradientLayer alloc] init];
    layer.colors = @[(id)[UIColor colorWithHexString:@"#1e222d" alpha:0].CGColor,
                     (id)[UIColor colorWithHexString:@"#1d212c" alpha:0.53].CGColor,
                     (id)[UIColor colorWithHexString:@"#1e222d" alpha:1].CGColor];
    
    layer.startPoint = CGPointMake(0.5, 0);
    layer.endPoint = CGPointMake(0.5, 1);
    layer.frame = self.view.bounds;
    
    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.frame = self.view.bounds;
    [self.backgroundView.layer addSublayer:layer];
    
    [self.view insertSubview:self.backgroundView atIndex:0];
}

- (void) textFieldDidChange:(UITextField *) textField {
    if (textField.text == nil || [textField.text isEqualToString:[AlivcProfile shareInstance].nickname]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (void)done{
    
    if ([self isContainsEmoji:self.nameTF.text]) {
        [MBProgressHUD showMessage:[@"nick_contain_emotion" localString] inView:self.view];
        return;
    }
    
    if ([self isEqual:self.nameTF.text]){
        [MBProgressHUD showMessage:[@"nick_all_empty" localString] inView:self.view];
        return;
    }
    if ([self getToInt:self.nameTF.text] > 16) {
        [MBProgressHUD showMessage:[@"nick_no_more_than_8" localString] inView:self.view];
        return;
    }

    __weak typeof(self)weakSelf = self;
    [AlivcUserInfoManager updateUserInfoWithNickName:self.nameTF.text userId:[AlivcProfile shareInstance].userId success:^{
       
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf)return;
        [AlivcProfile shareInstance].nickname = strongSelf.nameTF.text;
        
        if (strongSelf.updateNickNameCompltion) {
            strongSelf.updateNickNameCompltion(nil);
        }
    } failure:^(NSString * _Nonnull errDes) {
        
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf)return;
        if (strongSelf.updateNickNameCompltion) {
            strongSelf.updateNickNameCompltion(errDes);
        }
    }];
    [self.navigationController popViewControllerAnimated:true];
}

- (NSInteger)getToInt:(NSString*)strtemp
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [strtemp dataUsingEncoding:enc];
    return [da length];
}

-(BOOL)isEmptyString:(NSString *) string {
    if (!string)
    {
        return true;
    } else{
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *isString = [string stringByTrimmingCharactersInSet:set];
        if ([isString length] == 0)
        {
            return true;
        } else {
            return false;
        }
    }
}

- (BOOL)isContainsEmoji:(NSString *)string {
    __block BOOL isEomji = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    isEomji = YES;
                }
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                isEomji = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                isEomji = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                isEomji = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                isEomji = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                isEomji = YES;
            }
            if (!isEomji && substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                if (ls == 0x20e3) {
                    isEomji = YES;
                }
            }
        }
    }];
    return isEomji;
}

@end
