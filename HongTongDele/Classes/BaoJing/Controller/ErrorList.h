//
//  ErrorList.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/11/30.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol yichangDelegate <NSObject>//协议

- (void)CloseClick1;//协议方法
- (void)LeftClick1;//协议方法
- (void)RightClick1;//协议方法
- (void)bohaoBtnClick;
- (void)xinxiBtnClick;
- (void)daohangBtnClick;
- (void)weichuliClick;
- (void)chulizhongClick;
- (void)yichuliClick;
@end
@interface ErrorList : UIView<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *yunweiyijian;
@property (weak, nonatomic) IBOutlet UILabel *chulizhuangtai;
@property (weak, nonatomic) IBOutlet UILabel *tongxunzhuangtai;
@property (weak, nonatomic) IBOutlet UILabel *xiangqing;
@property (weak, nonatomic) IBOutlet UILabel *fadianliang;
@property (weak, nonatomic) IBOutlet UILabel *huhao;
@property (weak, nonatomic) IBOutlet UILabel *shoujihao;
@property (weak, nonatomic) IBOutlet UILabel *dizhi;
@property (weak, nonatomic) IBOutlet UILabel *gonglv;

@property (nonatomic, assign) id<yichangDelegate> delegate;//代理属性
- (void)ClickBut:(UIButton *)sender;//此方法执行时判断协议方法的执行情况
- (void)Left:(UIButton *)sender;//此方法执行时判断协议方法的执行情况
- (void)Right:(UIButton *)sender;//此方法执行时判断协议方法的执行情况
@end
