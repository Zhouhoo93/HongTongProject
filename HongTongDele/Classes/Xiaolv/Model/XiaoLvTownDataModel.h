//
//  XiaoLvTownDataModel.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/12/29.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XiaoLvTownDataModel : NSObject
@property (nonatomic,copy) NSString *addr;
@property (nonatomic,copy) NSString *bid;
@property (nonatomic,copy) NSString *brand_specifications;
@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *home;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *reduce_effect;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
