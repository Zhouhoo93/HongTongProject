//
//  ElectricityViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/8/4.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "ElectricityViewController.h"
#import "CJScroViewBar.h"
#import "SecondTableViewCell.h"
#import "MenuView.h"
#import "LeftMenuViewDemo.h"
#import "AppDelegate.h"
#import "LoginOneViewController.h"
#import "ElectricityModel.h"
#import "MJRefresh.h"
#define Bound_Width  [[UIScreen mainScreen] bounds].size.width
#define Bound_Height [[UIScreen mainScreen] bounds].size.height
// 获得RGB颜色
#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
@interface ElectricityViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,HomeMenuViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *AllView;
@property (nonatomic,strong) UIView *QuanEView;
@property (nonatomic,strong) UIView *YuDianView;
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) UITableView *table1;
@property (nonatomic,strong) UITableView *table2;
@property (nonatomic,strong) CJScroViewBar *scroView;
@property (nonatomic ,strong)MenuView      *menu;
@property (nonatomic,strong)ElectricityModel *model;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)LeftMenuViewDemo *demo;
@property (nonatomic,copy) NSString *timeBtn;
@property (nonatomic,strong) UIButton *timeSelectBtn;
@property (nonatomic,strong) UIButton *timeSelectBtn1;
@property (nonatomic,strong) UIButton *timeSelectBtn2;
@end

@implementation ElectricityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSegmentMenu];
    [self setMenu];
    [self requestData];
    // Do any additional setup after loading the view.
}

- (void)setMenu{
    self.demo = [[LeftMenuViewDemo alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width * 0.2, 20, [[UIScreen mainScreen] bounds].size.width * 0.8, [[UIScreen mainScreen] bounds].size.height-20)];
    self.demo.customDelegate = self;
    
    MenuView *menu = [MenuView MenuViewWithDependencyView:self.view MenuView:self.demo isShowCoverView:YES];
    //    MenuView *menu = [[MenuView alloc]initWithDependencyView:self.view MenuView:demo isShowCoverView:YES];
    self.menu = menu;

}

- (void)createSegmentMenu{
    //数据源
    NSArray *array = @[@"全部",@"全额上网",@"余电上网"];
    
    _scroView = [CJScroViewBar setTabBarPoint:CGPointMake(0, 0)];
    [_scroView setData:array NormalColor
                     :kColor(16, 16, 16) SelectColor
                     :[UIColor whiteColor] Font
                     :[UIFont systemFontOfSize:15]];
    
    
    [self.view addSubview:_scroView];
    
    //设置默认值
    [CJScroViewBar setViewIndex:0];
    
    //TabBar回调
    __weak ElectricityViewController *weakSelf =self;
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
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 50, 40)];
    [leftBtn setImage:[UIImage imageNamed:@"ab_ic_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scroView addSubview:leftBtn];
    
    
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 108, Bound_Width, Bound_Height - 108)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.contentSize = CGSizeMake(array.count*Bound_Width, 0);
    [self.view addSubview:self.scrollView];
    
    for (int i=0; i<array.count; i++) {
        if (i==0) {
            self.AllView = [[UIView alloc]initWithFrame:CGRectMake(i*Bound_Width, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))];
            self.AllView.backgroundColor = [UIColor whiteColor];
            [self.scrollView addSubview:self.AllView];
        }else if (i==1){
            self.QuanEView = [[UIView alloc]initWithFrame:CGRectMake(i*Bound_Width, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))];
            self.QuanEView.backgroundColor = [UIColor whiteColor];
            [self.scrollView addSubview:self.QuanEView];
        }else{
            self.YuDianView = [[UIView alloc]initWithFrame:CGRectMake(i*Bound_Width, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))];
            self.YuDianView.backgroundColor = [UIColor whiteColor];
            [self.scrollView addSubview:self.YuDianView];
        }
        
    }
    [self setTopButton];
    
}

-(void)backBtnClick{
    self.scroView = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setTopButton{
    for (int j=0; j<3; j++) {
        
        for (int i=0; i<3; i++) {
            
            if (i==0) {
                UIButton *topButton = [[UIButton alloc] initWithFrame:CGRectMake((KWidth-270)/4*(i+1)+90*i, 10, 90, 40)];
                [topButton setBackgroundImage:[UIImage imageNamed:@"图层-20"] forState:0];
                [topButton setTitle:@"     排 序" forState:0];
                [topButton setTitleColor:[UIColor whiteColor] forState:0];
                topButton.titleLabel.font = [UIFont systemFontOfSize:14];
                if (j==0) {
                    [self.AllView addSubview:topButton];
                }else if(j==1){
                    [self.QuanEView addSubview:topButton];
                }else{
                    [self.YuDianView addSubview:topButton];
                }

            }else if (i==1){
                if (j==0) {
                    self.timeSelectBtn = [[UIButton alloc] initWithFrame:CGRectMake((KWidth-270)/4*(i+1)+90*i, 10, 90, 40)];
                    [self.timeSelectBtn setBackgroundImage:[UIImage imageNamed:@"图层-21-拷贝"] forState:0];
                    [self.timeSelectBtn setTitle:@"     今 日" forState:0];
                    [self.timeSelectBtn addTarget:self action:@selector(shijianBtnClick) forControlEvents:UIControlEventTouchUpInside];
                    [self.timeSelectBtn setTitleColor:[UIColor whiteColor] forState:0];
                    self.timeSelectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                    if (j==0) {
                        [self.AllView addSubview:self.timeSelectBtn];
                    }else if(j==1){
                        [self.QuanEView addSubview:self.timeSelectBtn];
                    }else{
                        [self.YuDianView addSubview:self.timeSelectBtn];
                    }

                }else if (j==1){
                    self.timeSelectBtn1 = [[UIButton alloc] initWithFrame:CGRectMake((KWidth-270)/4*(i+1)+90*i, 10, 90, 40)];
                    [self.timeSelectBtn1 setBackgroundImage:[UIImage imageNamed:@"图层-21-拷贝"] forState:0];
                    [self.timeSelectBtn1 setTitle:@"     今 日" forState:0];
                    [self.timeSelectBtn1 addTarget:self action:@selector(shijianBtnClick) forControlEvents:UIControlEventTouchUpInside];
                    [self.timeSelectBtn1 setTitleColor:[UIColor whiteColor] forState:0];
                    self.timeSelectBtn1.titleLabel.font = [UIFont systemFontOfSize:14];
                    if (j==0) {
                        [self.AllView addSubview:self.timeSelectBtn1];
                    }else if(j==1){
                        [self.QuanEView addSubview:self.timeSelectBtn1];
                    }else{
                        [self.YuDianView addSubview:self.timeSelectBtn1];
                    }
                }else{
                    self.timeSelectBtn2 = [[UIButton alloc] initWithFrame:CGRectMake((KWidth-270)/4*(i+1)+90*i, 10, 90, 40)];
                    [self.timeSelectBtn2 setBackgroundImage:[UIImage imageNamed:@"图层-21-拷贝"] forState:0];
                    [self.timeSelectBtn2 setTitle:@"     今 日" forState:0];
                    [self.timeSelectBtn2 addTarget:self action:@selector(shijianBtnClick) forControlEvents:UIControlEventTouchUpInside];
                    [self.timeSelectBtn2 setTitleColor:[UIColor whiteColor] forState:0];
                    self.timeSelectBtn2.titleLabel.font = [UIFont systemFontOfSize:14];
                    if (j==0) {
                        [self.AllView addSubview:self.timeSelectBtn2];
                    }else if(j==1){
                        [self.QuanEView addSubview:self.timeSelectBtn2];
                    }else{
                        [self.YuDianView addSubview:self.timeSelectBtn2];
                    }
                }
                
            }else{
                UIButton *topButton = [[UIButton alloc] initWithFrame:CGRectMake((KWidth-270)/4*(i+1)+90*i, 10, 90, 40)];
                [topButton setBackgroundImage:[UIImage imageNamed:@"图层-19"] forState:0];
                [topButton setTitle:@"     筛 选" forState:0];
                [topButton addTarget:self action:@selector(ShaiXuanBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [topButton setTitleColor:[UIColor whiteColor] forState:0];
                topButton.titleLabel.font = [UIFont systemFontOfSize:14];
                if (j==0) {
                    [self.AllView addSubview:topButton];
                }else if(j==1){
                    [self.QuanEView addSubview:topButton];
                }else{
                    [self.YuDianView addSubview:topButton];
                }

            }
        }
    }
    [self setTableView];
}

- (void)ShaiXuanBtnClick{
    [self.menu show];
}

- (void)shijianBtnClick{
    UIActionSheet *actionsheet03 = [[UIActionSheet alloc] initWithTitle:@"选择时间" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"今日", @"本月",@"今年",  nil];
    // 显示
    [actionsheet03 showInView:self.view];

}
// UIActionSheetDelegate实现代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex=%ld", buttonIndex);
    
    
    if (0 == buttonIndex)
    {
        NSLog(@"点击了小戴按钮");
        self.timeBtn = @"今日";
        [self.timeSelectBtn setTitle:@"     今 日" forState:0];
        [self.timeSelectBtn1 setTitle:@"     今 日" forState:0];
        [self.timeSelectBtn2 setTitle:@"     今 日" forState:0];
        [self requestData];
    }
    else if (1 == buttonIndex)
    {
        NSLog(@"点击了中带按钮");
        self.timeBtn = @"本月";
        [self.timeSelectBtn setTitle:@"     本 月" forState:0];
        [self.timeSelectBtn1 setTitle:@"     本 月" forState:0];
        [self.timeSelectBtn2 setTitle:@"     本 月" forState:0];
        [self requestData];
    }
    else if (2 == buttonIndex)
    {
        NSLog(@"点击了大袋按钮");
        self.timeBtn = @"今年";
        [self.timeSelectBtn setTitle:@"     今 年" forState:0];
        [self.timeSelectBtn1 setTitle:@"     今 年" forState:0];
        [self.timeSelectBtn2 setTitle:@"     今 年" forState:0];
        [self requestData];
    }else if (3 == buttonIndex)
    {
        NSLog(@"点击了取消按钮");
    }
    
}


-(void)LeftMenuViewClick:(NSInteger)tag{
    [self.menu hidenWithAnimation];
    NSString *tagstr = [NSString stringWithFormat:@"%d",tag];
    [[[UIAlertView alloc] initWithTitle:@"提示" message:tagstr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
}

- (void)setTableView{
    for (int i=0; i<3; i++) {
        UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, KWidth, 300)];
        bgImage.userInteractionEnabled = YES;
        bgImage.image = [UIImage imageNamed:@"首页背景框"];
        if (i==0) {
            
            NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"TableTipView" owner:nil options:nil];
            UIView *TableTipView = [nibContents lastObject];
            TableTipView.frame = CGRectMake(0, 0, KWidth, 44);
            [bgImage addSubview:TableTipView];
            self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, KWidth, 300-80) style:UITableViewStylePlain];
            self.table.backgroundColor = [UIColor clearColor];
            self.table.delegate = self;
            self.table.dataSource = self;
            self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
            [bgImage addSubview:self.table];
            // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
            // 隐藏时间
            header.lastUpdatedTimeLabel.hidden = YES;
            // 隐藏状态
            //    header.stateLabel.hidden = YES;
            self.table.mj_header = header;
            self.table.mj_header.ignoredScrollViewContentInsetTop = self.table.contentInset.top;
            [self.AllView addSubview:bgImage];
        }else if (i==1){
            
            NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"TableTipView" owner:nil options:nil];
            UIView *TableTipView = [nibContents lastObject];
            TableTipView.frame = CGRectMake(0, 0, KWidth, 44);
            [bgImage addSubview:TableTipView];
            self.table1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, KWidth, 300-80) style:UITableViewStylePlain];
            self.table1.backgroundColor = [UIColor clearColor];
            self.table1.delegate = self;
            self.table1.dataSource = self;
            self.table1.separatorStyle = UITableViewCellSeparatorStyleNone;
            [bgImage addSubview:self.table1];
            // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
            // 隐藏时间
            header.lastUpdatedTimeLabel.hidden = YES;
            // 隐藏状态
            //    header.stateLabel.hidden = YES;
            self.table1.mj_header = header;
            self.table1.mj_header.ignoredScrollViewContentInsetTop = self.table1.contentInset.top;
            [self.QuanEView addSubview:bgImage];
        }else{
            
            NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"TableTipView" owner:nil options:nil];
            UIView *TableTipView = [nibContents lastObject];
            TableTipView.frame = CGRectMake(0, 0, KWidth, 44);
            [bgImage addSubview:TableTipView];
            self.table2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, KWidth, 300-80) style:UITableViewStylePlain];
            self.table2.backgroundColor = [UIColor clearColor];
            self.table2.delegate = self;
            self.table2.dataSource = self;
            self.table2.separatorStyle = UITableViewCellSeparatorStyleNone;
            [bgImage addSubview:self.table2];
            // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
            // 隐藏时间
            header.lastUpdatedTimeLabel.hidden = YES;
            // 隐藏状态
            //    header.stateLabel.hidden = YES;
            self.table2.mj_header = header;
            self.table2.mj_header.ignoredScrollViewContentInsetTop = self.table2.contentInset.top;
            [self.YuDianView addSubview:bgImage];
        }
     
        
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"SecondTableViewCell";
    // 2.从缓存池中取出cell
    SecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 3.如果缓存池中没有cell
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"SecondTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
        cell.backgroundColor = [UIColor clearColor];
        _model = _dataArr[indexPath.row];
        cell.houseID.text = [NSString stringWithFormat:@"%@",_model.house_id];
        CGFloat fadianliang = [_model.gen_cap floatValue];
        CGFloat shouyi = [_model.gen_fee floatValue];
        cell.fadianliang.text = [NSString stringWithFormat:@"%.2f/%.2f",fadianliang,shouyi];
        NSInteger num = [_model.installed_gross_capacity integerValue];
        cell.zhuangjiliang.text = [NSString stringWithFormat:@"%zd",num/1000];
        CGFloat zifaziyong = [_model.gen_use_self_cap floatValue];
        CGFloat jiazhi = [_model.gen_use_self_fee floatValue];
        cell.zifaziyong.text = [NSString stringWithFormat:@"%.2f/%.2f",zifaziyong,jiazhi];
        cell.shangwangdianliang.text = [NSString stringWithFormat:@"%@",_model.up_net_ele];
         CGFloat pingjungonglv = [_model.gen_power floatValue];
        cell.pingjungonglv.text = [NSString stringWithFormat:@"%.2f",pingjungonglv/1000];
    }
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 34;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / Bound_Width;
    //设置Bar的移动位置
    [CJScroViewBar setViewIndex:index];
    [self.scroView setlineFrame:index];
}

-(void)requestData{
    for (int i=0; i<3; i++) {
        
    
    NSString *URL = [NSString stringWithFormat:@"%@/sites/data",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (i==1) {
        [parameters setValue:@"0" forKey:@"access_way"];
    }else if (i==2){
        [parameters setValue:@"1" forKey:@"access_way"];
    }
        if (self.timeBtn.length>0) {
            [parameters setValue:self.timeBtn forKey:@"time"];
        }
    [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
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
            if (i==0) {
                NSLog(@"获取全部电站信息正确%@",responseObject);
                [self.dataArr removeAllObjects];
                for (NSMutableDictionary *dic in responseObject[@"content"][@"data"]) {
                    _model = [[ElectricityModel alloc] initWithDictionary:dic];
                    [self.dataArr addObject:_model];
                }
                
                [self.table reloadData];
            }else if (i==1){
                NSLog(@"获取全额信息正确%@",responseObject);
                [self.dataArr removeAllObjects];
                for (NSMutableDictionary *dic in responseObject[@"content"][@"data"]) {
                    _model = [[ElectricityModel alloc] initWithDictionary:dic];
                    [self.dataArr addObject:_model];
                }
                
                [self.table1 reloadData];
            }else if(i==2){
                NSLog(@"获取余电信息正确%@",responseObject);
                [self.dataArr removeAllObjects];
                for (NSMutableDictionary *dic in responseObject[@"content"][@"data"]) {
                    _model = [[ElectricityModel alloc] initWithDictionary:dic];
                    [self.dataArr addObject:_model];
                }
                
                [self.table2 reloadData];

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

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return  _dataArr;
}

-(ElectricityModel *)model{
    if (!_model) {
        _model = [[ElectricityModel alloc] init];
    }
    return  _model;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
