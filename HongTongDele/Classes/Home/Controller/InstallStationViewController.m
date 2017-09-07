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
@interface InstallStationViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic,strong)UITableView *table;
@property (nonatomic,strong)UIScrollView *bgScrollView;
@property (nonatomic,strong) NSMutableArray *FirstChartgenArr;
@property (nonatomic,strong) NSMutableArray *FirstChartuseArr;
@property (nonatomic,assign)float maxNumber;
@property (nonatomic,strong) JHLineChart *lineChart;
@property (nonatomic,strong) JHLineChart *lineChart2;
@property (nonatomic,strong) JHLineChart *lineChart1;
@property (nonatomic,strong) HistogramView *zhuView;
@property (nonatomic,strong) NSMutableArray *blueArr;
@property (nonatomic,strong) NSMutableArray *greenArr;
@property (nonatomic,strong) NSMutableArray *redArr;
@property (nonatomic,strong) NSMutableArray *yellowArr;
@end

@implementation InstallStationViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestFirstChart];
    [self requestSecondChart];
    self.title = @"电站详情";
    [self setUI];
    // Do any additional setup after loading the view.
}

- (void)setUI{
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight)];
    _bgScrollView.delegate = self;
    _bgScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.bgScrollView.contentSize = CGSizeMake(KWidth, 900);
    [self.view addSubview:_bgScrollView];
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, KWidth, 44*8) style:UITableViewStylePlain];
    self.table.backgroundColor = [UIColor whiteColor];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.bounces = NO;
    [self.bgScrollView addSubview:self.table];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    //    header.stateLabel.hidden = YES;
    self.table.mj_header = header;
    self.table.mj_header.ignoredScrollViewContentInsetTop = self.table.contentInset.top;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"InstallStationTableViewCell";
    // 2.从缓存池中取出cell
    InstallStationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 3.如果缓存池中没有cell
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"InstallStationTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
        cell.backgroundColor = [UIColor clearColor];
        if(indexPath.row==0){
            cell.LeftLabel.text = @"户号";
            cell.rightLabel.text = [NSString stringWithFormat:@"%@",self.house_id];
        }else if(indexPath.row==1){
            cell.LeftLabel.text = @"姓名";
            cell.rightLabel.text = @"";
        }else if(indexPath.row==2){
            cell.LeftLabel.text = @"电话";
            cell.rightLabel.text = @"";
        }else if(indexPath.row==3){
            cell.LeftLabel.text = @"地址";
            cell.rightLabel.text = [NSString stringWithFormat:@"%@",self.address];
        }else if(indexPath.row==4){
            cell.LeftLabel.text = @"装机容量";
            NSInteger num = [self.installed_gross_capacity integerValue];
            cell.rightLabel.text = [NSString stringWithFormat:@"%zdkw/h",num/1000];
        }else if(indexPath.row==5){
            cell.LeftLabel.text = @"并网方式";
            if ([self.access_way integerValue] ==0) {
                cell.rightLabel.text = @"全额上网";
            }else{
                cell.rightLabel.text = @"余电上网";
            }
            
        }else if(indexPath.row==6){
            cell.LeftLabel.text = @"并网时间";
            cell.rightLabel.text = [NSString stringWithFormat:@"%@",self.install_time];
        }else if(indexPath.row==7){
            cell.LeftLabel.text = @"状态";
            cell.rightLabel.text = [NSString stringWithFormat:@"%@",self.use_ele_way];
        }
        
        
    }
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setFirstChart{
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 400, KWidth-14, KHeight/667*211)];
    bg.image = [UIImage imageNamed:@"biaogebg"];
    [self.bgScrollView addSubview:bg];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2-105, 10, 250, 20)];
    titleLabel.text = @"今日发、用电功率曲线图";
    titleLabel.textColor = RGBColor(2, 28, 106);
    titleLabel.font = [UIFont systemFontOfSize:16];
    [bg addSubview:titleLabel];
    
    UILabel *waLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 25, 10)];
    waLabel.text = @"(kW)";
    waLabel.textColor = RGBColor(0, 60, 255);
    waLabel.font = [UIFont systemFontOfSize:11];
    [bg addSubview:waLabel];
    UILabel *waLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-38, 25, 25, 10)];
    waLabel1.text = @"(kW)";
    waLabel1.textColor = RGBColor(255, 0, 0);
    waLabel1.font = [UIFont systemFontOfSize:11];
    [bg addSubview:waLabel1];
    UILabel *shiLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-30,KHeight/667*190, 15, 10)];
    shiLabel.text = @"(h)";
    shiLabel.textColor = [UIColor darkGrayColor];
    shiLabel.font = [UIFont systemFontOfSize:11];
    [bg addSubview:shiLabel];
    
    UILabel *rightTopLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-77, 10, 50, 20)];
    rightTopLabel.text = @"发电功率";
    rightTopLabel.font = [UIFont systemFontOfSize:8];
    [bg addSubview:rightTopLabel];
    UIImageView *topImg = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-90, 15, 10, 10)];
    topImg.image = [UIImage imageNamed:@"椭圆-6"];
    [bg addSubview:topImg];
    
    UILabel *rightDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-77, 25, 50, 20)];
    rightDownLabel.text = @"用电功率";
    rightDownLabel.font = [UIFont systemFontOfSize:8];
    [bg addSubview:rightDownLabel];
    UIImageView *downImg = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-90, 30, 10, 10)];
    downImg.image = [UIImage imageNamed:@"椭圆-6-拷贝"];
    [bg addSubview:downImg];
    
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
    self.lineChart.xLineDataArr = @[@"0",@"2",@"4",@"6",@"8",@"10",@"12",@"14",@"16",@"18",@"20",@"22",@"24"];
    self.lineChart.contentInsets = UIEdgeInsetsMake(0, 25, 20, 10);
    
    self.lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
    //用电数据
    self.lineChart.valueArr = @[self.FirstChartgenArr];
    //    self.lineChart.valueArr = @[@1,@1,@1,[NSNull null],@1,@1,@1];
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
    [bg addSubview:self.lineChart];
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
        if (bei>6) {
            NSString *str1 = [NSString stringWithFormat:@"%.2f",maxUse];
            NSString *str2 = [NSString stringWithFormat:@"%.2f",maxUse*2];
            NSString *str3 = [NSString stringWithFormat:@"%.2f",maxUse*3];
            NSString *str4 = [NSString stringWithFormat:@"%.2f",maxUse*4];
            NSString *str5 = [NSString stringWithFormat:@"%.2f",maxUse*5];
            NSString *str6 = [NSString stringWithFormat:@"%.2f",maxUse*6];
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
    /*       Start animation        */
    [self.lineChart showAnimation];
    
    self.lineChart2 = [[JHLineChart alloc] initWithFrame:CGRectMake(0,KHeight/667*30, KWidth-14, KHeight/667*180) andLineChartType:JHChartLineValueNotForEveryX];
    self.lineChart2.isShowRight = NO;
    self.lineChart2.isShowLeft = YES;
    self.lineChart2.isKw = YES;
    self.lineChart2.xLineDataArr = @[@"0",@"2",@"4",@"6",@"8",@"10",@"12",@"14",@"16",@"18",@"20",@"22",@"24"];
    
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
    [bg addSubview:self.lineChart2];
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
            NSString *str1 = [NSString stringWithFormat:@"%.2f",maxUse];
            NSString *str2 = [NSString stringWithFormat:@"%.2f",maxUse*2];
            NSString *str3 = [NSString stringWithFormat:@"%.2f",maxUse*3];
            NSString *str4 = [NSString stringWithFormat:@"%.2f",maxUse*4];
            NSString *str5 = [NSString stringWithFormat:@"%.2f",maxUse*5];
            NSString *str6 = [NSString stringWithFormat:@"%.2f",maxUse*6];
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
    [self.lineChart2 showAnimation];
    
    
    
}

- (void)setZhuzhuang{
    
    UIImageView *bg1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 630, KWidth-14,KHeight/667*211)];
    bg1.image = [UIImage imageNamed:@"biaogebg"];
    [self.bgScrollView addSubview:bg1];
    
    UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2-105, 10, 250, 20)];
    secondLabel.text = @"今日发、用电量柱状图";
    secondLabel.textColor = RGBColor(2, 28, 106);
    secondLabel.font = [UIFont systemFontOfSize:16];
    [bg1 addSubview:secondLabel];
    
    UILabel *dianLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 40, 10)];
    dianLabel.text = @"(kW·h)";
    
    
    dianLabel.textColor = RGBColor(0, 60, 255);
    dianLabel.font = [UIFont systemFontOfSize:11];
    [bg1 addSubview:dianLabel];
    
    UILabel *shiLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-30,KHeight/667*190, 15, 10)];
    shiLabel1.text = @"(h)";
    shiLabel1.textColor = [UIColor darkGrayColor];
    shiLabel1.font = [UIFont systemFontOfSize:11];
    [bg1 addSubview:shiLabel1];
    
    UILabel *leftTopLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-95, 10, 50, 20)];
    leftTopLabel.text = @"上网";
    leftTopLabel.font = [UIFont systemFontOfSize:8];
    [bg1 addSubview:leftTopLabel];
    
    UIImageView *leftTopImg = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-108, 15, 10, 7)];
    leftTopImg.image = [UIImage imageNamed:@"矩形-23-拷贝"];
    [bg1 addSubview:leftTopImg];
    
    UILabel *leftDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-95, 25, 50, 20)];
    leftDownLabel.text = @"峰电";
    leftDownLabel.font = [UIFont systemFontOfSize:8];
    [bg1 addSubview:leftDownLabel];
    
    UIImageView *leftDownImg = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-108, 30, 10, 7)];
    leftDownImg.image = [UIImage imageNamed:@"矩形-23-拷贝-2"];
    [bg1 addSubview:leftDownImg];
    
    UILabel *rightTopLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-60, 10, 50, 20)];
    rightTopLabel1.text = @"自用";
    rightTopLabel1.font = [UIFont systemFontOfSize:8];
    [bg1 addSubview:rightTopLabel1];
    UIImageView *rightTopImg = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-73, 15, 10, 7)];
    rightTopImg.image = [UIImage imageNamed:@"矩形-23"];
    [bg1 addSubview:rightTopImg];
    
    UILabel *rightDownLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-60, 25, 50, 20)];
    rightDownLabel1.text = @"谷电";
    rightDownLabel1.font = [UIFont systemFontOfSize:8];
    [bg1 addSubview:rightDownLabel1];
    UIImageView *rightDownImg = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-73, 30, 10, 7)];
    rightDownImg.image = [UIImage imageNamed:@"矩形-23-拷贝-3"];
    [bg1 addSubview:rightDownImg];
    
    self.lineChart1 = [[JHLineChart alloc] initWithFrame:CGRectMake(0, 30, KWidth-14, KHeight/667*180) andLineChartType:JHChartLineValueNotForEveryX];
    self.lineChart1.isShowRight = NO;
    self.lineChart1.isShowLeft = YES;
    
    self.lineChart1.isKw = NO;
    
    self.lineChart1.xLineDataArr = @[@"0",@"2",@"4",@"6",@"8",@"10",@"12",@"14",@"16",@"18",@"20",@"22",@"24"];
    
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
    [bg1 addSubview:self.lineChart1];
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
    self.zhuView.arr1 = self.yellowArr;
    self.zhuView.arr2 = self.blueArr;
    self.zhuView.arr3 = self.greenArr;
    //    self.zhuView.arr4 = self.redArr;
    //    view.arr3 = @[@10,@10,@10,@10,@10,@10,@10,@10,@10,@10,@10];
    //    view.maxAll = self.maxAll;
    [bg1 addSubview:self.zhuView];
    //    self.page=0;
    //    [self addTimer];
    
}

// 曲线图数据
-(void)requestFirstChart{
    NSString *URL = [NSString stringWithFormat:@"%@/sites/get-power-graph-data",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSLog(@"token is :%@",token);
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.bid forKey:@"bid"];
    [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"第一张图%@",responseObject);
        if([responseObject[@"result"][@"errorMsg"] isEqualToString:@"token expired"]){
            [self newLogin];
            
            
        }else  if([responseObject[@"result"][@"success"] intValue] ==1){
            
            [self.FirstChartuseArr removeAllObjects];
            [self.FirstChartgenArr removeAllObjects];
            NSArray *array = responseObject[@"content"][@"use_power"];
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
            
            NSArray *array1 = responseObject[@"content"][@"gen_power"];
            
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
         }];
    
    
}

// 柱状图数据
-(void)requestSecondChart{
    NSString *URL = [NSString stringWithFormat:@"%@/sites/get-gen-use-med-low-graph-data",kUrl];
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
    [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"用电量柱状图%@",responseObject);
        if([responseObject[@"result"][@"success"] intValue] ==1){
            NSMutableArray *redAll = responseObject[@"content"][@"red"];
            [self.redArr removeAllObjects];
            for (int i=0; i<redAll.count; i++) {
                if (i%2==0) {
                    if (i+1==redAll.count) {
                        CGFloat qian = [redAll[i] floatValue];
                        CGFloat hou = 0;
                        NSString *str = [NSString stringWithFormat:@"%.2f",qian+hou];
                        [self.redArr addObject:str];
                    }else{
                        CGFloat qian = [redAll[i] floatValue];
                        CGFloat hou = [redAll[i+1] floatValue];
                        NSString *str = [NSString stringWithFormat:@"%.2f",qian+hou];
                        [self.redArr addObject:str];
                    }
                    
                }
            }
            
            NSMutableArray *yellowAll = responseObject[@"content"][@"yellow"];
            [self.yellowArr removeAllObjects];
            for (int i=0; i<yellowAll.count; i++) {
                if (i%2==0) {
                    if (i+1==yellowAll.count) {
                        CGFloat qian = [yellowAll[i] floatValue];
                        CGFloat hou = 0;
                        NSString *str = [NSString stringWithFormat:@"%.2f",qian+hou];
                        [self.yellowArr addObject:str];
                    }else{
                        CGFloat qian = [yellowAll[i] floatValue];
                        CGFloat hou = [yellowAll[i+1] floatValue];
                        NSString *str = [NSString stringWithFormat:@"%.2f",qian+hou];
                        [self.yellowArr addObject:str];
                    }
                    
                }
            }
            
            
            NSMutableArray *greenAll = responseObject[@"content"][@"green"];
            [self.greenArr removeAllObjects];
            for (int i=0; i<greenAll.count; i++) {
                if (i%2==0) {
                    if (i+1==greenAll.count) {
                        CGFloat qian = [greenAll[i] floatValue];
                        CGFloat hou = 0;
                        NSString *str = [NSString stringWithFormat:@"%.2f",qian+hou];
                        [self.greenArr addObject:str];
                    }else{
                        CGFloat qian = [greenAll[i] floatValue];
                        CGFloat hou = [greenAll[i+1] floatValue];
                        NSString *str = [NSString stringWithFormat:@"%.2f",qian+hou];
                        [self.greenArr addObject:str];
                    }
                    
                }
            }
            
            
            
            NSMutableArray *blueAll = responseObject[@"content"][@"bule"];
            [self.blueArr removeAllObjects];
            for (int i=0; i<blueAll.count; i++) {
                if (i%2==0) {
                    CGFloat qian = [blueAll[i] floatValue];
                    if (i+1==blueAll.count) {
                        CGFloat hou = 0;
                        NSString *str = [NSString stringWithFormat:@"%.2f",qian+hou];
                        [self.blueArr addObject:str];
                    }else{
                        CGFloat hou = [blueAll[i+1] floatValue];
                        NSString *str = [NSString stringWithFormat:@"%.2f",qian+hou];
                        [self.blueArr addObject:str];
                    }
                    
                }
            }
            
            for (int i=0; i<self.blueArr.count; i++) {
                if (i>3&&i<11) {
                    CGFloat blue = [self.blueArr[i] floatValue];
                    CGFloat red = [self.redArr[i] floatValue];
                    CGFloat fin = blue+red;
                    NSString *str = [NSString stringWithFormat:@"%.2f",fin];
                    [self.blueArr replaceObjectAtIndex:i withObject:str];
                }
            }
            for (int i=0; i<self.greenArr.count; i++) {
                if  (i<4||i>10){
                    CGFloat green = [self.greenArr[i] floatValue];
                    CGFloat red = [self.redArr[i] floatValue];
                    CGFloat fin = green+red;
                    NSString *str = [NSString stringWithFormat:@"%.2f",fin];
                    [self.greenArr replaceObjectAtIndex:i withObject:str];
                }
            }
            
            NSLog(@"red:%@",self.redArr);
            NSLog(@"yellowArr:%@",self.yellowArr);
            NSLog(@"blueArr:%@",self.blueArr);
            NSLog(@"greenArr:%@",self.greenArr);
            
            CGFloat max = 0;
            CGFloat sum = 0;
            for (int i=0; i<self.redArr.count; i++) {
                for (int k=0; k<_yellowArr.count; k++) {
                    if (k==i) {
                        CGFloat red = [self.redArr[i] floatValue];
                        CGFloat yellow = [self.yellowArr[k] floatValue];
                        sum = red+yellow;
                        if (sum>max) {
                            max = sum;
                        }
                    }
                }
            }
            CGFloat max1 = 0;
            CGFloat sum1 = 0;
            for (int i=0; i<self.blueArr.count; i++) {
                for (int k=0; k<_greenArr.count; k++) {
                    if (k==i) {
                        CGFloat red = [self.blueArr[i] floatValue];
                        CGFloat yellow = [self.greenArr[k] floatValue];
                        sum1 = red+yellow;
                        if (sum1>max1) {
                            max1 = sum1;
                        }
                    }
                }
            }
            if (max>max1) {
                self.maxNumber = max;
                self.zhuView.maxNumber = max;
            }else{
                self.maxNumber = max1;
                self.zhuView.maxNumber = max1;
            }
            
            
        }
        [self setZhuzhuang];
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
