//
//  HomeViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/11/9.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeOneView.h"
#import "HomeTwoView.h"
#import "HomeThreeView.h"
#import "HomeFourView.h"
#import "SelectFenGongSiViewController.h"
#import "SelectYunWeiViewController.h"
#import "ZhuangtaiListZongViewController.h"
#import "ZhuangTaiListViewController.h"
#import "ZhuangtaiViewController.h"
#import "BaoJingYunWeiListViewController.h"
#import "BaoJingLiShiViewController.h"
#import "XiaoLvYunWeiViewController.h"
#import "BaoJingLiShiListViewController.h"
#import "XiaoLvLishiViewController.h"
#import "LoginOneViewController.h"
#import "AppDelegate.h"
#import <RongIMKit/RongIMKit.h>
#import "shouyefengongsimodel.h"
#import "shouyeyunweiModel.h"
#import "JHPickView.h"
#import "SlectListViewController.h"
#import "XiaoLvHuViewController.h"
#import "BaoJingLishiYunweiListViewController.h"
#import "XiaoLvLiShiYunweiViewController.h"
@interface HomeViewController ()<UIScrollViewDelegate,UIActionSheetDelegate,NSTextLayoutOrientationProvider,TopButDelegate,TopButDelegate2,TopButDelegate3,TopButDelegate4,JHPickerDelegate>
@property (nonatomic,strong) UIScrollView *bgScrollView;
@property (nonatomic,strong)UITableView *table;
@property (nonatomic,strong)UIActionSheet *actionSheet;
@property (nonatomic,strong)UIActionSheet *actionSheet1;
@property (nonatomic,strong) UIButton *zonggongsibtn;
@property (nonatomic,strong) UIButton *fengongsibtn;
@property (nonatomic,strong) UIButton *yunweixiaozubtn;
@property (nonatomic,strong)HomeOneView *oneView;
@property (nonatomic,strong)HomeTwoView *twoView;
@property (nonatomic,strong)HomeThreeView *threeView;
@property (nonatomic,strong)HomeFourView *fourView;
@property (nonatomic,strong)NSMutableArray *fengongsiArr;
@property (nonatomic,strong)NSMutableArray *yunweiArr;
@property (nonatomic,strong)shouyefengongsimodel *fengongsi;
@property (nonatomic,strong)shouyeyunweiModel *yunwei;
@property (nonatomic,assign)NSInteger select;
@property (nonatomic,copy)NSString *selectFengongsi;
@property (nonatomic,copy)NSString *selectFengongsiID;
@property (nonatomic,copy)NSString *selectyunwei;
@property (nonatomic,copy)NSString *selectyunweiID;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy) NSString *changgename;
@property (nonatomic,copy) NSString *changgeID;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.type = [userDefaults valueForKey:@"type"];
    NSLog(@"type:%@",self.type);
    if ([self.type isEqualToString:@"parent"]) {
        [self requestfengongsi];
    }else if([self.type isEqualToString:@"company"]){
        [self requestyunwei];
    }
    [self setTopView];
    [self getRongYunToken];
    
    // Do any additional setup after loading the view.
}

- (void)setTopView{
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, KWidth, KHeight) style:UITableViewStylePlain];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.table];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    //    header.stateLabel.hidden = YES;
    self.table.mj_header = header;
    self.table.mj_header.ignoredScrollViewContentInsetTop = self.table.contentInset.top;
    
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight-64)];
    self.bgScrollView.delegate = self;
    self.bgScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.bgScrollView.contentSize = CGSizeMake(KWidth, 667-64);
    [self.table addSubview:self.bgScrollView];
    
    for (int i=0; i<3; i++) {
        
        if (i==0) {
            self.zonggongsibtn = [[UIButton alloc] initWithFrame:CGRectMake(10+i*((KWidth-60)/3+20), 10, (KWidth-60)/3, 34)];
            [self.zonggongsibtn setTitle:@"总公司" forState:UIControlStateNormal];
            [self.zonggongsibtn setTitleColor:RGBColor(91, 202, 255) forState:UIControlStateNormal];
            [self.zonggongsibtn addTarget:self action:@selector(zonggongsiBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [self.zonggongsibtn setBackgroundImage:[UIImage imageNamed:@"top3"] forState:UIControlStateNormal];
            [self.bgScrollView addSubview:self.zonggongsibtn];
        }else if(i==1){
             self.fengongsibtn = [[UIButton alloc] initWithFrame:CGRectMake(10+i*((KWidth-60)/3+20), 10, (KWidth-60)/3, 34)];
            [self.fengongsibtn setTitle:@"分公司" forState:UIControlStateNormal];
            [self.fengongsibtn addTarget:self action:@selector(fenfongsiBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [self.fengongsibtn setTitleColor:RGBColor(91, 202, 255) forState:UIControlStateNormal];
            [self.fengongsibtn setBackgroundImage:[UIImage imageNamed:@"top3"] forState:UIControlStateNormal];
            [self.bgScrollView addSubview:self.fengongsibtn];
        }else{
            self.yunweixiaozubtn = [[UIButton alloc] initWithFrame:CGRectMake(10+i*((KWidth-60)/3+20), 10, (KWidth-60)/3, 34)];
            [self.yunweixiaozubtn setTitle:@"运维小组" forState:UIControlStateNormal];
            [self.yunweixiaozubtn addTarget:self action:@selector(yunweixiaozuBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [self.yunweixiaozubtn setTitleColor:RGBColor(91, 202, 255) forState:UIControlStateNormal];
            [self.yunweixiaozubtn setBackgroundImage:[UIImage imageNamed:@"top3"] forState:UIControlStateNormal];
            [self.bgScrollView addSubview:self.yunweixiaozubtn];
        }
       
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *type = [userDefaults valueForKey:@"type"];
    if ([type isEqualToString:@"parent"]) {
        [self.zonggongsibtn setBackgroundImage:[UIImage imageNamed:@"top2"] forState:UIControlStateNormal];
        [self.zonggongsibtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else if ([type isEqualToString:@"company"]){
        [self.zonggongsibtn setBackgroundImage:[UIImage imageNamed:@"top1"] forState:UIControlStateNormal];
        [self.zonggongsibtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.zonggongsibtn.enabled = NO;
        [self.fengongsibtn setBackgroundImage:[UIImage imageNamed:@"top2"] forState:UIControlStateNormal];
        [self.fengongsibtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [self.zonggongsibtn setBackgroundImage:[UIImage imageNamed:@"top1"] forState:UIControlStateNormal];
        [self.zonggongsibtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.zonggongsibtn.enabled = NO;
        [self.fengongsibtn setBackgroundImage:[UIImage imageNamed:@"top1"] forState:UIControlStateNormal];
        [self.fengongsibtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.fengongsibtn.enabled = NO;
        [self.yunweixiaozubtn setBackgroundImage:[UIImage imageNamed:@"top2"] forState:UIControlStateNormal];
        [self.yunweixiaozubtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    self.oneView = [[[NSBundle mainBundle]loadNibNamed:@"HomeOneTabel" owner:self options:nil]objectAtIndex:0];
    self.oneView.Topdelegate = self;
    self.oneView.frame = CGRectMake(0, 55, KWidth, 120);
    [self.bgScrollView addSubview:self.oneView];
    
    self.twoView = [[[NSBundle mainBundle]loadNibNamed:@"HomeTwoTabel" owner:self options:nil]objectAtIndex:0];
    self.twoView.Topdelegate = self;
    self.twoView.frame = CGRectMake(0, 185, KWidth, 120);
    [self.bgScrollView addSubview:self.twoView];
    
    self.threeView = [[[NSBundle mainBundle]loadNibNamed:@"HomeThreeTabel" owner:self options:nil]objectAtIndex:0];
    self.threeView.Topdelegate  = self;
    self.threeView.frame = CGRectMake(0, 310, KWidth, 120);
    [self.bgScrollView addSubview:self.threeView];
    
    self.fourView = [[[NSBundle mainBundle]loadNibNamed:@"HomeFourTabel" owner:self options:nil]objectAtIndex:0];
    self.fourView.Topdelegate = self;
    self.fourView.frame = CGRectMake(0, 435, KWidth, 120);
    [self.bgScrollView addSubview:self.fourView];
    
    [self requestBaojingData];
    [self requestdianzhan];
    [self requestxiaolv];
}
-(void)zonggongsiBtnClick{
    [self.zonggongsibtn setBackgroundImage:[UIImage imageNamed:@"top2"] forState:UIControlStateNormal];
    [self.fengongsibtn setBackgroundImage:[UIImage imageNamed:@"top1"] forState:UIControlStateNormal];
    [self.yunweixiaozubtn setBackgroundImage:[UIImage imageNamed:@"top1"] forState:UIControlStateNormal];
    [self.fengongsibtn setTitle:@"分公司" forState:UIControlStateNormal];
    [self.yunweixiaozubtn setTitle:@"运维小组" forState:UIControlStateNormal];
    [self.yunweixiaozubtn setTitleColor:RGBColor(91, 202, 255) forState:UIControlStateNormal];
    [self.fengongsibtn setTitleColor:RGBColor(91, 202, 255) forState:UIControlStateNormal];
    self.type = @"parent";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:self.type forKey:@"type1"];
    [userDefaults synchronize];
    self.selectFengongsiID = nil;
    self.selectFengongsi = nil;
    self.selectyunwei = nil;
    self.selectyunweiID = nil;
    self.changgename = nil;
    self.changgeID = nil;
    [self refresh];
}
//执行协议方法
- (void)transButIndex
{

    if ([self.type isEqualToString:@"parent"]) {
        SelectFenGongSiViewController *vc = [[SelectFenGongSiViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.type isEqualToString:@"company"]){
        SelectYunWeiViewController *vc = [[SelectYunWeiViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.companyID = self.selectFengongsiID;
        vc.selectName = self.selectFengongsi;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        SlectListViewController *vc = [[SlectListViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.workID = self.selectyunweiID;
        vc.selectName = self.selectFengongsi;
        vc.selectName2 = self.selectyunwei;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}
- (void)transButIndex2
{

    if ([self.type isEqualToString:@"parent"]) {
        ZhuangtaiListZongViewController *vc = [[ZhuangtaiListZongViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.type isEqualToString:@"company"]){
        ZhuangTaiListViewController *vc = [[ZhuangTaiListViewController alloc] init];
        vc.name = self.selectFengongsi;
        vc.companyID = self.selectFengongsiID;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ZhuangtaiViewController *vc = [[ZhuangtaiViewController alloc] init];
        vc.workID = self.selectyunweiID;
        vc.name = self.selectFengongsi;
        vc.name1 = self.selectyunwei;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)transButIndex3
{

    if ([self.type isEqualToString:@"parent"]) {
        BaoJingYunWeiListViewController *vc = [[BaoJingYunWeiListViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.type isEqualToString:@"company"]){
        BaoJingYunWeiListViewController *vc = [[BaoJingYunWeiListViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.companyID = self.selectFengongsiID;
        vc.name = self.selectFengongsi;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        BaoJingLiShiViewController *vc = [[BaoJingLiShiViewController alloc] init];
        vc.workID = self.selectyunweiID;
        vc.fengongsi = self.selectFengongsi;
        vc.yunwei = self.selectyunwei;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

-(void)BaoJinglishi{
    

    if ([self.type isEqualToString:@"parent"]) {
        BaoJingLiShiListViewController *vc = [[BaoJingLiShiListViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.type isEqualToString:@"company"]){
        BaoJingLiShiListViewController *vc = [[BaoJingLiShiListViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        BaoJingLishiYunweiListViewController *vc = [[BaoJingLishiYunweiListViewController alloc] init];
        vc.workID = self.selectyunweiID;
        vc.fengongsi = self.selectFengongsi;
        vc.yunwei = self.selectyunwei;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)XiaoLvlishi{
    if ([self.type isEqualToString:@"parent"]) {
        XiaoLvLishiViewController *vc = [[XiaoLvLishiViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.type isEqualToString:@"company"]){
        XiaoLvLishiViewController *vc = [[XiaoLvLishiViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        XiaoLvLiShiYunweiViewController *vc = [[XiaoLvLiShiYunweiViewController alloc] init];
        vc.workID = self.selectyunweiID;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)transButIndex4
{
    if ([self.type isEqualToString:@"parent"]) {
        XiaoLvYunWeiViewController *vc = [[XiaoLvYunWeiViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.type isEqualToString:@"company"]){
        XiaoLvYunWeiViewController *vc = [[XiaoLvYunWeiViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.companyID = self.selectFengongsiID;
        vc.name = self.selectFengongsi;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        XiaoLvHuViewController *vc = [[XiaoLvHuViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.workID = self.selectyunweiID;
//        vc.fengongsi = self.selectFengongsi;
//        vc.yunwei = self.selectyunwei;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

- (void)refresh{
    [self requestdianzhan];
    [self requestxiaolv];
    [self requestBaojingData];
    [self.table.mj_header endRefreshing];
}

- (void)fenfongsiBtnClick{
    if (_fengongsiArr.count>0) {
        self.tabBarController.tabBar.hidden = YES;
        NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i=0; i<_fengongsiArr.count; i++) {
            _fengongsi = _fengongsiArr[i];
            [list addObject:_fengongsi.name];
        }
        JHPickView *picker = [[JHPickView alloc]initWithFrame:self.view.bounds];
        picker.classArr = list;
        self.select = 0;
        picker.delegate = self ;
        picker.arrayType = weightArray;
        [self.view addSubview:picker];
    }
    
}
- (void)yunweixiaozuBtnClick{
    if (_yunweiArr.count>0) {
        self.tabBarController.tabBar.hidden = YES;
        NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i=0; i<_yunweiArr.count; i++) {
            _yunwei = _yunweiArr[i];
            [list addObject:_yunwei.workname];
        }
        JHPickView *picker = [[JHPickView alloc]initWithFrame:self.view.bounds];
        picker.classArr = list;
        self.select = 1;
        picker.delegate = self ;
        picker.arrayType = weightArray;
        [self.view addSubview:picker];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text =@"暂无运维小组";
        [hud hideAnimated:YES afterDelay:2.f];
    }
    
}
-(void)PickerSelectorIndixString:(NSString *)str:(NSInteger)row
{
    self.tabBarController.tabBar.hidden = NO;
    if (self.select ==0) {
         [self.zonggongsibtn setBackgroundImage:[UIImage imageNamed:@"top1"] forState:UIControlStateNormal];
        [self.yunweixiaozubtn setBackgroundImage:[UIImage imageNamed:@"top1"] forState:UIControlStateNormal];
        [self.fengongsibtn setBackgroundImage:[UIImage imageNamed:@"top2"] forState:UIControlStateNormal];
        [self.fengongsibtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.fengongsibtn setTitle:str forState:UIControlStateNormal];
        for (int i=0; i<_fengongsiArr.count; i++) {
            _fengongsi = _fengongsiArr[i];
            if ([str isEqualToString:_fengongsi.name]) {
                self.selectFengongsiID = _fengongsi.ID;
                self.selectFengongsi = _fengongsi.name;
                self.changgename = _fengongsi.name;
                self.changgeID = _fengongsi.ID;
            }
        }
        self.type = @"company";
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:self.type forKey:@"type1"];
        [userDefaults synchronize];
        self.selectyunwei = nil;
        self.selectyunweiID = nil;
        [self refresh];
        [self requestyunwei];
    }else{
         [self.zonggongsibtn setBackgroundImage:[UIImage imageNamed:@"top1"] forState:UIControlStateNormal];
         [self.fengongsibtn setBackgroundImage:[UIImage imageNamed:@"top1"] forState:UIControlStateNormal];
        [self.yunweixiaozubtn setBackgroundImage:[UIImage imageNamed:@"top2"] forState:UIControlStateNormal];
        [self.yunweixiaozubtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.yunweixiaozubtn setTitle:str forState:UIControlStateNormal];
        for (int i=0; i<_yunweiArr.count; i++) {
            _yunwei = _yunweiArr[i];
            if ([str isEqualToString:_yunwei.workname]) {
                self.selectyunweiID = _yunwei.ID;
                self.selectyunwei = _yunwei.workname;
                self.changgename = _yunwei.workname;
                self.changgeID = _yunwei.ID;
            }
        }
        self.type = @"work";
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:self.type forKey:@"type1"];
        [userDefaults synchronize];
        [self refresh];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)requestBaojingData{
    NSString *URL = [NSString stringWithFormat:@"%@/police/index",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSString *changge = [NSString stringWithFormat:@"%@",_changgeID];
    if (changge.length>0) {
        [manager.requestSerializer  setValue:self.type forHTTPHeaderField:@"changeName"];
        [manager.requestSerializer  setValue:changge forHTTPHeaderField:@"changeId"];
    }
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取报警电站正确%@",responseObject);
        
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
            NSInteger Handle = [responseObject[@"content"][@"Handle"] integerValue];
            self.threeView.weichuli.text = [NSString stringWithFormat:@"%ld条",Handle];
            NSInteger Handled = [responseObject[@"content"][@"Handled"] integerValue];
            self.threeView.yichuli.text = [NSString stringWithFormat:@"%ld条",Handled];
            NSInteger InHandle = [responseObject[@"content"][@"InHandle"] integerValue];
            self.threeView.chulizhong.text = [NSString stringWithFormat:@"%ld条",InHandle];
            NSInteger abnormalTotal = [responseObject[@"content"][@"abnormalTotal"] integerValue];
            self.twoView.yichang.text = [NSString stringWithFormat:@"%ld次",abnormalTotal];
            NSInteger faultTotal = [responseObject[@"content"][@"faultTotal"] integerValue];
            self.twoView.guzhang.text = [NSString stringWithFormat:@"%ld次",faultTotal];
            NSInteger offlineTotal = [responseObject[@"content"][@"offlineTotal"] integerValue];
            self.twoView.lixian.text = [NSString stringWithFormat:@"%ld户",offlineTotal];
            NSInteger all = [responseObject[@"content"][@"totalHouse"] integerValue];
            NSInteger all1 = Handle+Handled+InHandle;
            self.twoView.baojingdianzhan.text = [NSString stringWithFormat:@"报警电站:%ld户",all];
            self.threeView.baojingxinxi.text = [NSString stringWithFormat:@"报警信息:%ld条",all1];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}
-(void)requestdianzhan{
    NSString *URL = [NSString stringWithFormat:@"%@/data/get-base-data",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSString *changge = [NSString stringWithFormat:@"%@",_changgeID];
    if (changge.length>0) {
        [manager.requestSerializer  setValue:self.type forHTTPHeaderField:@"changeName"];
        [manager.requestSerializer  setValue:changge forHTTPHeaderField:@"changeId"];
    }
    [manager POST:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取电站基本数据正确%@",responseObject);
        
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
            double value1 = 0.98000;
            double value2 = 0.98125;
            NSLog(@"%@",@(value1).description);
            NSLog(@"%@",@(value2).description);
            
            NSInteger zongzhuangji = [responseObject[@"content"][@"total_install_base"] integerValue];
            NSInteger zonghushu = [responseObject[@"content"][@"total_number_households"] integerValue];
            if (zongzhuangji>=0&&zongzhuangji<1000) {
                CGFloat zongzhuang = zongzhuangji ;
                self.oneView.zongzhuangji.text = [NSString stringWithFormat:@"%@瓦/%ld户",@(zongzhuang).description,zonghushu];
            }else if (zongzhuangji>=1000&&zongzhuangji<1000000){
                CGFloat zongzhuang = zongzhuangji/1000;
                self.oneView.zongzhuangji.text = [NSString stringWithFormat:@"%@千瓦/%ld户",@(zongzhuang).description,zonghushu];
            }else{
                CGFloat zongzhuang = zongzhuangji/1000000;
                self.oneView.zongzhuangji.text = [NSString stringWithFormat:@"%@兆瓦/%ld户",@(zongzhuang).description,zonghushu];
            }
           
            CGFloat fadian = [responseObject[@"content"][@"total_gen_cap"] floatValue];
            self.oneView.yifadian.text = [NSString stringWithFormat:@"%.3f度",fadian];
            NSInteger wanchenglv = [responseObject[@"content"][@"completion_rate"] integerValue];
            self.oneView.wanchenglv.text = [NSString stringWithFormat:@"%ld%%",wanchenglv];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}

-(void)requestxiaolv{
    NSString *URL = [NSString stringWithFormat:@"%@/abnormal/index",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSString *changge = [NSString stringWithFormat:@"%@",_changgeID];
    if (changge.length>0) {
        [manager.requestSerializer  setValue:self.type forHTTPHeaderField:@"changeName"];
        [manager.requestSerializer  setValue:changge forHTTPHeaderField:@"changeId"];
    }
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取效率数据正确%@",responseObject);
        
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
          
            
            NSInteger Handle = [responseObject[@"content"][@"Handle"] integerValue];
            NSInteger Handled = [responseObject[@"content"][@"Handled"] integerValue];
            NSInteger InHandle = [responseObject[@"content"][@"InHandle"] integerValue];
            self.fourView.weichuli.text = [NSString stringWithFormat:@"%ld户",Handle];
            self.fourView.chulizhong.text = [NSString stringWithFormat:@"%ld户",InHandle];
            self.fourView.yichuli.text = [NSString stringWithFormat:@"%ld户",Handled];
            self.fourView.xiaolvyichang.text = [NSString stringWithFormat:@"效率异常:%ld户",Handle+InHandle+Handled];
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

- (void)getRongYunToken{
    NSString *URL = [NSString stringWithFormat:@"%@/police/getToken",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    [userDefaults synchronize];
    
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"登陆融云正确%@",responseObject);
        NSString *rongToken = responseObject[@"content"];
        //----------融云------------
        [[RCIM sharedRCIM] initWithAppKey:@"x18ywvqfx6pzc"];
        [[RCIM sharedRCIM] connectWithToken:rongToken     success:^(NSString *userId) {
            NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        } error:^(RCConnectErrorCode status) {
            NSLog(@"登陆的错误码为:%d", status);
        } tokenIncorrect:^{
            //token过期或者不正确。
            //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
            //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
            NSLog(@"token错误");
        }];
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
}

-(void)requestfengongsi{
    NSString *URL = [NSString stringWithFormat:@"%@/user/index",kUrl];
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
            [_fengongsiArr removeAllObjects];
            for (NSMutableDictionary *dic in responseObject[@"content"]) {
                _fengongsi = [[shouyefengongsimodel alloc] initWithDictionary:dic];
                [self.fengongsiArr addObject:_fengongsi];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}
-(void)requestyunwei{
    NSString *URL = [NSString stringWithFormat:@"%@/user/com",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.selectFengongsiID forKey:@"company_id"];
    NSLog(@"参数:%@",parameters);
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取运维列表正确%@",responseObject);
        
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
            [_yunweiArr removeAllObjects];
            for (NSMutableDictionary *dic in responseObject[@"content"]) {
                _yunwei = [[shouyeyunweiModel alloc] initWithDictionary:dic];
                [self.yunweiArr addObject:_yunwei];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}
-(NSMutableArray *)fengongsiArr{
    if (!_fengongsiArr) {
        _fengongsiArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _fengongsiArr;
}
-(shouyefengongsimodel *)fengongsi{
    if(!_fengongsi){
        _fengongsi = [[shouyefengongsimodel alloc] init];
    }
    return _fengongsi;
}
-(NSMutableArray *)yunweiArr{
    if (!_yunweiArr) {
        _yunweiArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _yunweiArr;
}
-(shouyeyunweiModel *)yunwei{
    if (!_yunwei) {
        _yunwei = [[shouyeyunweiModel alloc] init];
    }
    return _yunwei;
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
