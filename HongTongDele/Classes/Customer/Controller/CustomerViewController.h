//
//  CustomerViewController.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/8/9.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import "CustomerListModel.h"
@interface CustomerViewController : RCConversationListViewController<RCIMUserInfoDataSource,RCIMGroupInfoDataSource,RCIMGroupMemberDataSource,RCIMGroupUserInfoDataSource>
@property (nonatomic,copy)NSString *touxiang;
@property (nonatomic,copy)NSString *nicheng;
@property (nonatomic,copy)NSString *telNumber;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableArray *grouparr;
@property (nonatomic,strong)NSString *group;
@property (nonatomic,strong)CustomerListModel *model;
@end
