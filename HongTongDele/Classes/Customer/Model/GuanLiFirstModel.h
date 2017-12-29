//
//  GuanLiFirstModel.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/12/29.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuanLiFirstModel : NSObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *offlineTotal;
@property (nonatomic,copy) NSString *abnormalTotal;
@property (nonatomic,copy) NSString *faultTotal;
@property (nonatomic,copy) NSString *Total;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
