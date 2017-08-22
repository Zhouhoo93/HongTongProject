//
//  MenuTableViewCell.h
//  MenuDemo
//
//  Created by Zhouhoo on 2017/8/7.
//  Copyright © 2017年 Lying. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TopButtonDelegate <NSObject>//协议

- (void)hideCell:(NSInteger)tag;//协议方法

@end
@interface MenuTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleTipLabel;
@property (weak, nonatomic) IBOutlet UIButton *FirstBtn;
@property (weak, nonatomic) IBOutlet UIButton *SecondBtn;
@property (weak, nonatomic) IBOutlet UIButton *ThiredBtn;
@property (nonatomic, assign) id<TopButtonDelegate>delegate;//代理属性
@end
