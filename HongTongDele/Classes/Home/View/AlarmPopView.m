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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
