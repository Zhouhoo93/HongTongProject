//
//  XiaoLvLishiViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/12/1.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "XiaoLvLishiViewController.h"
#import "JHTableChart.h"
#import "XiaoLvLiShiYunweiViewController.h"
@interface XiaoLvLishiViewController ()<UIScrollViewDelegate,TableButDelegate>
@property (nonatomic,strong)UILabel *yearLabel;
@property (nonatomic,strong)UIScrollView *bgscrollview;
@property (nonatomic,strong)JHTableChart *table1;
@property (nonatomic,strong)JHTableChart *table11;
@property (nonatomic,strong)JHTableChart *table2;
@property (nonatomic,strong)JHTableChart *table22;
@end

@implementation XiaoLvLishiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发电效率异常电站列表";
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

- (void)setTabel{
    UIImageView *topTable = [[UIImageView alloc] initWithFrame:CGRectMake(15, 67, KWidth-100, 30)];
    topTable.image = [UIImage imageNamed:@"发电bgt"];
    [self.bgscrollview addSubview:topTable];
    
    UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 4, 12, 17)];
    leftImg.image = [UIImage imageNamed:@"tbx"];
    [topTable addSubview:leftImg];
    
    UILabel *toplabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 2, KWidth-70, 24)];
    toplabel.font = [UIFont systemFontOfSize:15];
    toplabel.textColor = [UIColor darkGrayColor];
    toplabel.text = @"分公司一:20户 平均降效比:30%";
    [topTable addSubview:toplabel];
    
    UIImageView *biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 95, KWidth-20, 400)];
    biaogeBg.image = [UIImage imageNamed:@"表格bg"];
    [self.bgscrollview addSubview:biaogeBg];
    
    UIView *fourTable = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 95, KWidth, 400)];
    //    fourTable.bounces = NO;
    [self.bgscrollview addSubview:fourTable];
    
    self.table1 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 400)];
    self.table1.delegate = self;
    self.table1.typeCount = 88;
    self.table1.small = YES;
    self.table1.isblue = NO;
    self.table1.bodyTextColor = [UIColor blackColor];
    self.table1.tableTitleFont = [UIFont systemFontOfSize:14];
    //    table.xDescTextFontSize =  (CGFloat)13;
    //    table.yDescTextFontSize =  (CGFloat)13;
    self.table1.colTitleArr = @[@"类别|序号",@"运维小组",@"管辖区域",@"容量(kW)",@"降效(%)"];
    
    
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
    oneTable1.frame = CGRectMake(0, 131, KWidth, 364);
    oneTable1.bounces = NO;
    [self.bgscrollview addSubview:oneTable1];
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
    
    UIImageView *topTable1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 504, KWidth-100, 30)];
    topTable1.image = [UIImage imageNamed:@"发电bgt"];
    [self.bgscrollview addSubview:topTable1];
    
    UIImageView *leftImg1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 2, 12, 17)];
    leftImg1.image = [UIImage imageNamed:@"tbx"];
    [topTable1 addSubview:leftImg1];
    
    UILabel *toplabel1 = [[UILabel alloc] initWithFrame:CGRectMake(40, 2, KWidth-70, 24)];
    toplabel1.font = [UIFont systemFontOfSize:15];
    toplabel1.textColor = [UIColor darkGrayColor];
    toplabel1.text = @"分公司一:20户 平均降效比:30%";
    [topTable1 addSubview:toplabel1];
    
    UIImageView *biaogeBg1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 530, KWidth-20, 400)];
    biaogeBg1.image = [UIImage imageNamed:@"表格bg"];
    [self.bgscrollview addSubview:biaogeBg1];
    
    UIView *fourTable1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 530, KWidth, 400)];
    //    fourTable.bounces = NO;
    [self.bgscrollview addSubview:fourTable1];
    
    self.table2 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 400)];
    self.table2.delegate = self;
    self.table2.typeCount = 88;
    self.table2.small = YES;
    self.table2.isblue = NO;
    self.table2.bodyTextColor = [UIColor blackColor];
    self.table2.tableTitleFont = [UIFont systemFontOfSize:14];
    //    table.xDescTextFontSize =  (CGFloat)13;
    //    table.yDescTextFontSize =  (CGFloat)13;
    self.table2.colTitleArr = @[@"类别|序号",@"运维小组",@"管辖区域",@"容量(kW)",@"降效(%)"];
    
    
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
    oneTable2.frame = CGRectMake(0, 566, KWidth, 364);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)transButIndex:(NSInteger)index
{
    NSLog(@"代理方法%ld",index);
    //    self.navigationController.navigationBar.hidden = NO;
    XiaoLvLiShiYunweiViewController *vc = [[XiaoLvLiShiYunweiViewController alloc] init];
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
