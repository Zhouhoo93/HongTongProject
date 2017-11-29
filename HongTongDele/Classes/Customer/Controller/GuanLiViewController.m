//
//  GuanLiViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/11/29.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "GuanLiViewController.h"
#import "JHTableChart.h"
@interface GuanLiViewController ()<UIScrollViewDelegate,TableButDelegate>
@property (nonatomic,strong)UIScrollView *bgscrollview;
@property (nonatomic,strong)JHTableChart *table1;
@property (nonatomic,strong)JHTableChart *table11;
@property (nonatomic,strong)JHTableChart *table2;
@property (nonatomic,strong)JHTableChart *table22;
@end

@implementation GuanLiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"管理";
    
    self.bgscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, KWidth, KHeight-64)];
    self.bgscrollview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.bgscrollview.delegate = self;
    self.bgscrollview.contentSize = CGSizeMake(KWidth, 800);
    [self.view addSubview:self.bgscrollview];
    
    [self setTabelChart];
    // Do any additional setup after loading the view.
}

- (void)setTabelChart{
    UIImageView *biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, KWidth-20, 400)];
    biaogeBg.image = [UIImage imageNamed:@"表格bg"];
    [self.bgscrollview addSubview:biaogeBg];
    
    UIView *fourTable = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 15, KWidth, 400)];
    //    fourTable.bounces = NO;
    [self.bgscrollview addSubview:fourTable];
    
    self.table1 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 400)];
    self.table1.delegate = self;
    self.table1.typeCount = 88;
    self.table1.isblue = NO;
    self.table1.bodyTextColor = [UIColor blackColor];
    self.table1.tableTitleFont = [UIFont systemFontOfSize:14];
    //    table.xDescTextFontSize =  (CGFloat)13;
    //    table.yDescTextFontSize =  (CGFloat)13;
    self.table1.colTitleArr = @[@"类别|名称",@"设备离线(户)",@"设备异常(户)",@"设备故障(户)",@"效率异常(户)"];
    
    
    self.table1.colWidthArr = @[@70.0,@70.0,@70.0,@70.0,@70.0];
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
    oneTable1.frame = CGRectMake(0, 51, KWidth, 364);
    oneTable1.bounces = NO;
    [self.bgscrollview addSubview:oneTable1];
    self.table11 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 364)];
    self.table11.typeCount = 88;
    self.table11.isblue = NO;
    self.table11.delegate = self;
    self.table11.tableTitleFont = [UIFont systemFontOfSize:14];
    NSArray *tipArr = @[@"分公司一",@"7",@"8",@"5",@"2"];
    self.table11.colTitleArr = tipArr;
    //        self.table44.colWidthArr = colWid;
    self.table11.colWidthArr = @[@70.0,@70.0,@70.0,@70.0,@70.0];
    self.table11.bodyTextColor = [UIColor blackColor];
    self.table11.minHeightItems = 36;
    self.table11.lineColor = [UIColor lightGrayColor];
    self.table11.backgroundColor = [UIColor clearColor];
    
    NSArray *array2d2 = @[
                          @[@"分公司一",@"7",@"8",@"5",@"2"],
                          @[@"分公司一",@"7",@"8",@"5",@"2"],
                          @[@"分公司一",@"7",@"8",@"5",@"2"],
                          @[@"分公司一",@"7",@"8",@"5",@"2"],
                          @[@"分公司一",@"7",@"8",@"5",@"2"],
                          @[@"分公司一",@"7",@"8",@"5",@"2"],
                          @[@"分公司一",@"7",@"8",@"5",@"2"],
                          @[@"分公司一",@"7",@"8",@"5",@"2"],
                          @[@"分公司一",@"7",@"8",@"5",@"2"]];
    self.table11.dataArr = array2d2;
    [self.table11 showAnimation];
    [oneTable1 addSubview:self.table11];
    oneTable1.contentSize = CGSizeMake(KWidth, 360);
    self.table11.frame = CGRectMake(0, 0, KWidth, [self.table11 heightFromThisDataSource]);
    
    
    UIImageView *biaogeBg1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 415, KWidth-20, 400)];
    biaogeBg1.image = [UIImage imageNamed:@"表格bg"];
    [self.bgscrollview addSubview:biaogeBg1];
    
    UIView *fourTable1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 415, KWidth, 400)];
    //    fourTable.bounces = NO;
    [self.bgscrollview addSubview:fourTable1];
    
    self.table2 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 400)];
    self.table2.delegate = self;
    self.table2.typeCount = 88;
    self.table2.isblue = NO;
    self.table2.bodyTextColor = [UIColor blackColor];
    self.table2.tableTitleFont = [UIFont systemFontOfSize:14];
    //    table.xDescTextFontSize =  (CGFloat)13;
    //    table.yDescTextFontSize =  (CGFloat)13;
    self.table2.colTitleArr = @[@"类别|名称",@"设备离线(户)",@"设备异常(户)",@"设备故障(户)",@"效率异常(户)"];
    
    
    self.table2.colWidthArr = @[@70.0,@70.0,@70.0,@70.0,@70.0];
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
    oneTable2.frame = CGRectMake(0, 451, KWidth, 364);
    oneTable2.bounces = NO;
    [self.bgscrollview addSubview:oneTable2];
    self.table22 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 364)];
    self.table22.typeCount = 88;
    self.table22.isblue = NO;
    self.table22.delegate = self;
    self.table22.tableTitleFont = [UIFont systemFontOfSize:14];
    NSArray *tipArr1 = @[@"分公司一",@"7",@"8",@"5",@"2"];
    self.table22.colTitleArr = tipArr1;
    //        self.table44.colWidthArr = colWid;
    self.table22.colWidthArr = @[@70.0,@70.0,@70.0,@70.0,@70.0];
    self.table22.bodyTextColor = [UIColor blackColor];
    self.table22.minHeightItems = 36;
    self.table22.lineColor = [UIColor lightGrayColor];
    self.table22.backgroundColor = [UIColor clearColor];
    
    NSArray *array2d22 = @[
                          @[@"分公司一",@"7",@"8",@"5",@"2"],
                          @[@"分公司一",@"7",@"8",@"5",@"2"],
                          @[@"分公司一",@"7",@"8",@"5",@"2"],
                          @[@"分公司一",@"7",@"8",@"5",@"2"],
                          @[@"分公司一",@"7",@"8",@"5",@"2"],
                          @[@"分公司一",@"7",@"8",@"5",@"2"],
                          @[@"分公司一",@"7",@"8",@"5",@"2"],
                          @[@"分公司一",@"7",@"8",@"5",@"2"],
                          @[@"分公司一",@"7",@"8",@"5",@"2"]];
    self.table22.dataArr = array2d22;
    [self.table22 showAnimation];
    [oneTable2 addSubview:self.table22];
    oneTable2.contentSize = CGSizeMake(KWidth, 360);
    self.table22.frame = CGRectMake(0, 0, KWidth, [self.table11 heightFromThisDataSource]);
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
