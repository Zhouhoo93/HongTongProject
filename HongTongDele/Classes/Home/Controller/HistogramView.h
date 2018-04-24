//
//  HistogramView.h
//  zhuzhuang
//
//  Created by Zhouhoo on 2017/4/11.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistogramView : UIView
@property (nonatomic,strong)UILabel *xLabel;
@property (nonatomic,strong)UILabel *yLabel;
@property (nonatomic,strong)NSArray *arr;
@property (nonatomic,strong)NSArray *arr1;
@property (nonatomic,strong)NSArray *arr2;
@property (nonatomic,strong)NSArray *arr3;
@property (nonatomic,strong)NSArray *arr4;
@property (nonatomic,assign)NSInteger maxAll;
@property (nonatomic,assign)CGFloat maxNumber;
@property (nonatomic,assign) NSInteger num;
@end
