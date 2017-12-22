//
//  FenGongSiDataModel.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/12/22.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FenGongSiDataModel : NSObject
@property (nonatomic,copy) NSString *home;
@property (nonatomic,copy) NSString *total;
@property (nonatomic,copy) NSString *town_id;
@property (nonatomic,copy) NSString *town_name;
@property (nonatomic,copy) NSString *work_id;
@property (nonatomic,copy) NSString *work_name;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end