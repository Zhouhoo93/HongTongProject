//
//  HomeSelectViewController.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/8/4.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChangeName  //协议
-(void)changeName:(NSString*)string;
@end
@interface HomeSelectViewController : UIViewController
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,weak)id<ChangeName>delegate; //代理
@end
