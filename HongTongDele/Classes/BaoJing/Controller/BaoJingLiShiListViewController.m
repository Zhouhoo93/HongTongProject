//
//  BaoJingLiShiListViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/12/1.
//  Copyright © 2017年 xinyuntec. All rights reserved.
// 报警历史 运维

#import "BaoJingLiShiListViewController.h"
#import "JHTableChart.h"
#import "ShaiXuanYunWeiView.h"
#import "BaoJingLishiYunweiListViewController.h"
#import "JHPickView.h"
#import "FenGongSiListModel.h"
#import "FenGongSiDataModel.h"
#import "AppDelegate.h"
#import "LoginOneViewController.h"
@interface BaoJingLiShiListViewController ()<TableButDelegate,UIScrollViewDelegate,ShaiXuanYunWeiDelegate,JHPickerDelegate>
@property (nonatomic,strong)UILabel *yearLabel;
@property (nonatomic,strong)UIScrollView *bgscrollview;
@property (nonatomic,strong)JHTableChart *table1;
@property (nonatomic,strong)JHTableChart *table11;
@property (nonatomic,strong)JHTableChart *table2;
@property (nonatomic,strong)JHTableChart *table22;
@property (nonatomic,strong)ShaiXuanYunWeiView *shaixuanView;
@property (nonatomic,strong)FenGongSiListModel *model;
@property (nonatomic,strong)FenGongSiDataModel *Datamodel;
@property (nonatomic,strong)NSMutableArray *dataArr;//分公司数组
@property (nonatomic,strong)NSMutableArray *modelArr;
@property (nonatomic,copy)NSString *selectID;
@property (nonatomic,copy)NSString *gongsiName;
@property (nonatomic,strong)UILabel *toplabel;
@property (nonatomic,strong)UIImageView *biaogeBg;
@end

@implementation BaoJingLiShiListViewController

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
    self.bgscrollview.contentSize = CGSizeMake(KWidth, 950);
    [self.view addSubview:self.bgscrollview];
    
    UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth/2-90, 15, 180, 34)];
    leftImg.image = [UIImage imageNamed:@"2016"];
    [self.bgscrollview addSubview:leftImg];
    
    self.yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2-90, 15, 180, 34)];
    self.yearLabel.text = @"2018";
    self.yearLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgscrollview addSubview:self.yearLabel];
    
    UIButton *leftDownBtn = [[UIButton alloc] initWithFrame:CGRectMake(KWidth/2-90, 15, 60, 34)];
    [leftDownBtn addTarget:self action:@selector(leftDownBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgscrollview addSubview:leftDownBtn];
    
    UIButton *rightDownBtn = [[UIButton alloc] initWithFrame:CGRectMake(KWidth/2+30, 15, 60, 34)];
    [rightDownBtn addTarget:self action:@selector(rightDownBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgscrollview addSubview:rightDownBtn];
    [self requestData];
//    [self setTabel];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)diquClick{
    JHPickView *picker = [[JHPickView alloc]initWithFrame:self.view.bounds];
    picker.classArr = @[@"杭州",@"宁波",@"温州"];
    picker.delegate = self ;
    picker.arrayType = weightArray;
    [self.view addSubview:picker];
    //    self.selectedIndexPath = 0;
}

- (void)setTabel{
    UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(25, 56, 12, 17)];
    leftImg.image = [UIImage imageNamed:@"定位"];
    [self.bgscrollview addSubview:leftImg];
    
    if (self.toplabel) {
        
        self.toplabel.text = [NSString stringWithFormat:@"%@ 共%ld条",self.gongsiName,self.modelArr.count];
    }else{
    self.toplabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 54, KWidth-70, 24)];
    self.toplabel.font = [UIFont systemFontOfSize:15];
    self.toplabel.textColor = [UIColor darkGrayColor];
//    self.toplabel.text = @"分公司一 共90条";
    self.toplabel.text = [NSString stringWithFormat:@"%@ 共%ld条",self.gongsiName,self.modelArr.count];
    [self.bgscrollview addSubview:self.toplabel];
    }
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 54, KWidth-70, 24)];
    [leftBtn addTarget:self action:@selector(leftTitleClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgscrollview addSubview:leftBtn];
//    UIButton *shaixuanBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(KWidth-100, 54, 80, 30)];
//    [shaixuanBtn1 setImage:[UIImage imageNamed:@"筛选"] forState:UIControlStateNormal];
//    [shaixuanBtn1 addTarget:self action:@selector(shaixuanBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.bgscrollview addSubview:shaixuanBtn1];
    if (self.modelArr.count<10) {
        if (self.modelArr.count==0) {
            self.biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 85, KWidth-20, self.modelArr.count*40+35)];
            self.biaogeBg.image = [UIImage imageNamed:@"表格bg"];
            [self.bgscrollview addSubview:self.biaogeBg];
        }else{
            self.biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 85, KWidth-20, self.modelArr.count*40+33)];
            self.biaogeBg.image = [UIImage imageNamed:@"表格bg"];
            [self.bgscrollview addSubview:self.biaogeBg];
        }
    }else{
        self.biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 85, KWidth-20, 400)];
        self.biaogeBg.image = [UIImage imageNamed:@"表格bg"];
        [self.bgscrollview addSubview:self.biaogeBg];
    }
    
    
    UIView *fourTable = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 85, KWidth, 400)];
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
    self.table1.colTitleArr = @[@"类别|序号",@"名称",@"管辖范围",@"电站数",@"报警次数"];
    
    
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
    oneTable1.frame = CGRectMake(0, 121, KWidth, 364);
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
        [tipArr addObject:[NSString stringWithFormat:@"1"]];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_Datamodel.work_name]];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_Datamodel.town_name]];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_Datamodel.home]];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_Datamodel.total]];
    }
    self.table11.colTitleArr = tipArr;
    //        self.table44.colWidthArr = colWid;
    self.table11.colWidthArr = @[@30.0,@80.0,@120.0,@60.0,@60.0];
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
            [newArr addObject:[NSString stringWithFormat:@"%d",i+1]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_Datamodel.work_name]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_Datamodel.town_name]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_Datamodel.home]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_Datamodel.total]];
            [newArr1 addObject:newArr];
        }
        
    }
    self.table11.dataArr = newArr1;
    [self.table11 showAnimation];
    [oneTable1 addSubview:self.table11];
    oneTable1.contentSize = CGSizeMake(KWidth, 360);
    self.table11.frame = CGRectMake(0, 0, KWidth, [self.table11 heightFromThisDataSource]);
    
    
}
- (void)shaixuanBtnClick{
    self.shaixuanView = [[[NSBundle mainBundle]loadNibNamed:@"ShaiXuanYunWei" owner:self options:nil]objectAtIndex:0];
    self.shaixuanView.frame = CGRectMake(0, 0, KWidth, KHeight);
    self.shaixuanView.delegate = self;
    [self.view addSubview:self.shaixuanView];
}
- (void)leftTitleClick{
    NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<_dataArr.count; i++) {
        _model = _dataArr[i];
        [list addObject:_model.name];
    }
    JHPickView *picker = [[JHPickView alloc]initWithFrame:self.view.bounds];
    picker.classArr = list;
    picker.delegate = self ;
    picker.arrayType = weightArray;
    [self.view addSubview:picker];
}
-(void)PickerSelectorIndixString:(NSString *)str:(NSInteger)row
{
    for (int i=0; i<_dataArr.count; i++) {
        _model = _dataArr[i];
        if ([str isEqualToString:_model.name]) {
            self.selectID = _model.ID;
            self.gongsiName = _model.name;
        }
    }
    [self.table1 removeFromSuperview];
    [self.table11 removeFromSuperview];
    [self.biaogeBg removeFromSuperview];
//    [self.table3 removeFromSuperview];
//    [self.table33 removeFromSuperview];
//    [self.biaogeBg1 removeFromSuperview];
//    [self.biaogeBg removeFromSuperview];
//    [self.toplabel removeFromSuperview];
//    [self.toplabel1 removeFromSuperview];
//    [self.modelArr removeAllObjects];
//    [self.modelArr1 removeAllObjects];
    [self requestList];
//    [self requestList1];
   
    NSLog(@"%@,%ld",str,row);
    
}
- (void)CloseClick{
    [self.shaixuanView removeFromSuperview];
}

- (void)transButIndex:(NSInteger)index
{
    NSString *select = [NSString stringWithFormat:@"%@",_selectID];
    if (select.length>0) {
        for (int i=0; i<_dataArr.count; i++) {
            _model = _dataArr[i];
            NSString *str = [NSString stringWithFormat:@"%@",_model.ID];
            if ([select  isEqualToString:str]) {
                break;
            }
        }
    }else{
        _model = _dataArr[0];
    }
    _Datamodel = _modelArr[index];
    BaoJingLishiYunweiListViewController *vc = [[BaoJingLishiYunweiListViewController alloc] init];
    vc.workID = _Datamodel.work_id;
    vc.fengongsi = _model.name;
    vc.yunwei = _Datamodel.work_name;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)requestData{
    NSString *URL = [NSString stringWithFormat:@"%@/police/info",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
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
                _model = [[FenGongSiListModel alloc] initWithDictionary:dic];
                [self.dataArr addObject:_model];
            }
            NSString *str = [NSString stringWithFormat:@"%@",self.companyID];
            if (str.length>0) {
                self.selectID = self.companyID;
                self.gongsiName = self.name;
            }else{
                _model = _dataArr[0];
                self.selectID = _model.ID;
                self.gongsiName = _model.name;
            }
//            _model = _dataArr[0];
//            self.selectID = _model.ID;
//            self.gongsiName = _model.name;
            [self requestList];
       
            //            [self performSelector:@selector(requestList) withObject:nil afterDelay:1.0f];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}
-(void)requestList{
    NSString *selectID = [NSString stringWithFormat:@"%@",self.selectID];
    NSString *str = [NSString stringWithFormat:@"%@",self.companyID];
    if (![str isEqualToString:@"(null)"]) {
        self.selectID = self.companyID;
        self.gongsiName = self.name;
    }else{
        _model = _dataArr[0];
        self.selectID = [NSString stringWithFormat:@"%@",_model.ID];
        self.gongsiName = [NSString stringWithFormat:@"%@",_model.name];
    }
    
    NSString *URL = [NSString stringWithFormat:@"%@/police/company/list",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.selectID forKey:@"id"];
//    [parameters setValue:@"handle" forKey:@"type"];
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
            [_modelArr removeAllObjects];
            for (NSMutableDictionary *dic in responseObject[@"content"]) {
                _Datamodel = [[FenGongSiDataModel alloc] initWithDictionary:dic];
                [self.modelArr addObject:_Datamodel];
            }
                        [self setTabel];
//            [self setLeftTable];
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
-(FenGongSiListModel *)model{
    if (!_model) {
        _model = [[FenGongSiListModel alloc] init];
    }
    return _model;
}
-(FenGongSiDataModel *)Datamodel{
    if (!_Datamodel) {
        _Datamodel = [[FenGongSiDataModel alloc] init];
    }
    return _Datamodel;
}
-(NSMutableArray *)modelArr{
    if (!_modelArr) {
        _modelArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return  _modelArr;
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
