//
//  TwoScrollView.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/8/7.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^IndexBlock)(NSString *title,NSInteger index);
@interface TwoScrollView : UIView
@property (nonatomic, strong) UIColor    *lineColor;        //移动线的颜色(默认红色)
@property (nonatomic, assign) CGFloat    lineHeight;        //移动线的高度(默认2)
@property (nonatomic, assign) CGFloat    lineCornerRadius;  //移动线的两边弧度(默认3)
@property (nonatomic, copy  ) IndexBlock indexBlock;        //block回调(返回标题、下标)
/**
 *  设置控件位置
 *
 *  @param points 坐标
 *
 *  @return 对象
 */
+ (TwoScrollView *)sharedTabBar;
+ (TwoScrollView *)setTabBarPoint:(CGPoint)points;

/**
 *  设置数据源与属性
 *
 *  @param titles  每个选项的标题
 *  @param normal_color 默认颜色
 *  @param select_color 选中颜色
 *  @param font    字体
 */
- (void)setData:(NSArray *)titles NormalColor:(UIColor *)normal_color SelectColor:(UIColor *)select_color Font:(UIFont *)font;

/**
 *  得到移动的下标与内容
 *
 *  @param block 回调
 */
- (void)getViewIndex:(IndexBlock)block;

/**
 *  设置移动的位置
 *
 *  @param index 下标
 */
+ (void)setViewIndex:(NSInteger)index;
- (void)setViewIndex1:(NSInteger)index;
- (void)setlineFrame:(NSInteger)index;
@end
