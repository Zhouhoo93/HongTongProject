//
//  shouyefengongsimodel.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/12/29.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface shouyefengongsimodel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *name;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end