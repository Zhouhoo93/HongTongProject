//
//  XiaolvFengongsiListModel.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/12/28.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XiaolvFengongsiListModel : NSObject
@property (nonatomic,copy) NSString *company_id;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *total;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
