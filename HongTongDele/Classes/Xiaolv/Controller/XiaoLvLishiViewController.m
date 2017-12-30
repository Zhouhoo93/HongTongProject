//
//  XiaoLvLishiViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/12/1.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "XiaoLvLishiViewController.h"
#import "JHTableChart.h"
#import "XiaoLvLiShiYunweiViewController.h"
#import "JHPickView.h"
#import "XiaolvFengongsiListModel.h"
#import "LoginOneViewController.h"
#import "AppDelegate.h"
#import "XiaoLvWorkListModel.h"
@interface XiaoLvLishiViewController ()<UIScrollViewDelegate,TableButDelegate,JHPickerDelegate>
@property (nonatomic,strong)UILabel *yearLabel;
@property (nonatomic,strong)UIScrollView *bgscrollview;
@property (nonatomic,strong)JHTableChart *table1;
@property (nonatomic,strong)JHTableChart *table11;
@property (nonatomic,strong)JHTableChart *table2;
@property (nonatomic,strong)JHTableChart *table22;
@property (nonatomic,strong)NSMutableArray *listArr;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableArray *dataArr1;
@property (nonatomic,strong)XiaolvFengongsiListModel *listModel;
@property (nonatomic,strong)XiaoLvWorkListModel *workModel;
@property (nonatomic,copy)NSString *selectID;
@property (nonatomic,copy)NSString *selectName;
@property (nonatomic,strong)UILabel *toplabel1;
@property (nonatomic,strong)UILabel *toplabel;
@property (nonatomic,strong) UIImageView *biaogeBg;
@property (nonatomic,strong) UIImageView *biaogeBg1;
@end

@implementation XiaoLvLishiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发电效率异常电站列表";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self setTopBtn];
    // Do any additional setup after loading the view.
}

- (void)setTopBtn{
    self.bgscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight)];
    self.bgscrollview.delegate = self;
    self.bgscrollview.backgroundColor = [UIColor clearColor];
    self.bgscrollview.pagingEnabled = NO;
    self.bgscrollview.contentSize = CGSizeMake(KWidth, 950);
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
    
    [self requestfengongsi];
    
//    [self setTabel];
}
-(void)requestfengongsi{
    NSString *URL = [NSString stringWithFormat:@"%@/abnormal/info",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
//    [parameters setValue:@"Handle" forKey:@"type"];
    [parameters setValue:self.yearLabel.text forKey:@"year"];
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取分公司列表正确%@",responseObject);
        
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
                _listModel = [[XiaolvFengongsiListModel alloc] initWithDictionary:dic];
                [self.listArr addObject:_listModel];
            }
            NSString *str = [NSString stringWithFormat:@"%@",self.companyID];
            if (str.length>0) {
                self.selectID = self.companyID;
                self.selectName = self.name;
            }else{
                _listModel = _listArr[0];
                self.selectID = _listModel.company_id;
                self.selectName = _listModel.name;
            }
//            _listModel = _listArr[0];
//            self.selectID = _listModel.company_id;
//            self.selectName = _listModel.name;
            //            [self setLeftTable];
            //            [self setRightTable];
            [self requestList];
        
            //            [self performSelector:@selector(requestList) withObject:nil afterDelay:1.0f];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}


- (void)leftDownBtnClick{
    NSString *str = self.yearLabel.text;
    NSInteger strNum = [str integerValue];
    NSInteger strNum1 =strNum-1;
    self.yearLabel.text = [NSString stringWithFormat:@"%ld",strNum1];
    [self.table1 removeFromSuperview];
    [self.table11 removeFromSuperview];
    [self.biaogeBg removeFromSuperview];
    [self requestList];
}

- (void)rightDownBtnClick{
    NSString *str = self.yearLabel.text;
    NSInteger strNum = [str integerValue];
    NSInteger strNum1 =strNum+1;
    self.yearLabel.text = [NSString stringWithFormat:@"%ld",strNum1];
    [self.table1 removeFromSuperview];
    [self.table11 removeFromSuperview];
    [self.biaogeBg removeFromSuperview];
    [self requestList];
}

- (void)setTabel{
    UIImageView *topTable = [[UIImageView alloc] initWithFrame:CGRectMake(15, 67, KWidth-100, 30)];
    topTable.userInteractionEnabled = YES;
    topTable.image = [UIImage imageNamed:@"发电bgt"];
    [self.bgscrollview addSubview:topTable];
    
    UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 4, 12, 17)];
    leftImg.image = [UIImage imageNamed:@"tbx"];
    [topTable addSubview:leftImg];
    
    self.toplabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 2, KWidth-70, 24)];
    self.toplabel.font = [UIFont systemFontOfSize:15];
    self.toplabel.textColor = [UIColor darkGrayColor];
    //    self.toplabel.text = @"分公司一:20户 平均降效比:30%";
    self.toplabel.text = [NSString stringWithFormat:@"%@:%ld户 平均降效:30%%",_selectName,self.dataArr.count];
    [topTable addSubview:self.toplabel];
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, KWidth-100, 30)];
    [leftBtn addTarget:self action:@selector(leftTitleClick) forControlEvents:UIControlEventTouchUpInside];
    [topTable addSubview:leftBtn];
    
    if (self.dataArr.count<10) {
        if (self.dataArr.count==0) {
            self.biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 95, KWidth-20, self.dataArr.count*40+35)];
            self.biaogeBg.image = [UIImage imageNamed:@"表格bg"];
            [self.bgscrollview addSubview:self.biaogeBg];
        }else{
            self.biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 95, KWidth-20, self.dataArr.count*40+33)];
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
    self.table1.colTitleArr = @[@"类别|序号",@"运维小组",@"管辖区域",@"容量(kW)",@"降效(%)"];
    
    
    self.table1.colWidthArr = @[@30.0,@80.0,@120.0,@60.0,@60.0];
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
    if (self.dataArr.count>0) {
        _workModel = _dataArr[0];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_workModel.work_id]];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_workModel.work_name]];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_workModel.town_name]];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_workModel.brand_specification]];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_workModel.reduce_effect]];
    }
    self.table11.colTitleArr = tipArr;
    //        self.table44.colWidthArr = colWid;
    self.table11.colWidthArr = @[@30.0,@80.0,@120.0,@60.0,@60.0];
    self.table11.bodyTextColor = [UIColor blackColor];
    self.table11.minHeightItems = 36;
    self.table11.lineColor = [UIColor lightGrayColor];
    self.table11.backgroundColor = [UIColor clearColor];
    
    NSMutableArray *newArr1 = [[NSMutableArray alloc] init];
    for (int i=0; i<_dataArr.count; i++) {
        if (i>0) {
            NSMutableArray *newArr = [[NSMutableArray alloc] init];
            [newArr removeAllObjects];
            _workModel = _dataArr[i];
            [newArr addObject:[NSString stringWithFormat:@"%@",_workModel.work_id]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_workModel.work_name]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_workModel.town_name]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_workModel.brand_specification]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_workModel.reduce_effect]];
            [newArr1 addObject:newArr];
        }
        
    }
    self.table11.dataArr = newArr1;
    [self.table11 showAnimation];
    [oneTable1 addSubview:self.table11];
    oneTable1.contentSize = CGSizeMake(KWidth, 360);
    self.table11.frame = CGRectMake(0, 0, KWidth, [self.table11 heightFromThisDataSource]);
    
    
}
- (void)leftTitleClick{
    NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<_listArr.count; i++) {
        _listModel = _listArr[i];
        [list addObject:_listModel.name];
    }
    JHPickView *picker = [[JHPickView alloc]initWithFrame:self.view.bounds];
    picker.classArr = list;
    picker.delegate = self ;
    picker.arrayType = weightArray;
    [self.view addSubview:picker];
}
-(void)PickerSelectorIndixString:(NSString *)str:(NSInteger)row
{
    for (int i=0; i<_listArr.count; i++) {
        _listModel = _listArr[i];
        if ([str isEqualToString:_listModel.name]) {
            self.selectID = _listModel.company_id;
            self.selectName = str;
        }
    }
    [self.table1 removeFromSuperview];
    [self.table11 removeFromSuperview];

    [self.biaogeBg removeFromSuperview];
    [self.toplabel removeFromSuperview];
    [self.dataArr removeAllObjects];
    [self requestList];
   
    NSLog(@"%@,%ld",str,row);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)transButIndex:(NSInteger)index
{
    NSLog(@"代理方法%ld",index);
     _workModel = _dataArr[index];
    //    self.navigationController.navigationBar.hidden = NO;
    XiaoLvLiShiYunweiViewController *vc = [[XiaoLvLiShiYunweiViewController alloc] init];
    vc.workID = _workModel.work_id;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)requestList{
    NSString *selectID = [NSString stringWithFormat:@"%@",self.selectID];
    NSString *str = [NSString stringWithFormat:@"%@",self.companyID];
    if (![str isEqualToString:@"(null)"]) {
        self.selectID = self.companyID;
        self.selectName = self.name;
    }else{
        _listModel = _listArr[0];
        self.selectID = [NSString stringWithFormat:@"%@",_listModel.company_id];
        self.selectName = [NSString stringWithFormat:@"%@",_listModel.name];
    }
    
    NSString *URL = [NSString stringWithFormat:@"%@/abnormal/company",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.selectID forKey:@"id"];
    [parameters setValue:self.yearLabel.text forKey:@"year"];
    NSLog(@"parameters:%@",parameters);
    //type:值(handle 和  inhandle)
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取分公司数据正确%@",responseObject);
        
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
            [_dataArr removeAllObjects];
            for (NSMutableDictionary *dic in responseObject[@"content"]) {
                _workModel = [[XiaoLvWorkListModel alloc] initWithDictionary:dic];
                [self.dataArr addObject:_workModel];
            }
            //            [self setTabel];
            [self setTabel];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}




-(NSMutableArray *)listArr {
    if (!_listArr) {
        _listArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _listArr;
}
-(XiaolvFengongsiListModel *)listModel{
    if (!_listModel) {
        _listModel = [[XiaolvFengongsiListModel alloc] init];
    }
    return _listModel;
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
-(XiaoLvWorkListModel *)workModel {
    if (!_workModel) {
        _workModel = [[XiaoLvWorkListModel alloc] init];
    }
    return _workModel;
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return  _dataArr;
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
