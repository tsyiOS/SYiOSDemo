//
//  SYVerifyViewController.m
//  SYHtml
//
//  Created by leju_esf on 16/12/23.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "SYVerifyViewController.h"
#import "SVProgressHUD.h"
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
                self.password.text = @"";
                self.desLabel.text = @"密码错误,请重新输入";
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
