//
//  StationListModel.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/8/23.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "StationListModel.h"

@implementation StationListModel
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
