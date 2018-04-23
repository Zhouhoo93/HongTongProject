//
//  HuiZhiViewController.h
//  HongTongDele
//
//  Created by 天下 on 2018/4/23.
//  Copyright © 2018年 xinyuntec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XiaoLvErrorModel.h"
@interface HuiZhiViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *huhaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *shebeibianhaolabel;
@property (weak, nonatomic) IBOutlet UILabel *chulishijianLabel;
@property (weak, nonatomic) IBOutlet UILabel *chuliyuanyinLabel;
@property (weak, nonatomic) IBOutlet UILabel *shehejielunLabel;
@property (nonatomic,strong) XiaoLvErrorModel *model;
@end
