//
//  XiaoLvWorkListModel.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/12/28.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XiaoLvWorkListModel : NSObject
@property (nonatomic,copy) NSString *brand_specification;
@property (nonatomic,copy) NSString *reduce_effect;
@property (nonatomic,copy) NSString *town_name;
@property (nonatomic,copy) NSString *work_id;
@property (nonatomic,copy) NSString *work_name;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
