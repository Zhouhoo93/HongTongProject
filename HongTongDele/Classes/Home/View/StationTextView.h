//
//  StationTextView.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/11/16.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TopButDelegate <NSObject>//协议

- (void)transButIndex;//协议方法
- (void)xinxiBtnClick:(NSString *)tel;
- (void)bohaoBtnClick:(NSString *)tel;
@end
@interface StationTextView : UIView
@property (nonatomic, assign) id<TopButDelegate>delegate;//代理属性
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel1;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewToTopMas;
@property (weak, nonatomic) IBOutlet UILabel *wuding1;
@property (weak, nonatomic) IBOutlet UILabel *wuding2;
@property (weak, nonatomic) IBOutlet UILabel *zhuangji1;
@property (weak, nonatomic) IBOutlet UILabel *zhuangji2;
@property (weak, nonatomic) IBOutlet UILabel *chaoxiang1;
@property (weak, nonatomic) IBOutlet UILabel *chaoxiang2;
@property (weak, nonatomic) IBOutlet UILabel *jiaodu1;
@property (weak, nonatomic) IBOutlet UILabel *jiaodu2;
@property (weak, nonatomic) IBOutlet UILabel *taiqu1;
@property (weak, nonatomic) IBOutlet UILabel *taiqu2;
@property (weak, nonatomic) IBOutlet UILabel *xianlu1;
@property (weak, nonatomic) IBOutlet UILabel *xianlu2;
@property (weak, nonatomic) IBOutlet UILabel *ganhao1;
@property (weak, nonatomic) IBOutlet UILabel *ganhao2;
@property (weak, nonatomic) IBOutlet UILabel *zujian1;
@property (weak, nonatomic) IBOutlet UILabel *zujian2;
@property (weak, nonatomic) IBOutlet UILabel *guige1;
@property (weak, nonatomic) IBOutlet UILabel *guige2;
@property (weak, nonatomic) IBOutlet UILabel *shuliang1;
@property (weak, nonatomic) IBOutlet UILabel *shuliang2;
@property (weak, nonatomic) IBOutlet UILabel *nibianqi1;
@property (weak, nonatomic) IBOutlet UILabel *nibianqi2;
@property (weak, nonatomic) IBOutlet UILabel *guige3;
@property (weak, nonatomic) IBOutlet UILabel *guige4;
@property (weak, nonatomic) IBOutlet UILabel *taishu1;
@property (weak, nonatomic) IBOutlet UILabel *taishu2;
@property (weak, nonatomic) IBOutlet UILabel *bingwang1;
@property (weak, nonatomic) IBOutlet UILabel *bingwang2;
@property (weak, nonatomic) IBOutlet UILabel *bingwangfangshi1;
@property (weak, nonatomic) IBOutlet UILabel *bingwangfangshi2;
@property (weak, nonatomic) IBOutlet UIView *canshuView;

- (void)ClickBut;//此方法执行时判断协议方法的执行情况
@end
