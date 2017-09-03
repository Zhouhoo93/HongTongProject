//
//  CustomerListModel.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/9/1.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerListModel : NSObject
@property (nonatomic,copy) NSString *user_id;
@property (nonatomic,copy) NSString *nick;
@property (nonatomic,copy) NSString *headimgurl;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
