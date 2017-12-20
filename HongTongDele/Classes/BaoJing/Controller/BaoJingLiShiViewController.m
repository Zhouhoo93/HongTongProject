//
//  BaoJingLiShiViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/11/15.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//
//报警列表户
#import "BaoJingLiShiViewController.h"
#import "JHTableChart.h"
#import "ShaiXuanKuangView.h"
#import "ErrorList.h"
#import "JHPickView.h"
@interface BaoJingLiShiViewController ()<UIScrollViewDelegate,TableButDelegate,ShaiXuanDelegate,yichangDelegate,JHPickerDelegate>
@property (nonatomic,strong)UIScrollView *bgscrollview;
@property (nonatomic,strong)UIView *leftView;
@property (nonatomic,strong)UIView *rightView;
@property (nonatomic,strong)JHTableChart *table1;
@property (nonatomic,strong)JHTableChart *table11;
@property (nonatomic,strong)JHTableChart *table3;
@property (nonatomic,strong)JHTableChart *table33;
@property (nonatomic,strong)ShaiXuanKuangView *shaixuanView;
@property (nonatomic,strong)ErrorList *errorList;
@property (nonatomic,assign)NSInteger select;
@end

@implementation BaoJingLiShiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报警电站";
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
    self.bgscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 94, KWidth, KHeight-94)];
    self.bgscrollview.delegate = self;
    //    self.bgscrollview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.bgscrollview.pagingEnabled = YES;
    self.bgscrollview.contentSize = CGSizeMake(KWidth*2, 0);
    [self.view addSubview:_bgscrollview];
    
    UIImageView *leftbg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 900)];
    leftbg.userInteractionEnabled = YES;
    leftbg.image = [UIImage imageNamed:@"未处理1"];
    [self.bgscrollview addSubview:leftbg];
    
    self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, KWidth, 900)];
    self.leftView.backgroundColor = [UIColor clearColor];
    [leftbg addSubview:self.leftView];
    
    
    UIImageView *rightbg = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth, 0, KWidth, 900)];
    rightbg.userInteractionEnabled = YES;
    rightbg.image = [UIImage imageNamed:@"处理中1"];
    [self.bgscrollview addSubview:rightbg];
    
    self.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, KWidth, 900)];
    self.rightView.backgroundColor = [UIColor clearColor];
    [rightbg addSubview:self.rightView];
    
    [self setLeftTable];
    [self setRightTable];
}

- (void)setLeftTable{
    UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 16, 12, 17)];
    leftImg.image = [UIImage imageNamed:@"定位"];
    [self.leftView addSubview:leftImg];
    
    UILabel *toplabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 14, KWidth-70, 24)];
    toplabel.font = [UIFont systemFontOfSize:14];
    toplabel.textColor = [UIColor darkGrayColor];
    toplabel.text = @"xx公司(分公司) 运维小组1 周巷镇 共9条";
    [self.leftView addSubview:toplabel];
    
//    UIButton *shaixuanBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(KWidth-90, 14, 80, 30)];
//    [shaixuanBtn1 setImage:[UIImage imageNamed:@"筛选"] forState:UIControlStateNormal];
//    [shaixuanBtn1 addTarget:self action:@selector(shaixuanBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.leftView addSubview:shaixuanBtn1];
    
    UIImageView *biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 45, KWidth-20, 400)];
    biaogeBg.image = [UIImage imageNamed:@"表格bg"];
    [self.leftView addSubview:biaogeBg];
    
    UIView *fourTable = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, KWidth, 400)];
    //    fourTable.bounces = NO;
    [self.leftView addSubview:fourTable];
    
    self.table1 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 400)];
    self.table1.delegate = self;
    self.table1.typeCount = 88;
    self.table1.small = YES;
    self.table1.isblue = NO;
    self.table1.bodyTextColor = [UIColor blackColor];
    self.table1.tableTitleFont = [UIFont systemFontOfSize:14];
    //    table.xDescTextFontSize =  (CGFloat)13;
    //    table.yDescTextFontSize =  (CGFloat)13;
    self.table1.colTitleArr = @[@"类别|序号",@"户号",@"地址",@"通讯",@"详情",@"发生时间"];
    
    
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
    oneTable1.frame = CGRectMake(0, 81, KWidth, 364);
    oneTable1.bounces = NO;
    [self.leftView addSubview:oneTable1];
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

- (void)shaixuanBtnClick{
    self.shaixuanView = [[[NSBundle mainBundle]loadNibNamed:@"ShaiXuanKuang" owner:self options:nil]objectAtIndex:0];
    self.shaixuanView.frame = CGRectMake(0, 0, KWidth, KHeight);
    self.shaixuanView.delegate = self;
    [self.view addSubview:self.shaixuanView];
}
-(void)dizhiClick{
    JHPickView *picker = [[JHPickView alloc]initWithFrame:self.view.bounds];
    picker.classArr = @[@"杭州",@"宁波",@"温州"];
    self.select = 0;
    picker.delegate = self ;
    picker.arrayType = weightArray;
    [self.view addSubview:picker];
    //    self.selectedIndexPath = 0;
}
-(void)guzhangClick{
    JHPickView *picker = [[JHPickView alloc]initWithFrame:self.view.bounds];
    picker.classArr = @[@"无故障",@"电网过压",@"电网欠压",@"电网过频",@"电网欠频",@"电网阻抗大",@"频率抖动",@"电网过流",@"直流过压"];
    self.select = 1;
    picker.delegate = self ;
    picker.arrayType = weightArray;
    [self.view addSubview:picker];
    //    self.selectedIndexPath = 0;
}

- (void)CloseClick{
    [self.shaixuanView removeFromSuperview];
}

- (void)LeftClick {
    [self.shaixuanView removeFromSuperview];
}


- (void)RightClick {
    [self.shaixuanView removeFromSuperview];
}
#pragma mark - JHPickerDelegate

-(void)PickerSelectorIndixString:(NSString *)str:(NSInteger)row
{
    
    if (self.select ==0) {
        [self.shaixuanView.dizhiBtn setTitle:str forState:UIControlStateNormal];
    }else{
        [self.shaixuanView.guzhangBtn setTitle:str forState:UIControlStateNormal];
    }
    
    
}

- (void)setRightTable{
    UIImageView *rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 16, 12, 17)];
    rightImg.image = [UIImage imageNamed:@"定位"];
    [self.rightView addSubview:rightImg];
    
    UILabel *toplabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 14, KWidth-70, 24)];
    toplabel.font = [UIFont systemFontOfSize:14];
    toplabel.textColor = [UIColor darkGrayColor];
    toplabel.text = @"xx公司(分公司) 运维小组1 周巷镇 共9条";
    [self.rightView addSubview:toplabel];
    
//    UIButton *shaixuanBtn3 = [[UIButton alloc] initWithFrame:CGRectMake(KWidth-90, 14, 80, 30)];
//    [shaixuanBtn3 setImage:[UIImage imageNamed:@"筛选"] forState:UIControlStateNormal];
//    [shaixuanBtn3 addTarget:self action:@selector(shaixuanBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.rightView addSubview:shaixuanBtn3];
    
    UIImageView *biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 45, KWidth-20, 400)];
    biaogeBg.image = [UIImage imageNamed:@"表格bg"];
    [self.rightView addSubview:biaogeBg];
    
    UIView *fourTable = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, KWidth, 400)];
    //    fourTable.bounces = NO;
    [self.rightView addSubview:fourTable];
    
    self.table3 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 400)];
    self.table3.delegate = self;
    self.table3.typeCount = 88;
    self.table3.small = YES;
    self.table3.isblue = NO;
    self.table3.bodyTextColor = [UIColor blackColor];
    self.table3.tableTitleFont = [UIFont systemFontOfSize:14];
    //    table.xDescTextFontSize =  (CGFloat)13;
    //    table.yDescTextFontSize =  (CGFloat)13;
    self.table3.colTitleArr = @[@"类别|序号",@"户号",@"地址",@"通讯",@"详情",@"发生时间"];
    
    
    self.table3.colWidthArr = @[@30.0,@40.0,@90.0,@30.0,@90.0,@50.0];
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
    NSArray *tipArr = @[@"1",@"5678",@"水云村201号",@"在线",@"直流母线过流",@"08-01 20:20"];
    self.table33.colTitleArr = tipArr;
    //        self.table44.colWidthArr = colWid;
    self.table33.colWidthArr = @[@30.0,@40.0,@90.0,@30.0,@90.0,@50.0];
    self.table33.bodyTextColor = [UIColor blackColor];
    self.table33.minHeightItems = 36;
    self.table33.lineColor = [UIColor lightGrayColor];
    self.table33.backgroundColor = [UIColor clearColor];
    
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
    self.table33.dataArr = array2d2;
    [self.table33 showAnimation];
    [oneTable1 addSubview:self.table33];
    oneTable1.contentSize = CGSizeMake(KWidth, 360);
    self.table33.frame = CGRectMake(0, 0, KWidth, [self.table33 heightFromThisDataSource]);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)transButIndex:(NSInteger)index
{
    self.errorList = [[[NSBundle mainBundle]loadNibNamed:@"ErrorListView" owner:self options:nil]objectAtIndex:0];
        self.errorList.delegate = self;
    self.errorList.frame = CGRectMake(0, 0, KWidth, KHeight);
    [self.view addSubview:self.errorList];
}
- (void)CloseClick1{
    [self.errorList removeFromSuperview];
}
-(void)LeftClick1{
    [self.errorList removeFromSuperview];
}
-(void)RightClick1{
    [self.errorList removeFromSuperview];
}


@end
