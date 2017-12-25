//
//  GuanliModel.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/12/25.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuanliModel : NSObject
@property (nonatomic,copy) NSString *Handled;
@property (nonatomic,copy) NSString *InHandle;
@property (nonatomic,copy) NSString *handle;
@property (nonatomic,copy) NSString *handleAvg;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *responseAvg;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
