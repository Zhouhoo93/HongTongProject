//
//  YunWeiListModel.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/12/22.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YunWeiListModel : NSObject
@property (nonatomic,copy) NSString *addr;
@property (nonatomic,copy) NSString *bid;
@property (nonatomic,copy) NSString *cause;
@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *home;
@property (nonatomic,copy) NSString *nature;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
