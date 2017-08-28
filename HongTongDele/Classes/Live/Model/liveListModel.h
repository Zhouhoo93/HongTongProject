//
//  liveListModel.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/8/28.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface liveListModel : NSObject
@property (nonatomic,copy) NSString *assistPwd;
@property (nonatomic,copy) NSString *creator;
@property (nonatomic,copy) NSString *onlineNum;
@property (nonatomic,copy) NSString *pic;
@property (nonatomic,copy) NSString *roomId;
@property (nonatomic,copy) NSString *status;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
