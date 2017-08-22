//
//  AlarmPopView.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/8/7.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "AlarmPopView.h"

@implementation AlarmPopView
- (IBAction)cancelBtnClick:(id)sender {
    [self.delegate cancelBtnClick];
}
- (IBAction)quedingBtnClick:(id)sender {
    [self.delegate cancelBtnClick];
}
- (IBAction)bohaoBtnClick:(id)sender {
    [self.delegate bohaoBtnClick];
}
- (IBAction)xinxiBtnClick:(id)sender {
    [self.delegate xinxiBtnClick];
}
- (IBAction)daohangBtnClick:(id)sender {
    [self.delegate daohangBtnClick];
}
- (IBAction)weichuli:(id)sender {
    [self.delegate weichuliBtnClick];
}
- (IBAction)chulizhong:(id)sender {
    [self.delegate chulizhongBtnClick];
}
- (IBAction)yichuli:(id)sender {
    [self.delegate yichuliBtnClick];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
