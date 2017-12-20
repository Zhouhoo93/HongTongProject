//
//  ShaiXuanYunWeiView.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/12/15.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ShaiXuanYunWeiDelegate <NSObject>//协议

- (void)CloseClick;//协议方法
- (void)LeftClick;//协议方法
- (void)RightClick;//协议方法
- (void)diquClick;//协议方法
@end
@interface ShaiXuanYunWeiView : UIView
@property (weak, nonatomic) IBOutlet UITextField *huhao;
@property (weak, nonatomic) IBOutlet UIButton *guanxiaBtn;
@property (nonatomic, assign) id<ShaiXuanYunWeiDelegate> delegate;//代理属性
- (void)ClickBut:(UIButton *)sender;//此方法执行时判断协议方法的执行情况
- (void)Left:(UIButton *)sender;//此方法执行时判断协议方法的执行情况
- (void)Right:(UIButton *)sender;//此方法执行时判断协议方法的执行情况
- (void)diqu:(UIButton *)sender;//此方法执行时判断协议方法的执行情况
@end
