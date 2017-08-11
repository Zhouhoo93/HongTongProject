//
//  AlarmPopView.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/8/7.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <UIKit/UIKit.h>
//协议定义
@protocol UpdateAlertDelegate <NSObject>
- (void)cancelBtnClick;
@end
@interface AlarmPopView : UIView
//遵循协议的一个代理变量定义
@property (nonatomic, weak) id<UpdateAlertDelegate> delegate;
@end
