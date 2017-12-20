//
//  ShaiXuanYunWeiView.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/12/15.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "ShaiXuanYunWeiView.h"

@implementation ShaiXuanYunWeiView

- (IBAction)guanxiaoBtnClick:(id)sender {
    [self diqu:sender];
}
- (IBAction)leftBtnClick:(id)sender {
}
- (IBAction)rightBtnClick:(id)sender {
}
- (IBAction)closeBtnClick:(id)sender {
    [self ClickBut:sender];
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
-(void)diqu:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(diquClick)]) {
        //代理存在且有这个transButIndex:方法
        [self.delegate diquClick];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.huhao resignFirstResponder];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
