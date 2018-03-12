//
//  GuanLiViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/11/29.
//  Copyright © 2017年 xinyuntec. All rights reserve-d.
//

#import "GuanLiViewController.h"
#import "JHTableChart.h"
#import "LoginOneViewController.h"
#import "AppDelegate.h"
#import "GuanliModel.h"
#import "GuanLiFirstModel.h"
@interface GuanLiViewController ()<UIScrollViewDelegate,TableButDelegate>
@property (nonatomic,strong)UIScrollView *bgscrollview;
@property (nonatomic,strong)JHTableChart *table1;
@property (nonatomic,strong)JHTableChart *table11;
@property (nonatomic,strong)JHTableChart *table2;
@property (nonatomic,strong)JHTableChart *table22;
@property (nonatomic,strong)GuanliModel *model;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)GuanLiFirstModel *firstmodel;
@property (nonatomic,strong)NSMutableArray *dataArr1;
@property (nonatomic,strong)UIImageView *biaogeBg1;
@property (nonatomic,strong)UIImageView *biaogeBg2;
@end

@implementation GuanLiViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jinru:) name:@"jinru" object:nil];
}
- (void)jinru:(NSNotification *)text{
    NSLog(@"jinru");
    [self.biaogeBg1 removeFromSuperview];
    [self.biaogeBg2 removeFromSuperview];
    [self.table1 removeFromSuperview];
    [self.table11 removeFromSuperview];
    [self.table2 removeFromSuperview];
    [self.table22 removeFromSuperview];
    [self requestFirstData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设备和运维情况";
    
    self.bgscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, KWidth, KHeight-64)];
    self.bgscrollview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.bgscrollview.delegate = self;
    self.bgscrollview.contentSize = CGSizeMake(KWidth, 900);
    [self.view addSubview:self.bgscrollview];
    
    
    
    [self requestFirstData];
    // Do any additional setup after loading the view.
}

- (void)setTabelChart{
    
    if (self.dataArr1.count<10) {
        if (self.dataArr1.count==0) {
            self.biaogeBg1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, KWidth-20, self.dataArr1.count*40+35)];
            self.biaogeBg1.image = [UIImage imageNamed:@"表格bg"];
            [self.bgscrollview addSubview:self.biaogeBg1];
        }else{
           self.biaogeBg1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, KWidth-20, self.dataArr1.count*40+33)];
            self.biaogeBg1.image = [UIImage imageNamed:@"表格bg"];
            [self.bgscrollview addSubview:self.biaogeBg1];
        }
    }else{
        self.biaogeBg1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, KWidth-20, 400)];
        self.biaogeBg1.image = [UIImage imageNamed:@"表格bg"];
        [self.bgscrollview addSubview:self.biaogeBg1];
    }
    
    UIView *fourTable = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 15, KWidth, 400)];
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
    self.table1.colTitleArr = @[@"类别|名称",@"离线",@"异常",@"故障",@"效率异常"];
    
    
    self.table1.colWidthArr = @[@70.0,@70.0,@70.0,@70.0,@70.0];
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
    oneTable1.frame = CGRectMake(0, 51, KWidth, 364);
    oneTable1.bounces = NO;
    [self.bgscrollview addSubview:oneTable1];
    self.table11 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 364)];
    self.table11.typeCount = 88;
    self.table11.isblue = NO;
    self.table11.delegate = self;
    self.table11.tableTitleFont = [UIFont systemFontOfSize:14];
    NSMutableArray *tipArr = [[NSMutableArray alloc] init];
    _firstmodel = _dataArr1[0];
    [tipArr addObject:[NSString stringWithFormat:@"%@",_firstmodel.name]];
    [tipArr addObject:[NSString stringWithFormat:@"%@",_firstmodel.offlineTotal]];
    [tipArr addObject:[NSString stringWithFormat:@"%@",_firstmodel.abnormalTotal]];
    [tipArr addObject:[NSString stringWithFormat:@"%@",_firstmodel.faultTotal]];
    [tipArr addObject:[NSString stringWithFormat:@"%@",_firstmodel.Total]];
    self.table11.colTitleArr = tipArr;
    //        self.table44.colWidthArr = colWid;
    self.table11.colWidthArr = @[@70.0,@70.0,@70.0,@70.0,@70.0];
    self.table11.bodyTextColor = [UIColor blackColor];
    self.table11.minHeightItems = 36;
    self.table11.lineColor = [UIColor lightGrayColor];
    self.table11.backgroundColor = [UIColor clearColor];
    
    NSMutableArray *newArr = [[NSMutableArray alloc] init];
    NSMutableArray *newArr1 = [[NSMutableArray alloc] init];
    for (int i=0; i<_dataArr1.count; i++) {
        if (i>0) {
            [newArr removeAllObjects];
            _firstmodel = _dataArr1[i];
            [newArr addObject:[NSString stringWithFormat:@"%@",_firstmodel.name]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_firstmodel.offlineTotal]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_firstmodel.abnormalTotal]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_firstmodel.faultTotal]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_firstmodel.Total]];
            [newArr1 addObject:newArr];
        }
        
    }
    self.table11.dataArr = newArr1;
    [self.table11 showAnimation];
    [oneTable1 addSubview:self.table11];
    oneTable1.contentSize = CGSizeMake(KWidth, 360);
    self.table11.frame = CGRectMake(0, 0, KWidth, [self.table11 heightFromThisDataSource]);
    
    
    
    if (self.dataArr.count<10) {
        if (self.dataArr.count==0) {
            self.biaogeBg2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.dataArr1.count*40+35+20, KWidth-20, self.dataArr.count*40+35)];
            self.biaogeBg2.image = [UIImage imageNamed:@"表格bg"];
            [self.bgscrollview addSubview:self.biaogeBg2];
            
        }else{
            self.biaogeBg2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.dataArr1.count*40+33+20, KWidth-20, self.dataArr.count*40+33)];
            self.biaogeBg2.image = [UIImage imageNamed:@"表格bg"];
            [self.bgscrollview addSubview:self.biaogeBg2];
            
        }
    }else{
        
        self.biaogeBg2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 415+20, KWidth-20,440 )];
        self.biaogeBg2.image = [UIImage imageNamed:@"表格bg"];
        [self.bgscrollview addSubview:self.biaogeBg2];
    }
    UIView *fourTable1 = [[UIScrollView alloc] init];
    if (_dataArr.count<10) {
        fourTable1.frame = CGRectMake(0, self.dataArr.count*40+33+20, KWidth, 400);
    }else{
        fourTable1.frame = CGRectMake(0, 435, KWidth, 400);
    }
    //    fourTable.bounces = NO;
    [self.bgscrollview addSubview:fourTable1];
    
    self.table2 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 400)];
    self.table2.delegate = self;
    self.table2.typeCount = 88;
    self.table2.small = YES;
    self.table2.isblue = NO;
    self.table2.bodyTextColor = [UIColor blackColor];
    self.table2.tableTitleFont = [UIFont systemFontOfSize:14];
    //    table.xDescTextFontSize =  (CGFloat)13;
    //    table.yDescTextFontSize =  (CGFloat)13;
    self.table2.colTitleArr = @[@"类别|名称",@"未处理(条)",@"处理中(条)",@"已处理(条)",@"平均响应时间(分钟)",@"平均处理时间(小时)"];
    
    
    self.table2.colWidthArr = @[@55.0,@50.0,@50.0,@50.0,@70.0,@75.0];
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
    [fourTable1 addSubview:self.table2];
    /*        Automatic calculation table height        */
    self.table2.frame = CGRectMake(0, 0, KWidth, [self.table1 heightFromThisDataSource]);
    
    UIScrollView *oneTable2 = [[UIScrollView alloc] init];
    //        if (self.dayFeeArr.count>11) {
    //            oneTable1.frame = CGRectMake(0,KHeight/667*92, k_MainBoundsWidth, KHeight/664*(300));
    //        }else{
    //            oneTable1.frame = CGRectMake(0,KHeight/667*92, k_MainBoundsWidth, KHeight/667*46*self.dayFeeArr.count);

    if (_dataArr.count<10) {
        oneTable2.frame = CGRectMake(0, self.dataArr.count*40+33+20+36, KWidth, 400);
    }else{
        oneTable2.frame = CGRectMake(0, 435+36, KWidth, 400);
    }
    oneTable2.bounces = NO;
    [self.bgscrollview addSubview:oneTable2];
    self.table22 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 364)];
    self.table22.typeCount = 88;
    self.table22.isblue = NO;
    self.table22.delegate = self;
    self.table22.tableTitleFont = [UIFont systemFontOfSize:14];
    NSMutableArray *tipArr1 = [[NSMutableArray alloc] init];
    _model = _dataArr[0];
    [tipArr1 addObject:[NSString stringWithFormat:@"%@",_model.name]];
    [tipArr1 addObject:[NSString stringWithFormat:@"%@",_model.handle]];
    [tipArr1 addObject:[NSString stringWithFormat:@"%@",_model.InHandle]];
    [tipArr1 addObject:[NSString stringWithFormat:@"%@",_model.Handled]];
    [tipArr1 addObject:[NSString stringWithFormat:@"%@",_model.responseAvg]];
    [tipArr1 addObject:[NSString stringWithFormat:@"%@",_model.handleAvg]];
    self.table22.colTitleArr = tipArr1;
    //        self.table44.colWidthArr = colWid;
    self.table22.colWidthArr = @[@55.0,@50.0,@50.0,@50.0,@70.0,@75.0];
    self.table22.bodyTextColor = [UIColor blackColor];
    self.table22.minHeightItems = 36;
    self.table22.lineColor = [UIColor lightGrayColor];
    self.table22.backgroundColor = [UIColor clearColor];
    
    NSMutableArray *newArr2 = [[NSMutableArray alloc] init];
    NSMutableArray *newArr22 = [[NSMutableArray alloc] init];
    for (int i=0; i<_dataArr.count; i++) {
        if (i>0) {
            [newArr2 removeAllObjects];
            _model = _dataArr[i];
            [newArr2 addObject: [NSString stringWithFormat:@"%@",_model.name]];
            [newArr2 addObject:[NSString stringWithFormat:@"%@",_model.handle]];
            [newArr2 addObject:[NSString stringWithFormat:@"%@",_model.InHandle]];
            [newArr2 addObject:[NSString stringWithFormat:@"%@",_model.Handled]];
            [newArr2 addObject:[NSString stringWithFormat:@"%@",_model.responseAvg]];
            [newArr2 addObject:[NSString stringWithFormat:@"%@",_model.handleAvg]];
            [newArr22 addObject:newArr2];
        }
        
    }
    self.table22.dataArr = newArr22;
    [self.table22 showAnimation];
    [oneTable2 addSubview:self.table22];
    oneTable2.contentSize = CGSizeMake(KWidth, 360);
    self.table22.frame = CGRectMake(0, 0, KWidth, [self.table11 heightFromThisDataSource]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)requestData{
    NSString *URL = [NSString stringWithFormat:@"%@/police/manager",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获管理下面列表正确%@",responseObject);
        
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
            [self.dataArr removeAllObjects];
            for (NSMutableDictionary *dic in responseObject[@"content"]) {
                _model = [[GuanliModel alloc] initWithDictionary:dic];
                [self.dataArr addObject:_model];
            }
//            [self setLeftTable];
            [self setTabelChart];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}
-(void)requestFirstData{
    NSString *URL = [NSString stringWithFormat:@"%@/police/faultManager",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获管理下面列表正确%@",responseObject);
        
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
            [self.dataArr1 removeAllObjects];
            for (NSMutableDictionary *dic in responseObject[@"content"]) {
                _firstmodel = [[GuanLiFirstModel alloc] initWithDictionary:dic];
                [self.dataArr1 addObject:_firstmodel];
            }
            //            [self setLeftTable];
            [self requestData];
            
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
-(GuanliModel *)model{
    if (!_model) {
        _model = [[GuanliModel alloc] init];
    }
    return _model;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr;
}
-(GuanLiFirstModel *)firstmodel{
    if (!_firstmodel) {
        _firstmodel = [[GuanLiFirstModel alloc] init];
    }
    return _firstmodel;
}
-(NSMutableArray *)dataArr1{
    if (!_dataArr1) {
        _dataArr1 = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr1;
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
