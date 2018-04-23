//
//  XiaoLvErrorModel.m
//  HongTongDele
//
//  Created by 天下 on 2018/4/23.
//  Copyright © 2018年 xinyuntec. All rights reserved.
//

#import "XiaoLvErrorModel.h"

@implementation XiaoLvErrorModel
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
