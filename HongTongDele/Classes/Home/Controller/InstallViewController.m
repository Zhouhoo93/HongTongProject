//
//  InstallViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/8/4.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "InstallViewController.h"
#import "HomeSelectViewController.h"
#import "InstallTableViewCell.h"
#import "AppDelegate.h"
#import "LoginOneViewController.h"
#import "InstallModel.h"
#import "InstallStationViewController.h"
@interface InstallViewController ()<ChangeName,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,strong) UIButton *selectBtn2;
@property (nonatomic,strong) UIButton *selectBtn3;
@property (nonatomic,strong) UIButton *selectBtn4;
@property (nonatomic,strong) UIButton *selectBtn5;
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong)InstallModel *model;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableArray *provinceArr;
@property (nonatomic,strong)NSMutableArray *cityArr;
@property (nonatomic,strong)NSMutableArray *townArr;
@property (nonatomic,strong)NSMutableArray *addressArr;
@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *town;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *grade;
@end

@implementation InstallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.grade = @"province";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self SetSelectBtn];
    [self setTable];
    [self requestData];
    [self requestShaiXuanData];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)SetSelectBtn{
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 128)];
    bgImage.image = [UIImage imageNamed:@"形状-3"];
    bgImage.userInteractionEnabled = YES;
    [self.view addSubview:bgImage];
    
    UIImageView *backButtonImg = [[UIImageView alloc] initWithFrame:CGRectMake(30, 35, 10, 18)];
    backButtonImg.userInteractionEnabled = YES;
    backButtonImg.image = [UIImage imageNamed:@"ab_ic_back"];
    [bgImage addSubview:backButtonImg];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    [backButton addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgImage addSubview:backButton];
    
    for (int i=0; i<5; i++) {
        if (i==0) {
            UIButton *addressBtn = [[UIButton alloc] initWithFrame:CGRectMake(16*(i+1)+(KWidth-100)/5*i, 80, (KWidth-100)/5, 24)];
            addressBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [addressBtn setTitleColor:[UIColor blackColor] forState:0];
            [addressBtn setBackgroundImage:[UIImage imageNamed:@"形状-5-拷贝"] forState:0];
            [addressBtn setTitle:@"全部" forState:0];
            addressBtn.tag = 10000;
            [addressBtn addTarget:self action:@selector(selctBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bgImage addSubview:addressBtn];
        }else if (i==1){
            self.selectBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(16*(i+1)+(KWidth-100)/5*i, 80, (KWidth-100)/5, 24)];
            self.selectBtn2.titleLabel.font = [UIFont systemFontOfSize:13];
            [self.selectBtn2 setTitleColor:[UIColor blackColor] forState:0];
            [self.selectBtn2 setBackgroundImage:[UIImage imageNamed:@"形状-5-拷贝"] forState:0];
            [self.selectBtn2 setTitle:@"" forState:0];
            self.selectBtn2.tag = 10001;
            [self.selectBtn2 addTarget:self action:@selector(selctBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bgImage addSubview:self.selectBtn2];
        }else if (i==2){
            self.selectBtn3 = [[UIButton alloc] initWithFrame:CGRectMake(16*(i+1)+(KWidth-100)/5*i, 80, (KWidth-100)/5, 24)];
            self.selectBtn3.titleLabel.font = [UIFont systemFontOfSize:13];
            [self.selectBtn3 setTitleColor:[UIColor blackColor] forState:0];
            [self.selectBtn3 setBackgroundImage:[UIImage imageNamed:@"形状-5-拷贝"] forState:0];
            [self.selectBtn3 setTitle:@"" forState:0];
            self.selectBtn3.tag = 10002;
            [self.selectBtn3 addTarget:self action:@selector(selctBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bgImage addSubview:self.selectBtn3];
        }else if(i==3){
            self.selectBtn4 = [[UIButton alloc] initWithFrame:CGRectMake(16*(i+1)+(KWidth-100)/5*i, 80, (KWidth-100)/5, 24)];
            self.selectBtn4.titleLabel.font = [UIFont systemFontOfSize:13];
            [self.selectBtn4 setTitleColor:[UIColor blackColor] forState:0];
            [self.selectBtn4 setBackgroundImage:[UIImage imageNamed:@"形状-5-拷贝"] forState:0];
            [self.selectBtn4 setTitle:@"" forState:0];
            self.selectBtn4.tag = 10003;
            [self.selectBtn4 addTarget:self action:@selector(selctBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bgImage addSubview:self.selectBtn4];
        }else{
            self.selectBtn5 = [[UIButton alloc] initWithFrame:CGRectMake(16*(i+1)+(KWidth-100)/5*i, 80, (KWidth-100)/5, 24)];
            self.selectBtn5.titleLabel.font = [UIFont systemFontOfSize:13];
            [self.selectBtn5 setTitleColor:[UIColor blackColor] forState:0];
            [self.selectBtn5 setBackgroundImage:[UIImage imageNamed:@"形状-5-拷贝"] forState:0];
            [self.selectBtn5 setTitle:@"" forState:0];
            self.selectBtn5.tag = 10004;
            [self.selectBtn5 addTarget:self action:@selector(selctBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bgImage addSubview:self.selectBtn5];
        }
        
    }
    
}

- (void)selctBtnClick:(UIButton *)sender{
    if(sender.tag!=10000){
        
        HomeSelectViewController *vc = [[HomeSelectViewController alloc] init];
        if (sender.tag == 10001) {
            self.selectIndex  = 1;
            //            vc.dataArr = @[@"浙江省",@"河南省",@"江西省",@"河北省",@"山东省",@"福建省"];
            vc.dataArr = self.provinceArr;
        }else if (sender.tag == 10002) {
            self.selectIndex  = 2;
            //            vc.dataArr = @[@"杭州江干",@"杭州下城",@"杭州拱墅",@"杭州滨江",@"杭州萧山",@"杭州西湖"];
            vc.dataArr = self.cityArr;
        }else if (sender.tag == 10003) {
            self.selectIndex  = 3;
            //            vc.dataArr = @[@"白杨街道",@"下沙街道",@"啊啊街道",@"啊啊街道",@"啊啊街道",@"没有街道"];
            vc.dataArr = self.townArr;
        }else {
            self.selectIndex = 4;
            vc.dataArr = self.addressArr;
        }
        vc.hidesBottomBarWhenPushed = YES;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        self.selectBtn3.titleLabel.text = @"";
        self.selectBtn4.titleLabel.text = @"";
        self.selectBtn5.titleLabel.text = @"";
        self.city = @"";
        self.town = @"";
        self.address = @"";
        [self.cityArr removeAllObjects];
        [self.townArr removeAllObjects];
        [self.addressArr removeAllObjects];
    }
}
//协议要实现的方法
-(void)changeName:(NSString *)string
{
    if(self.selectIndex==1){
        [self.selectBtn2 setTitle:string forState:0];
        self.grade = @"city";
        self.province = string;
        [self requestShaiXuanData];
    }else if(self.selectIndex==2){
        [self.selectBtn3 setTitle:string forState:0];
        self.grade = @"town";
        self.city = string;
        [self requestShaiXuanData];
    }else if (self.selectIndex ==3){
        [self.selectBtn4 setTitle:string forState:0];
        self.town = string;
        self.grade = @"address";
        [self requestShaiXuanData];
    }else if (self.selectIndex ==4){
        self.address = string;
        [self.selectBtn5 setTitle:string forState:0];
        self.grade = @"province";
        //        [self requestShaiXuanData];
    }}

- (void)setTable{
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 120, KWidth, 340)];
    bgImage.userInteractionEnabled = YES;
    bgImage.image = [UIImage imageNamed:@"首页背景框"];
    [self.view addSubview:bgImage];
    
    UIView *titleHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 44)];
    titleHeaderView.backgroundColor = [UIColor clearColor];
    [bgImage addSubview:titleHeaderView];
    
    for (int i=0; i<3; i++) {
        UILabel *title = [[UILabel alloc] init];
        if (i==0) {
            title.frame = CGRectMake(20, 25, 50, 24);
            title.text = @"户号";
        }else if(i==1){
            title.frame = CGRectMake(KWidth/2-25, 25, 50, 24);
            //            title.textAlignment = NSTextAlignmentCenter;
            title.text = @"地址";
        }else if(i==2){
            title.frame = CGRectMake(KWidth-100, 25, 80, 24);
            title.text = @"装机量(kW)";
        }
        title.font = [UIFont systemFontOfSize:14];
        [titleHeaderView addSubview:title];
    }
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 48, KWidth, 340-68) style:UITableViewStylePlain];
    self.table.backgroundColor = [UIColor clearColor];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.delegate = self;
    self.table.dataSource = self;
    [bgImage addSubview:self.table];
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
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"InstallTableViewCell";
    // 2.从缓存池中取出cell
    InstallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 3.如果缓存池中没有cell
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"InstallTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
        cell.backgroundColor = [UIColor clearColor];
        //        cell.nameLabel.font = [UIFont systemFontOfSize:14];
        _model = _dataArr[indexPath.row];
        cell.houseID.text = _model.house_id;
        cell.address.text = _model.address;
        NSInteger num = [_model.installed_gross_capacity integerValue];
        cell.InstallNum.text = [NSString stringWithFormat:@"%zd",num/1000];
        
    }
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 34;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _model = _dataArr[indexPath.row];
    InstallStationViewController *vc = [[InstallStationViewController alloc] init];
    vc.access_way = _model.access_way;
    vc.house_id = _model.house_id;
    vc.address = _model.address;
    vc.installed_gross_capacity = _model.installed_gross_capacity;
    vc.install_time = _model.install_time;
    vc.use_ele_way = _model.use_ele_way;
    vc.bid = _model.bid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)requestData{
    NSString *URL = [NSString stringWithFormat:@"%@/sites/get-site-list",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取电站信息正确%@",responseObject);
        
        if ([responseObject[@"result"][@"success"] intValue] ==0) {
            NSNumber *code = responseObject[@"result"][@"errorCode"];
            NSString *errorcode = [NSString stringWithFormat:@"%@",code];
            if ([errorcode isEqualToString:@"4100"]||[errorcode isEqualToString:@"3100"])  {
                [MBProgressHUD showText:@"请重新登陆"];
                [self newLogin];
            }else{
                NSString *str = responseObject[@"result"][@"errorMsg"];
                [MBProgressHUD showText:str];
            }
        }else{
            for (NSMutableDictionary *dic in responseObject[@"content"][@"data"]) {
                _model = [[InstallModel alloc] initWithDictionary:dic];
                [self.dataArr addObject:_model];
            }
            if (_dataArr.count<10) {
                self.table.frame = CGRectMake(0, 48, KWidth, 34*_dataArr.count);
            }else{
                self.table.frame = CGRectMake(0, 48, KWidth, 340);
            }
            
            [self.table reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}

- (void)requestShaiXuanData{
    NSString *URL = [NSString stringWithFormat:@"%@/getArea",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.grade forKey:@"grade"];
    if ([self.grade isEqualToString:@"province"]) {
        //        [parameters setValue:self.province forKey:@"province"];
    }else if ([self.grade isEqualToString:@"city"]) {
        [parameters setValue:self.province forKey:@"province"];
    }else if ([self.grade isEqualToString:@"town"]) {
        [parameters setValue:self.city forKey:@"city"];
    }else if ([self.grade isEqualToString:@"address"]) {
        [parameters setValue:self.town forKey:@"town"];
    }
    NSLog(@"%@",parameters);
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"获取地址列表正确%@",responseObject);
        
        if ([responseObject[@"result"][@"success"] intValue] ==0) {
            NSNumber *code = responseObject[@"result"][@"errorCode"];
            NSString *errorcode = [NSString stringWithFormat:@"%@",code];
            if ([errorcode isEqualToString:@"4100"]||[errorcode isEqualToString:@"3100"])  {
                [MBProgressHUD showText:@"请重新登陆"];
                [self newLogin];
            }else{
                NSString *str = responseObject[@"result"][@"errorMsg"];
                [MBProgressHUD showText:str];
            }
        }else{
            if ([self.grade isEqualToString:@"province"]) {
                [self.provinceArr removeAllObjects];
                NSArray *arr = responseObject[@"content"];
                for (int i=0; i<arr.count; i++) {
                    NSString *str = arr[i][@"area"];
                    [self.provinceArr addObject:str];
                }
                if (self.provinceArr.count>0) {
                    [self.selectBtn2 setTitle:self.provinceArr[0] forState:UIControlStateNormal];
                }
                
                //                [self requestShaiXuanData];
                //                _filterController.dataList = [self packageDataList];
            }else if ([self.grade isEqualToString:@"city"]){
                [self.cityArr removeAllObjects];
                NSArray *arr = responseObject[@"content"];
                for (int i=0; i<arr.count; i++) {
                    NSString *str = arr[i][@"area"];
                    [self.cityArr addObject:str];
                }
                if (self.cityArr.count>0) {
                    [self.selectBtn3 setTitle:self.cityArr[0] forState:UIControlStateNormal];
                }
                
                //                [self requestShaiXuanData];
                
                //                _filterController.dataList = [self packageDataList];
            }else if ([self.grade isEqualToString:@"town"]){
                [self.townArr removeAllObjects];
                NSArray *arr = responseObject[@"content"];
                for (int i=0; i<arr.count; i++) {
                    NSString *str = arr[i][@"area"];
                    [self.townArr addObject:str];
                }
                if (self.townArr.count>0) {
                    [self.selectBtn4 setTitle:self.townArr[0] forState:UIControlStateNormal];
                }
                
                //                [self requestShaiXuanData];
                //                _filterController.dataList = [self packageDataList];
            }else if ([self.grade isEqualToString:@"address"]){
                [self.addressArr removeAllObjects];
                NSArray *arr = responseObject[@"content"];
                for (int i=0; i<arr.count; i++) {
                    NSString *str = arr[i][@"area"];
                    [self.addressArr addObject:str];
                }
                if (self.addressArr.count>0) {
                    [self.selectBtn5 setTitle:self.addressArr[0] forState:UIControlStateNormal];
                }
                //                _filterController.dataList = [self packageDataList];
            }
            //            [_filterController.mainTableView reloadData];
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

-(InstallModel *)model{
    if (!_model) {
        _model = [[InstallModel alloc] init];
    }
    return  _model;
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return  _dataArr;
}
-(NSMutableArray *)provinceArr{
    if (!_provinceArr) {
        _provinceArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _provinceArr;
}
-(NSMutableArray *)cityArr{
    if (!_cityArr) {
        _cityArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _cityArr;
}
-(NSMutableArray *)townArr{
    if (!_townArr) {
        _townArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _townArr;
}
-(NSMutableArray *)addressArr{
    if (!_addressArr) {
        _addressArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _addressArr;
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
