//
//  GuZhangModel.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/12/21.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuZhangModel : NSObject
@property (nonatomic,copy) NSString *bid;
@property (nonatomic,copy) NSString *cause;
@property (nonatomic,copy) NSString *created_at;
@property (nonatomic,copy) NSString *handleTime;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *nature;
@property (nonatomic,copy) NSString *responseTime;
@property (nonatomic,copy) NSString *status;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
