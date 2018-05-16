//
//  TaksHeaderView.m
//  TaskDemo
//
//  Created by leju_esf on 2018/4/19.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "TaksHeaderView.h"

@implementation TaksHeaderView

- (IBAction)clickBtn {
    if (self.openAction) {
        self.openAction();
    }
}

@end
