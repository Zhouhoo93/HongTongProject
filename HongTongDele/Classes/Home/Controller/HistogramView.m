//
//  HistogramView.m
//  zhuzhuang
//
//  Created by Zhouhoo on 2017/4/11.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "HistogramView.h"

@implementation HistogramView

- (void)drawRect:(CGRect)rect {

    
    //颜色数组
    NSArray *colorArr = @[RGBColor(164, 0, 0), RGBColor(164, 0, 0), RGBColor(164, 0, 0),RGBColor(164, 0, 0),RGBColor(164, 0, 0),RGBColor(164, 0, 0),RGBColor(164, 0, 0),RGBColor(164, 0, 0),RGBColor(164, 0, 0),RGBColor(164, 0, 0),RGBColor(164, 0, 0),RGBColor(164, 0, 0),RGBColor(164, 0, 0), RGBColor(164, 0, 0), RGBColor(164, 0, 0),RGBColor(164, 0, 0),RGBColor(164, 0, 0),RGBColor(164, 0, 0),RGBColor(164, 0, 0),RGBColor(164, 0, 0),RGBColor(164, 0, 0),RGBColor(164, 0, 0),RGBColor(164, 0, 0),RGBColor(164, 0, 0)];
    NSArray *colorArr1 = @[RGBColor(255, 191, 57), RGBColor(255, 191, 57), RGBColor(255, 191, 57),RGBColor(255, 191, 57),RGBColor(255, 191, 57),RGBColor(255, 191, 57),RGBColor(255, 191, 57),RGBColor(255, 191, 57),RGBColor(255, 191, 57),RGBColor(255, 191, 57),RGBColor(255, 191, 57),RGBColor(255, 191, 57),RGBColor(255, 191, 57), RGBColor(255, 191, 57), RGBColor(255, 191, 57),RGBColor(255, 191, 57),RGBColor(255, 191, 57),RGBColor(255, 191, 57),RGBColor(255, 191, 57),RGBColor(255, 191, 57),RGBColor(255, 191, 57),RGBColor(255, 191, 57),RGBColor(255, 191, 57),RGBColor(255, 191, 57)];
    NSArray *colorArr2 = @[RGBColor(24, 138, 0), RGBColor(24, 138, 0), RGBColor(24, 138, 0),RGBColor(24, 138, 0),RGBColor(0, 60, 255),RGBColor(0, 60, 255),RGBColor(0, 60, 255),RGBColor(0, 60, 255),RGBColor(0, 60, 255),RGBColor(0, 60, 255),RGBColor(0, 60, 255),RGBColor(24, 138, 0),RGBColor(0, 60, 255), RGBColor(0, 60, 255),RGBColor(0, 60, 255),RGBColor(0, 60, 255),RGBColor(0, 60, 255),RGBColor(0, 60, 255),RGBColor(0, 60, 255),RGBColor(0, 60, 255),RGBColor(0, 60, 255),RGBColor(0, 60, 255),RGBColor(0, 60, 255),RGBColor(0, 60, 255)];
    NSArray *colorArr3 = @[RGBColor(24, 138, 0), RGBColor(24, 138, 0), RGBColor(24, 138, 0),RGBColor(24, 138, 0),RGBColor(0, 60, 255),RGBColor(0, 60, 255),RGBColor(0, 60, 255),RGBColor(0, 60, 255),RGBColor(0, 60, 255),RGBColor(0, 60, 255),RGBColor(0, 60, 255),RGBColor(24, 138, 0),RGBColor(0, 60, 255), RGBColor(0, 60, 255),RGBColor(24, 138, 0),RGBColor(24, 138, 0),RGBColor(24, 138, 0),RGBColor(24, 138, 0),RGBColor(24, 138, 0),RGBColor(24, 138, 0),RGBColor(24, 138, 0)];

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat viewW = self.bounds.size.width-50;
    CGFloat viewH = self.bounds.size.height-40;
    
    NSUInteger count = _arr.count;
    CGFloat w = viewW / (12 * 4 );
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat y1 = 0;
    CGFloat y2 = 0;
    CGFloat y3 = 0;
    CGFloat h = 0;
    CGFloat h1 = 0;
    CGFloat h2 = 0;
    CGFloat h3 = 0;
    for (int i = 0; i < count; i ++) {
        
        x = i * w * 4+w+25;
        CGFloat hhh = [_arr[i] floatValue];
        CGFloat hhh1 = [_arr1[i] floatValue];
        CGFloat hhh2 = [_arr2[i] floatValue];
        CGFloat hhh3 = [_arr3[i] floatValue];
        if (hhh==0) {
            h=0;
        }else{
           h = ([_arr[i] floatValue] / _maxNumber) * viewH;
        }
        if (hhh1==0) {
            h1=0;
        }else{
        h1 = ([_arr1[i] floatValue] / _maxNumber) * viewH;
        }
        if (hhh2==0) {
            h2=0;
        }else{

        h2 = ([_arr2[i] floatValue] / _maxNumber) * viewH;
        }
        if (hhh3==0) {
            h3=0;
        }else{
        h3 = ([_arr3[i] floatValue] / _maxNumber) * viewH;
        }
        y = viewH - h+16;
        y1 = viewH - h1+16;
        y2 = viewH - h2+16;
        y3 = viewH - h3+16;
        //画矩形柱体
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(x, y, w, h)];
        
        //填充对应颜色
        [(UIColor *)colorArr[i] set];
        
        CGContextAddPath(ctx, path.CGPath);
        
        //注意是Fill, 而不是Stroke, 这样才可以填充矩形区域
        CGContextFillPath(ctx);
        
        
        //文本绘制
        NSString *str = [NSString stringWithFormat:@"%.2f", [_arr[i] floatValue]];
        
        //创建文字属性字典
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[NSFontAttributeName] = [UIFont systemFontOfSize:13];
        dic[NSForegroundColorAttributeName] = [UIColor blackColor];
        //设置笔触宽度
        dic[NSStrokeWidthAttributeName] = @1;
        
        //设置文字矩形的左上角位置,并且不会自动换行
        CGPoint p = CGPointMake(x + w * 0.25, y - 20);
        
        //drawInRect:会自动换行
        //drawAtPoint:不会自动换行
//        [str drawAtPoint:p withAttributes:dic];
        //--------------重叠的图------
        //画矩形柱体
        UIBezierPath *path1 = [UIBezierPath bezierPathWithRect:CGRectMake(x, y-h1, w, h1)];
        
        //填充对应颜色
        [(UIColor *)colorArr1[i] set];
        
        CGContextAddPath(ctx, path1.CGPath);
        
        //注意是Fill, 而不是Stroke, 这样才可以填充矩形区域
        CGContextFillPath(ctx);
        
       
//        //文本绘制
//        NSString *str1 = [NSString stringWithFormat:@"%ld", [_arr1[i] longValue]];
//        
//        //创建文字属性字典
//        NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
//        dic1[NSFontAttributeName] = [UIFont systemFontOfSize:13];
//        dic1[NSForegroundColorAttributeName] = [UIColor blackColor];
//        //设置笔触宽度
//        dic[NSStrokeWidthAttributeName] = @1;
//        
//        //设置文字矩形的左上角位置,并且不会自动换行
//        CGPoint p1 = CGPointMake(x + w * 0.25, y1 - 20);
        
        //drawInRect:会自动换行
        //drawAtPoint:不会自动换行
//        [str1 drawAtPoint:p1 withAttributes:dic1];
//---------------右边的柱状---------------
        //画矩形柱体
        UIBezierPath *path2 = [UIBezierPath bezierPathWithRect:CGRectMake(x+w, y2, w, h2)];
        
        //填充对应颜色
        [(UIColor *)colorArr2[i] set];
        
        CGContextAddPath(ctx, path2.CGPath);
        
        //注意是Fill, 而不是Stroke, 这样才可以填充矩形区域
        CGContextFillPath(ctx);
        
//        //文本绘制
//        NSString *str2 = [NSString stringWithFormat:@"%ld", [_arr2[i] longValue]];
//        
//        //创建文字属性字典
//        NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
//        dic2[NSFontAttributeName] = [UIFont systemFontOfSize:13];
//        dic2[NSForegroundColorAttributeName] = [UIColor blackColor];
//        //设置笔触宽度
//        dic2[NSStrokeWidthAttributeName] = @1;
//        
//        //设置文字矩形的左上角位置,并且不会自动换行
//        CGPoint p2 = CGPointMake(x+w + w * 0.25, y2 - 20);
        
        //drawInRect:会自动换行
        //drawAtPoint:不会自动换行
//        [str2 drawAtPoint:p2 withAttributes:dic2];
        //--------------重叠的图------
        //画矩形柱体
        UIBezierPath *path3 = [UIBezierPath bezierPathWithRect:CGRectMake(x+w, y2-h3, w, h3)];
        
        //填充对应颜色
        [(UIColor *)colorArr3[i] set];
        
        CGContextAddPath(ctx, path3.CGPath);
        
        //注意是Fill, 而不是Stroke, 这样才可以填充矩形区域
        CGContextFillPath(ctx);
        
        //文本绘制
//        NSString *str3 = [NSString stringWithFormat:@"%ld", [_arr3[i] longValue]];
//        
//        //创建文字属性字典
//        NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];
//        dic3[NSFontAttributeName] = [UIFont systemFontOfSize:13];
//        dic3[NSForegroundColorAttributeName] = [UIColor blackColor];
//        //设置笔触宽度
//        dic3[NSStrokeWidthAttributeName] = @1;
//        
//        //设置文字矩形的左上角位置,并且不会自动换行
//        CGPoint p3 = CGPointMake(x + w * 0.25, y1 - 20);
//        
        //drawInRect:会自动换行
        //drawAtPoint:不会自动换行
        //        [str1 drawAtPoint:p1 withAttributes:dic1];
       
    }
}
@end
