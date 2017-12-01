//
//  BaoJingLiShiListViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/12/1.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "BaoJingLiShiListViewController.h"
#import "JHTableChart.h"
#import "ShaiXuanKuangView.h"
#import "BaoJingLishiYunweiListViewController.h"
@interface BaoJingLiShiListViewController ()<TableButDelegate,UIScrollViewDelegate,ShaiXuanDelegate>
@property (nonatomic,strong)UILabel *yearLabel;
@property (nonatomic,strong)UIScrollView *bgscrollview;
@property (nonatomic,strong)JHTableChart *table1;
@property (nonatomic,strong)JHTableChart *table11;
@property (nonatomic,strong)JHTableChart *table2;
@property (nonatomic,strong)JHTableChart *table22;
@property (nonatomic,strong)ShaiXuanKuangView *shaixuanView;
@end

@implementation BaoJingLiShiListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报警信息列表";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self setTopBtn];
    // Do any additional setup after loading the view.
}

- (void)setTopBtn{
    self.bgscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight)];
    self.bgscrollview.delegate = self;
    self.bgscrollview.backgroundColor = [UIColor clearColor];
    self.bgscrollview.pagingEnabled = NO;
    self.bgscrollview.contentSize = CGSizeMake(KWidth, 950);
    [self.view addSubview:self.bgscrollview];
    
    UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth/2-90, 15, 180, 34)];
    leftImg.image = [UIImage imageNamed:@"2016"];
    [self.bgscrollview addSubview:leftImg];
    
    self.yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2-90, 15, 180, 34)];
    self.yearLabel.text = @"2016";
    self.yearLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgscrollview addSubview:self.yearLabel];
    
    UIButton *leftDownBtn = [[UIButton alloc] initWithFrame:CGRectMake(KWidth/2-90, 15, 60, 34)];
    [leftDownBtn addTarget:self action:@selector(leftDownBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgscrollview addSubview:leftDownBtn];
    
    UIButton *rightDownBtn = [[UIButton alloc] initWithFrame:CGRectMake(KWidth/2+30, 15, 60, 34)];
    [rightDownBtn addTarget:self action:@selector(rightDownBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgscrollview addSubview:rightDownBtn];
    
    [self setTabel];
}

- (void)leftDownBtnClick{
    NSString *str = self.yearLabel.text;
    NSInteger strNum = [str integerValue];
    NSInteger strNum1 =strNum-1;
    self.yearLabel.text = [NSString stringWithFormat:@"%ld",strNum1];
}

- (void)rightDownBtnClick{
    NSString *str = self.yearLabel.text;
    NSInteger strNum = [str integerValue];
    NSInteger strNum1 =strNum+1;
    self.yearLabel.text = [NSString stringWithFormat:@"%ld",strNum1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTabel{
    UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(25, 56, 12, 17)];
    leftImg.image = [UIImage imageNamed:@"定位"];
    [self.bgscrollview addSubview:leftImg];
    
    UILabel *toplabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 54, KWidth-70, 24)];
    toplabel.font = [UIFont systemFontOfSize:15];
    toplabel.textColor = [UIColor darkGrayColor];
    toplabel.text = @"分公司一 共90条";
    [self.bgscrollview addSubview:toplabel];
    
    UIButton *shaixuanBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(KWidth-100, 54, 80, 30)];
    [shaixuanBtn1 setImage:[UIImage imageNamed:@"筛选"] forState:UIControlStateNormal];
    [shaixuanBtn1 addTarget:self action:@selector(shaixuanBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgscrollview addSubview:shaixuanBtn1];
    
    UIImageView *biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 85, KWidth-20, 400)];
    biaogeBg.image = [UIImage imageNamed:@"表格bg"];
    [self.bgscrollview addSubview:biaogeBg];
    
    UIView *fourTable = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 85, KWidth, 400)];
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
    self.table1.colTitleArr = @[@"类别|序号",@"运维小组",@"管辖范围",@"户数(户)",@"报警条数(条)"];
    
    
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
    oneTable1.frame = CGRectMake(0, 121, KWidth, 364);
    oneTable1.bounces = NO;
    [self.bgscrollview addSubview:oneTable1];
    self.table11 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 364)];
    self.table11.typeCount = 88;
    self.table11.isblue = NO;
    self.table11.delegate = self;
    self.table11.tableTitleFont = [UIFont systemFontOfSize:14];
    NSArray *tipArr = @[@"1",@"运维小组1",@"周巷镇、镇海镇",@"10",@"10"];
    self.table11.colTitleArr = tipArr;
    //        self.table44.colWidthArr = colWid;
    self.table11.colWidthArr = @[@30.0,@80.0,@120.0,@60.0,@60.0];
    self.table11.bodyTextColor = [UIColor blackColor];
    self.table11.minHeightItems = 36;
    self.table11.lineColor = [UIColor lightGrayColor];
    self.table11.backgroundColor = [UIColor clearColor];
    
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
    self.table11.dataArr = array2d2;
    [self.table11 showAnimation];
    [oneTable1 addSubview:self.table11];
    oneTable1.contentSize = CGSizeMake(KWidth, 360);
    self.table11.frame = CGRectMake(0, 0, KWidth, [self.table11 heightFromThisDataSource]);
    
    UIImageView *leftImg1 = [[UIImageView alloc] initWithFrame:CGRectMake(25, 496, 12, 17)];
    leftImg1.image = [UIImage imageNamed:@"定位"];
    [self.bgscrollview addSubview:leftImg1];
    
    UILabel *toplabel1 = [[UILabel alloc] initWithFrame:CGRectMake(50, 494, KWidth-70, 24)];
    toplabel1.font = [UIFont systemFontOfSize:15];
    toplabel1.textColor = [UIColor darkGrayColor];
    toplabel1.text = @"分公司二 共90条";
    [self.bgscrollview addSubview:toplabel1];
    
    UIButton *shaixuanBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(KWidth-100, 492, 80, 30)];
    [shaixuanBtn2 setImage:[UIImage imageNamed:@"筛选"] forState:UIControlStateNormal];
    [shaixuanBtn2 addTarget:self action:@selector(shaixuanBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgscrollview addSubview:shaixuanBtn2];
    
    UIImageView *biaogeBg1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 520, KWidth-20, 400)];
    biaogeBg1.image = [UIImage imageNamed:@"表格bg"];
    [self.bgscrollview addSubview:biaogeBg1];
    
    UIView *fourTable1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 520, KWidth, 400)];
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
    self.table2.colTitleArr = @[@"类别|序号",@"运维小组",@"管辖范围",@"户数(户)",@"报警条数(条)"];
    
    
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
    oneTable2.frame = CGRectMake(0, 556, KWidth, 364);
    oneTable2.bounces = NO;
    [self.bgscrollview addSubview:oneTable2];
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
- (void)shaixuanBtnClick{
    self.shaixuanView = [[[NSBundle mainBundle]loadNibNamed:@"ShaiXuanKuang" owner:self options:nil]objectAtIndex:0];
    self.shaixuanView.frame = CGRectMake(0, 0, KWidth, KHeight);
    self.shaixuanView.delegate = self;
    [self.view addSubview:self.shaixuanView];
}

- (void)CloseClick{
    [self.shaixuanView removeFromSuperview];
}

- (void)transButIndex:(NSInteger)index
{
    BaoJingLishiYunweiListViewController *vc = [[BaoJingLishiYunweiListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
