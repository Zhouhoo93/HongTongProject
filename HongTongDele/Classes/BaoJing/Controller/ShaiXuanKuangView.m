//
//  ShaiXuanKuangView.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/11/29.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "ShaiXuanKuangView.h"

@implementation ShaiXuanKuangView
- (IBAction)chongzhiBtnClick:(id)sender {
}
- (IBAction)wanchengBtnClick:(id)sender {
}
- (IBAction)CloseBtnClick:(id)sender {
    [self ClickBut:sender];
}
- (IBAction)leftTimeSelect:(id)sender {
    [self Left:sender];
}
- (IBAction)rightTimeSelect:(id)sender {
    [self Right:sender];
}

//代理方法, 通过BUT 下标 来滑动视图
- (void)ClickBut:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(CloseClick)]) {
        //代理存在且有这个transButIndex:方法
        [self.delegate CloseClick];
    }
}

-(void)Left:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(LeftClick)]) {
        //代理存在且有这个transButIndex:方法
        [self.delegate LeftClick];
    }
}

-(void)Right:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(RightClick)]) {
        //代理存在且有这个transButIndex:方法
        [self.delegate RightClick];
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
