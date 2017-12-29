//
//  BaoJingLishiYunweiListViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/12/1.
//  Copyright © 2017年 xinyuntec. All rights reserved.
// 报警历史户

#import "BaoJingLishiYunweiListViewController.h"
#import "JHTableChart.h"
#import "ShaiXuanKuangView.h"
#import "JHPickView.h"
#import "AppDelegate.h"
#import "LoginOneViewController.h"
#import "YunWeiListModel.h"
@interface BaoJingLishiYunweiListViewController ()<TableButDelegate,UIScrollViewDelegate,ShaiXuanDelegate,JHPickerDelegate>
@property (nonatomic,strong)UILabel *yearLabel;
@property (nonatomic,strong)UIScrollView *bgscrollview;
@property (nonatomic,strong)JHTableChart *table1;
@property (nonatomic,strong)JHTableChart *table11;
@property (nonatomic,strong)ShaiXuanKuangView *shaixuanView;
@property (nonatomic,assign)NSInteger select;
@property (nonatomic,copy)NSString *selectID;
@property (nonatomic,copy)NSString *gongsiName;
@property (nonatomic,strong)UILabel *toplabel;
@property (nonatomic,strong)UIImageView *biaogeBg;
@property (nonatomic,copy)NSString *selectBid;
@property (nonatomic,strong)YunWeiListModel *Datamodel;
@property (nonatomic,strong)NSMutableArray *modelArr;
@end

@implementation BaoJingLishiYunweiListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报警电站";
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
    self.yearLabel.text = @"2017";
    self.yearLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgscrollview addSubview:self.yearLabel];
    
    UIButton *leftDownBtn = [[UIButton alloc] initWithFrame:CGRectMake(KWidth/2-90, 15, 60, 34)];
    [leftDownBtn addTarget:self action:@selector(leftDownBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgscrollview addSubview:leftDownBtn];
    
    UIButton *rightDownBtn = [[UIButton alloc] initWithFrame:CGRectMake(KWidth/2+30, 15, 60, 34)];
    [rightDownBtn addTarget:self action:@selector(rightDownBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgscrollview addSubview:rightDownBtn];
    
//    [self setTabel];
    [self requestData];
}

- (void)setTabel{
    UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 66, 12, 17)];
    leftImg.image = [UIImage imageNamed:@"定位"];
    [self.bgscrollview addSubview:leftImg];
    
//    UILabel *toplabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 64, KWidth-70, 24)];
//    toplabel.font = [UIFont systemFontOfSize:14];
//    toplabel.textColor = [UIColor darkGrayColor];
//    toplabel.text = @"xx公司(分公司) 运维小组1 周巷镇 共9条";
//    [self.bgscrollview addSubview:toplabel];
    if (self.toplabel) {
        
        self.toplabel.text = [NSString stringWithFormat:@"%@(分公司)%@ 共%ld条",self.fengongsi,self.yunwei,self.modelArr.count];
    }else{
        self.toplabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 64, KWidth-70, 24)];
        self.toplabel.font = [UIFont systemFontOfSize:15];
        self.toplabel.textColor = [UIColor darkGrayColor];
        //    self.toplabel.text = @"分公司一 共90条";
        self.toplabel.text = [NSString stringWithFormat:@"%@(分公司)%@ 共%ld条",self.fengongsi,self.yunwei,self.modelArr.count];
        [self.bgscrollview addSubview:self.toplabel];
    }
//    UIButton *shaixuanBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(KWidth-90, 64, 80, 30)];
//    [shaixuanBtn1 setImage:[UIImage imageNamed:@"筛选"] forState:UIControlStateNormal];
//    [shaixuanBtn1 addTarget:self action:@selector(shaixuanBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.bgscrollview addSubview:shaixuanBtn1];
    if (self.modelArr.count<10) {
        if (self.modelArr.count==0) {
            self.biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 95, KWidth-20, self.modelArr.count*40+35)];
            self.biaogeBg.image = [UIImage imageNamed:@"表格bg"];
            [self.bgscrollview addSubview:self.biaogeBg];
        }else{
            self.biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 95, KWidth-20, self.modelArr.count*40+33)];
            self.biaogeBg.image = [UIImage imageNamed:@"表格bg"];
            [self.bgscrollview addSubview:self.biaogeBg];
        }
    }else{
        self.biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 95, KWidth-20, 400)];
        self.biaogeBg.image = [UIImage imageNamed:@"表格bg"];
        [self.bgscrollview addSubview:self.biaogeBg];
    }
    
    
    UIView *fourTable = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 95, KWidth, 400)];
    //    fourTable.bounces = NO;
    [self.bgscrollview addSubview:fourTable];
    
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
    
    
    self.table1.colWidthArr = @[@30.0,@40.0,@90.0,@90.0,@50.0];
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
    self.table11.colWidthArr = @[@30.0,@40.0,@90.0,@90.0,@50.0];
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
    oneTable1.contentSize = CGSizeMake(KWidth, 360);
    self.table11.frame = CGRectMake(0, 0, KWidth, [self.table11 heightFromThisDataSource]);
    
}

- (void)leftDownBtnClick{
    NSString *str = self.yearLabel.text;
    NSInteger strNum = [str integerValue];
    NSInteger strNum1 =strNum-1;
    self.yearLabel.text = [NSString stringWithFormat:@"%ld",strNum1];
    [self.table1 removeFromSuperview];
    [self.table11 removeFromSuperview];
    [self.biaogeBg removeFromSuperview];
    [self requestData];
}

- (void)rightDownBtnClick{
    NSString *str = self.yearLabel.text;
    NSInteger strNum = [str integerValue];
    NSInteger strNum1 =strNum+1;
    self.yearLabel.text = [NSString stringWithFormat:@"%ld",strNum1];
    [self.table1 removeFromSuperview];
    [self.table11 removeFromSuperview];
    [self.biaogeBg removeFromSuperview];
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
#pragma mark - JHPickerDelegate

-(void)PickerSelectorIndixString:(NSString *)str:(NSInteger)row
{
    
    if (self.select ==0) {
        [self.shaixuanView.dizhiBtn setTitle:str forState:UIControlStateNormal];
    }else{
        [self.shaixuanView.guzhangBtn setTitle:str forState:UIControlStateNormal];
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
    [parameters setValue:self.yearLabel.text forKey:@"year"];
//    [parameters setValue:@"handle" forKey:@"type"];
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
            [self setTabel];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}
-(NSMutableArray *)modelArr{
    if (!_modelArr) {
        _modelArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return  _modelArr;
}
-(YunWeiListModel *)Datamodel{
    if (!_Datamodel) {
        _Datamodel = [[YunWeiListModel alloc] init];
    }
    return _Datamodel;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
