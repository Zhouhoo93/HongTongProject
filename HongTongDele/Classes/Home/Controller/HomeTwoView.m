//
//  HomeTwoView.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/11/20.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "HomeTwoView.h"
#import "ZhuangTaiListViewController.h"
@implementation HomeTwoView
- (IBAction)homeTwoBtnClcik:(id)sender {
    [self ClickBut:sender];
}

//代理方法, 通过BUT 下标 来滑动视图
- (void)ClickBut:(UIButton *)sender{
    if (self.Topdelegate && [self.Topdelegate respondsToSelector:@selector(transButIndex2)]) {
        //代理存在且有这个transButIndex:方法
        [self.Topdelegate transButIndex2];
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
