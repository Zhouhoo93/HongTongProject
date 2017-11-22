//
//  HomeThreeView.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/11/22.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "HomeThreeView.h"

@implementation HomeThreeView
- (IBAction)HomeThreeBtnClick:(id)sender {
    [self ClickBut:sender];
}
//代理方法, 通过BUT 下标 来滑动视图
- (void)ClickBut:(UIButton *)sender{
    if (self.Topdelegate && [self.Topdelegate respondsToSelector:@selector(transButIndex3)]) {
        //代理存在且有这个transButIndex:方法
        [self.Topdelegate transButIndex3];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
