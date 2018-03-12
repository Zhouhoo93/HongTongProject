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
#import "AppDelegate.h"
#import "LoginOneViewController.h"
#import "YunWeiListModel.h"
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
@property (nonatomic,strong)YunWeiListModel *Datamodel;
@property (nonatomic,strong)NSMutableArray *modelArr;//数据数组
@property (nonatomic,strong)NSMutableArray *modelArr1;
@property (nonatomic,strong)UIImageView *biaogeBg;
@property (nonatomic,strong)UIImageView *biaogeBg1;
@property (nonatomic,copy)NSString *selectBid;
@property (nonatomic,copy)NSString *selectID;
@property (nonatomic,assign)NSInteger jieduan;
@property (nonatomic,copy)NSString *position;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *address;
@property (nonatomic,copy)NSString *dianjiStatus;

@end

@implementation BaoJingLiShiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报警电站";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTop];
    self.jieduan = 0;
//    [self requestData];
//    [self requestData1];
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
    
//    [self setLeftTable];
//    [self setRightTable];
    [self requestData];
    [self requestData1];
}

- (void)setLeftTable{
    UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 16, 12, 17)];
    leftImg.image = [UIImage imageNamed:@"定位"];
    [self.leftView addSubview:leftImg];
    
    UILabel *toplabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 14, KWidth-70, 24)];
    toplabel.font = [UIFont systemFontOfSize:14];
    toplabel.textColor = [UIColor darkGrayColor];
    NSInteger coun = self.modelArr.count;
    toplabel.text = [NSString stringWithFormat:@"%@(分公司)%@ 共%ld条",self.fengongsi,self.yunwei,coun];
//    toplabel.text = @"xx公司(分公司) 运维小组1 周巷镇 共9条";
    [self.leftView addSubview:toplabel];
    
//    UIButton *shaixuanBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(KWidth-90, 14, 80, 30)];
//    [shaixuanBtn1 setImage:[UIImage imageNamed:@"筛选"] forState:UIControlStateNormal];
//    [shaixuanBtn1 addTarget:self action:@selector(shaixuanBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.leftView addSubview:shaixuanBtn1];
    
    if (self.modelArr.count<10) {
        if (self.modelArr.count==0) {
            self.biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 45, KWidth-20, self.modelArr.count*40+35)];
            self.biaogeBg.image = [UIImage imageNamed:@"表格bg"];
            [self.leftView addSubview:self.biaogeBg];
        }else{
            self.biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 45, KWidth-20, self.modelArr.count*40+33)];
            self.biaogeBg.image = [UIImage imageNamed:@"表格bg"];
            [self.leftView addSubview:self.biaogeBg];
        }
    }else{
        self.biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 45, KWidth-20, 400)];
        self.biaogeBg.image = [UIImage imageNamed:@"表格bg"];
        [self.leftView addSubview:self.biaogeBg];
    }
    
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
    NSMutableArray *tipArr = [[NSMutableArray alloc] init];
    if (self.modelArr.count>0) {
        _Datamodel = _modelArr[0];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_Datamodel.ID]];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_Datamodel.home]];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_Datamodel.addr]];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_Datamodel.nature]];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_Datamodel.cause]];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_Datamodel.date]];
    }
    self.table11.colTitleArr = tipArr;
    //        self.table44.colWidthArr = colWid;
    self.table11.colWidthArr = @[@30.0,@40.0,@90.0,@30.0,@90.0,@50.0];
    self.table11.bodyTextColor = [UIColor blackColor];
    self.table11.minHeightItems = 36;
    self.table11.lineColor = [UIColor lightGrayColor];
    self.table11.backgroundColor = [UIColor clearColor];
    
    NSMutableArray *newArr1 = [[NSMutableArray alloc] init];
    for (int i=0; i<_modelArr.count; i++) {
        if (i>0) {
            NSMutableArray *newArr = [[NSMutableArray alloc] init];
            [newArr removeAllObjects];
            _Datamodel = _modelArr[i];
            [newArr addObject:[NSString stringWithFormat:@"%@",_Datamodel.ID]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_Datamodel.home]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_Datamodel.addr]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_Datamodel.nature]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_Datamodel.cause]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_Datamodel.date]];
            [newArr1 addObject:newArr];
        }
        
    }
    self.table11.dataArr = newArr1;
    [self.table11 showAnimation];
    [oneTable1 addSubview:self.table11];
    oneTable1.contentSize = CGSizeMake(KWidth, 36*self.modelArr.count);
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
    NSInteger coun = self.modelArr1.count;
    toplabel.text = [NSString stringWithFormat:@"%@(分公司)%@ 共%ld条",self.fengongsi,self.yunwei,coun];
//    toplabel.text = @"xx公司(分公司) 运维小组1 周巷镇 共9条";
    [self.rightView addSubview:toplabel];
    
//    UIButton *shaixuanBtn3 = [[UIButton alloc] initWithFrame:CGRectMake(KWidth-90, 14, 80, 30)];
//    [shaixuanBtn3 setImage:[UIImage imageNamed:@"筛选"] forState:UIControlStateNormal];
//    [shaixuanBtn3 addTarget:self action:@selector(shaixuanBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.rightView addSubview:shaixuanBtn3];
    
    if (self.modelArr1.count<10) {
        if (self.modelArr1.count==0) {
            self.biaogeBg1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 45, KWidth-20, self.modelArr1.count*40+35)];
            self.biaogeBg1.image = [UIImage imageNamed:@"表格bg"];
            [self.rightView addSubview:self.biaogeBg1];
        }else{
            self.biaogeBg1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 45, KWidth-20, self.modelArr1.count*40+33)];
            self.biaogeBg1.image = [UIImage imageNamed:@"表格bg"];
            [self.rightView addSubview:self.biaogeBg1];
        }
    }else{
        self.biaogeBg1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 45, KWidth-20, 400)];
        self.biaogeBg1.image = [UIImage imageNamed:@"表格bg"];
        [self.rightView addSubview:self.biaogeBg1];
    }
    
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
    NSMutableArray *tipArr = [[NSMutableArray alloc] init];
    if (self.modelArr1.count>0) {
        _Datamodel = _modelArr1[0];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_Datamodel.ID]];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_Datamodel.home]];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_Datamodel.addr]];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_Datamodel.nature]];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_Datamodel.cause]];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_Datamodel.date]];
    }
    self.table33.colTitleArr = tipArr;
    //        self.table44.colWidthArr = colWid;
    self.table33.colWidthArr = @[@30.0,@40.0,@90.0,@30.0,@90.0,@50.0];
    self.table33.bodyTextColor = [UIColor blackColor];
    self.table33.minHeightItems = 36;
    self.table33.lineColor = [UIColor lightGrayColor];
    self.table33.backgroundColor = [UIColor clearColor];
    
    NSMutableArray *newArr1 = [[NSMutableArray alloc] init];
    for (int i=0; i<_modelArr1.count; i++) {
        if (i>0) {
            NSMutableArray *newArr = [[NSMutableArray alloc] init];
            [newArr removeAllObjects];
            _Datamodel = _modelArr1[i];
            [newArr addObject:[NSString stringWithFormat:@"%@",_Datamodel.ID]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_Datamodel.home]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_Datamodel.addr]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_Datamodel.nature]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_Datamodel.cause]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_Datamodel.date]];
            [newArr1 addObject:newArr];
        }
        
    }
    self.table33.dataArr = newArr1;
    [self.table33 showAnimation];
    [oneTable1 addSubview:self.table33];
    oneTable1.contentSize = CGSizeMake(KWidth, 36*self.modelArr1.count);
    self.table33.frame = CGRectMake(0, 0, KWidth, [self.table33 heightFromThisDataSource]);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)transButIndex:(NSInteger)index
{
    CGPoint offset = _bgscrollview.contentOffset;
    
    if (offset.x == 0) {
        _Datamodel = _modelArr[index];
        _selectID = _Datamodel.ID;
        _selectBid = _Datamodel.bid;
        self.jieduan = 0;
    }else{
        _Datamodel = _modelArr1[index];
        _selectID = _Datamodel.ID;
        _selectBid = _Datamodel.bid;
        self.jieduan = 1;
    }
    [self requesterror];
    
}
- (void)CloseClick1{
    [self.errorList removeFromSuperview];
}
-(void)LeftClick1{
    [self.errorList removeFromSuperview];
}
-(void)RightClick1{
    NSString *str = self.errorList.yunweiyijian.text;
    NSLog(@"str:%@ %@",str,self.dianjiStatus);
    [self requestchangge];
    [self.errorList removeFromSuperview];
}
-(void)bohaoBtnClick{
    NSString *str = [NSString stringWithFormat:@"tel:%@",self.phone];
//    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:18813189235"];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
}

-(void)xinxiBtnClick{
    NSString *str = [NSString stringWithFormat:@"sms://%@",self.phone];
    NSURL *url = [NSURL URLWithString:str];
    
    [[UIApplication sharedApplication] openURL:url];
    
    
}
-(void)weichuliClick{
    self.dianjiStatus = @"0";
}
-(void)chulizhongClick{
    self.dianjiStatus = @"1";
}
-(void)yichuliClick{
    self.dianjiStatus = @"2";
}

-(void)daohangBtnClick{
    [self mapBtnClick];
}
- (void)mapBtnClick{
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
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:30.833708884292438,119.9267578125|name:我的位置&destination=latlng:%@,%@|name:终点&mode=driving",newArray3[0],newArray3[1]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
    }else if (hasGaodeMap)
    {
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&poiname=%@&lat=%@&lon=%@&dev=1&style=2",@"红彤代理端", @"123123123", @"终点",newArray3[0],newArray3[1]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
    }else{
        [MBProgressHUD showText:@"请先安装百度地图或者高德地图"];
    }
}

-(void)requestData{
    NSString *URL = [NSString stringWithFormat:@"%@/police/work/list",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.workID forKey:@"id"];
    [parameters setValue:@"handle" forKey:@"type"];
    //type:值(handle 和  inhandle)
    NSLog(@"parameters:%@",parameters);
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取户列表正确%@",responseObject);
        
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
            [self.modelArr removeAllObjects];
            for (NSMutableDictionary *dic in responseObject[@"content"]) {
                _Datamodel = [[YunWeiListModel alloc] initWithDictionary:dic];
                [self.modelArr addObject:_Datamodel];
            }
            [self setLeftTable];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}
-(void)requestData1{
    NSString *URL = [NSString stringWithFormat:@"%@/police/work/list",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.workID forKey:@"id"];
    [parameters setValue:@"inhandle" forKey:@"type"];
    //type:值(handle 和  inhandle)
    NSLog(@"parameters:%@",parameters);
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取户列表正确%@",responseObject);
        
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
                _Datamodel = [[YunWeiListModel alloc] initWithDictionary:dic];
                [self.modelArr1 addObject:_Datamodel];
            }
            [self setRightTable];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}

-(void)requesterror{
    NSString *URL = [NSString stringWithFormat:@"%@/police/work/ropup",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.selectID forKey:@"id"];
    [parameters setValue:self.selectBid forKey:@"bid"];
    //type:值(handle 和  inhandle)
    NSLog(@"parameters:%@",parameters);
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取故障列表正确%@",responseObject);
        
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
           
            self.address = responseObject[@"content"][@"address"];
            NSString *house_id = responseObject[@"content"][@"house_id"];
            NSString *name = responseObject[@"content"][@"name"];
            self.phone = responseObject[@"content"][@"phone"];
            NSString *power = responseObject[@"content"][@"power"];
            NSString *today_gen = responseObject[@"content"][@"today_gen"];
            NSString *position = responseObject[@"content"][@"position"];
            self.position = position;
            self.errorList = [[[NSBundle mainBundle]loadNibNamed:@"ErrorListView" owner:self options:nil]objectAtIndex:0];
            self.errorList.delegate = self;
            self.errorList.frame = CGRectMake(0, 0, KWidth, KHeight);
            self.errorList.huhao.text = house_id;
            self.errorList.shoujihao.text = self.phone;
            self.errorList.dizhi.text = self.address;
            self.errorList.gonglv.text = [NSString stringWithFormat:@"%@kW",power];
            self.errorList.fadianliang.text = [NSString stringWithFormat:@"%@度",today_gen];;
            self.errorList.huhao.text = house_id;
            if (self.jieduan==0) {
                self.errorList.chulizhuangtai.text = @"未处理";
            }else{
                self.errorList.chulizhuangtai.text = @"处理中";
            }
            self.errorList.tongxunzhuangtai.text = _Datamodel.nature;
            [self.view addSubview:self.errorList];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}
-(void)requestchangge{
    NSString *URL = [NSString stringWithFormat:@"%@/police/work/handle",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.selectID forKey:@"id"];
    [parameters setValue:self.selectBid forKey:@"bid"];
    [parameters setValue:self.dianjiStatus forKey:@"status"];
    [parameters setValue:self.errorList.yunweiyijian.text forKey:@"opinion"];
    //type:值(handle 和  inhandle)
    NSLog(@"parameters:%@",parameters);
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传故障正确%@",responseObject);
        
        if ([responseObject[@"result"][@"success"] intValue] ==0) {
            NSNumber *code = responseObject[@"result"][@"errorCode"];
            NSString *errorcode = [NSString stringWithFormat:@"%@",code];
            if ([errorcode isEqualToString:@"3100"])  {
                [MBProgressHUD showText:@"请重新登陆"];
                [self newLogin];
            }else{
//                NSString *str = responseObject[@"result"][@"errorMsg"];
//                [MBProgressHUD showText:str];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text =responseObject[@"result"][@"errorMsg"];
                [hud hideAnimated:YES afterDelay:2.f];
            }
        }else{
            
            
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
-(NSMutableArray *)modelArr{
    if (!_modelArr) {
        _modelArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return  _modelArr;
}
-(NSMutableArray *)modelArr1{
    if (!_modelArr1) {
        _modelArr1 = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return  _modelArr1;
}
-(YunWeiListModel *)Datamodel{
    if (!_Datamodel) {
        _Datamodel = [[YunWeiListModel alloc] init];
    }
    return _Datamodel;
}
@end
