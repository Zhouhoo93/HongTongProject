//
//  ErrorListtwo.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/11/30.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "ErrorListtwo.h"

@implementation ErrorListtwo
- (IBAction)closeBtnClick:(id)sender {
    [self ClickBut:sender];
}
- (IBAction)quxiaoBtnClick:(id)sender {
    [self Left:sender];
}
- (IBAction)wanchengBtnClick:(id)sender {
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
- (IBAction)bohap:(id)sender {
    [self.delegate bohaoBtnClick];
}
- (IBAction)xinxi:(id)sender {
    [self.delegate xinxiBtnClick];
}
- (IBAction)daohang:(id)sender {
    [self.delegate daohangBtnClick];
}
- (IBAction)weichuli:(id)sender {
    [self.delegate weichuliClick];
}
- (IBAction)chulizhong:(id)sender {
    [self.delegate chulizhongClick];
}
- (IBAction)yichuli:(id)sender {
    [self.delegate yichuliClick];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
