//
//  ZhuangTaiListViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/11/20.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "ZhuangTaiListViewController.h"
#import "JHTableChart.h"
#import "ZhuangtaiViewController.h"
@interface ZhuangTaiListViewController ()<TableButDelegate>
@property (nonatomic,strong)JHTableChart *table;
@property (nonatomic,strong)JHTableChart *table1;
@end

@implementation ZhuangTaiListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"状态列表";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(25, 76, 12, 17)];
    leftImg.image = [UIImage imageNamed:@"定位"];
    [self.view addSubview:leftImg];
    
    UILabel *toplabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 74, 200, 24)];
    toplabel.text = @"XX公司(分公司)";
    [self.view addSubview:toplabel];
    
    [self setTabel];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setTabel{
    UIImageView *biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 140, KWidth-20, 400)];
    biaogeBg.image = [UIImage imageNamed:@"表格bg"];
    [self.view addSubview:biaogeBg];
    
    UIView *fourTable = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 140, KWidth, 400)];
    //    fourTable.bounces = NO;
    [self.view addSubview:fourTable];
    
    self.table = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 400)];
    self.table.delegate = self;
    self.table.typeCount = 88;
    self.table.isblue = NO;
    self.table.bodyTextColor = [UIColor blackColor];
    self.table.tableTitleFont = [UIFont systemFontOfSize:14];
    //    table.xDescTextFontSize =  (CGFloat)13;
    //    table.yDescTextFontSize =  (CGFloat)13;
    self.table.colTitleArr = @[@"类别|序号",@"运维小组",@"离线(户)",@"异常(户)",@"故障(户)"];
    
    
    self.table.colWidthArr = @[@30.0,@80.0,@80.0,@80.0,@80.0];
    //    table.beginSpace = 30;
    /*        Text color of the table body         */
    self.table.bodyTextColor = [UIColor blackColor];
    /*        Minimum grid height         */
    self.table.minHeightItems = 36;
    //    self.table4.tableChartTitleItemsHeight = KHeight/667*46;
    /*        Table line color         */
    self.table.lineColor = [UIColor lightGrayColor];
    
    self.table.backgroundColor = [UIColor clearColor];
    /*       Data source array, in accordance with the data from top to bottom that each line of data, if one of the rows of a column in a number of cells, can be stored in an array of         */
    
    //        self.table.dataArr = array2d2;
    
    
    /*        show   */
    //    fourTable.contentSize = CGSizeMake(KWidth, 46);
    [self.table showAnimation];
    [fourTable addSubview:self.table];
    /*        Automatic calculation table height        */
    self.table.frame = CGRectMake(0, 0, KWidth, [self.table heightFromThisDataSource]);
    
    UIScrollView *oneTable1 = [[UIScrollView alloc] init];
    //        if (self.dayFeeArr.count>11) {
    //            oneTable1.frame = CGRectMake(0,KHeight/667*92, k_MainBoundsWidth, KHeight/664*(300));
    //        }else{
    //            oneTable1.frame = CGRectMake(0,KHeight/667*92, k_MainBoundsWidth, KHeight/667*46*self.dayFeeArr.count);
    //        }
    oneTable1.frame = CGRectMake(0, 176, KWidth, 364);
    oneTable1.bounces = NO;
    [self.view addSubview:oneTable1];
    self.table1 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 364)];
    self.table1.typeCount = 88;
    self.table1.isblue = NO;
    self.table1.delegate = self;
    self.table1.tableTitleFont = [UIFont systemFontOfSize:14];
    NSArray *tipArr = @[@"1",@"运维小组1",@"50",@"50",@"50"];
    self.table1.colTitleArr = tipArr;
    //        self.table44.colWidthArr = colWid;
    self.table1.colWidthArr = @[@30.0,@80.0,@80.0,@80.0,@80.0];
    self.table1.bodyTextColor = [UIColor blackColor];
    self.table1.minHeightItems = 36;
    self.table1.lineColor = [UIColor lightGrayColor];
    self.table1.backgroundColor = [UIColor clearColor];
    
    NSArray *array2d2 = @[
                          @[@"2",@"运维小组2",@"40",@"40",@"40"],
                         @[@"3",@"运维小组3",@"50",@"50",@"50"],
                          @[@"4",@"运维小组4",@"50",@"50",@"50"],
                          @[@"5",@"运维小组5",@"50",@"50",@"50"],
                          @[@"6",@"运维小组6",@"50",@"50",@"50"],
                          @[@"7",@"运维小组7",@"50",@"50",@"50"],
                          @[@"8",@"运维小组8",@"50",@"50",@"50"],
                          @[@"9",@"运维小组9",@"50",@"50",@"50"],
                          @[@"10",@"运维小组10",@"50",@"50",@"50"]
                          ];
    self.table1.dataArr = array2d2;
    [self.table1 showAnimation];
    [oneTable1 addSubview:self.table1];
    oneTable1.contentSize = CGSizeMake(KWidth, 360);
    self.table1.frame = CGRectMake(0, 0, KWidth, [self.table1 heightFromThisDataSource]);
}
//执行协议方法
- (void)transButIndex:(NSInteger)index
{
    NSLog(@"代理方法%ld",index);
    ZhuangtaiViewController *vc = [[ZhuangtaiViewController alloc] init];
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