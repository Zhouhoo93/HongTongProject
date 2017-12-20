//
//  GuZhangListViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/11/20.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "GuZhangListViewController.h"
#import "JHTableChart.h"
#import "GuZhangLiShiListViewController.h"
@interface GuZhangListViewController ()<TableButDelegate>
@property (nonatomic,strong)JHTableChart *table;
@property (nonatomic,strong)JHTableChart *table1;
@end

@implementation GuZhangListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"今年电站故障列表";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self setUI];
    // Do any additional setup after loading the view.
}

- (void)setUI{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(KWidth-110, 78, 100, 34)];
    [rightBtn setImage:[UIImage imageNamed:@"历史报警2"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(lishiBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 84, KWidth-100, 34)];
    leftLabel.text = @"户号: 123456";
    leftLabel.numberOfLines = 0;
    leftLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:leftLabel];
    
    UILabel *leftLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 114, KWidth-100, 34)];
    leftLabel1.text = @"地址: 浙江省杭州市新加坡科技园";
    leftLabel1.font = [UIFont systemFontOfSize:16];
    leftLabel1.numberOfLines = 0;
    [self.view addSubview:leftLabel1];
    
    UIImageView *rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-170, 155, 24, 24)];
    rightImg.image = [UIImage imageNamed:@"报警数"];
    [self.view addSubview:rightImg];
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-145, 150, 110, 34)];
    rightLabel.font = [UIFont systemFontOfSize:15];
    rightLabel.text = @"总报警次数: 5次";
    [self.view addSubview:rightLabel];
    
    [self setTabel];
}

- (void)setTabel{
    UIImageView *biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 180, KWidth-20, 400)];
    biaogeBg.image = [UIImage imageNamed:@"表格bg"];
    [self.view addSubview:biaogeBg];
    
    UIView *fourTable = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 180, KWidth, 400)];
    //    fourTable.bounces = NO;
    [self.view addSubview:fourTable];
    
    self.table = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 400)];
    self.table.delegate = self;
    self.table.typeCount = 87;
    self.table.small = YES;
    self.table.isblue = NO;
    self.table.bodyTextColor = [UIColor blackColor];
    self.table.tableTitleFont = [UIFont systemFontOfSize:14];
    //    table.xDescTextFontSize =  (CGFloat)13;
    //    table.yDescTextFontSize =  (CGFloat)13;
    self.table.colTitleArr = @[@"类别|序号",@"时间",@"性质",@"详情",@"处理阶段",@"响应时间(分钟)",@"处理时间(小时)"];
    
    
    self.table.colWidthArr = @[@30.0,@40.0,@35.0,@80.0,@50.0,@55.0,@55.0];
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
    oneTable1.frame = CGRectMake(0, 216, KWidth, 364);
    oneTable1.bounces = NO;
    [self.view addSubview:oneTable1];
    self.table1 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 364)];
    self.table1.typeCount = 87;
    self.table1.isblue = NO;
    self.table1.delegate = self;
    self.table1.tableTitleFont = [UIFont systemFontOfSize:14];
    NSArray *tipArr = @[@"1",@"08-01 20:20",@"故障",@"逆变器掉线",@"未处理",@"14",@"1"];
    self.table1.colTitleArr = tipArr;
    //        self.table44.colWidthArr = colWid;
    self.table1.colWidthArr = @[@30.0,@40.0,@35.0,@80.0,@50.0,@55.0,@55.0];
    self.table1.bodyTextColor = [UIColor blackColor];
    self.table1.minHeightItems = 36;
    self.table1.lineColor = [UIColor lightGrayColor];
    self.table1.backgroundColor = [UIColor clearColor];
    
    NSArray *array2d2 = @[
                          @[@"2",@"08-01 20:20",@"异常",@"发电异常",@"已处理",@"14",@"1"],
                          @[@"3",@"08-01 20:20",@"故障",@"逆变器掉线",@"未处理",@"14",@"1"],
                          @[@"4",@"08-01 20:20",@"故障",@"逆变器掉线",@"未处理",@"14",@"1"],
                          @[@"5",@"08-01 20:20",@"故障",@"逆变器掉线",@"未处理",@"14",@"1"],
                          @[@"6",@"08-01 20:20",@"故障",@"逆变器掉线",@"未处理",@"14",@"1"],
                          @[@"7",@"08-01 20:20",@"故障",@"逆变器掉线",@"未处理",@"14",@"1"],
                          @[@"8",@"08-01 20:20",@"故障",@"逆变器掉线",@"未处理",@"14",@"1"],
                          @[@"9",@"08-01 20:20",@"故障",@"逆变器掉线",@"未处理",@"14",@"1"],
                          @[@"10",@"08-01 20:20",@"故障",@"逆变器掉线",@"未处理",@"14",@"1"]
                          ];
    self.table1.dataArr = array2d2;
    [self.table1 showAnimation];
    [oneTable1 addSubview:self.table1];
    oneTable1.contentSize = CGSizeMake(KWidth, 360);
    self.table1.frame = CGRectMake(0, 0, KWidth, [self.table1 heightFromThisDataSource]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)lishiBtnClick{
    GuZhangLiShiListViewController *vc = [[GuZhangLiShiListViewController alloc] init];
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
