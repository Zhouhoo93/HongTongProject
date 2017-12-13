//
//  HomeTwoView.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/11/20.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TopButDelegate2 <NSObject>//协议

- (void)transButIndex2;//协议方法
@end
@interface HomeTwoView : UIView
@property (weak, nonatomic) IBOutlet UILabel *baojingdianzhan;
@property (weak, nonatomic) IBOutlet UILabel *lixian;
@property (weak, nonatomic) IBOutlet UILabel *yichang;
@property (weak, nonatomic) IBOutlet UILabel *guzhang;
@property (nonatomic, assign) id<TopButDelegate2> Topdelegate;//代理属性
- (void)ClickBut:(UIButton *)sender;//此方法执行时判断协议方法的执行情况
@end
