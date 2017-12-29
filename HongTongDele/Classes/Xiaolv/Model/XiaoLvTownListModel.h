//
//  XiaoLvTownListModel.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/12/29.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XiaoLvTownListModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *townname;
@property (nonatomic,copy) NSString *area_id;
@property (nonatomic,copy) NSString *created_at;
@property (nonatomic,copy) NSString *updated_at;
@property (nonatomic,copy) NSString *total;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
