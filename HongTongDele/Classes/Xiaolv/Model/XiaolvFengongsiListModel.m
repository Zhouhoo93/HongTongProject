//
//  XiaolvFengongsiListModel.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/12/28.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "XiaolvFengongsiListModel.h"

@implementation XiaolvFengongsiListModel
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
