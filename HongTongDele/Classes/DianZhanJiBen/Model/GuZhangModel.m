//
//  GuZhangModel.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/12/21.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "GuZhangModel.h"

@implementation GuZhangModel
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    if ([super init]) {
        //KVC赋值
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}
@end
