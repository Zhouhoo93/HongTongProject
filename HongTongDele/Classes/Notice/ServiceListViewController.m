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
#import "CustomerListViewController.h"
#import "LiveViewController.h"
#import "UseIdLoginController.h"
#import "LiveCollectionViewCell.h"
#import "liveListModel.h"
#import "LivePlayerViewController.h"
#import "GLCore.h"
#import "GLRoomPublisher.h"
#import "MBProgressHUD.h"
#import "QRCodeController.h"
#import "GotyeLiveConfig.h"
#import "LoginOneViewController.h"
#import "AppDelegate.h"
@interface ServiceListViewController ()<UIScrollViewDelegate>
{
    GLAuthToken *_authToken;
    GLRoomPublisher *_publisher;
    GLRoomSession *_roomSession;
}
@property (nonatomic,strong)UIScrollView *bgScrollView;
@property(strong,nonatomic)UIWindow *window;
@property(strong,nonatomic)UIButton *button;
@property (nonatomic,copy)NSString *roomID;
@property (nonatomic,copy)NSString *roomWord;
@property (nonatomic,assign)BOOL isTuiSong;
@property (nonatomic,copy)NSString *NickName;
@property (nonatomic,strong)UIImageView *noDataIMG;
@property (nonatomic,copy)NSString *userName;
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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *roomID= [NSString stringWithFormat:@"%@",[userDefaults valueForKey:@"roomID"]];
    NSString *ps= [NSString stringWithFormat:@"%@",[userDefaults valueForKey:@"ps"]];
    if ([roomID isEqual:[NSNull class]]) {
        self.isTuiSong = YES;
        _roomID = roomID;
        _roomWord = ps;
        [userDefaults setValue:nil forKey:@"roomID"];
        [userDefaults setValue:nil forKey:@"ps"];
    }
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
        UIViewController *vc = [[CustomerListViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSLog(@"直播底部按钮");
        [self requestCreatLive];
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
//----------直播-----------
-(void)requestCreatLive{
    NSString *URL = [NSString stringWithFormat:@"%@/live-t/open-live",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    //    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    //    [parameters setValue:self.userRoomId.text forKey:@"room_name"];
    //    [parameters setValue:self.userPassword.text forKey:@"desc"];
    //    [parameters setValue:self.userNickName.text forKey:@"shareDesc"];
    [manager POST:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"创建直播正确%@",responseObject);
        
        if ([responseObject[@"result"][@"success"] intValue] ==0) {
            NSNumber *code = responseObject[@"result"][@"errorCode"];
            NSString *errorcode = [NSString stringWithFormat:@"%@",code];
            if ([errorcode isEqualToString:@"3100"])  {
                [MBProgressHUD showText:@"请重新登陆"];
                [self newLogin];
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text =responseObject[@"result"][@"errorMsg"];
                [hud hideAnimated:YES afterDelay:2.f];
            }
        }else{
            
            self.roomID = responseObject[@"content"][@"roomId"];
            self.roomWord = responseObject[@"content"][@"anchorPwd"];
            [self loginGo];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}
- (void)loginGo{
#if DEBUG
    [GLCore setDebugLogEnabled:YES];
#endif
    [GLCore registerWithAppKey:@"f26f2370069d4bac816fc73584e35088" accessSecret:@"049e345fd39f442cb20b7fb0c2cc5148" companyId:@"a2a1ed5eb8414c688fb3d060acf5dcd1"];
    NSString *roomId = _roomID;
    NSString *pwd = _roomWord;
    NSString *nickname = _userName;
    
    //    if (roomId.length == 0 || pwd.length == 0 || nickname.length == 0) {
    //        return;
    //    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _roomSession = [GLCore sessionWithType:GLRoomSessionTypeDefault roomId:roomId password:pwd nickname:nickname bindAccount:nil];
    
    @weakify(self);
    
    [_roomSession authOnSuccess:^(GLAuthToken *authToken) {
        
        @strongify(self);
        if (!strong_self) {
            return;
        }
        
        [GotyeLiveConfig config].roomId = strong_self->_roomID;
        [GotyeLiveConfig config].password = strong_self->_roomWord;
        [GotyeLiveConfig config].nickname = strong_self->_userName;
        
        strong_self->_authToken = authToken;
        if (strong_self->_authToken.role == GLAuthTokenRolePresenter) {
            [strong_self _loginPublisherWithForce:NO callback:^(NSError *error) {
                if (!error) {
                    [hud hide:YES];
                    LivePlayerViewController *viewController = [[LivePlayerViewController alloc] init];
                    viewController.hidesBottomBarWhenPushed = YES;
                    viewController.isLiveMode  = YES;
                    viewController.roomId = roomId;
                    viewController.isZhuBo = YES;
                    viewController.publisher = _publisher;
                    [strong_self.navigationController pushViewController:viewController animated:YES];
                    return;
                }
                
                if (error.code == GLPublisherErrorCodeOccupied) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"当前直播间已经有人登录了，继续登录的话将会踢出当前用户的用户。是否继续？" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *goOn = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        @weakify(strong_self);
                        
                        [strong_self _loginPublisherWithForce:YES callback:^(NSError *error) {
                            
                            @strongify(strong_self);
                            
                            if (!strong_strong_self) {
                                return;
                            }
                            
                            if (error) {
                                [strong_strong_self hud:hud showError:error.localizedDescription];
                                return;
                            }
                            
                            [hud hide:YES];
                            LivePlayerViewController *viewController = [[LivePlayerViewController alloc] init];
//                            viewController.hidesBottomBarWhenPushed = YES;
                            viewController.isLiveMode  = YES;
                            viewController.roomId = roomId;
                            viewController.isZhuBo = NO;
                            viewController.isZhuBo = YES;
                            viewController.navigationController.navigationBar.hidden = YES;
                            viewController.publisher = _publisher;
                            [strong_strong_self.navigationController pushViewController:viewController animated:YES];
                        }];
                    }];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [hud hide:YES];
                        [strong_self.view endEditing:YES];
                    }];
                    [alert addAction:cancel];
                    [alert addAction:goOn];
                    
                    [strong_self presentViewController:alert animated:YES completion:nil];
                } else {
                    [strong_self hud:hud showError:error.localizedDescription];
                }
            }];
        } else {
            [hud hide:YES];
            LivePlayerViewController *viewController = [[LivePlayerViewController alloc] init];
            viewController.hidesBottomBarWhenPushed = YES;
            viewController.isLiveMode  = NO;
            viewController.navigationController.navigationBar.hidden = YES;
            viewController.roomId = roomId;
            //            viewController.isZhuBo = NO;
            viewController.isZhuBo = YES;
            viewController.publisher = _publisher;
            [strong_self.navigationController pushViewController:viewController animated:YES];
        }
        
    } failure:^(NSError *error) {
        @strongify(self);
        [strong_self hud:hud showError:error.localizedDescription];
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

- (void)_loginPublisherWithForce:(BOOL)force callback:(void(^)(NSError *error))callback
{
    _publisher = [[GLRoomPublisher alloc]initWithSession:_roomSession];
    [_publisher loginWithForce:force success:^{
        if (callback) {
            callback(nil);
        }
    } failure:^(NSError *error) {
        if (callback) {
            callback(error);
        }
    }];
}

- (void)hud:(MBProgressHUD *)hud showError:(NSString *)error
{
    hud.detailsLabelText = error;
    hud.mode = MBProgressHUDModeText;
    [hud hide:YES afterDelay:1];
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
