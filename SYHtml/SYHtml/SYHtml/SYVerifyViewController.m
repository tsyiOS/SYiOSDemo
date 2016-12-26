//
//  SYVerifyViewController.m
//  SYHtml
//
//  Created by leju_esf on 16/12/23.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "SYVerifyViewController.h"
#import "SVProgressHUD.h"
#import <LocalAuthentication/LAContext.h>
#import <LocalAuthentication/LAError.h>

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

#define ScreenSacle ScreenW/320

#define SYUserPassWord @"SYUserPassWord"

@interface SYVerifyViewController ()
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *password;
@property (nonatomic, copy) NSString *lastPassWord;
@property (nonatomic, copy) NSMutableString *firstPassWord;
@property (nonatomic, copy) NSMutableString *sencodePassWord;
@end

@implementation SYVerifyViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *myLocalizedReasonString = @"使用指纹验证";
    
    /*
     typedef NS_ENUM(NSInteger, LAError)
     {
     //授权失败
     LAErrorAuthenticationFailed = kLAErrorAuthenticationFailed,
     
     //用户取消Touch ID授权
     LAErrorUserCancel           = kLAErrorUserCancel,
     
     //用户选择输入密码
     LAErrorUserFallback         = kLAErrorUserFallback,
     
     //系统取消授权(例如其他APP切入)
     LAErrorSystemCancel         = kLAErrorSystemCancel,
     
     //系统未设置密码
     LAErrorPasscodeNotSet       = kLAErrorPasscodeNotSet,
     
     //设备Touch ID不可用，例如未打开
     LAErrorTouchIDNotAvailable  = kLAErrorTouchIDNotAvailable,
     
     //设备Touch ID不可用，用户未录入
     LAErrorTouchIDNotEnrolled   = kLAErrorTouchIDNotEnrolled,
     } NS_ENUM_AVAILABLE(10_10, 8_0);
     */
    
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:myLocalizedReasonString reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }else {
                NSLog(@"认证失败:%@--%zd",error.description,error.code);
                switch (error.code) {
                    case LAErrorSystemCancel: {
                        //切换到其他APP，系统取消验证Touch ID
                        
                        break;
                    }
                    case LAErrorUserCancel: {
                        //用户取消验证Touch ID
                        
                        break;
                    }
                    case LAErrorUserFallback: {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //用户选择输入密码，切换主线程处理
                        }];
                        break;
                    }
                    case LAErrorAuthenticationFailed: {
                        //授权失败
                    
                    }
                    case LAErrorPasscodeNotSet: {
                         //系统未设置密码
                        
                    }
                    case LAErrorTouchIDNotAvailable: {
                         //设备Touch ID不可用，例如未打开
                        
                    }
                    case  LAErrorTouchIDNotEnrolled: {
                        //设备Touch ID不可用，用户未录入
                        
                    }
                        
                    default: {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理
                        }];
                        break;
                    }
                }
            }
        }];
    }else {
        NSLog(@"TouchID设备不可用");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    for (int i = 0; i < 10; i++) {
        [self.view addSubview:[self buttonWithTag:i]];
    }
    if (self.lastPassWord.length > 0) {
        self.desLabel.text = @"请输入密码";
    }else {
        self.desLabel.text = @"请设置4位数密码";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nubmerAction:(UIButton *)sender {
    self.password.text = [self.password.text stringByAppendingString:@" * "];
    if (self.lastPassWord.length > 0) {
        [self.firstPassWord appendString:[NSString stringWithFormat:@"%zd",sender.tag]];
        if (self.firstPassWord.length == 4) {
            if ([self.firstPassWord isEqualToString:self.lastPassWord]) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }else {
                [SVProgressHUD showErrorWithStatus:@"密码错误!"];
                self.password.text = @"";
                self.firstPassWord = nil;
            }
        }
    }else {
        NSLog(@"%@---%@",self.firstPassWord,self.sencodePassWord);
        if (self.firstPassWord.length < 4) {
            [self.firstPassWord appendString:[NSString stringWithFormat:@"%zd",sender.tag]];
            if (self.firstPassWord.length == 4) {
                self.password.text = @"";
                self.desLabel.text = @"请再次输入";
            }
        }else {
                [self.sencodePassWord appendString:[NSString stringWithFormat:@"%zd",sender.tag]];
                if (self.sencodePassWord.length == 4) {
                    if ([self.sencodePassWord isEqualToString:self.firstPassWord]) {
                        [self dismissViewControllerAnimated:YES completion:^{
                            [[NSUserDefaults standardUserDefaults] setObject:self.firstPassWord forKey:SYUserPassWord];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                        }];
                    }else {
                        [SVProgressHUD showErrorWithStatus:@"两次密码不一致!"];
                        self.firstPassWord = nil;
                        self.sencodePassWord = nil;
                        self.desLabel.text = @"请设置4位数密码";
                        self.password.text = @"";
                    }
                }
            }
    }
}

- (BOOL)passWordCorrect:(NSString *)password {
    return [self.lastPassWord isEqualToString:password];
}

- (UIButton *)buttonWithTag:(NSInteger)tag {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = tag;
    [btn addTarget:self action:@selector(nubmerAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"number%zd",tag]] forState:UIControlStateNormal];
    CGFloat itemW = 60*ScreenSacle;
    CGFloat margin = (ScreenW - itemW * 3)/4;
    if (tag == 0) {
        btn.frame = CGRectMake(itemW + 2 * margin, 160*ScreenSacle + 3*(itemW + margin), itemW, itemW);
    }else {
        NSInteger row = (tag - 1)/3;
        NSInteger col = (tag - 1)%3;
        btn.frame = CGRectMake(margin*(col + 1) + itemW * col, 160*ScreenSacle + row * (margin + itemW), itemW, itemW);
    }
    btn.layer.cornerRadius = itemW * 0.5;
    btn.clipsToBounds = YES;
    return btn;
}

- (NSString *)lastPassWord {
    if (_lastPassWord == nil) {
        _lastPassWord = [[NSUserDefaults standardUserDefaults] stringForKey:SYUserPassWord];
    }
    return _lastPassWord;
}

- (NSMutableString *)firstPassWord {
    if (_firstPassWord == nil) {
        _firstPassWord = [[NSMutableString alloc] init];
    }
    return _firstPassWord;
}

- (NSMutableString *)sencodePassWord {
    if (_sencodePassWord == nil) {
        _sencodePassWord = [[NSMutableString alloc] init];
    }
    return _sencodePassWord;
}

@end
