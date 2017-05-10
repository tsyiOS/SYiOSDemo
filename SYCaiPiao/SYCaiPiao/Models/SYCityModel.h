//
//  SYCityModel.h
//  SYCaiPiao
//
//  Created by leju_esf on 17/5/8.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYProvinceModel : NSObject
@property (nonatomic, assign) NSInteger province_code;
@property (nonatomic, copy) NSString *province_name;
@property (nonatomic, assign) NSInteger order_value;
@property (nonatomic, assign) NSInteger region_id;
@property (nonatomic, strong) NSArray *citys;
+ (NSArray *)provinces;
@end

@interface SYCityModel : NSObject
@property (nonatomic, assign) NSInteger city_code;
@property (nonatomic, copy) NSString *city_name;
@property (nonatomic, assign) NSInteger order_value;
@property (nonatomic, assign) NSInteger parent_code;
@property (nonatomic, strong) NSArray *areas;
@end

@interface SYAreaModel : NSObject
@property (nonatomic, assign) NSInteger area_code;
@property (nonatomic, copy) NSString *area_name;
@property (nonatomic, assign) NSInteger order_value;
@property (nonatomic, assign) NSInteger parent_code;
@end
