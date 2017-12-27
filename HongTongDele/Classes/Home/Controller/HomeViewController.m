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
#import "XiaoLvYunWeiViewController.h"
#import "BaoJingLiShiListViewController.h"
#import "XiaoLvLishiViewController.h"
#import "LoginOneViewController.h"
#import "AppDelegate.h"
#import <RongIMKit/RongIMKit.h>
@interface HomeViewController ()<UIScrollViewDelegate,UIActionSheetDelegate,NSTextLayoutOrientationProvider,TopButDelegate,TopButDelegate2,TopButDelegate3,TopButDelegate4>
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
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
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
    self.bgScrollView.contentSize = CGSizeMake(KWidth, KHeight-64);
    [self.table addSubview:self.bgScrollView];
    
    for (int i=0; i<3; i++) {
        
        if (i==0) {
            self.zonggongsibtn = [[UIButton alloc] initWithFrame:CGRectMake(10+i*((KWidth-60)/3+20), 10, (KWidth-60)/3, 34)];
            [self.zonggongsibtn setTitle:@"总公司" forState:UIControlStateNormal];
            [self.zonggongsibtn setTitleColor:RGBColor(91, 202, 255) forState:UIControlStateNormal];
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
            [self.yunweixiaozubtn addTarget:self action:@selector(yunweiBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [self.yunweixiaozubtn setTitleColor:RGBColor(91, 202, 255) forState:UIControlStateNormal];
            [self.yunweixiaozubtn setBackgroundImage:[UIImage imageNamed:@"top3"] forState:UIControlStateNormal];
            [self.bgScrollView addSubview:self.yunweixiaozubtn];
        }
       
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *type = [userDefaults valueForKey:@"type"];
    NSLog(@"type:%@",type);
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
    self.oneView.frame = CGRectMake(0, KHeight/667*55, KWidth, KHeight/667*120);
    [self.bgScrollView addSubview:self.oneView];
    
    self.twoView = [[[NSBundle mainBundle]loadNibNamed:@"HomeTwoTabel" owner:self options:nil]objectAtIndex:0];
    self.twoView.Topdelegate = self;
    self.twoView.frame = CGRectMake(0, KHeight/667*185, KWidth, KHeight/667*120);
    [self.bgScrollView addSubview:self.twoView];
    
    self.threeView = [[[NSBundle mainBundle]loadNibNamed:@"HomeThreeTabel" owner:self options:nil]objectAtIndex:0];
    self.threeView.Topdelegate  = self;
    self.threeView.frame = CGRectMake(0, KHeight/667*310, KWidth, KHeight/667*120);
    [self.bgScrollView addSubview:self.threeView];
    
    self.fourView = [[[NSBundle mainBundle]loadNibNamed:@"HomeFourTabel" owner:self options:nil]objectAtIndex:0];
    self.fourView.Topdelegate = self;
    self.fourView.frame = CGRectMake(0, KHeight/667*435, KWidth, KHeight/667*120);
    [self.bgScrollView addSubview:self.fourView];
    
    [self requestBaojingData];
    [self requestdianzhan];
}
//执行协议方法
- (void)transButIndex
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *type = [userDefaults valueForKey:@"type"];
    NSLog(@"type:%@",type);
    if ([type isEqualToString:@"parent"]) {
        SelectFenGongSiViewController *vc = [[SelectFenGongSiViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([type isEqualToString:@"company"]){
        SelectYunWeiViewController *vc = [[SelectYunWeiViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
   
    }
    
    
}
- (void)transButIndex2
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *type = [userDefaults valueForKey:@"type"];
    NSLog(@"type:%@",type);
    if ([type isEqualToString:@"parent"]) {
        ZhuangtaiListZongViewController *vc = [[ZhuangtaiListZongViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([type isEqualToString:@"company"]){
        ZhuangTaiListViewController *vc = [[ZhuangTaiListViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ZhuangtaiViewController *vc = [[ZhuangtaiViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)transButIndex3
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *type = [userDefaults valueForKey:@"type"];
    NSLog(@"type:%@",type);
    if ([type isEqualToString:@"parent"]) {
        BaoJingYunWeiListViewController *vc = [[BaoJingYunWeiListViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([type isEqualToString:@"company"]){
        
    }else{
        
    }
    
    
}

-(void)BaoJinglishi{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *type = [userDefaults valueForKey:@"type"];
    NSLog(@"type:%@",type);
    if ([type isEqualToString:@"parent"]) {
        BaoJingLiShiListViewController *vc = [[BaoJingLiShiListViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([type isEqualToString:@"company"]){
        
    }else{
        
    }
}

-(void)XiaoLvlishi{
    XiaoLvLishiViewController *vc = [[XiaoLvLishiViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)transButIndex4
{
    XiaoLvYunWeiViewController *vc = [[XiaoLvYunWeiViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)refresh{
    [self.table.mj_header endRefreshing];
}

- (void)fenfongsiBtnClick{
     self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"分公司1" otherButtonTitles:@"分公司2",@"分公司3", nil];
    //这里的actionSheetStyle也可以不设置；
    self.actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [self.actionSheet showInView:self.view];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet==self.actionSheet) {
        //按照按钮的顺序0-N；
        switch (buttonIndex) {
            case 0:
                NSLog(@"点击了分公司1");
                [self.fengongsibtn setTitle:@"分公司1" forState:UIControlStateNormal];
                [self.fengongsibtn setBackgroundImage:[UIImage imageNamed:@"top2"] forState:UIControlStateNormal];
                [self.fengongsibtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                break;
                
            case 1:
                NSLog(@"点击了分公司2");
                [self.fengongsibtn setTitle:@"分公司2" forState:UIControlStateNormal];
                [self.fengongsibtn setBackgroundImage:[UIImage imageNamed:@"top2"] forState:UIControlStateNormal];
                [self.fengongsibtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                break;
                
            case 2:
                NSLog(@"点击了分公司3");
                [self.fengongsibtn setTitle:@"分公司3" forState:UIControlStateNormal];
                [self.fengongsibtn setBackgroundImage:[UIImage imageNamed:@"top2"] forState:UIControlStateNormal];
                [self.fengongsibtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }else{
        //按照按钮的顺序0-N；
        switch (buttonIndex) {
            case 0:
                NSLog(@"点击了运维小组1");
                [self.fengongsibtn setTitle:@"运维小组1" forState:UIControlStateNormal];
                [self.yunweixiaozubtn setBackgroundImage:[UIImage imageNamed:@"top2"] forState:UIControlStateNormal];
                [self.yunweixiaozubtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                break;
                
            case 1:
                NSLog(@"点击了运维小组2");
                [self.fengongsibtn setTitle:@"运维小组2" forState:UIControlStateNormal];
                [self.yunweixiaozubtn setBackgroundImage:[UIImage imageNamed:@"top2"] forState:UIControlStateNormal];
                [self.yunweixiaozubtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                break;
                
            case 2:
                NSLog(@"点击了运维小组3");
                [self.fengongsibtn setTitle:@"运维小组3" forState:UIControlStateNormal];
                [self.yunweixiaozubtn setBackgroundImage:[UIImage imageNamed:@"top2"] forState:UIControlStateNormal];
                [self.yunweixiaozubtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }
    
    
}
- (void)yunweiBtnClick{
    self.actionSheet1 = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"运维小组1" otherButtonTitles:@"运维小组2",@"运维小组3", nil];
    //这里的actionSheetStyle也可以不设置；
    self.actionSheet1.actionSheetStyle = UIActionSheetStyleAutomatic;
    [self.actionSheet1 showInView:self.view];
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
            self.twoView.yichang.text = [NSString stringWithFormat:@"%ld户",abnormalTotal];
            NSInteger faultTotal = [responseObject[@"content"][@"faultTotal"] integerValue];
            self.twoView.guzhang.text = [NSString stringWithFormat:@"%ld户",faultTotal];
            NSInteger offlineTotal = [responseObject[@"content"][@"offlineTotal"] integerValue];
            self.twoView.lixian.text = [NSString stringWithFormat:@"%ld户",offlineTotal];
            NSInteger all = abnormalTotal+faultTotal+offlineTotal;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
