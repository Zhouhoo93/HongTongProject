//
//  townListModel.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/12/26.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface townListModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *townname;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
