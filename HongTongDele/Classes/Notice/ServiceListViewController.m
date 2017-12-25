//
//  ServiceListViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/10/16.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "ServiceListViewController.h"
#import "NoticeViewController.h"
#import "CustomerViewController.h"
#import "LiveViewController.h"
@interface ServiceListViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView *bgScrollView;
@property(strong,nonatomic)UIWindow *window;
@property(strong,nonatomic)UIButton *button;
@end

@implementation ServiceListViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelector:@selector(createButton) withObject:nil afterDelay:1];
    [self setUI];
    // Do any additional setup after loading the view.
}
- (void)setUI{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 64)];
    topView.backgroundColor = RGBColor(90, 212, 254);
    [self.view addSubview:topView];
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2-50, 20, 100, 44)];
    topLabel.text = @"服务";
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.font = [UIFont systemFontOfSize:20];
    topLabel.textColor = [UIColor whiteColor];
    [topView addSubview:topLabel];
    for (int i=0; i<3; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*KWidth/3, 64, KWidth/3, 44)];
        if (i==0) {
            [btn setTitle:@"推送" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(firstBtnClick) forControlEvents:UIControlEventTouchUpInside];
        }else if (i==1){
            [btn setTitle:@"客服" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(secondBtnClick) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [btn setTitle:@"直播" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(thirdBtnClick) forControlEvents:UIControlEventTouchUpInside];
        }
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.view addSubview:btn];
    }
    for (int i=0; i<2; i++) {
        UIView *line = [[UIButton alloc] initWithFrame:CGRectMake((i+1)*KWidth/3, 64, 1, 44)];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:line];
    }
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 108, KWidth, KHeight-108-44)];
    _bgScrollView.delegate = self;
    _bgScrollView.contentSize = CGSizeMake(KWidth*3, KHeight-108-44);
    _bgScrollView.backgroundColor = [UIColor grayColor];
    _bgScrollView.pagingEnabled= YES;
    [self.view addSubview:self.bgScrollView];
    
    NoticeViewController *vc = [[NoticeViewController alloc] init];
    [self addChildViewController:vc];
    // 假设scrollView已经添加到self.view上了
    vc.view.frame = CGRectMake(0, 0, KWidth, KHeight-108-44);
    [self.bgScrollView addSubview:vc.view];
    
    CustomerViewController *vc1 = [[CustomerViewController alloc] init];
    [self addChildViewController:vc1];
    // 假设scrollView已经添加到self.view上了
    vc1.view.frame = CGRectMake(KWidth, 0, KWidth, KHeight-108-44);
    [self.bgScrollView addSubview:vc1.view];
    
    LiveViewController *vc2 = [[LiveViewController alloc] init];
    [self addChildViewController:vc2];
    // 假设scrollView已经添加到self.view上了
    vc2.view.frame = CGRectMake(KWidth*2, 0, KWidth, KHeight-108-44);
    [self.bgScrollView addSubview:vc2.view];
}

- (void)firstBtnClick{
    [self.bgScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)secondBtnClick{
    [self.bgScrollView setContentOffset:CGPointMake(KWidth, 0) animated:YES];
}

- (void)thirdBtnClick{
    [self.bgScrollView setContentOffset:CGPointMake(KWidth*2, 0) animated:YES];
}

- (void)createButton
{
//    _button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_button setTitle:@"悬浮按钮" forState:UIControlStateNormal];
//    _button.frame = CGRectMake(0, 0, 80, 80);
//    [_button addTarget:self action:@selector(resignWindow) forControlEvents:UIControlEventTouchUpInside];
//    _window = [[UIWindow alloc]initWithFrame:CGRectMake(100, 200, 80, 80)];
//    _window.windowLevel = UIWindowLevelAlert+1;
//    _window.backgroundColor = [UIColor redColor];
//    _window.layer.cornerRadius = 40;
//    _window.layer.masksToBounds = YES;
//    [_window addSubview:_button];
//    [_window makeKeyAndVisible];//关键语句,显示window
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _button.frame = CGRectMake(KWidth - 80, KHeight - 140, 60, 60);
    
    [_button setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
//    _button.backgroundColor = [UIColor redColor];
    [_button addTarget:self action:@selector(onTapLiveBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_button];
    
}
- (void)onTapLiveBtn

{
    CGPoint offset = self.bgScrollView.contentOffset;
    
    if (offset.x == 0) {
        NSLog(@"推送点击底部按钮");
    }else if(offset.x == KWidth){
       NSLog(@"客服点击底部按钮");
        [self requestLivePeople];
    }else{
        NSLog(@"直播底部按钮");
    }
    
    
}
- (void)requestLivePeople{
    NSString *URL = [NSString stringWithFormat:@"%@/police/getChatList",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取聊天列表正确%@",responseObject);
        
        if ([responseObject[@"result"][@"success"] intValue] ==0) {
            NSNumber *code = responseObject[@"result"][@"errorCode"];
            NSString *errorcode = [NSString stringWithFormat:@"%@",code];
            if ([errorcode isEqualToString:@"3100"])  {
                [MBProgressHUD showText:@"请重新登陆"];
//                [self newLogin];
            }else{
                NSString *str = responseObject[@"result"][@"errorMsg"];
                [MBProgressHUD showText:str];
            }
        }else{
            
//            for (NSMutableDictionary *dic in responseObject[@"content"]) {
//                _model = [[CustomerListModel alloc] initWithDictionary:dic];
//                [self.dataArr addObject:_model];
//            }
//            [self.listTableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
}
- (void)resignWindow
{
    
//    [_window resignKeyWindow];
//    _window = nil;
    
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
