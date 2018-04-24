//
//  InstallStationViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/8/17.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "InstallStationViewController.h"
#import "InstallStationTableViewCell.h"
#import "JHLineChart.h"
#import "HistogramView.h"
#import "AppDelegate.h"
#import "LoginOneViewController.h"
#import "StationTextView.h"
#import "GuZhangListViewController.h"
@interface InstallStationViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,TopButDelegate>

@property (nonatomic,strong)UITableView *table;
@property (nonatomic,strong)UIScrollView *bgScrollView;
@property (nonatomic,strong) NSMutableArray *FirstChartgenArr;
@property (nonatomic,strong) NSMutableArray *FirstChartuseArr;
@property (nonatomic,strong) NSMutableArray *FirstChartgenArr1;
@property (nonatomic,strong) NSMutableArray *FirstChartuseArr1;
@property (nonatomic,strong) NSMutableArray *FirstChartXArr;
@property (nonatomic,strong) NSMutableArray *FirstChartXArr1;
@property (nonatomic,assign)float maxNumber;
@property (nonatomic,assign)float maxNumber2;
@property (nonatomic,assign)float maxNumber3;
@property (nonatomic,strong) JHLineChart *lineChart;
@property (nonatomic,strong) JHLineChart *lineChart2;
@property (nonatomic,strong) JHLineChart *lineChart1;
@property (nonatomic,strong) JHLineChart *lineChart3;
@property (nonatomic,strong) JHLineChart *lineChart4;
@property (nonatomic,strong) HistogramView *zhuView;
@property (nonatomic,strong) HistogramView *zhuView1;
@property (nonatomic,strong) HistogramView *zhuView2;
@property (nonatomic,strong) NSMutableArray *blueArr;
@property (nonatomic,strong) NSMutableArray *greenArr;
@property (nonatomic,strong) NSMutableArray *redArr;
@property (nonatomic,strong) NSMutableArray *yellowArr;
@property (nonatomic,copy) NSString *state;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,strong) UIImageView *bg;
@property (nonatomic,strong) UIImageView *bg1;
@property (nonatomic,strong) UIImageView *bg2;
@property (nonatomic,strong) UIImageView *bg3;
@property (nonatomic,strong) UIImageView *bg4;
@property (nonatomic,strong) UIImageView *bg5;
@property (nonatomic,strong)StationTextView *StationTextview;
@property (nonatomic,strong) UIScrollView *firstScroll;
@property (nonatomic,strong) UIScrollView *firstScroll1;
@property (nonatomic,copy) NSString *position;
@end

@implementation InstallStationViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}
- (void)viewDidLoad {
    [self setUI];
    [super viewDidLoad];
    [self requestData];
    [self requestFirstChart];
    [self requestFirstChart2];
//    [self requestSecondChart];
    [self requestSecondChart];
    [self requestSecondChart1];
    [self requestSecondChart2];
    self.title = @"电站详情";
    
    // Do any additional setup after loading the view.
}

- (void)setUI{
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight)];
    _bgScrollView.delegate = self;
    _bgScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.bgScrollView.contentSize = CGSizeMake(KWidth, 860);
    [self.view addSubview:_bgScrollView];
    
    self.StationTextview = [[[NSBundle mainBundle]loadNibNamed:@"StationTextView" owner:self options:nil]objectAtIndex:0];
    self.StationTextview.delegate = self;
    self.StationTextview.frame = CGRectMake(0, 0, KWidth, 390);
    
    self.StationTextview.viewToTopMas.constant = 34;
    self.StationTextview.wuding1.hidden = YES;
    self.StationTextview.wuding2.hidden = YES;
    self.StationTextview.zhuangji1.hidden = YES;
    self.StationTextview.zhuangji2.hidden = YES;
    self.StationTextview.chaoxiang1.hidden = YES;
    self.StationTextview.chaoxiang2.hidden = YES;
    self.StationTextview.jiaodu1.hidden = YES;
    self.StationTextview.jiaodu2.hidden = YES;
    self.StationTextview.taiqu1.hidden = YES;
    self.StationTextview.taiqu2.hidden = YES;
    self.StationTextview.xianlu1.hidden = YES;
    self.StationTextview.xianlu2.hidden = YES;
    self.StationTextview.ganhao1.hidden = YES;
    self.StationTextview.ganhao2.hidden = YES;
    self.StationTextview.zujian1.hidden = YES;
    self.StationTextview.zujian2.hidden = YES;
    self.StationTextview.guige1.hidden = YES;
    self.StationTextview.guige2.hidden = YES;
    self.StationTextview.shuliang1.hidden = YES;
    self.StationTextview.shuliang2.hidden = YES;
    self.StationTextview.nibianqi1.hidden = YES;
    self.StationTextview.nibianqi2.hidden = YES;
    self.StationTextview.guige3.hidden = YES;
    self.StationTextview.guige4.hidden = YES;
    self.StationTextview.taishu1.hidden = YES;
    self.StationTextview.taishu2.hidden = YES;
    self.StationTextview.bingwang1.hidden = YES;
    self.StationTextview.bingwang2.hidden = YES;
    self.StationTextview.bingwangfangshi1.hidden = YES;
    self.StationTextview.bingwangfangshi2.hidden = YES;
    self.StationTextview.canshuView.hidden = YES;
    
    [self.bgScrollView addSubview:self.StationTextview];
    
    self.firstScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 410, KWidth,KHeight/667*211 )];
    self.firstScroll.contentSize = CGSizeMake(KWidth*2, 0);
    self.firstScroll.pagingEnabled = YES;
    [self.bgScrollView addSubview:self.firstScroll];
    self.firstScroll1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 630, KWidth,KHeight/667*211 )];
    self.firstScroll1.contentSize = CGSizeMake(KWidth*3, 0);
    self.firstScroll1.pagingEnabled = YES;
    [self.bgScrollView addSubview:self.firstScroll1];
}
//执行协议方法
- (void)transButIndex
{
    NSLog(@"代理方法");
    if (self.StationTextview.wuding1.hidden) {
        
        self.bg.frame = CGRectMake(0, 550, KWidth-14, KHeight/667*211);
        self.bg1.frame = CGRectMake(0, 750, KWidth-14,KHeight/667*211);
        self.bgScrollView.contentSize = CGSizeMake(KWidth, 1000);
        self.StationTextview.frame = CGRectMake(0, 0, KWidth, 530);
    }else{
        self.bg.frame = CGRectMake(0, 410, KWidth-14, KHeight/667*211);
        self.bg1.frame = CGRectMake(0, 610, KWidth-14,KHeight/667*211);
        self.bgScrollView.contentSize = CGSizeMake(KWidth, 860);
        self.StationTextview.frame = CGRectMake(0, 0, KWidth, 390);
    }
    
}

- (void)xinxiBtnClick:(NSString *)tel{
    NSString *telLabel = [NSString stringWithFormat:@"sms://%@",tel];
    NSURL *url = [NSURL URLWithString:telLabel];
    
    [[UIApplication sharedApplication] openURL:url];
}

- (void)bohaoBtnClick:(NSString *)tel{
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",tel];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
- (void)daohangBtnClick{
    NSArray *newArray3 = [self.position componentsSeparatedByString:@","];
    BOOL hasBaiduMap = NO;
    BOOL hasGaodeMap = NO;
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]){
        hasBaiduMap = YES;
    }
    
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
        hasGaodeMap = YES;
    }
    
    
    if (hasBaiduMap)
    {
        
        //        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:终点&mode=driving",currentLat, currentLon,_shopLat,_shopLon] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:30.3373243942,120.3936767578|name:我的位置&destination=latlng:%@,%@|name:终点&mode=driving",newArray3[1],newArray3[0]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
        NSLog(@"定位:%@",urlString);
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
    }else if(hasGaodeMap)
    {
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&poiname=%@&lat=%@&lon=%@&dev=1&style=2",@"红彤代理端", @"123123123", @"终点",newArray3[1],newArray3[0]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"定位:%@",urlString);
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
    }else{
        [MBProgressHUD showText:@"请先安装百度地图或者高德地图"];
    }
}
- (void)zhengchangBtnClick{
    GuZhangListViewController *vc = [[GuZhangListViewController alloc] init];
    vc.bid = self.bid;
    vc.huhao = self.StationTextview.huhao.text;
    vc.address = self.StationTextview.addressLabel1.text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)lixianBtnClick{
    GuZhangListViewController *vc = [[GuZhangListViewController alloc] init];
    vc.bid = self.bid;
    vc.huhao = self.StationTextview.huhao.text;
    vc.address = self.StationTextview.addressLabel1.text;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)yichangBtnClick{
    GuZhangListViewController *vc = [[GuZhangListViewController alloc] init];
    vc.bid = self.bid;
    vc.huhao = self.StationTextview.huhao.text;
    vc.address = self.StationTextview.addressLabel1.text;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)guzhangBtnClick{
    GuZhangListViewController *vc = [[GuZhangListViewController alloc] init];
    vc.bid = self.bid;
    vc.huhao = self.StationTextview.huhao.text;
    vc.address = self.StationTextview.addressLabel1.text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setFirstChart{
    
    
    self.bg = [[UIImageView alloc] initWithFrame:CGRectMake(7, 0, KWidth-14, KHeight/667*211)];
    self.bg.image = [UIImage imageNamed:@"表格bg"];
    [self.firstScroll addSubview:self.bg];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2-105, 10, 250, 20)];
    titleLabel.text = @"月效率曲线比较图";
    titleLabel.textColor = RGBColor(2, 28, 106);
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.bg addSubview:titleLabel];
    
    UILabel *waLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 25, 10)];
    waLabel.text = @"(度)";
    waLabel.textColor = RGBColor(0, 60, 255);
    waLabel.font = [UIFont systemFontOfSize:11];
    [self.bg addSubview:waLabel];
    UILabel *waLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-38, 25, 25, 10)];
    waLabel1.text = @"(度)";
    waLabel1.textColor = RGBColor(255, 0, 0);
    waLabel1.font = [UIFont systemFontOfSize:11];
    [self.bg addSubview:waLabel1];
    UILabel *shiLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-33,KHeight/667*190, 30, 10)];
    shiLabel.text = @"(日)";
    shiLabel.textColor = [UIColor darkGrayColor];
    shiLabel.font = [UIFont systemFontOfSize:11];
    [self.bg addSubview:shiLabel];
    
    UILabel *rightTopLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-77, 10, 50, 20)];
    rightTopLabel.text = @"单个电站";
    rightTopLabel.font = [UIFont systemFontOfSize:8];
    [self.bg addSubview:rightTopLabel];
    UIImageView *topImg = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-90, 15, 10, 10)];
    topImg.image = [UIImage imageNamed:@"椭圆-6"];
    [self.bg addSubview:topImg];
    
    UILabel *rightDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-77, 25, 50, 20)];
    rightDownLabel.text = @"整个电站";
    rightDownLabel.font = [UIFont systemFontOfSize:8];
    [self.bg addSubview:rightDownLabel];
    UIImageView *downImg = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-90, 30, 10, 10)];
    downImg.image = [UIImage imageNamed:@"椭圆-6-拷贝"];
    [self.bg addSubview:downImg];
    
    NSInteger count = 1;
    for (int i=0; i<self.FirstChartgenArr.count; i++) {
        if (i>0) {
            if (self.FirstChartgenArr[i]>=0) {
                if (self.FirstChartgenArr[i-1]<0) {
                    count++;
                }
            }
        }
    }
    NSMutableArray *genArr1 = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<self.FirstChartgenArr.count; i++) {
        if (i>0) {
            if (self.FirstChartgenArr[i]>=0) {
                if (self.FirstChartgenArr[i-1]<0) {
                    [genArr1 addObject:self.FirstChartgenArr[i]];
                }
            }else{
                
            }
        }
    }
    
    
    
    self.lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(0,KHeight/667*30, KWidth-14, KHeight/667*180) andLineChartType:JHChartLineValueNotForEveryX];
    self.lineChart.isShowRight = NO;
    self.lineChart.xLineDataArr = self.FirstChartXArr;
    self.lineChart.contentInsets = UIEdgeInsetsMake(0, 25, 20, 10);
    
    self.lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
    //用电数据
    self.lineChart.valueArr = @[self.FirstChartgenArr];
   
    self.lineChart.showYLevelLine = YES;
    self.lineChart.showYLine = YES;
    self.lineChart.isShowLeft = NO;
    self.lineChart.isKw = YES;
    self.lineChart.isShowRight = YES;
    self.lineChart.showValueLeadingLine = NO;
    self.lineChart.valueFontSize = 0.0;
    self.lineChart.backgroundColor = [UIColor clearColor];
    /* Line Chart colors */
    self.lineChart.valueLineColorArr =@[ RGBColor(255, 0, 0)];
    /* Colors for every line chart*/
    //    lineChart.pointColorArr = @[[UIColor orangeColor],[UIColor yellowColor]];
    /* color for XY axis */
    self.lineChart.xAndYLineColor = [UIColor blackColor];
    /* XY axis scale color */
    self.lineChart.xAndYNumberColor = [UIColor darkGrayColor];
    /* Dotted line color of the coordinate point */
    self.lineChart.positionLineColorArr = @[[UIColor clearColor],[UIColor clearColor]];
    /*        Set whether to fill the content, the default is False         */
    //    lineChart.contentFill = YES;
    /*        Set whether the curve path         */
    self.lineChart.pathCurve = YES;
    /*        Set fill color array         */
    //    lineChart.contentFillColorArr = @[[UIColor colorWithRed:0 green:1 blue:0 alpha:0.468],[UIColor colorWithRed:1 green:0 blue:0 alpha:0.468]];
    [self.bg addSubview:self.lineChart];
    CGFloat maxUse = 0;
    for (int i=0; i<_FirstChartgenArr.count; i++) {
        CGFloat num = [_FirstChartgenArr[i] floatValue];
        if (num > maxUse) {
            maxUse = num;
        }
    }
    CGFloat maxGen = 0;
    for (int i=0; i<_FirstChartuseArr.count; i++) {
        CGFloat num = [_FirstChartuseArr[i] floatValue];
        if (num > maxGen) {
            maxGen = num;
        }
    }
    CGFloat bei = maxGen/maxUse;
    CGFloat da = maxUse-maxGen;
    if (maxUse==0) {
        NSString *str1 = [NSString stringWithFormat:@"%.2f",maxUse];
        NSString *str2 = [NSString stringWithFormat:@"%.2f",maxUse*2];
        NSString *str3 = [NSString stringWithFormat:@"%.2f",maxUse*3];
        NSString *str4 = [NSString stringWithFormat:@"%.2f",maxUse*4];
        NSString *str5 = [NSString stringWithFormat:@"%.2f",maxUse*5];
        NSString *str6 = [NSString stringWithFormat:@"%.2f",maxUse*6];
        self.lineChart.yLineDataArr = @[str1,str2,str3,str4,str5,str6];
    }else{
        CGFloat six = 1/6;
        if (bei>6) {
            NSString *str1 = [NSString stringWithFormat:@"%.2f",maxUse];
            NSString *str2 = [NSString stringWithFormat:@"%.2f",maxUse*2];
            NSString *str3 = [NSString stringWithFormat:@"%.2f",maxUse*3];
            NSString *str4 = [NSString stringWithFormat:@"%.2f",maxUse*4];
            NSString *str5 = [NSString stringWithFormat:@"%.2f",maxUse*5];
            NSString *str6 = [NSString stringWithFormat:@"%.2f",maxUse*6];
            self.lineChart.yLineDataArr = @[str1,str2,str3,str4,str5,str6];
        }else if (bei<1/6){
            NSString *str1 = [NSString stringWithFormat:@"%.2f",maxUse/6];
            NSString *str2 = [NSString stringWithFormat:@"%.2f",maxUse/6*2];
            NSString *str3 = [NSString stringWithFormat:@"%.2f",maxUse/6*3];
            NSString *str4 = [NSString stringWithFormat:@"%.2f",maxUse/6*4];
            NSString *str5 = [NSString stringWithFormat:@"%.2f",maxUse/6*5];
            NSString *str6 = [NSString stringWithFormat:@"%.2f",maxUse/6*6];
            self.lineChart.yLineDataArr = @[str1,str2,str3,str4,str5,str6];
        }else{
            if (da>0) {
                NSString *str1 = [NSString stringWithFormat:@"%.2f",maxUse/6];
                NSString *str2 = [NSString stringWithFormat:@"%.2f",maxUse/6*2];
                NSString *str3 = [NSString stringWithFormat:@"%.2f",maxUse/6*3];
                NSString *str4 = [NSString stringWithFormat:@"%.2f",maxUse/6*4];
                NSString *str5 = [NSString stringWithFormat:@"%.2f",maxUse/6*5];
                NSString *str6 = [NSString stringWithFormat:@"%.2f",maxUse];
                self.lineChart.yLineDataArr = @[str1,str2,str3,str4,str5,str6];
            }else{
                NSString *str1 = [NSString stringWithFormat:@"%.2f",maxGen/6];
                NSString *str2 = [NSString stringWithFormat:@"%.2f",maxGen/6*2];
                NSString *str3 = [NSString stringWithFormat:@"%.2f",maxGen/6*3];
                NSString *str4 = [NSString stringWithFormat:@"%.2f",maxGen/6*4];
                NSString *str5 = [NSString stringWithFormat:@"%.2f",maxGen/6*5];
                NSString *str6 = [NSString stringWithFormat:@"%.2f",maxGen];
                self.lineChart.yLineDataArr = @[str1,str2,str3,str4,str5,str6];
            }
        }
    }
    NSLog(@"valueArr:%@,yLineDataArr:%@",self.lineChart.valueArr,self.lineChart.yLineDataArr);
    /*       Start animation        */
    [self.lineChart showAnimation];
    
    self.lineChart2 = [[JHLineChart alloc] initWithFrame:CGRectMake(0,KHeight/667*30, KWidth-14, KHeight/667*180) andLineChartType:JHChartLineValueNotForEveryX];
    self.lineChart2.isShowRight = NO;
    self.lineChart2.isShowLeft = YES;
    self.lineChart2.isKw = YES;
    self.lineChart2.xLineDataArr = self.FirstChartXArr;
    
    self.lineChart2.contentInsets = UIEdgeInsetsMake(0, 25, 20, 10);
    
    self.lineChart2.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
    //用电数据
    self.lineChart2.valueArr = @[self.FirstChartuseArr];
    
    self.lineChart2.showYLevelLine = NO;
    self.lineChart2.showYLine = NO;
    self.lineChart2.showValueLeadingLine = NO;
    self.lineChart2.valueFontSize = 0.0;
    self.lineChart2.backgroundColor = [UIColor clearColor];
    /* Line Chart colors */
    self.lineChart2.valueLineColorArr =@[ RGBColor(0, 60, 255)];
    /* Colors for every line chart*/
    //    lineChart.pointColorArr = @[[UIColor orangeColor],[UIColor yellowColor]];
    /* color for XY axis */
    self.lineChart2.xAndYLineColor = [UIColor blackColor];
    /* XY axis scale color */
    self.lineChart.xAndYNumberColor = [UIColor darkGrayColor];
    /* Dotted line color of the coordinate point */
    self.lineChart2.positionLineColorArr = @[[UIColor clearColor],[UIColor clearColor]];
    /*        Set whether to fill the content, the default is False         */
    //    lineChart.contentFill = YES;
    /*        Set whether the curve path         */
    self.lineChart2.pathCurve = YES;
    /*        Set fill color array         */
    //    lineChart.contentFillColorArr = @[[UIColor colorWithRed:0 green:1 blue:0 alpha:0.468],[UIColor colorWithRed:1 green:0 blue:0 alpha:0.468]];
    [self.bg addSubview:self.lineChart2];
    /*       Start animation        */
    
    CGFloat bei1 = maxUse/maxGen;
    if (maxGen==0) {
        NSString *str1 = [NSString stringWithFormat:@"%.2f",maxGen];
        NSString *str2 = [NSString stringWithFormat:@"%.2f",maxGen*2];
        NSString *str3 = [NSString stringWithFormat:@"%.2f",maxGen*3];
        NSString *str4 = [NSString stringWithFormat:@"%.2f",maxGen*4];
        NSString *str5 = [NSString stringWithFormat:@"%.2f",maxGen*5];
        NSString *str6 = [NSString stringWithFormat:@"%.2f",maxGen*6];
        self.lineChart2.yLineDataArr = @[str1,str2,str3,str4,str5,str6];
    }else{
        if (bei1>6) {
            NSString *str1 = [NSString stringWithFormat:@"%.2f",maxGen];
            NSString *str2 = [NSString stringWithFormat:@"%.2f",maxGen*2];
            NSString *str3 = [NSString stringWithFormat:@"%.2f",maxGen*3];
            NSString *str4 = [NSString stringWithFormat:@"%.2f",maxGen*4];
            NSString *str5 = [NSString stringWithFormat:@"%.2f",maxGen*5];
            NSString *str6 = [NSString stringWithFormat:@"%.2f",maxGen*6];
            self.lineChart2.yLineDataArr = @[str1,str2,str3,str4,str5,str6];
        }else if (bei1<1/6){
            NSString *str1 = [NSString stringWithFormat:@"%.2f",maxGen/6];
            NSString *str2 = [NSString stringWithFormat:@"%.2f",maxGen/6*2];
            NSString *str3 = [NSString stringWithFormat:@"%.2f",maxGen/6*3];
            NSString *str4 = [NSString stringWithFormat:@"%.2f",maxGen/6*4];
            NSString *str5 = [NSString stringWithFormat:@"%.2f",maxGen/6*5];
            NSString *str6 = [NSString stringWithFormat:@"%.2f",maxGen/6*6];
            self.lineChart2.yLineDataArr = @[str1,str2,str3,str4,str5,str6];
        }else{
            if (da>0) {
                NSString *str1 = [NSString stringWithFormat:@"%.2f",maxUse/6];
                NSString *str2 = [NSString stringWithFormat:@"%.2f",maxUse/6*2];
                NSString *str3 = [NSString stringWithFormat:@"%.2f",maxUse/6*3];
                NSString *str4 = [NSString stringWithFormat:@"%.2f",maxUse/6*4];
                NSString *str5 = [NSString stringWithFormat:@"%.2f",maxUse/6*5];
                NSString *str6 = [NSString stringWithFormat:@"%.2f",maxUse];
                self.lineChart2.yLineDataArr = @[str1,str2,str3,str4,str5,str6];
            }else{
                NSString *str1 = [NSString stringWithFormat:@"%.2f",maxGen/6];
                NSString *str2 = [NSString stringWithFormat:@"%.2f",maxGen/6*2];
                NSString *str3 = [NSString stringWithFormat:@"%.2f",maxGen/6*3];
                NSString *str4 = [NSString stringWithFormat:@"%.2f",maxGen/6*4];
                NSString *str5 = [NSString stringWithFormat:@"%.2f",maxGen/6*5];
                NSString *str6 = [NSString stringWithFormat:@"%.2f",maxGen];
                self.lineChart2.yLineDataArr = @[str1,str2,str3,str4,str5,str6];
            }
        }
    }
    NSLog(@"valueArr2:%@,yLineDataArr2:%@",self.lineChart2.valueArr,self.lineChart2.yLineDataArr);
    [self.lineChart2 showAnimation];
    
    
    
}
- (void)setFirstChart1{
    
    
    self.bg2 = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth+7, 0, KWidth-14, KHeight/667*211)];
    self.bg2.image = [UIImage imageNamed:@"表格bg"];
    [self.firstScroll addSubview:self.bg2];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2-105, 10, 250, 20)];
    titleLabel.text = @"年效率曲线比较图";
    titleLabel.textColor = RGBColor(2, 28, 106);
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.bg2 addSubview:titleLabel];
    
    UILabel *waLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 25, 10)];
    waLabel.text = @"(度)";
    waLabel.textColor = RGBColor(0, 60, 255);
    waLabel.font = [UIFont systemFontOfSize:11];
    [self.bg2 addSubview:waLabel];
    UILabel *waLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-38, 25, 25, 10)];
    waLabel1.text = @"(度)";
    waLabel1.textColor = RGBColor(255, 0, 0);
    waLabel1.font = [UIFont systemFontOfSize:11];
    [self.bg2 addSubview:waLabel1];
    UILabel *shiLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-33,KHeight/667*190, 30, 10)];
    shiLabel.text = @"(月)";
    shiLabel.textColor = [UIColor darkGrayColor];
    shiLabel.font = [UIFont systemFontOfSize:11];
    [self.bg2 addSubview:shiLabel];
    
    UILabel *rightTopLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-77, 10, 50, 20)];
    rightTopLabel.text = @"单个电站";
    rightTopLabel.font = [UIFont systemFontOfSize:8];
    [self.bg2 addSubview:rightTopLabel];
    UIImageView *topImg = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-90, 15, 10, 10)];
    topImg.image = [UIImage imageNamed:@"椭圆-6"];
    [self.bg2 addSubview:topImg];
    
    UILabel *rightDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-77, 25, 50, 20)];
    rightDownLabel.text = @"整个电站";
    rightDownLabel.font = [UIFont systemFontOfSize:8];
    [self.bg2 addSubview:rightDownLabel];
    UIImageView *downImg = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-90, 30, 10, 10)];
    downImg.image = [UIImage imageNamed:@"椭圆-6-拷贝"];
    [self.bg2 addSubview:downImg];
    
    NSInteger count = 1;
    for (int i=0; i<self.FirstChartgenArr1.count; i++) {
        if (i>0) {
            if (self.FirstChartgenArr1[i]>=0) {
                if (self.FirstChartgenArr1[i-1]<0) {
                    count++;
                }
            }
        }
    }
    NSMutableArray *genArr1 = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<self.FirstChartgenArr1.count; i++) {
        if (i>0) {
            if (self.FirstChartgenArr1[i]>=0) {
                if (self.FirstChartgenArr1[i-1]<0) {
                    [genArr1 addObject:self.FirstChartgenArr1[i]];
                }
            }else{
                
            }
        }
    }
    
    
    
    self.lineChart3 = [[JHLineChart alloc] initWithFrame:CGRectMake(0,KHeight/667*30, KWidth-14, KHeight/667*180) andLineChartType:JHChartLineValueNotForEveryX];
    self.lineChart3.isShowRight = NO;
    self.lineChart3.xLineDataArr = self.FirstChartXArr1;
    self.lineChart3.contentInsets = UIEdgeInsetsMake(0, 25, 20, 10);
    
    self.lineChart3.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
    //用电数据
    self.lineChart3.valueArr = @[self.FirstChartgenArr1];
    //    self.lineChart.valueArr = @[@1,@1,@1,[NSNull null],@1,@1,@1];
    self.lineChart3.showYLevelLine = YES;
    self.lineChart3.showYLine = YES;
    self.lineChart3.isShowLeft = NO;
    self.lineChart3.isKw = YES;
    self.lineChart3.isShowRight = YES;
    self.lineChart3.showValueLeadingLine = NO;
    self.lineChart3.valueFontSize = 0.0;
    self.lineChart3.backgroundColor = [UIColor clearColor];
    /* Line Chart colors */
    self.lineChart3.valueLineColorArr =@[ RGBColor(255, 0, 0)];
    /* Colors for every line chart*/
    //    lineChart.pointColorArr = @[[UIColor orangeColor],[UIColor yellowColor]];
    /* color for XY axis */
    self.lineChart3.xAndYLineColor = [UIColor blackColor];
    /* XY axis scale color */
    self.lineChart3.xAndYNumberColor = [UIColor darkGrayColor];
    /* Dotted line color of the coordinate point */
    self.lineChart3.positionLineColorArr = @[[UIColor clearColor],[UIColor clearColor]];
    /*        Set whether to fill the content, the default is False         */
    //    lineChart.contentFill = YES;
    /*        Set whether the curve path         */
    self.lineChart3.pathCurve = YES;
    /*        Set fill color array         */
    //    lineChart.contentFillColorArr = @[[UIColor colorWithRed:0 green:1 blue:0 alpha:0.468],[UIColor colorWithRed:1 green:0 blue:0 alpha:0.468]];
    [self.bg2 addSubview:self.lineChart3];
    CGFloat maxUse = 0;
    for (int i=0; i<_FirstChartgenArr1.count; i++) {
        CGFloat num = [_FirstChartgenArr1[i] floatValue];
        if (num > maxUse) {
            maxUse = num;
        }
    }
    CGFloat maxGen = 0;
    for (int i=0; i<_FirstChartuseArr1.count; i++) {
        CGFloat num = [_FirstChartuseArr1[i] floatValue];
        if (num > maxGen) {
            maxGen = num;
        }
    }
    CGFloat bei = maxGen/maxUse;
    CGFloat da = maxUse-maxGen;
    if (maxUse==0) {
        NSString *str1 = [NSString stringWithFormat:@"%.2f",maxUse];
        NSString *str2 = [NSString stringWithFormat:@"%.2f",maxUse*2];
        NSString *str3 = [NSString stringWithFormat:@"%.2f",maxUse*3];
        NSString *str4 = [NSString stringWithFormat:@"%.2f",maxUse*4];
        NSString *str5 = [NSString stringWithFormat:@"%.2f",maxUse*5];
        NSString *str6 = [NSString stringWithFormat:@"%.2f",maxUse*6];
        self.lineChart3.yLineDataArr = @[str1,str2,str3,str4,str5,str6];
    }else{
        CGFloat six = 1/6;
        if (bei>6) {
            NSString *str1 = [NSString stringWithFormat:@"%.2f",maxUse];
            NSString *str2 = [NSString stringWithFormat:@"%.2f",maxUse*2];
            NSString *str3 = [NSString stringWithFormat:@"%.2f",maxUse*3];
            NSString *str4 = [NSString stringWithFormat:@"%.2f",maxUse*4];
            NSString *str5 = [NSString stringWithFormat:@"%.2f",maxUse*5];
            NSString *str6 = [NSString stringWithFormat:@"%.2f",maxUse*6];
            self.lineChart3.yLineDataArr = @[str1,str2,str3,str4,str5,str6];
        }else if (bei<1/6){
            NSString *str1 = [NSString stringWithFormat:@"%.2f",maxUse/6];
            NSString *str2 = [NSString stringWithFormat:@"%.2f",maxUse/6*2];
            NSString *str3 = [NSString stringWithFormat:@"%.2f",maxUse/6*3];
            NSString *str4 = [NSString stringWithFormat:@"%.2f",maxUse/6*4];
            NSString *str5 = [NSString stringWithFormat:@"%.2f",maxUse/6*5];
            NSString *str6 = [NSString stringWithFormat:@"%.2f",maxUse/6*6];
            self.lineChart3.yLineDataArr = @[str1,str2,str3,str4,str5,str6];
        }else{
            if (da>0) {
                NSString *str1 = [NSString stringWithFormat:@"%.2f",maxUse/6];
                NSString *str2 = [NSString stringWithFormat:@"%.2f",maxUse/6*2];
                NSString *str3 = [NSString stringWithFormat:@"%.2f",maxUse/6*3];
                NSString *str4 = [NSString stringWithFormat:@"%.2f",maxUse/6*4];
                NSString *str5 = [NSString stringWithFormat:@"%.2f",maxUse/6*5];
                NSString *str6 = [NSString stringWithFormat:@"%.2f",maxUse];
                self.lineChart3.yLineDataArr = @[str1,str2,str3,str4,str5,str6];
            }else{
                NSString *str1 = [NSString stringWithFormat:@"%.2f",maxGen/6];
                NSString *str2 = [NSString stringWithFormat:@"%.2f",maxGen/6*2];
                NSString *str3 = [NSString stringWithFormat:@"%.2f",maxGen/6*3];
                NSString *str4 = [NSString stringWithFormat:@"%.2f",maxGen/6*4];
                NSString *str5 = [NSString stringWithFormat:@"%.2f",maxGen/6*5];
                NSString *str6 = [NSString stringWithFormat:@"%.2f",maxGen];
                self.lineChart3.yLineDataArr = @[str1,str2,str3,str4,str5,str6];
            }
        }
    }
    /*       Start animation        */
    [self.lineChart3 showAnimation];
    
    self.lineChart4 = [[JHLineChart alloc] initWithFrame:CGRectMake(0,KHeight/667*30, KWidth-14, KHeight/667*180) andLineChartType:JHChartLineValueNotForEveryX];
    self.lineChart4.isShowRight = NO;
    self.lineChart4.isShowLeft = YES;
    self.lineChart4.isKw = YES;
    self.lineChart4.xLineDataArr = self.FirstChartXArr1;
    
    self.lineChart4.contentInsets = UIEdgeInsetsMake(0, 25, 20, 10);
    
    self.lineChart4.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
    //用电数据
    self.lineChart4.valueArr = @[self.FirstChartuseArr1];
    
    self.lineChart4.showYLevelLine = NO;
    self.lineChart4.showYLine = NO;
    self.lineChart4.showValueLeadingLine = NO;
    self.lineChart4.valueFontSize = 0.0;
    self.lineChart4.backgroundColor = [UIColor clearColor];
    /* Line Chart colors */
    self.lineChart4.valueLineColorArr =@[ RGBColor(0, 60, 255)];
    /* Colors for every line chart*/
    //    lineChart.pointColorArr = @[[UIColor orangeColor],[UIColor yellowColor]];
    /* color for XY axis */
    self.lineChart4.xAndYLineColor = [UIColor blackColor];
    /* XY axis scale color */
    self.lineChart4.xAndYNumberColor = [UIColor darkGrayColor];
    /* Dotted line color of the coordinate point */
    self.lineChart4.positionLineColorArr = @[[UIColor clearColor],[UIColor clearColor]];
    /*        Set whether to fill the content, the default is False         */
    //    lineChart.contentFill = YES;
    /*        Set whether the curve path         */
    self.lineChart4.pathCurve = YES;
    /*        Set fill color array         */
    //    lineChart.contentFillColorArr = @[[UIColor colorWithRed:0 green:1 blue:0 alpha:0.468],[UIColor colorWithRed:1 green:0 blue:0 alpha:0.468]];
    [self.bg2 addSubview:self.lineChart4];
    /*       Start animation        */
    
    CGFloat bei1 = maxUse/maxGen;
    if (maxGen==0) {
        NSString *str1 = [NSString stringWithFormat:@"%.2f",maxGen];
        NSString *str2 = [NSString stringWithFormat:@"%.2f",maxGen*2];
        NSString *str3 = [NSString stringWithFormat:@"%.2f",maxGen*3];
        NSString *str4 = [NSString stringWithFormat:@"%.2f",maxGen*4];
        NSString *str5 = [NSString stringWithFormat:@"%.2f",maxGen*5];
        NSString *str6 = [NSString stringWithFormat:@"%.2f",maxGen*6];
        self.lineChart4.yLineDataArr = @[str1,str2,str3,str4,str5,str6];
    }else{
        if (bei1>6) {
            NSString *str1 = [NSString stringWithFormat:@"%.2f",maxGen];
            NSString *str2 = [NSString stringWithFormat:@"%.2f",maxGen*2];
            NSString *str3 = [NSString stringWithFormat:@"%.2f",maxGen*3];
            NSString *str4 = [NSString stringWithFormat:@"%.2f",maxGen*4];
            NSString *str5 = [NSString stringWithFormat:@"%.2f",maxGen*5];
            NSString *str6 = [NSString stringWithFormat:@"%.2f",maxGen*6];
            self.lineChart4.yLineDataArr = @[str1,str2,str3,str4,str5,str6];
        }else if (bei1<1/6){
            NSString *str1 = [NSString stringWithFormat:@"%.2f",maxGen/6];
            NSString *str2 = [NSString stringWithFormat:@"%.2f",maxGen/6*2];
            NSString *str3 = [NSString stringWithFormat:@"%.2f",maxGen/6*3];
            NSString *str4 = [NSString stringWithFormat:@"%.2f",maxGen/6*4];
            NSString *str5 = [NSString stringWithFormat:@"%.2f",maxGen/6*5];
            NSString *str6 = [NSString stringWithFormat:@"%.2f",maxGen/6*6];
            self.lineChart4.yLineDataArr = @[str1,str2,str3,str4,str5,str6];
        }else{
            if (da>0) {
                NSString *str1 = [NSString stringWithFormat:@"%.2f",maxUse/6];
                NSString *str2 = [NSString stringWithFormat:@"%.2f",maxUse/6*2];
                NSString *str3 = [NSString stringWithFormat:@"%.2f",maxUse/6*3];
                NSString *str4 = [NSString stringWithFormat:@"%.2f",maxUse/6*4];
                NSString *str5 = [NSString stringWithFormat:@"%.2f",maxUse/6*5];
                NSString *str6 = [NSString stringWithFormat:@"%.2f",maxUse];
                self.lineChart4.yLineDataArr = @[str1,str2,str3,str4,str5,str6];
            }else{
                NSString *str1 = [NSString stringWithFormat:@"%.2f",maxGen/6];
                NSString *str2 = [NSString stringWithFormat:@"%.2f",maxGen/6*2];
                NSString *str3 = [NSString stringWithFormat:@"%.2f",maxGen/6*3];
                NSString *str4 = [NSString stringWithFormat:@"%.2f",maxGen/6*4];
                NSString *str5 = [NSString stringWithFormat:@"%.2f",maxGen/6*5];
                NSString *str6 = [NSString stringWithFormat:@"%.2f",maxGen];
                self.lineChart4.yLineDataArr = @[str1,str2,str3,str4,str5,str6];
            }
        }
    }
    NSLog(@"valueArr:%@,yLineDataArr:%@",self.lineChart3.valueArr,self.lineChart3.yLineDataArr);
    [self.lineChart4 showAnimation];
    
    
    
}

- (void)setZhuzhuang{
    self.bg1 = [[UIImageView alloc] initWithFrame:CGRectMake(7, 0, KWidth-14,KHeight/667*211)];
    self.bg1.image = [UIImage imageNamed:@"表格bg"];
    [self.firstScroll1 addSubview:self.bg1];
    
    UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2-105, 10, 250, 20)];
    secondLabel.text = @"日发电量柱状图";
    secondLabel.textColor = RGBColor(2, 28, 106);
    secondLabel.font = [UIFont systemFontOfSize:16];
    [self.bg1 addSubview:secondLabel];
    
    UILabel *dianLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 40, 10)];
    dianLabel.text = @"(度)";
    
    
    dianLabel.textColor = RGBColor(0, 60, 255);
    dianLabel.font = [UIFont systemFontOfSize:11];
    [self.bg1 addSubview:dianLabel];
    
    UILabel *shiLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-33,KHeight/667*190, 15, 10)];
    shiLabel1.text = @"(h)";
    shiLabel1.textColor = [UIColor darkGrayColor];
    shiLabel1.font = [UIFont systemFontOfSize:11];
    [self.bg1 addSubview:shiLabel1];
    
    
    
    UILabel *rightTopLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-60, 10, 50, 20)];
    rightTopLabel1.text = @"发电量";
    rightTopLabel1.font = [UIFont systemFontOfSize:8];
    [self.bg1 addSubview:rightTopLabel1];
    UIImageView *rightTopImg = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-73, 15, 10, 7)];
    rightTopImg.image = [UIImage imageNamed:@"矩形-23"];
    [self.bg1 addSubview:rightTopImg];
    
    
    
    self.lineChart1 = [[JHLineChart alloc] initWithFrame:CGRectMake(0, 30, KWidth-14, KHeight/667*180) andLineChartType:JHChartLineValueNotForEveryX];
    self.lineChart1.isShowRight = NO;
    self.lineChart1.isShowLeft = YES;
    
    self.lineChart1.isKw = NO;
    
    self.lineChart1.xLineDataArr = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24"];
    
    self.lineChart1.contentInsets = UIEdgeInsetsMake(0, 25, 20, 10);
    
    self.lineChart1.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
    self.lineChart1.valueArr = @[];
    self.lineChart1.showYLevelLine = YES;
    self.lineChart1.showYLine = YES;
    self.lineChart1.showValueLeadingLine = NO;
    self.lineChart1.valueFontSize = 0.0;
    self.lineChart1.xAndYLineColor = [UIColor blackColor];
    /* XY axis scale color */
    self.lineChart1.xAndYNumberColor = [UIColor darkGrayColor];
    self.lineChart1.backgroundColor = [UIColor clearColor];
    [self.bg1 addSubview:self.lineChart1];
    NSString *yline1 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*0];
    NSString *yline2 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*1];
    NSString *yline3 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*2];
    NSString *yline4 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*3];
    NSString *yline5 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*4];
    NSString *yline6 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*5];
    self.lineChart1.yLineDataArr = @[yline2,yline3,yline4,yline5,yline6];
    /*       Start animation        */
    [self.lineChart1 showAnimation];
    
    
    //    JHLineChart *lineChart11 = [[JHLineChart alloc] initWithFrame:CGRectMake(0, 30, KWidth-14, KHeight/667*180) andLineChartType:JHChartLineValueNotForEveryX];
    //    lineChart11.isShowRight = NO;
    //    lineChart11.isShowLeft = YES;
    //
    //    lineChart11.isKw = NO;
    //
    //    lineChart11.xLineDataArr = @[@"0",@"2",@"4",@"6",@"8",@"10",@"12",@"14",@"16",@"18",@"20",@"22",@"24"];
    //
    //    lineChart11.contentInsets = UIEdgeInsetsMake(0, 25, 20, 10);
    //
    //    lineChart11.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
    //    lineChart11.valueArr = @[];
    //    lineChart11.showYLevelLine = NO;
    //    lineChart11.showYLine = NO;
    //    lineChart11.showValueLeadingLine = NO;
    //    lineChart11.valueFontSize = 0.0;
    //    lineChart11.xAndYLineColor = [UIColor blackColor];
    //    /* XY axis scale color */
    //    lineChart11.xAndYNumberColor = [UIColor darkGrayColor];
    //    lineChart11.backgroundColor = [UIColor clearColor];
    //    [self.bgScrollView addSubview:lineChart11];
    
    //    NSString *yline11 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*0];
    //    NSString *yline22 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*1];
    //    NSString *yline33 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*2];
    //    NSString *yline44 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*3];
    //    NSString *yline55 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*4];
    //    NSString *yline66 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*5];
    //    lineChart11.yLineDataArr = @[yline22,yline33,yline44,yline55,yline66];
    //    /*       Start animation        */
    //    [lineChart11 showAnimation];
    
    
    self.zhuView = [[HistogramView alloc] initWithFrame:CGRectMake(0, 34, KWidth-14, KHeight/667*180)];
    self.zhuView.maxNumber = self.maxNumber;
    self.zhuView.backgroundColor = [UIColor clearColor];
    self.zhuView.arr = self.redArr;
    self.zhuView.arr1 =  nil;
    self.zhuView.arr2 =  nil;
    self.zhuView.arr3 =  nil;
    //    self.zhuView.arr4 = self.redArr;
//        self.zhuView.arr3 = @[@10,@10,@10,@10,@10,@10,@10,@10,@10,@10,@10];
    //    view.maxAll = self.maxAll;
    [self.bg1 addSubview:self.zhuView];
    //    self.page=0;
    //    [self addTimer];
    
}
- (void)setZhuzhuang1{
    self.bg4 = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth+7, 0, KWidth-14,KHeight/667*211)];
    self.bg4.image = [UIImage imageNamed:@"表格bg"];
    [self.firstScroll1 addSubview:self.bg4];
    
    UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2-105, 10, 250, 20)];
    secondLabel.text = @"月发电量柱状图";
    secondLabel.textColor = RGBColor(2, 28, 106);
    secondLabel.font = [UIFont systemFontOfSize:16];
    [self.bg4 addSubview:secondLabel];
    
    UILabel *dianLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 40, 10)];
    dianLabel.text = @"(度)";
    
    
    dianLabel.textColor = RGBColor(0, 60, 255);
    dianLabel.font = [UIFont systemFontOfSize:11];
    [self.bg4 addSubview:dianLabel];
    
    UILabel *shiLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-33,KHeight/667*190, 30, 10)];
    shiLabel1.text = @"(日)";
    shiLabel1.textColor = [UIColor darkGrayColor];
    shiLabel1.font = [UIFont systemFontOfSize:11];
    [self.bg4 addSubview:shiLabel1];
    
    UILabel *leftTopLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-60, 10, 50, 20)];
    leftTopLabel.text = @"发电量";
    leftTopLabel.font = [UIFont systemFontOfSize:8];
    [self.bg4 addSubview:leftTopLabel];
    
    UIImageView *leftTopImg = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-73, 15, 10, 7)];
    leftTopImg.image = [UIImage imageNamed:@"矩形-23-拷贝"];
    [self.bg4 addSubview:leftTopImg];
    
    JHLineChart *lineChart4 = [[JHLineChart alloc] initWithFrame:CGRectMake(0, 30, KWidth-14, KHeight/667*180) andLineChartType:JHChartLineValueNotForEveryX];
    lineChart4.isShowRight = NO;
    lineChart4.isShowLeft = YES;
    
    lineChart4.isKw = NO;
    
    lineChart4.xLineDataArr = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31"];
    
    lineChart4.contentInsets = UIEdgeInsetsMake(0, 25, 20, 10);
    
    lineChart4.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
    lineChart4.valueArr = @[];
    lineChart4.showYLevelLine = YES;
    lineChart4.showYLine = YES;
    lineChart4.showValueLeadingLine = NO;
    lineChart4.valueFontSize = 0.0;
    lineChart4.xAndYLineColor = [UIColor blackColor];
    /* XY axis scale color */
    lineChart4.xAndYNumberColor = [UIColor darkGrayColor];
    lineChart4.backgroundColor = [UIColor clearColor];
    [self.bg4 addSubview:lineChart4];
    NSString *yline1 = [NSString stringWithFormat:@"%.2f",_maxNumber2/5*0];
    NSString *yline2 = [NSString stringWithFormat:@"%.2f",_maxNumber2/5*1];
    NSString *yline3 = [NSString stringWithFormat:@"%.2f",_maxNumber2/5*2];
    NSString *yline4 = [NSString stringWithFormat:@"%.2f",_maxNumber2/5*3];
    NSString *yline5 = [NSString stringWithFormat:@"%.2f",_maxNumber2/5*4];
    NSString *yline6 = [NSString stringWithFormat:@"%.2f",_maxNumber2/5*5];
    lineChart4.yLineDataArr = @[yline2,yline3,yline4,yline5,yline6];
    /*       Start animation        */
    [lineChart4 showAnimation];
    
    
    //    JHLineChart *lineChart11 = [[JHLineChart alloc] initWithFrame:CGRectMake(0, 30, KWidth-14, KHeight/667*180) andLineChartType:JHChartLineValueNotForEveryX];
    //    lineChart11.isShowRight = NO;
    //    lineChart11.isShowLeft = YES;
    //
    //    lineChart11.isKw = NO;
    //
    //    lineChart11.xLineDataArr = @[@"0",@"2",@"4",@"6",@"8",@"10",@"12",@"14",@"16",@"18",@"20",@"22",@"24"];
    //
    //    lineChart11.contentInsets = UIEdgeInsetsMake(0, 25, 20, 10);
    //
    //    lineChart11.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
    //    lineChart11.valueArr = @[];
    //    lineChart11.showYLevelLine = NO;
    //    lineChart11.showYLine = NO;
    //    lineChart11.showValueLeadingLine = NO;
    //    lineChart11.valueFontSize = 0.0;
    //    lineChart11.xAndYLineColor = [UIColor blackColor];
    //    /* XY axis scale color */
    //    lineChart11.xAndYNumberColor = [UIColor darkGrayColor];
    //    lineChart11.backgroundColor = [UIColor clearColor];
    //    [self.bgScrollView addSubview:lineChart11];
    
    //    NSString *yline11 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*0];
    //    NSString *yline22 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*1];
    //    NSString *yline33 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*2];
    //    NSString *yline44 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*3];
    //    NSString *yline55 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*4];
    //    NSString *yline66 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*5];
    //    lineChart11.yLineDataArr = @[yline22,yline33,yline44,yline55,yline66];
    //    /*       Start animation        */
    //    [lineChart11 showAnimation];
    
    
    self.zhuView1 = [[HistogramView alloc] initWithFrame:CGRectMake(0, 34, KWidth-14, KHeight/667*180)];
    self.zhuView1.maxNumber = self.maxNumber2;
    self.zhuView1.backgroundColor = [UIColor clearColor];
    self.zhuView1.num = 1;
    self.zhuView1.arr = nil;
    self.zhuView1.arr1 = self.yellowArr;
    self.zhuView1.arr2 = nil;
    self.zhuView1.arr3 = nil;
    //    self.zhuView.arr4 = self.redArr;
//        self.zhuView1.arr = @[@10,@10,@10,@10,@10,@10,@10,@10,@10,@10,@10];
    //    view.maxAll = self.maxAll;
    [self.bg4 addSubview:self.zhuView1];
    //    self.page=0;
    //    [self addTimer];
    
}
- (void)setZhuzhuang2{
    self.bg5 = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth*2+7, 0, KWidth-14,KHeight/667*211)];
    self.bg5.image = [UIImage imageNamed:@"表格bg"];
    [self.firstScroll1 addSubview:self.bg5];
    
    UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2-105, 10, 250, 20)];
    secondLabel.text = @"年发电量柱状图";
    secondLabel.textColor = RGBColor(2, 28, 106);
    secondLabel.font = [UIFont systemFontOfSize:16];
    [self.bg5 addSubview:secondLabel];
    
    UILabel *dianLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 40, 10)];
    dianLabel.text = @"(度)";
    
    
    dianLabel.textColor = RGBColor(0, 60, 255);
    dianLabel.font = [UIFont systemFontOfSize:11];
    [self.bg5 addSubview:dianLabel];
    
    UILabel *shiLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-30,KHeight/667*190, 30, 10)];
    shiLabel1.text = @"(月)";
    shiLabel1.textColor = [UIColor darkGrayColor];
    shiLabel1.font = [UIFont systemFontOfSize:11];
    [self.bg5 addSubview:shiLabel1];
    
   
    
    UILabel *leftDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-60, 10, 50, 20)];
    leftDownLabel.text = @"发电量";
    leftDownLabel.font = [UIFont systemFontOfSize:8];
    [self.bg5 addSubview:leftDownLabel];
    
    UIImageView *leftDownImg = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-73, 15, 10, 7)];
    leftDownImg.image = [UIImage imageNamed:@"矩形-23-拷贝-2"];
    [self.bg5 addSubview:leftDownImg];
    
    
    
    JHLineChart *lineChart4 = [[JHLineChart alloc] initWithFrame:CGRectMake(0, 30, KWidth-14, KHeight/667*180) andLineChartType:JHChartLineValueNotForEveryX];
    lineChart4.isShowRight = NO;
    lineChart4.isShowLeft = YES;
    
    lineChart4.isKw = NO;
    
    lineChart4.xLineDataArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    
    lineChart4.contentInsets = UIEdgeInsetsMake(0, 25, 20, 10);
    
    lineChart4.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
    lineChart4.valueArr = @[];
    lineChart4.showYLevelLine = YES;
    lineChart4.showYLine = YES;
    lineChart4.showValueLeadingLine = NO;
    lineChart4.valueFontSize = 0.0;
    lineChart4.xAndYLineColor = [UIColor blackColor];
    /* XY axis scale color */
    lineChart4.xAndYNumberColor = [UIColor darkGrayColor];
    lineChart4.backgroundColor = [UIColor clearColor];
    [self.bg5 addSubview:lineChart4];
    NSString *yline1 = [NSString stringWithFormat:@"%.2f",_maxNumber3/5*0];
    NSString *yline2 = [NSString stringWithFormat:@"%.2f",_maxNumber3/5*1];
    NSString *yline3 = [NSString stringWithFormat:@"%.2f",_maxNumber3/5*2];
    NSString *yline4 = [NSString stringWithFormat:@"%.2f",_maxNumber3/5*3];
    NSString *yline5 = [NSString stringWithFormat:@"%.2f",_maxNumber3/5*4];
    NSString *yline6 = [NSString stringWithFormat:@"%.2f",_maxNumber3/5*5];
    lineChart4.yLineDataArr = @[yline2,yline3,yline4,yline5,yline6];
    /*       Start animation        */
    [lineChart4 showAnimation];
    
    
    //    JHLineChart *lineChart11 = [[JHLineChart alloc] initWithFrame:CGRectMake(0, 30, KWidth-14, KHeight/667*180) andLineChartType:JHChartLineValueNotForEveryX];
    //    lineChart11.isShowRight = NO;
    //    lineChart11.isShowLeft = YES;
    //
    //    lineChart11.isKw = NO;
    //
    //    lineChart11.xLineDataArr = @[@"0",@"2",@"4",@"6",@"8",@"10",@"12",@"14",@"16",@"18",@"20",@"22",@"24"];
    //
    //    lineChart11.contentInsets = UIEdgeInsetsMake(0, 25, 20, 10);
    //
    //    lineChart11.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
    //    lineChart11.valueArr = @[];
    //    lineChart11.showYLevelLine = NO;
    //    lineChart11.showYLine = NO;
    //    lineChart11.showValueLeadingLine = NO;
    //    lineChart11.valueFontSize = 0.0;
    //    lineChart11.xAndYLineColor = [UIColor blackColor];
    //    /* XY axis scale color */
    //    lineChart11.xAndYNumberColor = [UIColor darkGrayColor];
    //    lineChart11.backgroundColor = [UIColor clearColor];
    //    [self.bgScrollView addSubview:lineChart11];
    
    //    NSString *yline11 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*0];
    //    NSString *yline22 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*1];
    //    NSString *yline33 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*2];
    //    NSString *yline44 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*3];
    //    NSString *yline55 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*4];
    //    NSString *yline66 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*5];
    //    lineChart11.yLineDataArr = @[yline22,yline33,yline44,yline55,yline66];
    //    /*       Start animation        */
    //    [lineChart11 showAnimation];
    
    
    self.zhuView2 = [[HistogramView alloc] initWithFrame:CGRectMake(0, 34, KWidth-14, KHeight/667*180)];
    self.zhuView2.maxNumber = self.maxNumber3;
    self.zhuView2.backgroundColor = [UIColor clearColor];
    self.zhuView2.num = 2;
    self.zhuView2.arr = nil;
    self.zhuView2.arr1 = nil;
    self.zhuView2.arr2 = self.blueArr;
    self.zhuView2.arr3 = nil;
    //    self.zhuView.arr4 = self.redArr;
    //    view.arr3 = @[@10,@10,@10,@10,@10,@10,@10,@10,@10,@10,@10];
    //    view.maxAll = self.maxAll;
    [self.bg5 addSubview:self.zhuView2];
    //    self.page=0;
    //    [self addTimer];
    
}
// 曲线图数据
-(void)requestData{
    NSString *URL = [NSString stringWithFormat:@"%@/data/get-site-info",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSLog(@"token is :%@",token);
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.bid forKey:@"bid"];
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"电站详情%@",responseObject);
        NSString *house_id = responseObject[@"content"][@"house_id"];
        self.StationTextview.huhao.text = [NSString stringWithFormat:@"%@",house_id];
        NSString *name = responseObject[@"content"][@"name"];
        self.StationTextview.xingming.text = [NSString stringWithFormat:@"%@",name];
        NSString *phone = responseObject[@"content"][@"phone"];
        self.StationTextview.telLabel.text = [NSString stringWithFormat:@"%@",phone];
        NSString *address = responseObject[@"content"][@"address"];
        self.position = responseObject[@"content"][@"position"];
        if (address.length>11) {
           
            NSString *str1 = [address substringToIndex:11];//截取掉下标5之前的字符串
            NSString *str2 = [address substringFromIndex:11];
            self.StationTextview.addressLabel1.text = [NSString stringWithFormat:@"%@",str1];
            self.StationTextview.addressLabel2.text = [NSString stringWithFormat:@"%@",str2];
        }else{
            self.StationTextview.addressLabel1.text = [NSString stringWithFormat:@"%@",address];
        }
      
//        self.StationTextview.huhao.text = responseObject[@"content"][@"house_id"];
        NSString *roof_property = responseObject[@"content"][@"roof_property"];
        self.StationTextview.wuding2.text = [NSString stringWithFormat:@"%@",roof_property];
        NSString *installed_capacity = responseObject[@"content"][@"installed_capacity"];
        self.StationTextview.zhuangji2.text = [NSString stringWithFormat:@"%@",installed_capacity];
        NSString *laying_direction = responseObject[@"content"][@"laying_direction"];
        self.StationTextview.chaoxiang2.text = [NSString stringWithFormat:@"%@",laying_direction];
        NSString *laying_angle = responseObject[@"content"][@"laying_angle"];
        self.StationTextview.jiaodu2.text = [NSString stringWithFormat:@"%@",laying_angle];
        NSString *zone_area = responseObject[@"content"][@"zone_area"];
        self.StationTextview.taiqu2.text = [NSString stringWithFormat:@"%@",zone_area];
         NSString *line = responseObject[@"content"][@"line"];
        self.StationTextview.xianlu2.text = [NSString stringWithFormat:@"%@",line];
        NSString *pole_no = responseObject[@"content"][@"pole_no"];
        self.StationTextview.ganhao2.text = [NSString stringWithFormat:@"%@",pole_no];
        NSString *brand = responseObject[@"content"][@"brand"];
        self.StationTextview.zujian2.text = [NSString stringWithFormat:@"%@",brand];
        NSString *brand_specifications = responseObject[@"content"][@"brand_specifications"];
        self.StationTextview.guige2.text = [NSString stringWithFormat:@"%@",brand_specifications];
        NSString *brand_num = responseObject[@"content"][@"brand_num"];
        self.StationTextview.shuliang2.text = [NSString stringWithFormat:@"%@",brand_num];
        NSString *inverter = responseObject[@"content"][@"inverter"];
        self.StationTextview.nibianqi2.text = [NSString stringWithFormat:@"%@",inverter];
        NSString *laying_direction1 = responseObject[@"content"][@"laying_direction"];
        self.StationTextview.guige4.text = [NSString stringWithFormat:@"%@kW",laying_direction1];//没有
        NSString *inverter_num = responseObject[@"content"][@"inverter_num"];
        self.StationTextview.taishu2.text = [NSString stringWithFormat:@"%@",inverter_num];
        NSString *install_time = responseObject[@"content"][@"install_time"];
        self.StationTextview.bingwang2.text = [NSString stringWithFormat:@"%@",install_time];
        NSString *access_way = responseObject[@"content"][@"access_way"];
        self.StationTextview.bingwangfangshi2.text = [NSString stringWithFormat:@"%@",access_way];
        //------
        NSString *str = responseObject[@"content"][@"power"];
        self.StationTextview.dangqiangonglv.text = [NSString stringWithFormat:@"%@kW",str];
        NSString *str1 = responseObject[@"content"][@"today_gen"];
        self.StationTextview.jinrifadianliang.text = [NSString stringWithFormat:@"%@度",str1];
        NSString *brand_specifications1 = responseObject[@"content"][@"brand_specifications"];
        self.StationTextview.zhuanhuanxiaolv.text = [NSString stringWithFormat:@"%@度",brand_specifications1];// 没有
        NSString *group_name = responseObject[@"content"][@"group_name"];
        self.StationTextview.yunweixiaozu.text = [NSString stringWithFormat:@"%@度",group_name];
        if (self.table) {
            [self.table reloadData];
        }
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    
    
}


// 曲线图数据
-(void)requestFirstChart{
    NSString *URL = [NSString stringWithFormat:@"%@/data/get-graph-efficient",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSLog(@"token is :%@",token);
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.bid forKey:@"bid"];
    [parameters setValue:@"month" forKey:@"type"];
    NSLog(@"bid is :%@",self.bid);
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"第一张图%@",responseObject);
        if([responseObject[@"result"][@"errorMsg"] isEqualToString:@"token expired"]){
            [self newLogin];
            
            
        }else  if([responseObject[@"result"][@"success"] intValue] ==1){
            
            [self.FirstChartuseArr removeAllObjects];
            [self.FirstChartgenArr removeAllObjects];
            NSArray *array = responseObject[@"content"][@"all"];
            self.FirstChartXArr = responseObject[@"content"][@"all_date"];
            NSMutableArray *valuearr = [[NSMutableArray alloc]initWithCapacity:0];
            if ([array isEqual:[NSNull null]]) {
                array = nil;
            }else{

                for (int i =0; i<array.count; i++) {
                    NSString *value = [NSString stringWithFormat:@"%@",array[i]];
                    [valuearr addObject:value];
                }

                for (int i=0; i<valuearr.count; i++) {
                    CGFloat num = [valuearr[i] floatValue];
                    CGFloat number = [valuearr[valuearr.count-1] floatValue];
                    if (number<0) {
                        for (NSInteger m = valuearr.count-1; m>=0; m--) {
                            CGFloat number1 = [valuearr[m] floatValue];
                            if (number1<0) {
                                [valuearr removeObjectAtIndex:m];
                            }else{
                                break;
                            }
                        }
                    }
                    NSInteger count = 0;
                    if (num<0) {
                        if (i==0) {
                            [valuearr replaceObjectAtIndex:0 withObject:@"0"];
                        }
                        for (int j=i; j<valuearr.count-i; j++) {
                            CGFloat num1 = [valuearr[j] floatValue];

                            if (num1<0) {
                                count++;
                            }else{
                                break;
                            }

                        }
                        for (int k=0; k<count; k++) {
                            CGFloat hou = [valuearr[i+count] floatValue];
                            CGFloat qian = [valuearr[i-1] floatValue];
                            CGFloat tihuan = qian-(qian-hou)/(count)*(k+1);
                            NSString *str = [NSString stringWithFormat:@"%.2f",tihuan];
                            [valuearr replaceObjectAtIndex:i+k withObject:str];
                        }
                    }
                }
            
                self.FirstChartgenArr = valuearr;
            }
            NSLog(@"用电数组:%@",self.FirstChartgenArr);
            
            NSArray *array1 = responseObject[@"content"][@"single"];
            
            NSMutableArray *valuearr1 = [[NSMutableArray alloc]initWithCapacity:0];
            if ([array1 isEqual:[NSNull null]] ) {
                array1 = nil;
            }else{

                for (int i =0; i<array1.count; i++) {
                    NSString *value1 = [NSString stringWithFormat:@"%@",array1[i]];
                    [valuearr1 addObject:value1];
                }

                for (int i=0; i<valuearr1.count; i++) {
                    CGFloat num = [valuearr1[i] floatValue];
                    CGFloat number = [valuearr1[valuearr1.count-1] floatValue];
                    if (number<0) {
                        for (NSInteger m = valuearr1.count-1; m>=0; m--) {
                            CGFloat number1 = [valuearr1[m] floatValue];
                            if (number1<0) {
                                [valuearr1 removeObjectAtIndex:m];
                            }else{
                                break;
                            }
                        }
                    }
                    NSInteger count = 0;
                    if (num<0) {
                        if (i==0) {
                            [valuearr1 replaceObjectAtIndex:0 withObject:@"0"];
                        }
                        for (int j=i; j<valuearr1.count-i; j++) {
                            CGFloat num1 = [valuearr1[j] floatValue];
                            if (num1<0) {
                                count++;
                            }else{
                                break;
                            }

                        }
                        for (int k=0; k<count; k++) {
                            CGFloat hou = [valuearr1[i+count] floatValue];
                            CGFloat qian = [valuearr1[i-1] floatValue];
                            CGFloat tihuan = qian-(qian-hou)/count*(k+1);
                            NSString *str = [NSString stringWithFormat:@"%.2f",tihuan];
                            [valuearr1 replaceObjectAtIndex:i+k withObject:str];
                        }
                    }
                }
        
                self.FirstChartuseArr = valuearr1;
                
            }
            NSLog(@"发电数组:%@",self.FirstChartuseArr);
            
        }
        [self setFirstChart];
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
//             self.FirstChartgenArr = @[@0,@0,@0,@0,@0,@0,@0,@0];
//             self.FirstChartuseArr = @[@0,@0,@0,@0,@0,@0,@0,@0];
//             [self setFirstChart];
         }];
    
    
}
// 曲线图数据
-(void)requestFirstChart2{
    NSString *URL = [NSString stringWithFormat:@"%@/data/get-graph-efficient",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSLog(@"token is :%@",token);
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.bid forKey:@"bid"];
    [parameters setValue:@"year" forKey:@"type"];
    NSLog(@"bid is :%@",self.bid);
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"第一张图%@",responseObject);
        if([responseObject[@"result"][@"errorMsg"] isEqualToString:@"token expired"]){
            [self newLogin];
            
            
        }else  if([responseObject[@"result"][@"success"] intValue] ==1){
            
            [self.FirstChartuseArr1 removeAllObjects];
            [self.FirstChartgenArr1 removeAllObjects];
            NSArray *array = responseObject[@"content"][@"all"];
            self.FirstChartXArr1 = responseObject[@"content"][@"all_date"];
            NSMutableArray *valuearr = [[NSMutableArray alloc]initWithCapacity:0];
            if ([array isEqual:[NSNull null]]) {
                array = nil;
            }else{
                
                for (int i =0; i<array.count; i++) {
                    NSString *value = [NSString stringWithFormat:@"%@",array[i]];
                    [valuearr addObject:value];
                }
                
                for (int i=0; i<valuearr.count; i++) {
                    CGFloat num = [valuearr[i] floatValue];
                    CGFloat number = [valuearr[valuearr.count-1] floatValue];
                    if (number<0) {
                        for (NSInteger m = valuearr.count-1; m>=0; m--) {
                            CGFloat number1 = [valuearr[m] floatValue];
                            if (number1<0) {
                                [valuearr removeObjectAtIndex:m];
                            }else{
                                break;
                            }
                        }
                    }
                    NSInteger count = 0;
                    if (num<0) {
                        if (i==0) {
                            [valuearr replaceObjectAtIndex:0 withObject:@"0"];
                        }
                        for (int j=i; j<valuearr.count-i; j++) {
                            CGFloat num1 = [valuearr[j] floatValue];
                            
                            if (num1<0) {
                                count++;
                            }else{
                                break;
                            }
                            
                        }
                        for (int k=0; k<count; k++) {
                            CGFloat hou = [valuearr[i+count] floatValue];
                            CGFloat qian = [valuearr[i-1] floatValue];
                            CGFloat tihuan = qian-(qian-hou)/(count)*(k+1);
                            NSString *str = [NSString stringWithFormat:@"%.2f",tihuan];
                            [valuearr replaceObjectAtIndex:i+k withObject:str];
                        }
                    }
                }
                
                self.FirstChartgenArr1 = valuearr;
            }
            NSLog(@"用电数组:%@",self.FirstChartgenArr1);
            
            NSArray *array1 = responseObject[@"content"][@"single"];
            
            NSMutableArray *valuearr1 = [[NSMutableArray alloc]initWithCapacity:0];
            if ([array1 isEqual:[NSNull null]] ) {
                array1 = nil;
            }else{
                
                for (int i =0; i<array1.count; i++) {
                    NSString *value1 = [NSString stringWithFormat:@"%@",array1[i]];
                    [valuearr1 addObject:value1];
                }
                
                for (int i=0; i<valuearr1.count; i++) {
                    CGFloat num = [valuearr1[i] floatValue];
                    CGFloat number = [valuearr1[valuearr1.count-1] floatValue];
                    if (number<0) {
                        for (NSInteger m = valuearr1.count-1; m>=0; m--) {
                            CGFloat number1 = [valuearr1[m] floatValue];
                            if (number1<0) {
                                [valuearr1 removeObjectAtIndex:m];
                            }else{
                                break;
                            }
                        }
                    }
                    NSInteger count = 0;
                    if (num<0) {
                        if (i==0) {
                            [valuearr1 replaceObjectAtIndex:0 withObject:@"0"];
                        }
                        for (int j=i; j<valuearr1.count-i; j++) {
                            CGFloat num1 = [valuearr1[j] floatValue];
                            if (num1<0) {
                                count++;
                            }else{
                                break;
                            }
                            
                        }
                        for (int k=0; k<count; k++) {
                            CGFloat hou = [valuearr1[i+count] floatValue];
                            CGFloat qian = [valuearr1[i-1] floatValue];
                            CGFloat tihuan = qian-(qian-hou)/count*(k+1);
                            NSString *str = [NSString stringWithFormat:@"%.2f",tihuan];
                            [valuearr1 replaceObjectAtIndex:i+k withObject:str];
                        }
                    }
                }
                
                self.FirstChartuseArr1 = valuearr1;
                
            }
            NSLog(@"发电数组:%@",self.FirstChartuseArr1);
            
        }
        [self setFirstChart1];
    }
     
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
              NSLog(@"%@",error);  //这里打印错误信息
//              self.FirstChartgenArr1 = @[@0,@0,@0,@0,@0,@0,@0,@0];
//              self.FirstChartuseArr1 = @[@0,@0,@0,@0,@0,@0,@0,@0];
//              [self setFirstChart1];
          }];
    
    
}

// 柱状图数据
-(void)requestSecondChart{
    NSString *URL = [NSString stringWithFormat:@"%@/data/get-graph-gen-cap",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSLog(@"token is :%@",token);
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.bid forKey:@"bid"];
    [parameters setValue:@"day" forKey:@"type"];
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"用电量日柱状图%@",responseObject);
        if([responseObject[@"result"][@"success"] intValue] ==1){
            NSMutableArray *redAll = responseObject[@"content"];
            [self.redArr removeAllObjects];
            for (int i=0; i<redAll.count; i++) {
//                if (i%2==0) {
//                    if (i+1==redAll.count) {
//                        CGFloat qian = [redAll[i] floatValue];
//                        CGFloat hou = 0;
//                        NSString *str = [NSString stringWithFormat:@"%.2f",qian+hou];
//                        [self.redArr addObject:str];
//                    }else{
                        CGFloat qian = [redAll[i] floatValue];
//                        CGFloat hou = [redAll[i+1] floatValue];
                        NSString *str = [NSString stringWithFormat:@"%.2f",qian];
                        [self.redArr addObject:str];
//                    }
//
//                }
            }
            CGFloat max = 0;
            for (int i=0; i<self.redArr.count; i++) {
                CGFloat now = [self.redArr[i] floatValue];
                if (now>max) {
                    max = now;
                }
            }
            self.maxNumber = max;
            
        }
        [self setZhuzhuang];
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
            
            
         }];
    
    
}
// 柱状图数据1
-(void)requestSecondChart1{
    NSString *URL = [NSString stringWithFormat:@"%@/data/get-graph-gen-cap",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSLog(@"token is :%@",token);
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.bid forKey:@"bid"];
    [parameters setValue:@"month" forKey:@"type"];
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"用电量月柱状图%@",responseObject);
        if([responseObject[@"result"][@"success"] intValue] ==1){
            NSMutableArray *yellowAll = responseObject[@"content"];
            [self.yellowArr removeAllObjects];
            for (int i=0; i<yellowAll.count; i++) {
//                if (i%2==0) {
//                    if (i+1==yellowAll.count) {
//                        CGFloat qian = [yellowAll[i] floatValue];
//                        CGFloat hou = 0;
//                        NSString *str = [NSString stringWithFormat:@"%.2f",qian+hou];
//                        [self.yellowArr addObject:str];
//                    }else{
                        CGFloat qian = [yellowAll[i] floatValue];
//                        CGFloat hou = [yellowAll[i+1] floatValue];
                        NSString *str = [NSString stringWithFormat:@"%.2f",qian];
                        [self.yellowArr addObject:str];
//                    }
//
//                }
            }
            CGFloat max = 0;
            for (int i=0; i<self.yellowArr.count; i++) {
                CGFloat now = [self.yellowArr[i] floatValue];
                if (now>max) {
                    max = now;
                }
            }
            self.maxNumber2 = max;
            
        }
        [self setZhuzhuang1];
    }
     
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
              
              
          }];
    
    
}
// 柱状图数据1
-(void)requestSecondChart2{
    NSString *URL = [NSString stringWithFormat:@"%@/data/get-graph-gen-cap",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSLog(@"token is :%@",token);
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.bid forKey:@"bid"];
    [parameters setValue:@"year" forKey:@"type"];
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"用电量年柱状图%@",responseObject);
        if([responseObject[@"result"][@"success"] intValue] ==1){
            NSMutableArray *blueAll = responseObject[@"content"];
            [self.blueArr removeAllObjects];
            for (int i=0; i<blueAll.count; i++) {
//                if (i%2==0) {
//                    if (i+1==blueAll.count) {
//                        CGFloat qian = [blueAll[i] floatValue];
//                        CGFloat hou = 0;
//                        NSString *str = [NSString stringWithFormat:@"%.2f",qian+hou];
//                        [self.blueArr addObject:str];
//                    }else{
                        CGFloat qian = [blueAll[i] floatValue];
//                        CGFloat hou = [blueAll[i+1] floatValue];
                        NSString *str = [NSString stringWithFormat:@"%.2f",qian];
                        [self.blueArr addObject:str];
//                    }
//
//                }
            }
            CGFloat max = 0;
            for (int i=0; i<self.blueArr.count; i++) {
                CGFloat now = [self.blueArr[i] floatValue];
                if (now>max) {
                    max = now;
                }
            }
            self.maxNumber3 = max;
            
        }
        [self setZhuzhuang2];
    }
     
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
              
              
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

-(NSMutableArray *)redArr{
    if(!_redArr){
        _redArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _redArr;
}
-(NSMutableArray *)yellowArr{
    if(!_yellowArr){
        _yellowArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _yellowArr;
}
-(NSMutableArray *)greenArr{
    if(!_greenArr){
        _greenArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _greenArr;
}
-(NSMutableArray *)blueArr{
    if(!_blueArr){
        _blueArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _blueArr;
}
-(NSMutableArray *)FirstChartXArr{
    if(!_FirstChartXArr){
        _FirstChartXArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _FirstChartXArr;
}
-(NSMutableArray *)FirstChartXArr1{
    if(!_FirstChartXArr1){
        _FirstChartXArr1 = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _FirstChartXArr1;
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
