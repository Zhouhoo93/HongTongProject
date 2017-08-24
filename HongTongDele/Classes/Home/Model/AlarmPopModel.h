//
//  AlarmPopModel.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/8/23.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlarmPopModel : NSObject
@property (nonatomic,copy) NSString *addr;
@property (nonatomic,copy) NSString *bid;
@property (nonatomic,copy) NSString *cause;
@property (nonatomic,copy) NSString *created_at;
@property (nonatomic,copy) NSString *ele_gen;
@property (nonatomic,copy) NSString *happen_time;
@property (nonatomic,copy) NSString *home;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *nature;
@property (nonatomic,copy) NSString *power;
@property (nonatomic,copy) NSString *small_agent_id;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *tel;
@property (nonatomic,copy) NSString *updated_at;
- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
