//
//  addPosListModel.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/9/4.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface addPosListModel : NSObject
@property (nonatomic,copy) NSString *area;
@property (nonatomic,copy) NSString *position;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
