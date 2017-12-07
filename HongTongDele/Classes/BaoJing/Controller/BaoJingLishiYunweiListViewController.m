//
//  BaoJingLishiYunweiListViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/12/1.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "BaoJingLishiYunweiListViewController.h"
#import "JHTableChart.h"
@interface BaoJingLishiYunweiListViewController ()<TableButDelegate,UIScrollViewDelegate>
@property (nonatomic,strong)UILabel *yearLabel;
@property (nonatomic,strong)UIScrollView *bgscrollview;
@property (nonatomic,strong)JHTableChart *table1;
@property (nonatomic,strong)JHTableChart *table11;
@end

@implementation BaoJingLishiYunweiListViewController

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
    self.bgscrollview.contentSize = CGSizeMake(KWidth, 0);
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

- (void)setTabel{
    UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 66, 12, 17)];
    leftImg.image = [UIImage imageNamed:@"定位"];
    [self.bgscrollview addSubview:leftImg];
    
    UILabel *toplabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 64, KWidth-70, 24)];
    toplabel.font = [UIFont systemFontOfSize:14];
    toplabel.textColor = [UIColor darkGrayColor];
    toplabel.text = @"xx公司(分公司) 运维小组1 周巷镇 共9条";
    [self.bgscrollview addSubview:toplabel];
    
    UIButton *shaixuanBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(KWidth-90, 64, 80, 30)];
    [shaixuanBtn1 setImage:[UIImage imageNamed:@"筛选"] forState:UIControlStateNormal];
    [shaixuanBtn1 addTarget:self action:@selector(shaixuanBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgscrollview addSubview:shaixuanBtn1];
    
    UIImageView *biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 95, KWidth-20, 400)];
    biaogeBg.image = [UIImage imageNamed:@"表格bg"];
    [self.bgscrollview addSubview:biaogeBg];
    
    UIView *fourTable = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 95, KWidth, 400)];
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
    self.table1.colTitleArr = @[@"类别|序号",@"户号",@"地址",@"通讯状态",@"详情",@"发生时间"];
    
    
    self.table1.colWidthArr = @[@30.0,@40.0,@90.0,@30.0,@90.0,@50.0];
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
    NSArray *tipArr = @[@"1",@"5678",@"水云村201号",@"在线",@"直流母线过流",@"08-01 20:20"];
    self.table11.colTitleArr = tipArr;
    //        self.table44.colWidthArr = colWid;
    self.table11.colWidthArr = @[@30.0,@40.0,@90.0,@30.0,@90.0,@50.0];
    self.table11.bodyTextColor = [UIColor blackColor];
    self.table11.minHeightItems = 36;
    self.table11.lineColor = [UIColor lightGrayColor];
    self.table11.backgroundColor = [UIColor clearColor];
    
    NSArray *array2d2 = @[
                          @[@"1",@"5678",@"水云村201号",@"在线",@"直流母线过流",@"08-01 20:20"],
                          @[@"2",@"5678",@"水云村201号",@"在线",@"直流母线过流",@"08-01 20:20"],
                          @[@"3",@"5678",@"水云村201号",@"在线",@"直流母线过流",@"08-01 20:20"],
                          @[@"4",@"5678",@"水云村201号",@"在线",@"直流母线过流",@"08-01 20:20"],
                          @[@"5",@"5678",@"水云村201号",@"在线",@"直流母线过流",@"08-01 20:20"],
                          @[@"6",@"5678",@"水云村201号",@"在线",@"直流母线过流",@"08-01 20:20"],
                          @[@"7",@"5678",@"水云村201号",@"在线",@"直流母线过流",@"08-01 20:20"],
                          @[@"8",@"5678",@"水云村201号",@"在线",@"直流母线过流",@"08-01 20:20"],
                          @[@"9",@"5678",@"水云村201号",@"在线",@"直流母线过流",@"08-01 20:20"]];
    self.table11.dataArr = array2d2;
    [self.table11 showAnimation];
    [oneTable1 addSubview:self.table11];
    oneTable1.contentSize = CGSizeMake(KWidth, 360);
    self.table11.frame = CGRectMake(0, 0, KWidth, [self.table11 heightFromThisDataSource]);
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
