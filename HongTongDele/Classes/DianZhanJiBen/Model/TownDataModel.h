//
//  TownDataModel.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/12/26.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TownDataModel : NSObject
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *bid;
@property (nonatomic,copy) NSString *completion_rate;
@property (nonatomic,copy) NSString *gen_cap;
@property (nonatomic,copy) NSString *house_id;
@property (nonatomic,copy) NSString *install_base;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
