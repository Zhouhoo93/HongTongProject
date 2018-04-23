//
//  XiaoLvErrorModel.h
//  HongTongDele
//
//  Created by 天下 on 2018/4/23.
//  Copyright © 2018年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XiaoLvErrorModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *work_id;
@property (nonatomic,copy) NSString *result;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *abnormal_id;
@property (nonatomic,copy) NSString *police_id;
@property (nonatomic,copy) NSString *read;
@property (nonatomic,copy) NSString *created_at;
@property (nonatomic,copy) NSString *updated_at;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
