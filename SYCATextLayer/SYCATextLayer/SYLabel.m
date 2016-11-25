//
//  SYLabel.m
//  SYCATextLayer
//
//  Created by leju_esf on 16/11/25.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "SYLabel.h"
#import "NSString+SYExtension.h"
#import "NSAttributedString+SYExtension.h"

@interface SYLabel ()
@property (nonatomic, strong) CATextLayer *textLayer;
@end

@implementation SYLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        [self.layer addSublayer:self.textLayer];
//        _linkTextColor = [UIColor redColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1.0);
    CGContextSetRGBFillColor (context, 0.5, 0.5, 0.5, 0.5);
    UIFont  *font = [UIFont boldSystemFontOfSize:18.0];
    [@"公司：北京中软科技股份有限公司\n部门：ERP事业部\n姓名：McLiang" drawAtPoint:CGPointMake(0,0) withAttributes:@{NSFontAttributeName:font}];
    
}

- (void)setText:(id)text {
    _text = text;
    self.textLayer.string = text;
    if ([text isKindOfClass:[NSString class]]) {
        
    }else if ([text isKindOfClass:[NSAttributedString class]]) {
        
    }
}

- (void)setLinkText:(NSString *)linkText {
    _linkText = linkText;
    if ([self.text isKindOfClass:[NSString class]]) {
        NSRange rang = [self.text rangeOfString:linkText];
        if (rang.length > 0 && rang.location != NSNotFound) {
            NSArray *texts = [self.text componentsSeparatedByString:linkText];
            for (int i = 0; i < texts.count; i++) {
                CATextLayer *texLayer = [CATextLayer layer];
                
            }
        }
        
    }else if ([self.text isKindOfClass:[NSAttributedString class]]) {
        
    }
}

//- (void)setFrame:(CGRect)frame {
//    
//}

- (CATextLayer *)textLayer {
    if (_textLayer == nil) {
        _textLayer = [CATextLayer layer];
        _textLayer.frame = self.frame;
        _textLayer.foregroundColor = [UIColor blackColor].CGColor;
        _textLayer.alignmentMode = kCAAlignmentNatural;
        _textLayer.wrapped = YES;
        _textLayer.truncationMode = kCATruncationEnd;
        UIFont *font = [UIFont systemFontOfSize:17];
        _textLayer.font = CGFontCreateWithFontName( (__bridge CFStringRef)font.fontName);
        _textLayer.fontSize = font.pointSize;
        _textLayer.contentsScale = [UIScreen mainScreen].scale;
    }
    return _textLayer;
}
@end
