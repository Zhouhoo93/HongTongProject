//
//  HomeFourView.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/11/29.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "HomeFourView.h"

@implementation HomeFourView
- (IBAction)BtnClick:(id)sender {
    [self ClickBut:sender];
}
//代理方法, 通过BUT 下标 来滑动视图
- (void)ClickBut:(UIButton *)sender{
    if (self.Topdelegate && [self.Topdelegate respondsToSelector:@selector(transButIndex4)]) {
        //代理存在且有这个transButIndex:方法
        [self.Topdelegate transButIndex4];
    }
}

-(void)XiaoLvClick:(UIButton *)sender{
    if (self.Topdelegate && [self.Topdelegate respondsToSelector:@selector(XiaoLvlishi)]) {
        //代理存在且有这个transButIndex:方法
        [self.Topdelegate XiaoLvlishi];
    }
}

- (IBAction)lishiBtnClick:(id)sender {
    [self XiaoLvClick:sender];
    
}
@end
