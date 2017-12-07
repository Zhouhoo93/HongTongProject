//
//  ErrorList.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/11/30.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "ErrorList.h"

@implementation ErrorList
- (IBAction)closeBtnClick:(id)sender {
    [self ClickBut1:sender];
}
- (IBAction)quxiaoBtnClick:(id)sender {
    [self Left1:sender];
}
- (IBAction)wanchengBtnClick:(id)sender {
    [self Right1:sender];
}
//代理方法, 通过BUT 下标 来滑动视图
- (void)ClickBut1:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(CloseClick1)]) {
        //代理存在且有这个transButIndex:方法
        [self.delegate CloseClick1];
    }
}

-(void)Left1:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(LeftClick1)]) {
        //代理存在且有这个transButIndex:方法
        [self.delegate LeftClick1];
    }
}

-(void)Right1:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(RightClick1)]) {
        //代理存在且有这个transButIndex:方法
        [self.delegate RightClick1];
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
