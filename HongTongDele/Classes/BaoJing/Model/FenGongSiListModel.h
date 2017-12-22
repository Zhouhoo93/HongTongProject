//
//  FenGongSiListModel.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/12/22.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FenGongSiListModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *address;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
