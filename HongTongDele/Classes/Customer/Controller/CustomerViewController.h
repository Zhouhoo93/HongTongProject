//
//  CustomerViewController.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/8/9.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
@interface CustomerViewController : RCConversationListViewController<RCIMUserInfoDataSource,RCIMGroupInfoDataSource>
@property (nonatomic,copy)NSString *touxiang;
@property (nonatomic,copy)NSString *nicheng;
@property (nonatomic,copy)NSString *telNumber;
@end
