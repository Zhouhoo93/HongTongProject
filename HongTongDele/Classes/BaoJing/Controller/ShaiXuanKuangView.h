//
//  ShaiXuanKuangView.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/11/29.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ShaiXuanDelegate <NSObject>//协议

- (void)CloseClick;//协议方法
@end
@interface ShaiXuanKuangView : UIView
@property (nonatomic, assign) id<ShaiXuanDelegate> delegate;//代理属性
- (void)ClickBut:(UIButton *)sender;//此方法执行时判断协议方法的执行情况
@end
