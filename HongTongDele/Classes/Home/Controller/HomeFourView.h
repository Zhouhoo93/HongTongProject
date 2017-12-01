//
//  HomeFourView.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/11/29.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TopButDelegate4 <NSObject>//协议

- (void)transButIndex4;//协议方法
- (void)XiaoLvlishi;
@end
@interface HomeFourView : UIView
@property (nonatomic, assign) id<TopButDelegate4> Topdelegate;//代理属性
- (void)ClickBut:(UIButton *)sender;//此方法执行时判断协议方法的执行情况
- (void)XiaoLvClick:(UIButton *)sender;//此方法执行时判断协议方法的执行情况
@end
