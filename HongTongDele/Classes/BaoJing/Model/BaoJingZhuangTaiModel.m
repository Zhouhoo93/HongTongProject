//
//  BaoJingZhuangTaiModel.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/12/13.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "BaoJingZhuangTaiModel.h"

@implementation BaoJingZhuangTaiModel
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    if ([super init]) {
        //KVC赋值
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
