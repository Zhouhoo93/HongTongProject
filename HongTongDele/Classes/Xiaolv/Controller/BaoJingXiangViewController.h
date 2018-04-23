//
//  BaoJingXiangViewController.h
//  HongTongDele
//
//  Created by 天下 on 2018/4/23.
//  Copyright © 2018年 xinyuntec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XiaoLvBaoJingModel.h"
@interface BaoJingXiangViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *huhaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *shebeibianhaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *baojingyuanyinLabel;
@property (weak, nonatomic) IBOutlet UILabel *chulizhuangtaiLabel;
@property (weak, nonatomic) IBOutlet UILabel *dizhiLabel;
@property (weak, nonatomic) IBOutlet UILabel *fashengshijianLabel;
@property (weak, nonatomic) IBOutlet UILabel *xiangyingshijianLabel;
@property (nonatomic,strong)XiaoLvBaoJingModel *model;
@end
