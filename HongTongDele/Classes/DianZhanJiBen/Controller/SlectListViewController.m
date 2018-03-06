//
//  SlectListViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/11/13.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "SlectListViewController.h"
#import "JHTableChart.h"
#import "InstallStationViewController.h"
#import "LoginOneViewController.h"
#import "AppDelegate.h"
#import "JHPickView.h"
#import "townListModel.h"
#import "TownDataModel.h"
@interface SlectListViewController ()<TableButDelegate,JHPickerDelegate>
@property (nonatomic,strong)JHTableChart *table;
@property (nonatomic,strong)JHTableChart *table1;
@property (nonatomic,strong)NSMutableArray *towndataArr1;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)TownDataModel *Model;
@property (nonatomic,strong)townListModel *townModel;
@property (nonatomic,strong)UILabel *leftLabel2;
@property (nonatomic,strong)UILabel *downLabel;
@property (nonatomic,copy)NSString *townID;
@property (nonatomic,strong) UIImageView *biaogeBg;
@end

@implementation SlectListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"电站列表";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
   
    [self requestzhen];
    // Do any additional setup after loading the view.
}

- (void)setUI{
    UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 80, 13, 20)];
    leftImg.image = [UIImage imageNamed:@"定位"];
    [self.view addSubview:leftImg];
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 80, 100, 20)];
    leftLabel.text = self.selectName;
    [self.view addSubview:leftLabel];
    
    UIImageView *leftImg1 = [[UIImageView alloc] initWithFrame:CGRectMake(135, 82, 15, 15)];
    leftImg1.image = [UIImage imageNamed:@"分隔号"];
    [self.view addSubview:leftImg1];
    
    UILabel *leftLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(155, 80, 100, 20)];
    leftLabel1.text = self.selectName2;
    [self.view addSubview:leftLabel1];
    
    UIImageView *leftImg2 = [[UIImageView alloc] initWithFrame:CGRectMake(250, 82, 15, 15)];
    leftImg2.image = [UIImage imageNamed:@"分隔号"];
    [self.view addSubview:leftImg2];
    
    self.leftLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(270, 80, 100, 20)];
//    self.leftLabel2.text = @"镇海镇";
    _townModel = _towndataArr1[0];
    self.leftLabel2.text = _townModel.townname;
    [self.view addSubview:self.leftLabel2];
    
    UIButton *zhenBtn = [[UIButton alloc] initWithFrame:CGRectMake(270, 80, 100, 20)];
    [zhenBtn addTarget:self action:@selector(zhenBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zhenBtn];
    
    self.downLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 105, 300, 20)];
    self.downLabel.text = @"装机量:  kW   户数: 户";
    self.downLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.downLabel];
}

- (void)zhenBtnClick{
    JHPickView *picker = [[JHPickView alloc]initWithFrame:self.view.bounds];
    NSMutableArray *townName = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<_towndataArr1.count; i++) {
        self.townModel = _towndataArr1[i];
        [townName addObject:_townModel.townname];
    }
    picker.classArr = townName;
    picker.delegate = self ;
    picker.arrayType = weightArray;
    [self.view addSubview:picker];
}
#pragma mark - JHPickerDelegate

-(void)PickerSelectorIndixString:(NSString *)str:(NSInteger)row
{
    self.leftLabel2.text = str;
    for (int i=0; i<_towndataArr1.count; i++) {
        self.townModel = _towndataArr1[i];
        if ([str isEqualToString:_townModel.townname]) {
            self.townID = _townModel.ID;
        }
    }
    [self.table removeFromSuperview];
    [self.table1 removeFromSuperview];
    [self.biaogeBg removeFromSuperview];
    [self requestData];
}

- (void)setTabel{
    if (self.dataArr.count<10) {
        if (self.dataArr.count==0) {
            self.biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 150, KWidth-20, self.dataArr.count*40+35)];
            self.biaogeBg.image = [UIImage imageNamed:@"表格bg"];
            [self.view addSubview:self.biaogeBg];
        }else{
            self.biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 150, KWidth-20, self.dataArr.count*40+33)];
            self.biaogeBg.image = [UIImage imageNamed:@"表格bg"];
            [self.view addSubview:self.biaogeBg];
        }
    }else{
        self.biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 150, KWidth-20, 400)];
        self.biaogeBg.image = [UIImage imageNamed:@"表格bg"];
        [self.view addSubview:self.biaogeBg];
    }
    
    UIView *fourTable = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 150, KWidth, 400)];
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
    self.table.colTitleArr = @[@"类别|序号",@"户号",@"地址",@"装机容量(kW)",@"已发电量(度)",@"完成率(%)"];

    
    self.table.colWidthArr = @[@30.0,@40.0,@130.0,@50.0,@50.0,@50.0];
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
    oneTable1.frame = CGRectMake(0, 186, KWidth, 364);
    oneTable1.bounces = NO;
    [self.view addSubview:oneTable1];
    self.table1 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 364)];
    self.table1.typeCount = 88;
    self.table1.isblue = NO;
    self.table1.delegate = self;
    self.table1.tableTitleFont = [UIFont systemFontOfSize:14];
    NSMutableArray *tipArr = [[NSMutableArray alloc] init];
    _Model = _dataArr[0];
    [tipArr addObject:[NSString stringWithFormat:@"1"]];
    [tipArr addObject:[NSString stringWithFormat:@"%@",_Model.house_id]];
    [tipArr addObject:[NSString stringWithFormat:@"%@",_Model.address]];
    [tipArr addObject:[NSString stringWithFormat:@"%@",_Model.install_base]];
    [tipArr addObject:[NSString stringWithFormat:@"%@",_Model.gen_cap]];
    [tipArr addObject:[NSString stringWithFormat:@"%@%%",_Model.completion_rate]];
    self.table1.colTitleArr = tipArr;
    //        self.table44.colWidthArr = colWid;
    self.table1.colWidthArr = @[@30.0,@40.0,@130.0,@50.0,@50.0,@50.0];
    self.table1.bodyTextColor = [UIColor blackColor];
    self.table1.minHeightItems = 36;
    self.table1.lineColor = [UIColor lightGrayColor];
    self.table1.backgroundColor = [UIColor clearColor];
    
    
    NSMutableArray *newArr1 = [[NSMutableArray alloc] init];

    for (int i=0; i<_dataArr.count; i++) {
        if (i>0) {
            NSMutableArray *newArr = [[NSMutableArray alloc] init];
            _Model = _dataArr[i];
            [newArr addObject:[NSString stringWithFormat:@"%d",i+1]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_Model.house_id]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_Model.address]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_Model.install_base]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_Model.gen_cap]];
            [newArr addObject:[NSString stringWithFormat:@"%@%%",_Model.completion_rate]];
            [newArr1 addObject:newArr];
        }
        
    }
    NSLog(@"%@",newArr1);
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
    _Model = _dataArr[index];
    InstallStationViewController *vc = [[InstallStationViewController alloc] init];
    vc.bid = _Model.bid;
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)requestData{
    NSString *URL = [NSString stringWithFormat:@"%@/data/get-role-list",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:@"work" forKey:@"role"];
    [parameters setValue:self.townID forKey:@"village_id"];
    NSLog(@"参数:%@",parameters);
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取镇数据正确%@",responseObject);
        
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
            NSString *str = responseObject[@"content"][@"total_install_base"];
            NSString *str1 = responseObject[@"content"][@"total_num"];
            self.downLabel.text = [NSString stringWithFormat:@"装机量:  %@kW  户数: %@户",str,str1];
            [_dataArr removeAllObjects];
            for (NSMutableDictionary *dic in responseObject[@"content"][@"list"]) {
                _Model = [[TownDataModel alloc] initWithDictionary:dic];
                [self.dataArr addObject:_Model];
            }
            [self setTabel];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}

-(void)requestzhen{
    NSString *URL = [NSString stringWithFormat:@"%@/user/gettowninfor",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
//    [parameters setValue:@"work" forKey:@"role"];
    [parameters setValue:self.workID forKey:@"work_id"];
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取镇列表正确%@",responseObject);
        
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
                _townModel = [[townListModel alloc] initWithDictionary:dic];
                [self.towndataArr1 addObject:_townModel];
            }
            _townModel = _towndataArr1[0];
            self.townID = _townModel.ID;
            [self setUI];
            [self requestData];
            //            [self.collectionView reloadData];
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
-(townListModel *)townModel{
    if (!_townModel) {
        _townModel = [[townListModel alloc] init];
    }
    return _townModel;
}
-(NSMutableArray *)towndataArr1{
    if (!_towndataArr1) {
        _towndataArr1 = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _towndataArr1;
}
-(TownDataModel *)Model{
    if (!_Model) {
        _Model = [[TownDataModel alloc] init];
    }
    return _Model;
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
