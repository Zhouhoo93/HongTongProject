//
//  StationListModel.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/8/23.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StationListModel : NSObject
@property (nonatomic,copy) NSString *home;
@property (nonatomic,copy) NSString *nature;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
