//
//  CustomerListModel.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/9/1.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerListModel : NSObject
@property (nonatomic,copy) NSString *addr;
@property (nonatomic,copy) NSString *bid;
@property (nonatomic,copy) NSString *created_at;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *middle_agents_id;
@property (nonatomic,copy) NSString *pic;
@property (nonatomic,copy) NSString *register_id;
@property (nonatomic,copy) NSString *rong_token;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *tel;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *updated_at;
@property (nonatomic,copy) NSString *username;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
