//
//  SYVideoModel.m
//  SYRecordVideoDemo
//
//  Created by leju_esf on 17/3/16.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYVideoModel.h"
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>

@implementation SYVideoModel

- (NSString *)takeDate {
    NSString *year = [self.path substringWithRange:NSMakeRange(self.path.length - 18, 4)];
    NSString *month = [self.path substringWithRange:NSMakeRange(self.path.length - 14, 2)];
    NSString *date = [self.path substringWithRange:NSMakeRange(self.path.length - 12, 2)];
    NSString *hour = [self.path substringWithRange:NSMakeRange(self.path.length - 10, 2)];
    NSString *minute = [self.path substringWithRange:NSMakeRange(self.path.length - 8, 2)];
    NSString *second = [self.path substringWithRange:NSMakeRange(self.path.length - 6, 2)];
    return [NSString stringWithFormat:@"%@年%@月%@日%@:%@:%@",year,month,date,hour,minute,second];
}

+ (void)saveVideo:(SYVideoModel *)video{
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self videoList]];
    [tempArray addObject:video];
    [NSKeyedArchiver archiveRootObject:tempArray toFile:[self dataPath]];
}

+ (NSArray *)videoList {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self dataPath]];
}

+ (NSString *)dataPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject stringByAppendingPathComponent:@"videoList.data"];
}

- (UIImage*) thumbnailImageAtTime:(NSTimeInterval)time {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:self.path] options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 50) actualTime:NULL error:&thumbnailImageGenerationError];
    
    int32_t preferredTimeScale = 600;
    CMTime inTime = CMTimeMakeWithSeconds(time, preferredTimeScale);
    
    CGImageRef image = [assetImageGenerator copyCGImageAtTime:inTime actualTime:&inTime error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:image] : nil;
    
    return thumbnailImage;
}


- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        Class c = self.class;
        while (c && c != [NSObject class]) {
            unsigned int count = 0;
            Ivar *ivar = class_copyIvarList(c, &count);
            for (int i = 0; i<count; i++) {
                Ivar iva = ivar[i];
                const char *name = ivar_getName(iva);
                NSString *strName = [NSString stringWithUTF8String:name];
                id value = [decoder decodeObjectForKey:strName];
                [self setValue:value forKey:strName];
            }
            free(ivar);
            c = [self superclass];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    Class c = self.class;
    while (c && c != [NSObject class]) {
        unsigned int count;
        Ivar *ivar = class_copyIvarList(c, &count);
        for (int i=0; i<count; i++) {
            Ivar iv = ivar[i];
            const char *name = ivar_getName(iv);
            NSString *strName = [NSString stringWithUTF8String:name];
            id value = [self valueForKey:strName];
            [encoder encodeObject:value forKey:strName];
        }
        free(ivar);
        c = [self superclass];
    }
}

@end
