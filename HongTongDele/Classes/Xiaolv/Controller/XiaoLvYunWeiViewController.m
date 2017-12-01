//
//  XiaoLvYunWeiViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/11/29.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "XiaoLvYunWeiViewController.h"
#import "JHTableChart.h"
#import "XiaoLvHuViewController.h"
@interface XiaoLvYunWeiViewController ()<UIScrollViewDelegate,TableButDelegate>
@property (nonatomic,strong)UIScrollView *bgscrollview;
@property (nonatomic,strong)UIScrollView *bgscrollview1;
@property (nonatomic,strong)UIScrollView *bg;
@property (nonatomic,strong)UIView *leftView;
@property (nonatomic,strong)UIView *rightView;
@property (nonatomic,strong)JHTableChart *table1;
@property (nonatomic,strong)JHTableChart *table11;
@property (nonatomic,strong)JHTableChart *table2;
@property (nonatomic,strong)JHTableChart *table22;
@property (nonatomic,strong)JHTableChart *table3;
@property (nonatomic,strong)JHTableChart *table33;
@property (nonatomic,strong)JHTableChart *table4;
@property (nonatomic,strong)JHTableChart *table44;
@end

@implementation XiaoLvYunWeiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发电效率异常电站列表";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTop];
    // Do any additional setup after loading the view.
}

- (void)setTop{
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, KWidth/2-1, 44)];
    leftLabel.textAlignment  = NSTextAlignmentCenter;
    leftLabel.text = @"未处理";
    [self.view addSubview:leftLabel];
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, KWidth/2-1, 44)];
    [self.view addSubview:leftBtn];
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2, 64, KWidth/2, 44)];
    rightLabel.textAlignment  = NSTextAlignmentCenter;
    rightLabel.text = @"处理中";
    [self.view addSubview:rightLabel];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(KWidth/2, 64, KWidth/2, 44)];
    [self.view addSubview:rightBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(KWidth/2-1, 64, 1, 44)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:line];
    
    [self setScroll];
}

- (void)setScroll{
    self.bg = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 94, KWidth, KHeight-94)];
    self.bg.delegate = self;
    //    self.bgscrollview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.bg.pagingEnabled = YES;
    self.bg.contentSize = CGSizeMake(KWidth*2, KHeight-94);
    [self.view addSubview:self.bg];
    
    UIImageView *leftbg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight-94)];
    leftbg.image = [UIImage imageNamed:@"未处理1"];
    leftbg.userInteractionEnabled = YES;
    [self.bg addSubview:leftbg];
    
    UIImageView *rightbg = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth, 0, KWidth, KHeight-94)];
    rightbg.image = [UIImage imageNamed:@"处理中1"];
    rightbg.userInteractionEnabled = YES;
    [self.bg addSubview:rightbg];
    
    self.bgscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight-94)];
    self.bgscrollview.delegate = self;
    self.bgscrollview.backgroundColor = [UIColor clearColor];
    self.bgscrollview.pagingEnabled = NO;
    self.bgscrollview.contentSize = CGSizeMake(KWidth, 900);
    [self.bg addSubview:self.bgscrollview];
    
    self.bgscrollview1 = [[UIScrollView alloc] initWithFrame:CGRectMake(KWidth, 0, KWidth, KHeight-94)];
    self.bgscrollview1.delegate = self;
    self.bgscrollview1.backgroundColor = [UIColor clearColor];
    self.bgscrollview1.pagingEnabled = NO;
    self.bgscrollview1.contentSize = CGSizeMake(KWidth, 900);
    [self.bg addSubview:self.bgscrollview1];
    
    self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 900)];
    self.leftView.backgroundColor = [UIColor clearColor];
    [self.bg addSubview:self.leftView];
    
    
    
    self.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 900)];
    self.rightView.backgroundColor = [UIColor clearColor];
    [self.bgscrollview1 addSubview:self.rightView];
    
    
    
    [self setLeftTable];
    [self setRightTable];
}


- (void)setLeftTable{
    UIImageView *topTable = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17, KWidth-100, 30)];
    topTable.image = [UIImage imageNamed:@"发电bgt"];
    [self.leftView addSubview:topTable];
    
    UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 4, 12, 17)];
    leftImg.image = [UIImage imageNamed:@"tbx"];
    [topTable addSubview:leftImg];
    
    UILabel *toplabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 2, KWidth-70, 24)];
    toplabel.font = [UIFont systemFontOfSize:15];
    toplabel.textColor = [UIColor darkGrayColor];
    toplabel.text = @"分公司一:20户 平均降效比:30%";
    [topTable addSubview:toplabel];
    
    UIImageView *biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 45, KWidth-20, 400)];
    biaogeBg.image = [UIImage imageNamed:@"表格bg"];
    [self.leftView addSubview:biaogeBg];
    
    UIView *fourTable = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, KWidth, 400)];
    //    fourTable.bounces = NO;
    [self.leftView addSubview:fourTable];
    
    self.table1 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 400)];
    self.table1.delegate = self;
    self.table1.typeCount = 88;
    self.table1.isblue = NO;
    self.table1.bodyTextColor = [UIColor blackColor];
    self.table1.tableTitleFont = [UIFont systemFontOfSize:14];
    //    table.xDescTextFontSize =  (CGFloat)13;
    //    table.yDescTextFontSize =  (CGFloat)13;
    self.table1.colTitleArr = @[@"类别|序号",@"运维小组",@"管辖区域",@"装机容量(kW)",@"降效比(%)"];
    
    
    self.table1.colWidthArr = @[@30.0,@80.0,@120.0,@60.0,@60.0];
    //    table.beginSpace = 30;
    /*        Text color of the table body         */
    self.table1.bodyTextColor = [UIColor blackColor];
    /*        Minimum grid height         */
    self.table1.minHeightItems = 36;
    //    self.table4.tableChartTitleItemsHeight = KHeight/667*46;
    /*        Table line color         */
    self.table1.lineColor = [UIColor lightGrayColor];
    
    self.table1.backgroundColor = [UIColor clearColor];
    /*       Data source array, in accordance with the data from top to bottom that each line of data, if one of the rows of a column in a number of cells, can be stored in an array of         */
    
    //        self.table.dataArr = array2d2;
    
    
    /*        show   */
    //    fourTable.contentSize = CGSizeMake(KWidth, 46);
    [self.table1 showAnimation];
    [fourTable addSubview:self.table1];
    /*        Automatic calculation table height        */
    self.table1.frame = CGRectMake(0, 0, KWidth, [self.table1 heightFromThisDataSource]);
    
    UIScrollView *oneTable1 = [[UIScrollView alloc] init];
    //        if (self.dayFeeArr.count>11) {
    //            oneTable1.frame = CGRectMake(0,KHeight/667*92, k_MainBoundsWidth, KHeight/664*(300));
    //        }else{
    //            oneTable1.frame = CGRectMake(0,KHeight/667*92, k_MainBoundsWidth, KHeight/667*46*self.dayFeeArr.count);
    //        }
    oneTable1.frame = CGRectMake(0, 81, KWidth, 364);
    oneTable1.bounces = NO;
    [self.leftView addSubview:oneTable1];
    self.table11 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 364)];
    self.table11.typeCount = 88;
    self.table11.isblue = NO;
    self.table11.delegate = self;
    self.table11.tableTitleFont = [UIFont systemFontOfSize:14];
    NSArray *tipArr = @[@"1",@"运维小组1",@"周巷镇、镇海镇",@"12",@"31"];
    self.table11.colTitleArr = tipArr;
    //        self.table44.colWidthArr = colWid;
    self.table11.colWidthArr = @[@30.0,@80.0,@120.0,@60.0,@60.0];
    self.table11.bodyTextColor = [UIColor blackColor];
    self.table11.minHeightItems = 36;
    self.table11.lineColor = [UIColor lightGrayColor];
    self.table11.backgroundColor = [UIColor clearColor];
    
    NSArray *array2d2 = @[
                          @[@"2",@"运维小组2",@"镇海镇、周巷镇",@"12",@"31"],
                          @[@"3",@"运维小组3",@"镇海镇、周巷镇",@"12",@"31"],
                          @[@"4",@"运维小组4",@"镇海镇、周巷镇",@"12",@"31"],
                          @[@"5",@"运维小组5",@"镇海镇、周巷镇",@"12",@"31"],
                          @[@"6",@"运维小组6",@"镇海镇、周巷镇",@"12",@"31"],
                          @[@"7",@"运维小组7",@"镇海镇、周巷镇",@"12",@"31"],
                          @[@"8",@"运维小组8",@"镇海镇、周巷镇",@"12",@"31"],
                          @[@"9",@"运维小组9",@"镇海镇、周巷镇",@"12",@"31"],
                          @[@"10",@"运维小组10",@"镇海镇、周巷镇",@"12",@"31"]];
    self.table11.dataArr = array2d2;
    [self.table11 showAnimation];
    [oneTable1 addSubview:self.table11];
    oneTable1.contentSize = CGSizeMake(KWidth, 360);
    self.table11.frame = CGRectMake(0, 0, KWidth, [self.table11 heightFromThisDataSource]);
    
    UIImageView *topTable1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 454, KWidth-100, 30)];
    topTable1.image = [UIImage imageNamed:@"发电bgt"];
    [self.leftView addSubview:topTable1];
    
    UIImageView *leftImg1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 2, 12, 17)];
    leftImg1.image = [UIImage imageNamed:@"tbx"];
    [topTable1 addSubview:leftImg1];
    
    UILabel *toplabel1 = [[UILabel alloc] initWithFrame:CGRectMake(40, 2, KWidth-70, 24)];
    toplabel1.font = [UIFont systemFontOfSize:15];
    toplabel1.textColor = [UIColor darkGrayColor];
    toplabel1.text = @"分公司一:20户 平均降效比:30%";
    [topTable1 addSubview:toplabel1];
    
    UIImageView *biaogeBg1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 480, KWidth-20, 400)];
    biaogeBg1.image = [UIImage imageNamed:@"表格bg"];
    [self.leftView addSubview:biaogeBg1];
    
    UIView *fourTable1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 480, KWidth, 400)];
    //    fourTable.bounces = NO;
    [self.leftView addSubview:fourTable1];
    
    self.table2 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 400)];
    self.table2.delegate = self;
    self.table2.typeCount = 88;
    self.table2.isblue = NO;
    self.table2.bodyTextColor = [UIColor blackColor];
    self.table2.tableTitleFont = [UIFont systemFontOfSize:14];
    //    table.xDescTextFontSize =  (CGFloat)13;
    //    table.yDescTextFontSize =  (CGFloat)13;
    self.table2.colTitleArr = @[@"类别|序号",@"运维小组",@"管辖区域",@"装机容量(kW)",@"降效比(%)"];
    
    
    self.table2.colWidthArr = @[@30.0,@80.0,@120.0,@60.0,@60.0];
    //    table.beginSpace = 30;
    /*        Text color of the table body         */
    self.table2.bodyTextColor = [UIColor blackColor];
    /*        Minimum grid height         */
    self.table2.minHeightItems = 36;
    //    self.table4.tableChartTitleItemsHeight = KHeight/667*46;
    /*        Table line color         */
    self.table2.lineColor = [UIColor lightGrayColor];
    
    self.table2.backgroundColor = [UIColor clearColor];
    /*       Data source array, in accordance with the data from top to bottom that each line of data, if one of the rows of a column in a number of cells, can be stored in an array of         */
    
    //        self.table.dataArr = array2d2;
    
    
    /*        show   */
    //    fourTable.contentSize = CGSizeMake(KWidth, 46);
    [self.table2 showAnimation];
    [fourTable1 addSubview:self.table2];
    /*        Automatic calculation table height        */
    self.table2.frame = CGRectMake(0, 0, KWidth, [self.table1 heightFromThisDataSource]);
    
    UIScrollView *oneTable2 = [[UIScrollView alloc] init];
    //        if (self.dayFeeArr.count>11) {
    //            oneTable1.frame = CGRectMake(0,KHeight/667*92, k_MainBoundsWidth, KHeight/664*(300));
    //        }else{
    //            oneTable1.frame = CGRectMake(0,KHeight/667*92, k_MainBoundsWidth, KHeight/667*46*self.dayFeeArr.count);
    //        }
    oneTable2.frame = CGRectMake(0, 516, KWidth, 364);
    oneTable2.bounces = NO;
    [self.leftView addSubview:oneTable2];
    self.table22 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 364)];
    self.table22.typeCount = 88;
    self.table22.isblue = NO;
    self.table22.delegate = self;
    self.table22.tableTitleFont = [UIFont systemFontOfSize:14];
    NSArray *tipArr1 = @[@"1",@"运维小组1",@"周巷镇、镇海镇",@"10",@"10"];
    self.table22.colTitleArr = tipArr1;
    //        self.table44.colWidthArr = colWid;
    self.table22.colWidthArr = @[@30.0,@80.0,@120.0,@60.0,@60.0];
    self.table22.bodyTextColor = [UIColor blackColor];
    self.table22.minHeightItems = 36;
    self.table22.lineColor = [UIColor lightGrayColor];
    self.table22.backgroundColor = [UIColor clearColor];
    
    NSArray *array2d22 = @[
                           @[@"2",@"运维小组2",@"周巷镇、镇海镇",@"10",@"10"],
                           @[@"3",@"运维小组3",@"周巷镇、镇海镇",@"10",@"10"],
                           @[@"4",@"运维小组4",@"周巷镇、镇海镇",@"10",@"10"],
                           @[@"5",@"运维小组5",@"周巷镇、镇海镇",@"10",@"10"],
                           @[@"6",@"运维小组6",@"周巷镇、镇海镇",@"10",@"10"],
                           @[@"7",@"运维小组7",@"周巷镇、镇海镇",@"10",@"10"],
                           @[@"8",@"运维小组8",@"周巷镇、镇海镇",@"10",@"10"],
                           @[@"9",@"运维小组9",@"周巷镇、镇海镇",@"10",@"10"],
                           @[@"10",@"运维小组10",@"周巷镇、镇海镇",@"10",@"10"]];
    self.table22.dataArr = array2d22;
    [self.table22 showAnimation];
    [oneTable2 addSubview:self.table22];
    oneTable2.contentSize = CGSizeMake(KWidth, 360);
    self.table22.frame = CGRectMake(0, 0, KWidth, [self.table22 heightFromThisDataSource]);
}



- (void)setRightTable{
    UIImageView *topTable = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17, KWidth-100, 30)];
    topTable.image = [UIImage imageNamed:@"发电bgt"];
    [self.rightView addSubview:topTable];
    
    UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 4, 12, 17)];
    leftImg.image = [UIImage imageNamed:@"tbx"];
    [topTable addSubview:leftImg];
    
    UILabel *toplabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 2, KWidth-70, 24)];
    toplabel.font = [UIFont systemFontOfSize:15];
    toplabel.textColor = [UIColor darkGrayColor];
    toplabel.text = @"分公司一:20户 平均降效比:30%";
    [topTable addSubview:toplabel];
    
    UIImageView *biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 45, KWidth-20, 400)];
    biaogeBg.image = [UIImage imageNamed:@"表格bg"];
    [self.rightView addSubview:biaogeBg];
    
    UIView *fourTable = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, KWidth, 400)];
    //    fourTable.bounces = NO;
    [self.rightView addSubview:fourTable];
    
    self.table3 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 400)];
    self.table3.delegate = self;
    self.table3.typeCount = 88;
    self.table3.isblue = NO;
    self.table3.bodyTextColor = [UIColor blackColor];
    self.table3.tableTitleFont = [UIFont systemFontOfSize:14];
    //    table.xDescTextFontSize =  (CGFloat)13;
    //    table.yDescTextFontSize =  (CGFloat)13;
    self.table3.colTitleArr = @[@"类别|序号",@"运维小组",@"管辖区域",@"装机容量(kW)",@"降效比(%)"];
    
    
    self.table3.colWidthArr = @[@30.0,@80.0,@120.0,@60.0,@60.0];
    //    table.beginSpace = 30;
    /*        Text color of the table body         */
    self.table3.bodyTextColor = [UIColor blackColor];
    /*        Minimum grid height         */
    self.table3.minHeightItems = 36;
    //    self.table4.tableChartTitleItemsHeight = KHeight/667*46;
    /*        Table line color         */
    self.table3.lineColor = [UIColor lightGrayColor];
    
    self.table3.backgroundColor = [UIColor clearColor];
    /*       Data source array, in accordance with the data from top to bottom that each line of data, if one of the rows of a column in a number of cells, can be stored in an array of         */
    
    //        self.table.dataArr = array2d2;
    
    
    /*        show   */
    //    fourTable.contentSize = CGSizeMake(KWidth, 46);
    [self.table3 showAnimation];
    [fourTable addSubview:self.table3];
    /*        Automatic calculation table height        */
    self.table3.frame = CGRectMake(0, 0, KWidth, [self.table3 heightFromThisDataSource]);
    
    UIScrollView *oneTable1 = [[UIScrollView alloc] init];
    //        if (self.dayFeeArr.count>11) {
    //            oneTable1.frame = CGRectMake(0,KHeight/667*92, k_MainBoundsWidth, KHeight/664*(300));
    //        }else{
    //            oneTable1.frame = CGRectMake(0,KHeight/667*92, k_MainBoundsWidth, KHeight/667*46*self.dayFeeArr.count);
    //        }
    oneTable1.frame = CGRectMake(0, 81, KWidth, 364);
    oneTable1.bounces = NO;
    [self.rightView addSubview:oneTable1];
    self.table33 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 364)];
    self.table33.typeCount = 88;
    self.table33.isblue = NO;
    self.table33.delegate = self;
    self.table33.tableTitleFont = [UIFont systemFontOfSize:14];
    NSArray *tipArr = @[@"1",@"运维小组1",@"周巷镇、镇海镇",@"10",@"10"];
    self.table33.colTitleArr = tipArr;
    //        self.table44.colWidthArr = colWid;
    self.table33.colWidthArr = @[@30.0,@80.0,@120.0,@60.0,@60.0];
    self.table33.bodyTextColor = [UIColor blackColor];
    self.table33.minHeightItems = 36;
    self.table33.lineColor = [UIColor lightGrayColor];
    self.table33.backgroundColor = [UIColor clearColor];
    
    NSArray *array2d2 = @[
                          @[@"2",@"运维小组2",@"周巷镇、镇海镇",@"10",@"10"],
                          @[@"3",@"运维小组3",@"周巷镇、镇海镇",@"10",@"10"],
                          @[@"4",@"运维小组4",@"周巷镇、镇海镇",@"10",@"10"],
                          @[@"5",@"运维小组5",@"周巷镇、镇海镇",@"10",@"10"],
                          @[@"6",@"运维小组6",@"周巷镇、镇海镇",@"10",@"10"],
                          @[@"7",@"运维小组7",@"周巷镇、镇海镇",@"10",@"10"],
                          @[@"8",@"运维小组8",@"周巷镇、镇海镇",@"10",@"10"],
                          @[@"9",@"运维小组9",@"周巷镇、镇海镇",@"10",@"10"],
                          @[@"10",@"运维小组10",@"周巷镇、镇海镇",@"10",@"10"]];
    self.table33.dataArr = array2d2;
    [self.table33 showAnimation];
    [oneTable1 addSubview:self.table33];
    oneTable1.contentSize = CGSizeMake(KWidth, 360);
    self.table33.frame = CGRectMake(0, 0, KWidth, [self.table33 heightFromThisDataSource]);
    
    UIImageView *topTable1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 454, KWidth-100, 30)];
    topTable1.image = [UIImage imageNamed:@"发电bgt"];
    [self.rightView addSubview:topTable1];
    
    UIImageView *leftImg1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 2, 12, 17)];
    leftImg1.image = [UIImage imageNamed:@"tbx"];
    [topTable1 addSubview:leftImg1];
    
    UILabel *toplabel1 = [[UILabel alloc] initWithFrame:CGRectMake(40, 2, KWidth-70, 24)];
    toplabel1.font = [UIFont systemFontOfSize:15];
    toplabel1.textColor = [UIColor darkGrayColor];
    toplabel1.text = @"分公司一:20户 平均降效比:30%";
    [topTable1 addSubview:toplabel1];
    
    UIImageView *biaogeBg1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 480, KWidth-20, 400)];
    biaogeBg1.image = [UIImage imageNamed:@"表格bg"];
    [self.rightView addSubview:biaogeBg1];
    
    UIView *fourTable1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 480, KWidth, 400)];
    //    fourTable.bounces = NO;
    [self.rightView addSubview:fourTable1];
    
    self.table4 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 400)];
    self.table4.delegate = self;
    self.table4.typeCount = 88;
    self.table4.isblue = NO;
    self.table4.bodyTextColor = [UIColor blackColor];
    self.table4.tableTitleFont = [UIFont systemFontOfSize:14];
    //    table4 =  (CGFloat)13;
    //    table.yDescTextFontSize =  (CGFloat)13;
    self.table4.colTitleArr = @[@"类别|序号",@"运维小组",@"管辖区域",@"装机容量(kW)",@"降效比(%)"];
    
    
    self.table4.colWidthArr = @[@30.0,@80.0,@120.0,@60.0,@60.0];
    //    table.beginSpace = 30;
    /*        Text color of the table body         */
    self.table4.bodyTextColor = [UIColor blackColor];
    /*        Minimum grid height         */
    self.table4.minHeightItems = 36;
    //    self.table4.tableChartTitleItemsHeight = KHeight/667*46;
    /*        Table line color         */
    self.table4.lineColor = [UIColor lightGrayColor];
    
    self.table4.backgroundColor = [UIColor clearColor];
    /*       Data source array, in accordance with the data from top to bottom that each line of data, if one of the rows of a column in a number of cells, can be stored in an array of         */
    
    //        self.table.dataArr = array2d2;
    
    
    /*        show   */
    //    fourTable.contentSize = CGSizeMake(KWidth, 46);
    [self.table4 showAnimation];
    [fourTable1 addSubview:self.table4];
    /*        Automatic calculation table height        */
    self.table4.frame = CGRectMake(0, 0, KWidth, [self.table4 heightFromThisDataSource]);
    
    UIScrollView *oneTable2 = [[UIScrollView alloc] init];
    //        if (self.dayFeeArr.count>11) {
    //            oneTable1.frame = CGRectMake(0,KHeight/667*92, k_MainBoundsWidth, KHeight/664*(300));
    //        }else{
    //            oneTable1.frame = CGRectMake(0,KHeight/667*92, k_MainBoundsWidth, KHeight/667*46*self.dayFeeArr.count);
    //        }
    oneTable2.frame = CGRectMake(0, 516, KWidth, 364);
    oneTable2.bounces = NO;
    [self.rightView addSubview:oneTable2];
    self.table44 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 364)];
    self.table44.typeCount = 88;
    self.table44.isblue = NO;
    self.table44.delegate = self;
    self.table44.tableTitleFont = [UIFont systemFontOfSize:14];
    NSArray *tipArr1 = @[@"1",@"运维小组1",@"周巷镇、镇海镇",@"10",@"10"];
    self.table44.colTitleArr = tipArr1;
    //        self.table44.colWidthArr = colWid;
    self.table44.colWidthArr = @[@30.0,@80.0,@120.0,@60.0,@60.0];
    self.table44.bodyTextColor = [UIColor blackColor];
    self.table44.minHeightItems = 36;
    self.table44.lineColor = [UIColor lightGrayColor];
    self.table44.backgroundColor = [UIColor clearColor];
    
    NSArray *array2d22 = @[
                           @[@"2",@"运维小组2",@"周巷镇、镇海镇",@"10",@"10"],
                           @[@"3",@"运维小组3",@"周巷镇、镇海镇",@"10",@"10"],
                           @[@"4",@"运维小组4",@"周巷镇、镇海镇",@"10",@"10"],
                           @[@"5",@"运维小组5",@"周巷镇、镇海镇",@"10",@"10"],
                           @[@"6",@"运维小组6",@"周巷镇、镇海镇",@"10",@"10"],
                           @[@"7",@"运维小组7",@"周巷镇、镇海镇",@"10",@"10"],
                           @[@"8",@"运维小组8",@"周巷镇、镇海镇",@"10",@"10"],
                           @[@"9",@"运维小组9",@"周巷镇、镇海镇",@"10",@"10"],
                           @[@"10",@"运维小组10",@"周巷镇、镇海镇",@"10",@"10"]];
    self.table44.dataArr = array2d22;
    [self.table44 showAnimation];
    [oneTable2 addSubview:self.table44];
    oneTable2.contentSize = CGSizeMake(KWidth, 360);
    self.table44.frame = CGRectMake(0, 0, KWidth, [self.table44 heightFromThisDataSource]);
}

- (void)transButIndex:(NSInteger)index
{
    NSLog(@"代理方法%ld",index);
    //    self.navigationController.navigationBar.hidden = NO;
    XiaoLvHuViewController *vc = [[XiaoLvHuViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
