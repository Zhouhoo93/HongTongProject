//
//  HomeOneView.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/11/10.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TopButDelegate <NSObject>//协议

- (void)transButIndex;//协议方法
@end

@interface HomeOneView : UIView
@property (weak, nonatomic) IBOutlet UILabel *zongzhuangji;
@property (weak, nonatomic) IBOutlet UILabel *yifadian;
@property (weak, nonatomic) IBOutlet UILabel *wanchenglv;
@property (nonatomic, assign) id<TopButDelegate> Topdelegate;//代理属性
- (void)ClickBut:(UIButton *)sender;//此方法执行时判断协议方法的执行情况
@end
