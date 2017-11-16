//
//  SlectListViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/11/13.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "SlectListViewController.h"
#import "JHTableChart.h"
#import "InstallStationViewController.h"
@interface SlectListViewController ()<TableButDelegate>
@property (nonatomic,strong)JHTableChart *table;
@property (nonatomic,strong)JHTableChart *table1;
@end

@implementation SlectListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"电站列表";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self setUI];
    [self setTabel];
    // Do any additional setup after loading the view.
}

- (void)setUI{
    UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 80, 13, 20)];
    leftImg.image = [UIImage imageNamed:@"定位"];
    [self.view addSubview:leftImg];
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 80, 100, 20)];
    leftLabel.text = @"分公司一";
    [self.view addSubview:leftLabel];
    
    UIImageView *leftImg1 = [[UIImageView alloc] initWithFrame:CGRectMake(135, 82, 15, 15)];
    leftImg1.image = [UIImage imageNamed:@"分隔号"];
    [self.view addSubview:leftImg1];
    
    UILabel *leftLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(155, 80, 100, 20)];
    leftLabel1.text = @"运维小组2";
    [self.view addSubview:leftLabel1];
    
    UIImageView *leftImg2 = [[UIImageView alloc] initWithFrame:CGRectMake(250, 82, 15, 15)];
    leftImg2.image = [UIImage imageNamed:@"分隔号"];
    [self.view addSubview:leftImg2];
    
    UILabel *leftLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(270, 80, 100, 20)];
    leftLabel2.text = @"镇海镇";
    [self.view addSubview:leftLabel2];
    
    UILabel *downLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 105, 300, 20)];
    downLabel.text = @"装机量:  90kW   户数: 9户";
    downLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:downLabel];
}

- (void)setTabel{
    UIImageView *biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 150, KWidth-20, 400)];
    biaogeBg.image = [UIImage imageNamed:@"表格bg"];
    [self.view addSubview:biaogeBg];
    
    UIView *fourTable = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 150, KWidth, 400)];
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
    self.table.colTitleArr = @[@"类别|序号",@"户号",@"地址",@"装机容量(kW)",@"已发电量(度)",@"完成率(%)"];

    
    self.table.colWidthArr = @[@30.0,@40.0,@130.0,@50.0,@50.0,@50.0];
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
    oneTable1.frame = CGRectMake(0, 186, KWidth, 364);
    oneTable1.bounces = NO;
    [self.view addSubview:oneTable1];
    self.table1 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 364)];
    self.table1.typeCount = 88;
    self.table1.isblue = NO;
    self.table1.delegate = self;
    self.table1.tableTitleFont = [UIFont systemFontOfSize:14];
    NSArray *tipArr = @[@"1",@"5678",@"水云街998号1幢",@"10kW",@"100度",@"60%"];
    self.table1.colTitleArr = tipArr;
    //        self.table44.colWidthArr = colWid;
    self.table1.colWidthArr = @[@30.0,@40.0,@130.0,@50.0,@50.0,@50.0];
    self.table1.bodyTextColor = [UIColor blackColor];
    self.table1.minHeightItems = 36;
    self.table1.lineColor = [UIColor lightGrayColor];
    self.table1.backgroundColor = [UIColor clearColor];
    
    NSArray *array2d2 = @[
                          @[@"2",@"5678",@"水云街998号1幢",@"10kW",@"100度",@"60%"],
                          @[@"3",@"5678",@"水云街998号1幢",@"10kW",@"100度",@"60%"],
                          @[@"4",@"5678",@"水云街998号1幢",@"10kW",@"100度",@"60%"],
                          @[@"5",@"5678",@"水云街998号1幢",@"10kW",@"100度",@"60%"],
                          @[@"6",@"5678",@"水云街998号1幢",@"10kW",@"100度",@"60%"],
                          @[@"7",@"5678",@"水云街998号1幢",@"10kW",@"100度",@"60%"],
                          @[@"8",@"5678",@"水云街998号1幢",@"10kW",@"100度",@"60%"],
                          @[@"9",@"5678",@"水云街998号1幢",@"10kW",@"100度",@"60%"],
                          @[@"10",@"5678",@"水云街998号1幢",@"10kW",@"100度",@"60%"]
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
    InstallStationViewController *vc = [[InstallStationViewController alloc] init];
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
