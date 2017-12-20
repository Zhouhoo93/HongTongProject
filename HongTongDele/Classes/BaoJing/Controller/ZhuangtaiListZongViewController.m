//
//  ZhuangtaiListZongViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/11/20.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "ZhuangtaiListZongViewController.h"
#import "JHTableChart.h"
#import "ZhuangTaiListViewController.h"
#import "LoginOneViewController.h"
#import "AppDelegate.h"
#import "BaoJingZhuangTaiModel.h"
@interface ZhuangtaiListZongViewController ()<TableButDelegate>
@property (nonatomic,strong)JHTableChart *table;
@property (nonatomic,strong)JHTableChart *table1;
@property (nonatomic,strong)BaoJingZhuangTaiModel *model;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)UIImageView *biaogeBg;
@end

@implementation ZhuangtaiListZongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self requestData];
//    [self setTabel];
    // Do any additional setup after loading the view.
}
- (void)setTabel{
    if (self.dataArr.count<10) {
        self.biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 110, KWidth-20, self.dataArr.count*40+33)];
        self.biaogeBg.image = [UIImage imageNamed:@"表格bg"];
        [self.view addSubview:self.biaogeBg];
    }else{
        self.biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 110, KWidth-20, 400)];
        self.biaogeBg.image = [UIImage imageNamed:@"表格bg"];
        [self.view addSubview:self.biaogeBg];
    }
    
    
    UIView *fourTable = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 110, KWidth, 400)];
    //    fourTable.bounces = NO;
    [self.view addSubview:fourTable];
    
    self.table = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 400)];
    self.table.delegate = self;
    self.table.typeCount = 88;
    self.table.small = YES;
    self.table.isblue = NO;
    self.table.bodyTextColor = [UIColor blackColor];
    self.table.tableTitleFont = [UIFont systemFontOfSize:14];
    //    table.xDescTextFontSize =  (CGFloat)13;
    //    table.yDescTextFontSize =  (CGFloat)13;
    self.table.colTitleArr = @[@"类别|序号",@"运维小组",@"离线(户)",@"异常(户)",@"故障(户)"];
    
    
    self.table.colWidthArr = @[@30.0,@80.0,@80.0,@80.0,@80.0];
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
    oneTable1.frame = CGRectMake(0, 146, KWidth, 364);
    oneTable1.bounces = NO;
    [self.view addSubview:oneTable1];
    self.table1 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 364)];
    self.table1.typeCount = 88;
    self.table1.isblue = NO;
    self.table1.delegate = self;
    self.table1.tableTitleFont = [UIFont systemFontOfSize:14];
    
    NSMutableArray *tipArr = [[NSMutableArray alloc] init];
    _model = _dataArr[0];
    [tipArr addObject:[NSString stringWithFormat:@"%@",_model.company_id]];
    [tipArr addObject:[NSString stringWithFormat:@"%@",_model.name]];
    [tipArr addObject:[NSString stringWithFormat:@"%@",_model.offlineTotal]];
    [tipArr addObject:[NSString stringWithFormat:@"%@",_model.abnormalTotal]];
    [tipArr addObject:[NSString stringWithFormat:@"%@",_model.faultTotal]];
    self.table1.colTitleArr = tipArr;
    //        self.table44.colWidthArr = colWid;
    self.table1.colWidthArr = @[@30.0,@80.0,@80.0,@80.0,@80.0];
    self.table1.bodyTextColor = [UIColor blackColor];
    self.table1.minHeightItems = 36;
    self.table1.lineColor = [UIColor lightGrayColor];
    self.table1.backgroundColor = [UIColor clearColor];
    
    NSMutableArray *newArr = [[NSMutableArray alloc] init];
    NSMutableArray *newArr1 = [[NSMutableArray alloc] init];
    for (int i=0; i<_dataArr.count; i++) {
        if (i>0) {
            _model = _dataArr[i];
            [newArr addObject: [NSString stringWithFormat:@"%@",_model.company_id]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_model.name]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_model.offlineTotal]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_model.abnormalTotal]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_model.faultTotal]];
            [newArr1 addObject:newArr];
        }
        
    }
    self.table1.dataArr = newArr1;
    
    [self.table1 showAnimation];
    [oneTable1 addSubview:self.table1];
    oneTable1.contentSize = CGSizeMake(KWidth, 360);
    self.table1.frame = CGRectMake(0, 0, KWidth, [self.table1 heightFromThisDataSource]);
}
//执行协议方法
- (void)transButIndex:(NSInteger)index
{
    NSLog(@"代理方法%ld",index);
        ZhuangTaiListViewController *vc = [[ZhuangTaiListViewController alloc] init];
        _model = self.dataArr[index];
        vc.name = _model.name;
        vc.companyID = _model.company_id;
        [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)requestData{
    NSString *URL = [NSString stringWithFormat:@"%@/police/status",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取总公司状态正确%@",responseObject);
        
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
