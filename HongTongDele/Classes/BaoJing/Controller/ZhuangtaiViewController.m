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
#import "ZhuangTaiYunWeiModel.h"
#import "JHPickView.h"
#define Bound_Width  [[UIScreen mainScreen] bounds].size.width
#define Bound_Height [[UIScreen mainScreen] bounds].size.height
// 获得RGB颜色
#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
@interface ZhuangtaiViewController ()<UIScrollViewDelegate,TableButDelegate,JHPickerDelegate>
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
@property (nonatomic,strong)ZhuangTaiYunWeiModel *zhuangtaimodel;
@property (nonatomic,strong)NSMutableArray *dataArr1;
@property (nonatomic,strong)NSMutableArray *dataArr2;
@property (nonatomic,strong)NSMutableArray *dataArr3;
@property (nonatomic,strong)NSMutableArray *towndataArr1;
@property (nonatomic,strong)NSMutableArray *towndataArr2;
@property (nonatomic,strong)NSMutableArray *towndataArr3;
@property (nonatomic,assign)NSInteger select;
@property (nonatomic,strong)UILabel *tipLabel1;
@property (nonatomic,strong)UILabel *tipLabel2;
@property (nonatomic,strong)UILabel *tipLabel3;
@property (nonatomic,assign)NSInteger selecttown1;
@property (nonatomic,assign)NSInteger selecttown2;
@property (nonatomic,assign)NSInteger selecttown3;
@property (nonatomic,assign)NSInteger cishu;
@property (nonatomic,strong)UIImageView *biaogeBG1;
@property (nonatomic,strong)UIImageView *biaogeBG2;
@property (nonatomic,strong)UIImageView *biaogeBG3;
@end

@implementation ZhuangtaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.cishu = 0;
    self.selecttown1 = 0;
    self.selecttown2 = 0;
    self.selecttown3 = 0;
    self.title = @"报警电站";
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
    topLabel.text = @"报警电站";
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
    
    for (int i=0; i<3; i++) {
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
    //    [self setTabel];
    
}
- (void)setTabel{
    NSLog(@"%@ %@ %@",self.dataArr1,self.dataArr2,self.dataArr3);
    NSLog(@"%@ %@ %@",self.towndataArr1,self.towndataArr2,self.towndataArr3);
    for (int i=0; i<3; i++) {
        
        if (i==0) {
            UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(25, 16, 12, 17)];
            leftImg.image = [UIImage imageNamed:@"定位"];
            [self.AllView addSubview:leftImg];
            
            self.tipLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(50, 14, KWidth-70, 24)];
            self.tipLabel1.font = [UIFont systemFontOfSize:15];
            self.tipLabel1.textColor = [UIColor darkGrayColor];
            if (self.towndataArr1.count>0) {
                NSString *town = self.towndataArr1[0];
                NSMutableArray *arrar = self.dataArr1[0];
                NSInteger coun = arrar.count;
                self.tipLabel1.text = [NSString stringWithFormat:@"%@(分公司)%@ %@ 共%ld户",self.name,self.name1,town,coun];
            }else{
                self.tipLabel1.text = [NSString stringWithFormat:@"%@(分公司)%@ ",self.name,self.name1];
            }
            //;@"XX公司(分公司)运维小组1 周巷镇 共9户"
            [self.AllView addSubview:self.tipLabel1];
            
            UIButton *oneBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 14, KWidth-70, 24)];
            [oneBtn addTarget:self action:@selector(oneBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [self.AllView addSubview:oneBtn];
            
            if (self.dataArr1.count<10) {
                if (self.dataArr1.count==0) {
                    self.biaogeBG1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, KWidth-20, self.dataArr1.count*40+35)];
                    self.biaogeBG1.image = [UIImage imageNamed:@"表格bg"];
                    [self.AllView addSubview:self.biaogeBG1];
                }else{
                    self.biaogeBG1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, KWidth-20, self.dataArr1.count*40+33)];
                    self.biaogeBG1.image = [UIImage imageNamed:@"表格bg"];
                    [self.AllView addSubview:self.biaogeBG1];
                }
            }else{
                self.biaogeBG1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, KWidth-20, 400)];
                self.biaogeBG1.image = [UIImage imageNamed:@"表格bg"];
                [self.AllView addSubview:self.biaogeBG1];
            }
            
            UIView *fourTable = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, KWidth, 400)];
            //    fourTable.bounces = NO;
            [self.AllView addSubview:fourTable];
            
            self.table1 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 400)];
            self.table1.delegate = self;
            self.table1.typeCount = 88;
            self.table1.small = YES;
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
            NSMutableArray *tipArr = [[NSMutableArray alloc] init];
            NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
            if (_dataArr1.count>0) {
                arr = _dataArr1[0];
            }
            if (arr.count>0) {
                _zhuangtaimodel = _dataArr1[0][0];
                [tipArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.ID]];
                [tipArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.home]];
                [tipArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.addr]];
                [tipArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.cause]];
                [tipArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.created_at]];
            }
            
            self.table11.colTitleArr = tipArr;
            //        self.table44.colWidthArr = colWid;
            self.table11.colWidthArr = @[@30.0,@60.0,@100.0,@80.0,@80.0];
            self.table11.bodyTextColor = [UIColor blackColor];
            self.table11.minHeightItems = 36;
            self.table11.lineColor = [UIColor lightGrayColor];
            self.table11.backgroundColor = [UIColor clearColor];
            
            NSMutableArray *newArr = [[NSMutableArray alloc] init];
            NSMutableArray *newArr1 = [[NSMutableArray alloc] init];
            
            for (int i=0; i<arr.count; i++) {
                if (i>0) {
                    [newArr removeAllObjects];
                    _zhuangtaimodel = arr[i];
                    [newArr addObject: [NSString stringWithFormat:@"%@",_zhuangtaimodel.ID]];
                    [newArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.home]];
                    [newArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.addr]];
                    [newArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.cause]];
                    [newArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.created_at]];
                    [newArr1 addObject:newArr];
                }
                
            }
            self.table11.dataArr = newArr1;
            [self.table11 showAnimation];
            [oneTable1 addSubview:self.table11];
            oneTable1.contentSize = CGSizeMake(KWidth, 360);
            self.table11.frame = CGRectMake(0, 0, KWidth, [self.table11 heightFromThisDataSource]);
        }else if (i==1){
            UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(25, 16, 12, 17)];
            leftImg.image = [UIImage imageNamed:@"定位"];
            [self.QuanEView addSubview:leftImg];
            
            self.tipLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(50, 14, KWidth-70, 24)];
            self.tipLabel2.font = [UIFont systemFontOfSize:15];
            self.tipLabel2.textColor = [UIColor darkGrayColor];
            if (self.dataArr2.count>0) {
                NSString *town = self.towndataArr2[0];
                NSMutableArray *arrar = self.dataArr2[0];
                NSInteger coun = arrar.count;
                self.tipLabel2.text = [NSString stringWithFormat:@"%@(分公司)%@ %@ 共%ld户",self.name,self.name1,town,coun];
            }else{
                self.tipLabel2.text = [NSString stringWithFormat:@"%@(分公司)%@ ",self.name,self.name1];
            }
            [self.QuanEView addSubview:self.tipLabel2];
            
            UIButton *twoBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 14, KWidth-70, 24)];
            [twoBtn addTarget:self action:@selector(twoBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [self.QuanEView addSubview:twoBtn];
            NSMutableArray *arrar = self.dataArr2[0];
            if (arrar.count<10) {
                if (arrar.count==0) {
                    self.biaogeBG2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, KWidth-20, arrar.count*40+35)];
                    self.biaogeBG2.image = [UIImage imageNamed:@"表格bg"];
                    [self.QuanEView addSubview:self.biaogeBG2];
                }else{
                    self.biaogeBG2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, KWidth-20, arrar.count*40+33)];
                    self.biaogeBG2.image = [UIImage imageNamed:@"表格bg"];
                    [self.QuanEView addSubview:self.biaogeBG2];
                }
            }else{
                self.biaogeBG2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, KWidth-20, 400)];
                self.biaogeBG2.image = [UIImage imageNamed:@"表格bg"];
                [self.QuanEView addSubview:self.biaogeBG2];
            }
            
            UIView *fourTable = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, KWidth, 400)];
            //    fourTable.bounces = NO;
            [self.QuanEView addSubview:fourTable];
            
            self.table2 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 400)];
            self.table2.delegate = self;
            self.table2.typeCount = 88;
            self.table2.small = YES;
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
            NSMutableArray *tipArr = [[NSMutableArray alloc] init];
            NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
            if (_dataArr2.count>0) {
                arr = _dataArr2[0];
            }
            if (arr.count>0) {
                _zhuangtaimodel = _dataArr2[0][0];
                [tipArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.ID]];
                [tipArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.home]];
                [tipArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.addr]];
                [tipArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.cause]];
                [tipArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.created_at]];
            }
            self.table22.colTitleArr = tipArr;
            //        self.table44.colWidthArr = colWid;
            self.table22.colWidthArr = @[@30.0,@60.0,@100.0,@80.0,@80.0];
            self.table22.bodyTextColor = [UIColor blackColor];
            self.table22.minHeightItems = 36;
            self.table22.lineColor = [UIColor lightGrayColor];
            self.table22.backgroundColor = [UIColor clearColor];
            NSMutableArray *newArr = [[NSMutableArray alloc] init];
            NSMutableArray *newArr1 = [[NSMutableArray alloc] init];
            for (int i=0; i<arr.count; i++) {
                if (i>0) {
                    [newArr removeAllObjects];
                    _zhuangtaimodel = _dataArr2[0][i];
                    [newArr addObject: [NSString stringWithFormat:@"%@",_zhuangtaimodel.ID]];
                    [newArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.home]];
                    [newArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.addr]];
                    [newArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.cause]];
                    [newArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.created_at]];
                    [newArr1 addObject:newArr];
                }
                
            }
            self.table22.dataArr = newArr1;
            [self.table22 showAnimation];
            [oneTable1 addSubview:self.table22];
            oneTable1.contentSize = CGSizeMake(KWidth, 360);
            self.table22.frame = CGRectMake(0, 0, KWidth, [self.table22 heightFromThisDataSource]);
        }else{
            UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(25, 16, 12, 17)];
            leftImg.image = [UIImage imageNamed:@"定位"];
            [self.YuDianView addSubview:leftImg];
            
            self.tipLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(50, 14, KWidth-70, 24)];
            self.tipLabel3.font = [UIFont systemFontOfSize:15];
            self.tipLabel3.textColor = [UIColor darkGrayColor];
            if (self.towndataArr3.count>0) {
                NSString *town = self.towndataArr3[0];
                NSMutableArray *arrar = self.dataArr3[0];
                NSInteger coun = arrar.count;
                self.tipLabel3.text = [NSString stringWithFormat:@"%@(分公司)%@ %@ 共%ld户",self.name,self.name1,town,coun];
            }else{
                self.tipLabel3.text = [NSString stringWithFormat:@"%@(分公司)%@ ",self.name,self.name1];
            }
            [self.YuDianView addSubview:self.tipLabel3];
            
            UIButton *threeBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 14, KWidth-70, 24)];
            [threeBtn addTarget:self action:@selector(threeBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [self.YuDianView addSubview:threeBtn];
            NSMutableArray *arrar = self.dataArr3[0];
            if (arrar.count<10) {
                if (arrar.count==0) {
                    self.biaogeBG3 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, KWidth-20, arrar.count*40+35)];
                    self.biaogeBG3.image = [UIImage imageNamed:@"表格bg"];
                    [self.YuDianView addSubview:self.biaogeBG3];
                }else{
                    self.biaogeBG3 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, KWidth-20, arrar.count*40+33)];
                    self.biaogeBG3.image = [UIImage imageNamed:@"表格bg"];
                    [self.YuDianView addSubview:self.biaogeBG3];
                }
            }else{
                self.biaogeBG3 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, KWidth-20, 400)];
                self.biaogeBG3.image = [UIImage imageNamed:@"表格bg"];
                [self.YuDianView addSubview:self.biaogeBG3];
            }
            
            UIView *fourTable = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, KWidth, 400)];
            //    fourTable.bounces = NO;
            [self.YuDianView addSubview:fourTable];
            
            self.table3 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 400)];
            self.table3.delegate = self;
            self.table3.typeCount = 88;
            self.table3.small = YES;
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
            NSMutableArray *tipArr = [[NSMutableArray alloc] init];
            NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
            if (_dataArr3.count>0) {
                arr = _dataArr3[0];
            }
            if (arr.count>0) {
                _zhuangtaimodel = _dataArr3[0][0];
                [tipArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.ID]];
                [tipArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.home]];
                [tipArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.addr]];
                [tipArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.cause]];
                [tipArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.created_at]];
            }
            self.table33.colTitleArr = tipArr;
            //        self.table44.colWidthArr = colWid;
            self.table33.colWidthArr = @[@30.0,@60.0,@100.0,@80.0,@80.0];
            self.table33.bodyTextColor = [UIColor blackColor];
            self.table33.minHeightItems = 36;
            self.table33.lineColor = [UIColor lightGrayColor];
            self.table33.backgroundColor = [UIColor clearColor];
            NSMutableArray *newArr = [[NSMutableArray alloc] init];
            NSMutableArray *newArr1 = [[NSMutableArray alloc] init];
            for (int i=0; i<arr.count; i++) {
                if (i>0) {
                    [newArr removeAllObjects];
                    _zhuangtaimodel = _dataArr3[0][i];
                    [newArr addObject: [NSString stringWithFormat:@"%@",_zhuangtaimodel.ID]];
                    [newArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.home]];
                    [newArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.addr]];
                    [newArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.cause]];
                    [newArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.created_at]];
                    [newArr1 addObject:newArr];
                }
                
            }
            self.table33.dataArr = newArr1;
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
    CGPoint offset = _scrollView.contentOffset;
    
    if (offset.x == 0) {
        NSLog(@"代理方法%ld  第一页",index);
        
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
        if (_dataArr1.count>0) {
            arr = _dataArr1[_selecttown1];
        }
        _zhuangtaimodel = arr[index];
        self.navigationController.navigationBar.hidden = NO;
        InstallStationViewController *vc = [[InstallStationViewController alloc] init];
        vc.bid = _zhuangtaimodel.bid;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(offset.x == 375){
        NSLog(@"代理方法%ld  第二页",index);
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
        if (_dataArr2.count>0) {
            arr = _dataArr2[_selecttown2];
        }
        _zhuangtaimodel = arr[index];
        self.navigationController.navigationBar.hidden = NO;
        InstallStationViewController *vc = [[InstallStationViewController alloc] init];
        vc.bid = _zhuangtaimodel.bid;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSLog(@"代理方法%ld  第三页",index);
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
        if (_dataArr3.count>0) {
            arr = _dataArr3[_selecttown3];
        }
        _zhuangtaimodel = arr[index];
        self.navigationController.navigationBar.hidden = NO;
        InstallStationViewController *vc = [[InstallStationViewController alloc] init];
        vc.bid = _zhuangtaimodel.bid;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)oneBtnClick{
    JHPickView *picker = [[JHPickView alloc]initWithFrame:self.view.bounds];
    picker.classArr = self.towndataArr1;
    self.select = 0;
    picker.delegate = self ;
    picker.arrayType = weightArray;
    [self.view addSubview:picker];
}
-(void)twoBtnClick{
    JHPickView *picker = [[JHPickView alloc]initWithFrame:self.view.bounds];
    picker.classArr = self.towndataArr2;
    self.select = 1;
    picker.delegate = self ;
    picker.arrayType = weightArray;
    [self.view addSubview:picker];
}
-(void)threeBtnClick{
    JHPickView *picker = [[JHPickView alloc]initWithFrame:self.view.bounds];
    picker.classArr = self.towndataArr3;
    self.select = 2;
    picker.delegate = self ;
    picker.arrayType = weightArray;
    [self.view addSubview:picker];
}

#pragma mark - JHPickerDelegate

-(void)PickerSelectorIndixString:(NSString *)str:(NSInteger)row
{
    NSInteger select = 0;
    NSLog(@"%@ %ld",str,row);
    
    if (self.select ==0) {
        [self.table1 removeFromSuperview];
        [self.table11 removeFromSuperview];
        for (int i=0; i<_towndataArr1.count; i++) {
            if ( [str isEqualToString:_towndataArr1[i]]) {
                select = i;
                self.selecttown1 = i;
            }
        }
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
        if (_dataArr1.count>0) {
            arr = _dataArr1[select];
        }
        if (arr.count<10) {
            if (arr.count==0) {
                self.biaogeBG1.frame = CGRectMake(10, 40, KWidth-20, arr.count*40+35);
            }else{
                self.biaogeBG1.frame =CGRectMake(10, 40, KWidth-20, arr.count*40+33);
            }
        }else{
            self.biaogeBG1.frame = CGRectMake(10, 40, KWidth-20, 400);
            
        }
        
        UIView *fourTable = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, KWidth, 400)];
        //    fourTable.bounces = NO;
        [self.AllView addSubview:fourTable];
        
        self.table1 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 400)];
//        self.table1.delegate = self;
        self.table1.typeCount = 88;
        self.table1.small = YES;
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
        NSMutableArray *tipArr = [[NSMutableArray alloc] init];
       
        if (arr.count>0) {
            _zhuangtaimodel = arr[0];
            [tipArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.ID]];
            [tipArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.home]];
            [tipArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.addr]];
            [tipArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.cause]];
            [tipArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.created_at]];
        }
        
        self.table11.colTitleArr = tipArr;
        //        self.table44.colWidthArr = colWid;
        self.table11.colWidthArr = @[@30.0,@60.0,@100.0,@80.0,@80.0];
        self.table11.bodyTextColor = [UIColor blackColor];
        self.table11.minHeightItems = 36;
        self.table11.lineColor = [UIColor lightGrayColor];
        self.table11.backgroundColor = [UIColor clearColor];
        
        NSMutableArray *newArr = [[NSMutableArray alloc] init];
        NSMutableArray *newArr1 = [[NSMutableArray alloc] init];
        
        for (int i=0; i<arr.count; i++) {
            if (i>0) {
                [newArr removeAllObjects];
                _zhuangtaimodel = arr[i];
                [newArr addObject: [NSString stringWithFormat:@"%@",_zhuangtaimodel.ID]];
                [newArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.home]];
                [newArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.addr]];
                [newArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.cause]];
                [newArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.created_at]];
                [newArr1 addObject:newArr];
            }
            
        }
        self.table11.dataArr = newArr1;
        [self.table11 showAnimation];
        [oneTable1 addSubview:self.table11];
        oneTable1.contentSize = CGSizeMake(KWidth, 360);
        self.table11.frame = CGRectMake(0, 0, KWidth, [self.table11 heightFromThisDataSource]);
        
        NSString *town = str;
        NSInteger coun = arr.count;
        //        self.tipLabel2.text = @"";
        self.tipLabel1.text = [NSString stringWithFormat:@"%@(分公司)%@ %@ 共%ld户",self.name,self.name1,town,coun];
        NSLog(@"%@",self.tipLabel1.text);
    }else if(self.select==1){
        [self.table2 removeFromSuperview];
        [self.table22 removeFromSuperview];
        for (int i=0; i<_towndataArr2.count; i++) {
            if ( [str isEqualToString:_towndataArr2[i]]) {
                select = i;
                self.selecttown2 = i;
            }
        }
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
        if (_dataArr2.count>0) {
            arr = _dataArr2[select];
        }
        if (arr.count<10) {
            if (arr.count==0) {
                self.biaogeBG2.frame = CGRectMake(10, 40, KWidth-20, arr.count*40+35);
            }else{
                self.biaogeBG2.frame =CGRectMake(10, 40, KWidth-20, arr.count*40+33);
            }
        }else{
            self.biaogeBG2.frame = CGRectMake(10, 40, KWidth-20, 400);
            
        }
        
        UIView *fourTable = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, KWidth, 400)];
        //    fourTable.bounces = NO;
        [self.QuanEView addSubview:fourTable];
        
        self.table2 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 400)];
//        self.table2.delegate = self;
        self.table2.typeCount = 88;
        self.table2.small = YES;
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
        NSMutableArray *tipArr = [[NSMutableArray alloc] init];
        
        if (arr.count>0) {
            _zhuangtaimodel = arr[0];
            [tipArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.ID]];
            [tipArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.home]];
            [tipArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.addr]];
            [tipArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.cause]];
            [tipArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.created_at]];
        }
        
        self.table22.colTitleArr = tipArr;
        //        self.table44.colWidthArr = colWid;
        self.table22.colWidthArr = @[@30.0,@60.0,@100.0,@80.0,@80.0];
        self.table22.bodyTextColor = [UIColor blackColor];
        self.table22.minHeightItems = 36;
        self.table22.lineColor = [UIColor lightGrayColor];
        self.table22.backgroundColor = [UIColor clearColor];
        
        NSMutableArray *newArr = [[NSMutableArray alloc] init];
        NSMutableArray *newArr1 = [[NSMutableArray alloc] init];
        
        for (int i=0; i<arr.count; i++) {
            if (i>0) {
                _zhuangtaimodel = arr[i];
                [newArr removeAllObjects];
                [newArr addObject: [NSString stringWithFormat:@"%@",_zhuangtaimodel.ID]];
                [newArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.home]];
                [newArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.addr]];
                [newArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.cause]];
                [newArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.created_at]];
                [newArr1 addObject:newArr];
            }
            
        }
        self.table22.dataArr = newArr1;
        [self.table22 showAnimation];
        [oneTable1 addSubview:self.table22];
        oneTable1.contentSize = CGSizeMake(KWidth, 360);
        self.table22.frame = CGRectMake(0, 0, KWidth, [self.table22 heightFromThisDataSource]);
        
        NSString *town = str;
        NSInteger coun = arr.count;
        //        self.tipLabel2.text = @"";
        self.tipLabel2.text = [NSString stringWithFormat:@"%@(分公司)%@ %@ 共%ld户",self.name,self.name1,town,coun];
        NSLog(@"%@",self.tipLabel2.text);
    }else{
        [self.table3 removeFromSuperview];
        [self.table33 removeFromSuperview];
        for (int i=0; i<_towndataArr3.count; i++) {
            if ( [str isEqualToString:_towndataArr3[i]]) {
                select = i;
                self.selecttown3 = i;
            }
        }
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
        if (_dataArr3.count>0) {
            arr = _dataArr3[select];
        }
        if (arr.count<10) {
            if (arr.count==0) {
                self.biaogeBG3.frame = CGRectMake(10, 40, KWidth-20, arr.count*40+35);
            }else{
                self.biaogeBG3.frame =CGRectMake(10, 40, KWidth-20, arr.count*40+33);
            }
        }else{
            self.biaogeBG3.frame = CGRectMake(10, 40, KWidth-20, 400);
            
        }
        
        UIView *fourTable = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, KWidth, 400)];
        //    fourTable.bounces = NO;
        [self.YuDianView addSubview:fourTable];
        
        self.table3 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 400)];
//        self.table3.delegate = self;
        self.table3.typeCount = 88;
        self.table3.small = YES;
        self.table3.isblue = NO;
        self.table3.bodyTextColor = [UIColor blackColor];
        self.table3.tableTitleFont = [UIFont systemFontOfSize:14];
        //    table.xDescTextFontSize =  (CGFloat)13;
        //    table.yDescTextFontSize =  (CGFloat)13;
        self.table3.colTitleArr = @[@"类别|序号",@"户号",@"地址",@"详情",@"发生时间"];
        
        
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
        NSMutableArray *tipArr = [[NSMutableArray alloc] init];
        
        if (arr.count>0) {
            _zhuangtaimodel = arr[0];
            [tipArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.ID]];
            [tipArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.home]];
            [tipArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.addr]];
            [tipArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.cause]];
            [tipArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.created_at]];
        }
        
        self.table33.colTitleArr = tipArr;
        //        self.table44.colWidthArr = colWid;
        self.table33.colWidthArr = @[@30.0,@60.0,@100.0,@80.0,@80.0];
        self.table33.bodyTextColor = [UIColor blackColor];
        self.table33.minHeightItems = 36;
        self.table33.lineColor = [UIColor lightGrayColor];
        self.table33.backgroundColor = [UIColor clearColor];
        
        NSMutableArray *newArr = [[NSMutableArray alloc] init];
        NSMutableArray *newArr1 = [[NSMutableArray alloc] init];
        
        for (int i=0; i<arr.count; i++) {
            if (i>0) {
                _zhuangtaimodel = arr[i];
                [newArr removeAllObjects];
                [newArr addObject: [NSString stringWithFormat:@"%@",_zhuangtaimodel.ID]];
                [newArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.home]];
                [newArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.addr]];
                [newArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.cause]];
                [newArr addObject:[NSString stringWithFormat:@"%@",_zhuangtaimodel.created_at]];
                [newArr1 addObject:newArr];
            }
            
        }
        self.table33.dataArr = newArr1;
        [self.table33 showAnimation];
        [oneTable1 addSubview:self.table33];
        oneTable1.contentSize = CGSizeMake(KWidth, 360);
        self.table33.frame = CGRectMake(0, 0, KWidth, [self.table33 heightFromThisDataSource]);
        
        NSString *town = str;
        NSInteger coun = arr.count;
        //        self.tipLabel2.text = @"";
        self.tipLabel3.text = [NSString stringWithFormat:@"%@(分公司)%@ %@ 共%ld户",self.name,self.name1,town,coun];
        NSLog(@"%@",self.tipLabel3.text);
    }
    
}

-(void)requestData{
    //?nature=离线    离线,异常,故障
    for (int i=0; i<3;i++ ) {
        
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
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setValue:@"nature" forKey:@""];
        if (i==0) {
            [parameters setValue:@"offline" forKey:@"nature"];
        }else if (i==1){
            [parameters setValue:@"abnormal" forKey:@"nature"];
        }else{
            [parameters setValue:@"fault" forKey:@"nature"];
        }
        [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
            
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
                    if (i==0) {
                        [self.towndataArr1 addObject:dic[@"town"]];
                    }else if(i==1){
                        [self.towndataArr2 addObject:dic[@"town"]];
                    }else if(i==2){
                        [self.towndataArr3 addObject:dic[@"town"]];
                    }
                    NSLog(@"dic:%@",dic);
                    NSMutableArray *arr1 = [[NSMutableArray alloc] initWithCapacity:0];
                    NSMutableArray *arr2 = [[NSMutableArray alloc] initWithCapacity:0];
                    NSMutableArray *arr3 = [[NSMutableArray alloc] initWithCapacity:0];
                    for (NSDictionary *dic1 in dic[@"table"]){
                        _zhuangtaimodel = [[ZhuangTaiYunWeiModel alloc] initWithDictionary:dic1];
                        if (i==0) {
                            [arr1 addObject:_zhuangtaimodel];
                        }else if (i==1){
                            [arr2 addObject:_zhuangtaimodel];
                        }else{
                            [arr3 addObject:_zhuangtaimodel];
                        }
                        
                    
                    }
                    if (i==0) {
                        [self.dataArr1 addObject:arr1];
                    }else if (i==1){
                        [self.dataArr2 addObject:arr2];
                    }else if(i==2){
                        [self.dataArr3 addObject:arr3];
                    }
                }
                    
                    if (i==2) {
//                                            [self setTabel];
                        [self performSelector:@selector(setTabel) withObject:nil afterDelay:1.0f];
                    }
                    }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"失败%@",error);
                        //        [MBProgressHUD showText:@"%@",error[@"error"]];
                    }];
        
                }
        
    
                    
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
    -(ZhuangTaiYunWeiModel *)zhuangtaimodel{
        if (!_zhuangtaimodel) {
            _zhuangtaimodel = [[BaoJingZhuangTaiModel alloc] init];
        }
        return _zhuangtaimodel;
    }
    -(NSMutableArray *)dataArr1{
        if (!_dataArr1) {
            _dataArr1 = [[NSMutableArray alloc] initWithCapacity:0];
        }
        return  _dataArr1;
    }
    -(NSMutableArray *)dataArr2{
        if (!_dataArr2) {
            _dataArr2 = [[NSMutableArray alloc] initWithCapacity:0];
        }
        return  _dataArr2;
    }
    -(NSMutableArray *)dataArr3{
        if (!_dataArr3) {
            _dataArr3 = [[NSMutableArray alloc] initWithCapacity:0];
        }
        return  _dataArr3;
    }
    -(NSMutableArray *)towndataArr1{
        if (!_towndataArr1) {
            _towndataArr1 = [[NSMutableArray alloc] initWithCapacity:0];
        }
        return  _towndataArr1;
    }
    -(NSMutableArray *)towndataArr2{
        if (!_towndataArr2) {
            _towndataArr2 = [[NSMutableArray alloc] initWithCapacity:0];
        }
        return  _towndataArr2;
    }
    -(NSMutableArray *)towndataArr3{
        if (!_towndataArr3) {
            _towndataArr3 = [[NSMutableArray alloc] initWithCapacity:0];
        }
        return  _towndataArr3;
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
