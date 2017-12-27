//
//  FenGongSiListModelTwo.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/12/26.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FenGongSiListModelTwo : NSObject
@property (nonatomic,copy) NSString *completion_rate;
@property (nonatomic,copy) NSString *role;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *total_gen_cap;
@property (nonatomic,copy) NSString *total_install_base;
@property (nonatomic,copy) NSString *total_number_households;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
