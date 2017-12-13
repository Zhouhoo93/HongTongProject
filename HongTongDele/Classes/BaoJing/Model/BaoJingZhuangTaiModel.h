//
//  BaoJingZhuangTaiModel.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/12/13.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaoJingZhuangTaiModel : NSObject
@property (nonatomic,copy) NSString *abnormalTotal;
@property (nonatomic,copy) NSString *company_id;
@property (nonatomic,copy) NSString *faultTotal;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *offlineTotal;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
