//
//  HomeThreeView.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/11/22.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TopButDelegate3 <NSObject>//协议

- (void)transButIndex3;//协议方法
- (void)BaoJinglishi;
@end
@interface HomeThreeView : UIView
@property (nonatomic, assign) id<TopButDelegate3> Topdelegate;//代理属性
- (void)ClickBut:(UIButton *)sender;//此方法执行时判断协议方法的执行情况
- (void)BaoJingClick:(UIButton *)sender;//此方法执行时判断协议方法的执行情况
@end
