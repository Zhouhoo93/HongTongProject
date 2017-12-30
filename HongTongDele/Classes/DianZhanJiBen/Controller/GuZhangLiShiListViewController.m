//
//  GuZhangLiShiListViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/11/20.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "GuZhangLiShiListViewController.h"
#import "JHTableChart.h"
#import "GuZhangModel.h"
#import "LoginOneViewController.h"
#import "AppDelegate.h"
@interface GuZhangLiShiListViewController ()<TableButDelegate>
@property (nonatomic,strong)JHTableChart *table;
@property (nonatomic,strong)JHTableChart *table1;
@property (nonatomic,strong) UILabel *yearLabel;
@property (nonatomic,strong)UILabel *rightLabel;
@property (nonatomic,strong)GuZhangModel *model;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)UIImageView *biaogeBg;
@end

@implementation GuZhangLiShiListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历年电站故障列表";
    [self setUI];
    [self requestData];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setUI{
//    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(KWidth-110, 78, 100, 34)];
//    [rightBtn setImage:[UIImage imageNamed:@"历史报警2"] forState:UIControlStateNormal];
//    [self.view addSubview:rightBtn];
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 84, KWidth-100, 34)];
    leftLabel.text = [NSString stringWithFormat:@"户号: %@",self.huhao];
    leftLabel.numberOfLines = 0;
    leftLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:leftLabel];
    
    UILabel *leftLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 114, KWidth-100, 34)];
    leftLabel1.text = [NSString stringWithFormat:@"地址: %@",self.address];
    leftLabel1.font = [UIFont systemFontOfSize:16];
    leftLabel1.numberOfLines = 0;
    [self.view addSubview:leftLabel1];
    
    UIImageView *rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-160, 155, 24, 24)];
    rightImg.image = [UIImage imageNamed:@"报警数"];
    [self.view addSubview:rightImg];
    
    self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-135, 150, 110, 34)];
    self.rightLabel.font = [UIFont systemFontOfSize:15];
    self.rightLabel.text = [NSString stringWithFormat:@"总报警次数:%ld次",self.dataArr.count];
    [self.view addSubview:self.rightLabel];
    
    UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 150, 180, 34)];
    leftImg.image = [UIImage imageNamed:@"2016"];
    [self.view addSubview:leftImg];
    
    self.yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, 180, 34)];
    self.yearLabel.text = @"2016";
    self.yearLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.yearLabel];
    
    UIButton *leftDownBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 150, 60, 34)];
    [leftDownBtn addTarget:self action:@selector(leftDownBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftDownBtn];
    
    UIButton *rightDownBtn = [[UIButton alloc] initWithFrame:CGRectMake(130, 150, 60, 34)];
    [rightDownBtn addTarget:self action:@selector(rightDownBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightDownBtn];
    
//    [self setTabel];
}

- (void)leftDownBtnClick{
    NSString *str = self.yearLabel.text;
    NSInteger strNum = [str integerValue];
    NSInteger strNum1 =strNum-1;
    self.yearLabel.text = [NSString stringWithFormat:@"%ld",strNum1];
    [self requestData];
}

- (void)rightDownBtnClick{
    NSString *str = self.yearLabel.text;
    NSInteger strNum = [str integerValue];
    NSInteger strNum1 =strNum+1;
    self.yearLabel.text = [NSString stringWithFormat:@"%ld",strNum1];
    [self requestData];
}

- (void)setTabel{
    self.rightLabel.text = [NSString stringWithFormat:@"总报警次数:%ld次",self.dataArr.count];
    if (self.dataArr.count<10) {
        if (self.dataArr.count==0) {
            self.biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 190, KWidth-20, self.dataArr.count*40+35)];
            self.biaogeBg.image = [UIImage imageNamed:@"表格bg"];
            [self.view addSubview:self.biaogeBg];
        }else{
            self.biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 190, KWidth-20, self.dataArr.count*40+33)];
            self.biaogeBg.image = [UIImage imageNamed:@"表格bg"];
            [self.view addSubview:self.biaogeBg];
        }
    }else{
        self.biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 190, KWidth-20, 400)];
        self.biaogeBg.image = [UIImage imageNamed:@"表格bg"];
        [self.view addSubview:self.biaogeBg];
    }
    UIView *fourTable = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 190, KWidth, 400)];
    //    fourTable.bounces = NO;
    [self.view addSubview:fourTable];
    
    self.table = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 400)];
    self.table.small = YES;
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
    oneTable1.frame = CGRectMake(0, 226, KWidth, 364);
    oneTable1.bounces = NO;
    [self.view addSubview:oneTable1];
    self.table1 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 364)];
    self.table1.typeCount = 87;
    self.table1.isblue = NO;
    self.table1.delegate = self;
    self.table1.tableTitleFont = [UIFont systemFontOfSize:14];
    NSMutableArray *tipArr = [[NSMutableArray alloc] initWithCapacity:0];
    if (_dataArr.count>0) {
        _model = _dataArr[0];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_model.ID]];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_model.created_at]];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_model.nature]];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_model.cause]];
        if ([_model.status integerValue]==0) {
            [tipArr addObject:@"未处理"];
        }else if([_model.status integerValue]==1){
            [tipArr addObject:@"处理中"];
        }else{
            [tipArr addObject:@"已处理"];
        }
        [tipArr addObject:[NSString stringWithFormat:@"%@",_model.responseTime]];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_model.handleTime]];
    }
    
    self.table1.colTitleArr = tipArr;
    //        self.table44.colWidthArr = colWid;
    self.table1.colWidthArr = @[@30.0,@40.0,@35.0,@80.0,@50.0,@55.0,@55.0];
    self.table1.bodyTextColor = [UIColor blackColor];
    self.table1.minHeightItems = 36;
    self.table1.lineColor = [UIColor lightGrayColor];
    self.table1.backgroundColor = [UIColor clearColor];
    
    NSMutableArray *newArr1 = [[NSMutableArray alloc] init];
    for (int i=0; i<_dataArr.count; i++) {
        if (i>0) {
            NSMutableArray *newArr = [[NSMutableArray alloc] init];
            [newArr removeAllObjects];
            _model = _dataArr[i];
            [newArr addObject:[NSString stringWithFormat:@"%@",_model.ID]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_model.created_at]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_model.nature]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_model.cause]];
            if ([_model.status integerValue]==0) {
                [newArr addObject:@"未处理"];
            }else if([_model.status integerValue]==1){
                [newArr addObject:@"处理中"];
            }else{
                [newArr addObject:@"已处理"];
            }
            [newArr addObject:[NSString stringWithFormat:@"%@",_model.responseTime]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_model.handleTime]];
            [newArr1 addObject:newArr];
            NSLog(@"newArr :%@   newarr1:%@",newArr,newArr1);
        }
        
    }
    self.table1.dataArr = newArr1;
    [self.table1 showAnimation];
    [oneTable1 addSubview:self.table1];
    oneTable1.contentSize = CGSizeMake(KWidth, 360);
    self.table1.frame = CGRectMake(0, 0, KWidth, [self.table1 heightFromThisDataSource]);
}

-(void)requestData{
    
    NSString *URL = [NSString stringWithFormat:@"%@/police/bidAnyData",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.bid forKey:@"bid"];
    [parameters setValue:self.yearLabel.text forKey:@"year"];
    NSLog(@"参数:%@",parameters);
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"今年电站故障列表正确%@",responseObject);
        
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
            [self.biaogeBg removeFromSuperview];
            [self.table1 removeFromSuperview];
            [self.table removeFromSuperview];
            for (NSMutableDictionary *dic in responseObject[@"content"]) {
                _model = [[GuZhangModel alloc] initWithDictionary:dic];
                [self.dataArr addObject:_model];
            }
            [self setTabel];
            
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
-(GuZhangModel *)model{
    if (!_model) {
        _model = [[GuZhangModel alloc] init];
    }
    return _model;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr;
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
