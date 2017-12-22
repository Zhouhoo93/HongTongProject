//
//  ErrorListtwo.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/11/30.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol yichangDelegate <NSObject>//协议

- (void)CloseClick;//协议方法
- (void)LeftClick;//协议方法
- (void)RightClick;//协议方法
@end
@interface ErrorListtwo : UIView
@property (nonatomic, assign) id<yichangDelegate> delegate;//代理属性
- (void)ClickBut:(UIButton *)sender;//此方法执行时判断协议方法的执行情况
- (void)Left:(UIButton *)sender;//此方法执行时判断协议方法的执行情况
- (void)Right:(UIButton *)sender;//此方法执行时判断协议方法的执行情况
@end