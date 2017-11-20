//
//  StationTextView.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/11/16.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "StationTextView.h"

@implementation StationTextView
- (IBAction)canshuBtnClick:(id)sender {
    if(self.viewToTopMas.constant == 170 ){
        [self ClickBut];
        self.viewToTopMas.constant = 34;
        self.wuding1.hidden = YES;
        self.wuding2.hidden = YES;
        self.zhuangji1.hidden = YES;
        self.zhuangji2.hidden = YES;
        self.chaoxiang1.hidden = YES;
        self.chaoxiang2.hidden = YES;
        self.jiaodu1.hidden = YES;
        self.jiaodu2.hidden = YES;
        self.taiqu1.hidden = YES;
        self.taiqu2.hidden = YES;
        self.xianlu1.hidden = YES;
        self.xianlu2.hidden = YES;
        self.ganhao1.hidden = YES;
        self.ganhao2.hidden = YES;
        self.zujian1.hidden = YES;
        self.zujian2.hidden = YES;
        self.guige1.hidden = YES;
        self.guige2.hidden = YES;
        self.shuliang1.hidden = YES;
        self.shuliang2.hidden = YES;
        self.nibianqi1.hidden = YES;
        self.nibianqi2.hidden = YES;
        self.guige3.hidden = YES;
        self.guige4.hidden = YES;
        self.taishu1.hidden = YES;
        self.taishu2.hidden = YES;
        self.bingwang1.hidden = YES;
        self.bingwang2.hidden = YES;
        self.bingwangfangshi1.hidden = YES;
        self.bingwangfangshi2.hidden = YES;
        self.canshuView.hidden = YES;
    }else{
        [self ClickBut];
        self.viewToTopMas.constant = 170;
        self.wuding1.hidden = NO;
        self.wuding2.hidden = NO;
        self.zhuangji1.hidden = NO;
        self.zhuangji2.hidden = NO;
        self.chaoxiang1.hidden = NO;
        self.chaoxiang2.hidden = NO;
        self.jiaodu1.hidden = NO;
        self.jiaodu2.hidden = NO;
        self.taiqu1.hidden = NO;
        self.taiqu2.hidden = NO;
        self.xianlu1.hidden = NO;
        self.xianlu2.hidden = NO;
        self.ganhao1.hidden = NO;
        self.ganhao2.hidden = NO;
        self.zujian1.hidden = NO;
        self.zujian2.hidden = NO;
        self.guige1.hidden = NO;
        self.guige2.hidden = NO;
        self.shuliang1.hidden = NO;
        self.shuliang2.hidden = NO;
        self.nibianqi1.hidden = NO;
        self.nibianqi2.hidden = NO;
        self.guige3.hidden = NO;
        self.guige4.hidden = NO;
        self.taishu1.hidden = NO;
        self.taishu2.hidden = NO;
        self.bingwang1.hidden = NO;
        self.bingwang2.hidden = NO;
        self.bingwangfangshi1.hidden = NO;
        self.bingwangfangshi2.hidden = NO;
        self.canshuView.hidden = NO;
    }
    
}
- (void)ClickBut{
    if (self.delegate && [self.delegate respondsToSelector:@selector(transButIndex)]) {
        //代理存在且有这个transButIndex:方法
        [self.delegate transButIndex];
    }
}
- (IBAction)bohaoBtnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bohaoBtnClick:)]) {
        //代理存在且有这个transButIndex:方法
        [self.delegate bohaoBtnClick:self.telLabel.text];
    }
}
- (IBAction)xinxiBtnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xinxiBtnClick:)]) {
        //代理存在且有这个transButIndex:方法
        [self.delegate xinxiBtnClick:self.telLabel.text];
    }
}
- (IBAction)daohangBtnClick:(id)sender {
}
- (IBAction)zhengchangBtnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(zhengchangBtnClick)]) {
        //代理存在且有这个transButIndex:方法
        [self.delegate zhengchangBtnClick];
    }
}
- (IBAction)lixianBtnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(lixianBtnClick)]) {
        //代理存在且有这个transButIndex:方法
        [self.delegate lixianBtnClick];
    }
}
- (IBAction)yichangBtnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(yichangBtnClick)]) {
        //代理存在且有这个transButIndex:方法
        [self.delegate yichangBtnClick];
    }
}
- (IBAction)guzhangBtnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(guzhangBtnClick)]) {
        //代理存在且有这个transButIndex:方法
        [self.delegate guzhangBtnClick];
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
