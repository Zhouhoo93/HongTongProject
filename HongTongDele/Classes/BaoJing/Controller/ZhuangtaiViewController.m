//
//  ZhuangtaiViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/11/21.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "ZhuangtaiViewController.h"
#import "CJScroViewBar.h"
#import "JHTableChart.h"
#import "InstallStationViewController.h"
#import "LoginOneViewController.h"
#import "AppDelegate.h"
#import "BaoJingZhuangTaiModel.h"
#define Bound_Width  [[UIScreen mainScreen] bounds].size.width
#define Bound_Height [[UIScreen mainScreen] bounds].size.height
// 获得RGB颜色
#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
@interface ZhuangtaiViewController ()<UIScrollViewDelegate,TableButDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *AllView;
@property (nonatomic,strong) UIView *QuanEView;
@property (nonatomic,strong) UIView *YuDianView;
@property (nonatomic,strong) CJScroViewBar *scroView;
@property (nonatomic,strong)JHTableChart *table1;
@property (nonatomic,strong)JHTableChart *table11;
@property (nonatomic,strong)JHTableChart *table2;
@property (nonatomic,strong)JHTableChart *table22;
@property (nonatomic,strong)JHTableChart *table3;
@property (nonatomic,strong)JHTableChart *table33;
@property (nonatomic,strong)BaoJingZhuangTaiModel *model;
@property (nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation ZhuangtaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [self createSegmentMenu];
    [self requestData];
    // Do any additional setup after loading the view.
}
- (void)createSegmentMenu{
    //数据源
    NSArray *array = @[@"离线",@"异常",@"故障"];
    
    _scroView = [CJScroViewBar setTabBarPoint:CGPointMake(0, 0)];
    [_scroView setData:array NormalColor
                      :kColor(16, 16, 16) SelectColor
                      :[UIColor whiteColor] Font
                      :[UIFont systemFontOfSize:15]];
    [self.view addSubview:_scroView];
    
    //设置默认值
    [CJScroViewBar setViewIndex:0];
    
    //TabBar回调
    __weak ZhuangtaiViewController *weakSelf =self;
    [_scroView getViewIndex:^(NSString *title, NSInteger index) {
        
        NSLog(@"title:%@ - index:%li",title,index);
        
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.scrollView.contentOffset = CGPointMake(index * Bound_Width, 0);
        }];
        
        /***********************【回调】***********************/
        //
        //         如果是tabbleView。这里可以写刷新操作
        //
        /***********************【回调】***********************/
    }];
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 20, 30)];
    [leftBtn setImage:[UIImage imageNamed:@"ab_ic_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scroView addSubview:leftBtn];
    
    UILabel *topLabel= [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2-50, 30, 100, 30)];
    topLabel.textColor = [UIColor whiteColor];
    topLabel.text = @"状态列表";
    topLabel.font = [UIFont systemFontOfSize:17];
    topLabel.textAlignment = NSTextAlignmentCenter;
    [_scroView addSubview:topLabel];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 108, Bound_Width, Bound_Height - 108)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.contentSize = CGSizeMake(array.count*Bound_Width, 0);
    [self.view addSubview:self.scrollView];
    
    for (int i=0; i<array.count; i++) {
        if (i==0) {
            self.AllView = [[UIView alloc]initWithFrame:CGRectMake(i*Bound_Width, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))];
            self.AllView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [self.scrollView addSubview:self.AllView];
        }else if (i==1){
            self.QuanEView = [[UIView alloc]initWithFrame:CGRectMake(i*Bound_Width, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))];
            self.QuanEView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [self.scrollView addSubview:self.QuanEView];
        }else{
            self.YuDianView = [[UIView alloc]initWithFrame:CGRectMake(i*Bound_Width, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))];
            self.YuDianView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [self.scrollView addSubview:self.YuDianView];
        }
        
    }
    [self setTabel];
    
}
- (void)setTabel{
    for (int i=0; i<3; i++) {
        
        if (i==0) {
            UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(25, 16, 12, 17)];
            leftImg.image = [UIImage imageNamed:@"定位"];
            [self.AllView addSubview:leftImg];
            
            UILabel *toplabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 14, KWidth-70, 24)];
            toplabel.font = [UIFont systemFontOfSize:15];
            toplabel.textColor = [UIColor darkGrayColor];
            toplabel.text = [NSString stringWithFormat:@"%@(分公司)%@",self.name,self.name1];
            //;@"XX公司(分公司)运维小组1 周巷镇 共9户"
            [self.AllView addSubview:toplabel];
            
            UIImageView *biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, KWidth-20, 400)];
            biaogeBg.image = [UIImage imageNamed:@"表格bg"];
            [self.AllView addSubview:biaogeBg];
            
            UIView *fourTable = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, KWidth, 400)];
            //    fourTable.bounces = NO;
            [self.AllView addSubview:fourTable];
            
            self.table1 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 400)];
            self.table1.delegate = self;
            self.table1.typeCount = 88;
            self.table1.isblue = NO;
            self.table1.bodyTextColor = [UIColor blackColor];
            self.table1.tableTitleFont = [UIFont systemFontOfSize:14];
            //    table.xDescTextFontSize =  (CGFloat)13;
            //    table.yDescTextFontSize =  (CGFloat)13;
            self.table1.colTitleArr = @[@"类别|序号",@"户号",@"地址",@"详情",@"发生时间"];
            
            
            self.table1.colWidthArr = @[@30.0,@60.0,@100.0,@80.0,@80.0];
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
            oneTable1.frame = CGRectMake(0, 76, KWidth, 364);
            oneTable1.bounces = NO;
            [self.AllView addSubview:oneTable1];
            self.table11 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 364)];
            self.table11.typeCount = 88;
            self.table11.isblue = NO;
            self.table11.delegate = self;
            self.table11.tableTitleFont = [UIFont systemFontOfSize:14];
            NSArray *tipArr = @[@"1",@"5678",@"水云街55号1幢",@"设备离线",@"09-02 20:20"];
            self.table11.colTitleArr = tipArr;
            //        self.table44.colWidthArr = colWid;
            self.table11.colWidthArr = @[@30.0,@60.0,@100.0,@80.0,@80.0];
            self.table11.bodyTextColor = [UIColor blackColor];
            self.table11.minHeightItems = 36;
            self.table11.lineColor = [UIColor lightGrayColor];
            self.table11.backgroundColor = [UIColor clearColor];
            
            NSArray *array2d2 = @[
                                  @[@"2",@"5678",@"水云街55号1幢",@"设备离线",@"09-02 20:20"],
                                  @[@"3",@"5678",@"水云街55号1幢",@"设备离线",@"09-02 20:20"],
                                  @[@"3",@"5678",@"水云街55号1幢",@"设备离线",@"09-02 20:20"],
                                  @[@"4",@"5678",@"水云街55号1幢",@"设备离线",@"09-02 20:20"],
                                  @[@"5",@"5678",@"水云街55号1幢",@"设备离线",@"09-02 20:20"],
                                  @[@"6",@"5678",@"水云街55号1幢",@"设备离线",@"09-02 20:20"],
                                  @[@"7",@"5678",@"水云街55号1幢",@"设备离线",@"09-02 20:20"],
                                  @[@"8",@"5678",@"水云街55号1幢",@"设备离线",@"09-02 20:20"],
                                  @[@"9",@"5678",@"水云街55号1幢",@"设备离线",@"09-02 20:20"]];
            self.table11.dataArr = array2d2;
            [self.table11 showAnimation];
            [oneTable1 addSubview:self.table11];
            oneTable1.contentSize = CGSizeMake(KWidth, 360);
            self.table11.frame = CGRectMake(0, 0, KWidth, [self.table11 heightFromThisDataSource]);
        }else if (i==1){
            UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(25, 16, 12, 17)];
            leftImg.image = [UIImage imageNamed:@"定位"];
            [self.QuanEView addSubview:leftImg];
            
            UILabel *toplabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 14, KWidth-70, 24)];
            toplabel.font = [UIFont systemFontOfSize:15];
            toplabel.textColor = [UIColor darkGrayColor];
            toplabel.text = toplabel.text = [NSString stringWithFormat:@"%@(分公司)%@",self.name,self.name1];;
            [self.QuanEView addSubview:toplabel];
            
            UIImageView *biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, KWidth-20, 400)];
            biaogeBg.image = [UIImage imageNamed:@"表格bg"];
            [self.QuanEView addSubview:biaogeBg];
            
            UIView *fourTable = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, KWidth, 400)];
            //    fourTable.bounces = NO;
            [self.QuanEView addSubview:fourTable];
            
            self.table2 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 400)];
            self.table2.delegate = self;
            self.table2.typeCount = 88;
            self.table2.isblue = NO;
            self.table2.bodyTextColor = [UIColor blackColor];
            self.table2.tableTitleFont = [UIFont systemFontOfSize:14];
            //    table.xDescTextFontSize =  (CGFloat)13;
            //    table.yDescTextFontSize =  (CGFloat)13;
            self.table2.colTitleArr = @[@"类别|序号",@"户号",@"地址",@"详情",@"发生时间"];
            
            
            self.table2.colWidthArr = @[@30.0,@60.0,@100.0,@80.0,@80.0];
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
            [fourTable addSubview:self.table2];
            /*        Automatic calculation table height        */
            self.table2.frame = CGRectMake(0, 0, KWidth, [self.table2 heightFromThisDataSource]);
            
            UIScrollView *oneTable1 = [[UIScrollView alloc] init];
            //        if (self.dayFeeArr.count>11) {
            //            oneTable1.frame = CGRectMake(0,KHeight/667*92, k_MainBoundsWidth, KHeight/664*(300));
            //        }else{
            //            oneTable1.frame = CGRectMake(0,KHeight/667*92, k_MainBoundsWidth, KHeight/667*46*self.dayFeeArr.count);
            //        }
            oneTable1.frame = CGRectMake(0, 76, KWidth, 364);
            oneTable1.bounces = NO;
            [self.QuanEView addSubview:oneTable1];
            self.table22 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 364)];
            self.table22.typeCount = 88;
            self.table22.isblue = NO;
            self.table22.delegate = self;
            self.table22.tableTitleFont = [UIFont systemFontOfSize:14];
            NSArray *tipArr = @[@"1",@"5678",@"水云街55号1幢",@"设备异常",@"09-02 20:20"];
            self.table22.colTitleArr = tipArr;
            //        self.table44.colWidthArr = colWid;
            self.table22.colWidthArr = @[@30.0,@60.0,@100.0,@80.0,@80.0];
            self.table22.bodyTextColor = [UIColor blackColor];
            self.table22.minHeightItems = 36;
            self.table22.lineColor = [UIColor lightGrayColor];
            self.table22.backgroundColor = [UIColor clearColor];
            
            NSArray *array2d2 = @[
                                  @[@"2",@"5678",@"水云街55号1幢",@"设备异常",@"09-02 20:20"],
                                  @[@"3",@"5678",@"水云街55号1幢",@"设备异常",@"09-02 20:20"],
                                  @[@"3",@"5678",@"水云街55号1幢",@"设备异常",@"09-02 20:20"],
                                  @[@"4",@"5678",@"水云街55号1幢",@"设备异常",@"09-02 20:20"],
                                  @[@"5",@"5678",@"水云街55号1幢",@"设备异常",@"09-02 20:20"],
                                  @[@"6",@"5678",@"水云街55号1幢",@"设备异常",@"09-02 20:20"],
                                  @[@"7",@"5678",@"水云街55号1幢",@"设备异常",@"09-02 20:20"],
                                  @[@"8",@"5678",@"水云街55号1幢",@"设备异常",@"09-02 20:20"],
                                  @[@"9",@"5678",@"水云街55号1幢",@"设备异常",@"09-02 20:20"]];
            self.table22.dataArr = array2d2;
            [self.table22 showAnimation];
            [oneTable1 addSubview:self.table22];
            oneTable1.contentSize = CGSizeMake(KWidth, 360);
            self.table22.frame = CGRectMake(0, 0, KWidth, [self.table22 heightFromThisDataSource]);
        }else{
            UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(25, 16, 12, 17)];
            leftImg.image = [UIImage imageNamed:@"定位"];
            [self.YuDianView addSubview:leftImg];
            
            UILabel *toplabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 14, KWidth-70, 24)];
            toplabel.font = [UIFont systemFontOfSize:15];
            toplabel.textColor = [UIColor darkGrayColor];
            toplabel.text = [NSString stringWithFormat:@"%@(分公司)%@",self.name,self.name1];;
            [self.YuDianView addSubview:toplabel];
            
            UIImageView *biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, KWidth-20, 400)];
            biaogeBg.image = [UIImage imageNamed:@"表格bg"];
            [self.YuDianView addSubview:biaogeBg];
            
            UIView *fourTable = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, KWidth, 400)];
            //    fourTable.bounces = NO;
            [self.YuDianView addSubview:fourTable];
            
            self.table3 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 400)];
            self.table3.delegate = self;
            self.table3.typeCount = 88;
            self.table3.isblue = NO;
            self.table3.bodyTextColor = [UIColor blackColor];
            self.table3.tableTitleFont = [UIFont systemFontOfSize:14];
            //    table.xDescTextFontSize =  (CGFloat)13;
            //    table.yDescTextFontSize =  (CGFloat)13;
            self.table3.colTitleArr = @[@"类别|序号",@"户号",@"地址",@"详情",@"发生时间"];;
            
            
            self.table3.colWidthArr = @[@30.0,@60.0,@100.0,@80.0,@80.0];
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
            oneTable1.frame = CGRectMake(0, 76, KWidth, 364);
            oneTable1.bounces = NO;
            [self.YuDianView addSubview:oneTable1];
            self.table33 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 364)];
            self.table33.typeCount = 88;
            self.table33.isblue = NO;
            self.table33.delegate = self;
            self.table33.tableTitleFont = [UIFont systemFontOfSize:14];
            NSArray *tipArr = @[@"1",@"5678",@"水云街55号1幢",@"设备故障",@"09-02 20:20"];
            self.table33.colTitleArr = tipArr;
            //        self.table44.colWidthArr = colWid;
            self.table33.colWidthArr = @[@30.0,@60.0,@100.0,@80.0,@80.0];
            self.table33.bodyTextColor = [UIColor blackColor];
            self.table33.minHeightItems = 36;
            self.table33.lineColor = [UIColor lightGrayColor];
            self.table33.backgroundColor = [UIColor clearColor];
            
            NSArray *array2d2 = @[
                                  @[@"2",@"5678",@"水云街55号1幢",@"设备故障",@"09-02 20:20"],
                                  @[@"3",@"5678",@"水云街55号1幢",@"设备故障",@"09-02 20:20"],
                                  @[@"3",@"5678",@"水云街55号1幢",@"设备故障",@"09-02 20:20"],
                                  @[@"4",@"5678",@"水云街55号1幢",@"设备故障",@"09-02 20:20"],
                                  @[@"5",@"5678",@"水云街55号1幢",@"设备故障",@"09-02 20:20"],
                                  @[@"6",@"5678",@"水云街55号1幢",@"设备故障",@"09-02 20:20"],
                                  @[@"7",@"5678",@"水云街55号1幢",@"设备故障",@"09-02 20:20"],
                                  @[@"8",@"5678",@"水云街55号1幢",@"设备故障",@"09-02 20:20"],
                                  @[@"9",@"5678",@"水云街55号1幢",@"设备故障",@"09-02 20:20"]];
            self.table33.dataArr = array2d2;
            [self.table33 showAnimation];
            [oneTable1 addSubview:self.table33];
            oneTable1.contentSize = CGSizeMake(KWidth, 360);
            self.table33.frame = CGRectMake(0, 0, KWidth, [self.table33 heightFromThisDataSource]);
        }
        
    }
}
-(void)backBtnClick{
    self.scroView = nil;
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UITableView class]]){
        //UITableView
    }
    if (scrollView ==_scrollView) {
        //scrollView
        NSInteger index = scrollView.contentOffset.x / Bound_Width;
        //设置Bar的移动位置
        [CJScroViewBar setViewIndex:index];
        [self.scroView setlineFrame:index];
    }
    //    NSInteger index = scrollView.contentOffset.x / Bound_Width;
    //    //设置Bar的移动位置
    //    [CJScroViewBar setViewIndex:index];
    //    [self.scroView setlineFrame:index];
    
}

- (void)transButIndex:(NSInteger)index
{
    NSLog(@"代理方法%ld",index);
    self.navigationController.navigationBar.hidden = NO;
    InstallStationViewController *vc = [[InstallStationViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)requestData{
    NSString *URL = [NSString stringWithFormat:@"%@/police/status",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    [manager.requestSerializer  setValue:@"work" forHTTPHeaderField:@"user"];
    [manager.requestSerializer  setValue:[NSString stringWithFormat:@"%@",self.workID] forHTTPHeaderField:@"id"];
    NSLog(@"workid:%@",self.workID);
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取运维小组状态正确%@",responseObject);
        
        if ([responseObject[@"result"][@"success"] intValue] ==0) {
            NSNumber *code = responseObject[@"result"][@"errorCode"];
            NSString *errorcode = [NSString stringWithFormat:@"%@",code];
            if ([errorcode isEqualToString:@"3100"])  {
                [MBProgressHUD showText:@"请重新登陆"];
                [self newLogin];
            }else{
                NSString *str = responseObject[@"result"][@"errorMsg"];
                [MBProgressHUD showText:str];
            }
        }else{
            for (NSMutableDictionary *dic in responseObject[@"content"]) {
                _model = [[BaoJingZhuangTaiModel alloc] initWithDictionary:dic];
                [self.dataArr addObject:_model];
            }
//            [self setTabel];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}
- (void)newLogin{
    [MBProgressHUD showText:@"请重新登录"];
    [self performSelector:@selector(backTo) withObject: nil afterDelay:2.0f];
}
-(void)backTo{
    [self clearLocalData];
    //    LoginViewController *VC =[[LoginViewController alloc] init];
    //    VC.hidesBottomBarWhenPushed = YES;
    UIApplication *app =[UIApplication sharedApplication];
    AppDelegate *app2 = app.delegate;
    //    app2.window.rootViewController = VC;
    //    [self.navigationController pushViewController:VC animated:YES];
    LoginOneViewController *loginViewController = [[LoginOneViewController alloc] initWithNibName:@"LoginOneViewController" bundle:nil];
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:loginViewController];
    
    app2.window.rootViewController = navigationController;
}
- (void)clearLocalData{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:nil forKey:@"phone"];
    [userDefaults setValue:nil forKey:@"passWord"];
    [userDefaults setValue:nil forKey:@"token"];
    //    [userDefaults setValue:nil forKey:@"registerid"];
    [userDefaults synchronize];
    
}
-(BaoJingZhuangTaiModel *)model{
    if (!_model) {
        _model = [[BaoJingZhuangTaiModel alloc] init];
    }
    return _model;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return  _dataArr;
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
