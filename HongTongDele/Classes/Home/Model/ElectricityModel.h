//
//  ElectricityModel.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/8/17.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ElectricityModel : NSObject
@property (nonatomic,copy) NSString *access_way;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *area_id;
@property (nonatomic,copy) NSString *bid;
@property (nonatomic,copy) NSString *city_subsidies_time;
@property (nonatomic,copy) NSString *created_at;
@property (nonatomic,copy) NSString *gen_cap;
@property (nonatomic,copy) NSString *gen_fee;
@property (nonatomic,copy) NSString *gen_power;
@property (nonatomic,copy) NSString *gen_use_self_cap;
@property (nonatomic,copy) NSString *gen_use_self_fee;
@property (nonatomic,copy) NSString *house_id;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *income;
@property (nonatomic,copy) NSString *install_time;
@property (nonatomic,copy) NSString *installed_gross_capacity;
@property (nonatomic,copy) NSString *position;
@property (nonatomic,copy) NSString *province_subsidies_end_time;
@property (nonatomic,copy) NSString *small_agent_id;
@property (nonatomic,copy) NSString *state_subsidies_end_time;
@property (nonatomic,copy) NSString *town_subsidies_end_time;
@property (nonatomic,copy) NSString *up_net_ele;
@property (nonatomic,copy) NSString *up_net_fee;
@property (nonatomic,copy) NSString *updated_at;
@property (nonatomic,copy) NSString *use_ele_way;
@property (nonatomic,copy) NSString *village_id;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
