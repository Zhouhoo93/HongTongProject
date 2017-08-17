//
//  MainModel.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/8/17.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainModel : NSObject
@property (nonatomic,strong) NSArray *full_access;
@property (nonatomic,strong) NSArray *installed_gross_capacity;
@property (nonatomic,strong) NSArray *part_access;
@property (nonatomic,strong) NSArray *power;
@property (nonatomic,strong) NSArray *today_gencap_income;
@property (nonatomic,strong) NSArray *today_self_occupied;
@property (nonatomic,strong) NSArray *today_up_ele_income;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
