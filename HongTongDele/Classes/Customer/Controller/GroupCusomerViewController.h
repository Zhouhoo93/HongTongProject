//
//  GroupCusomerViewController.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/9/6.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import "CustomerListModel.h"
@interface GroupCusomerViewController : RCConversationViewController
@property (nonatomic,copy)NSString *group;
@property (nonatomic,copy)NSString *telNumber;
@property (nonatomic,copy)NSString *touxiang;
@property (nonatomic,copy)NSString *nicheng;
@property (nonatomic,strong)CustomerListModel *model;
@property (nonatomic,copy)NSMutableArray *groupArr;
@property (nonatomic,copy)NSMutableArray *dataArr;
@end
