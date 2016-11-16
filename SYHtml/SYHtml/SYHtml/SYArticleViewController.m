//
//  SYArticleViewController.m
//  SYHtml
//
//  Created by leju_esf on 16/11/16.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "SYArticleViewController.h"
#import "SYHtmlManager.h"
#import "SYArticleModel.h"
@interface SYArticleViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation SYArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[SYHtmlManager sharedSYHtmlManager] requestDataWithUrl:self.urlString andType:SYHtmlTypeArticle completion:^(id response) {
        if (response) {
            SYArticleModel *model = (SYArticleModel *)response;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.textView.text = model.text;
                self.title = model.title;
            });
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
