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
- (void)LeftClick;//协议方法
- (void)RightClick;//协议方法
@end
@interface ShaiXuanKuangView : UIView
@property (weak, nonatomic) IBOutlet UIButton *rightTimeBtn;

@property (weak, nonatomic) IBOutlet UIButton *leftTimeBtn;
@property (nonatomic, assign) id<ShaiXuanDelegate> delegate;//代理属性
- (void)ClickBut:(UIButton *)sender;//此方法执行时判断协议方法的执行情况
- (void)Left:(UIButton *)sender;//此方法执行时判断协议方法的执行情况
- (void)Right:(UIButton *)sender;//此方法执行时判断协议方法的执行情况
@end
