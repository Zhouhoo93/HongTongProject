//
//  ZhuangTaiYunWeiModel.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/12/20.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZhuangTaiYunWeiModel : NSObject
@property (nonatomic,copy) NSString *addr;
@property (nonatomic,copy) NSString *bid;
@property (nonatomic,copy) NSString *cause;
@property (nonatomic,copy) NSString *created_at;
@property (nonatomic,copy) NSString *home;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *nature;
@property (nonatomic,copy) NSString *police_id;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *work;
@property (nonatomic,copy) NSString *work_id;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
