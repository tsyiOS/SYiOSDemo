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

#define MaxVideoCount 10

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

- (void)sy_setImage:(void (^)(UIImage *))block {
    if (self.defaultImage) {
        block(self.defaultImage);
    }else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            _defaultImage = [self thumbnailImageAtTime:1];
            dispatch_async(dispatch_get_main_queue(), ^{
                block(_defaultImage);
            });
        });
    }
}

- (long long)size {
    if (_size == 0) {
        _size = [[NSFileManager defaultManager] attributesOfItemAtPath:self.path error:nil].fileSize;
    }
    return _size;
}

- (NSString *)sizeStr {
    if (_sizeStr == nil) {
        if (self.size < 1024) {
            _sizeStr = [NSString stringWithFormat:@"%lldB",self.size];
        }else if (self.size/1024 < 1024) {
            _sizeStr = [NSString stringWithFormat:@"%lldKB",self.size/1024];
        }else if (self.size/(1024*1024) < 1024){
            _sizeStr = [NSString stringWithFormat:@"%lldM",self.size/(1024*1024)];
        }else{
             _sizeStr = [NSString stringWithFormat:@"%lldG",self.size/(1024*1024*1024)];
        }
    }
    return _sizeStr;
}

+ (void)saveVideo:(SYVideoModel *)video{
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self videoList]];
    if (tempArray.count > MaxVideoCount) {
        SYVideoModel *model = tempArray.firstObject;
        [[NSFileManager defaultManager] removeItemAtPath:model.path error:nil];
        [tempArray removeObjectAtIndex:0];
    }
    [tempArray addObject:video];
    [NSKeyedArchiver archiveRootObject:tempArray toFile:[self dataPath]];
}

+ (NSArray *)removeVideo:(SYVideoModel *)video {
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self videoList]];
    for (SYVideoModel *model in tempArray) {
        if ([model.path isEqualToString:video.path]) {
            [tempArray removeObject:model];
            [[NSFileManager defaultManager] removeItemAtPath:video.path error:nil];
            break;
        }
    }
    [NSKeyedArchiver archiveRootObject:tempArray toFile:[self dataPath]];
    return tempArray;
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
