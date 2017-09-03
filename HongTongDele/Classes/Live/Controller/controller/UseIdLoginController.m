//
//  UseIdLoginController.m
//  LiveLinkAnchor
//
//  Created by Jim on 16/7/8.
//  Copyright © 2016年 yangchuanshuai. All rights reserved.
//

#import "UseIdLoginController.h"
#import "LivePlayerViewController.h"
#import "GLCore.h"
#import "GLRoomPublisher.h"
#import "MBProgressHUD.h"
#import "QRCodeController.h"
#import "GotyeLiveConfig.h"
#import "AppDelegate.h"
#import "LoginOneViewController.h"
@interface UseIdLoginController ()
{
    GLAuthToken *_authToken;
    GLRoomPublisher *_publisher;
    GLRoomSession *_roomSession;
}

@property (strong, nonatomic) IBOutlet UITextField *userRoomId;
@property (strong, nonatomic) IBOutlet UITextField *userPassword;
@property (strong, nonatomic) IBOutlet UITextField *userNickName;
@property (strong, nonatomic) IBOutlet UIButton *loginBt;

@end

@implementation UseIdLoginController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillHideNotification object:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

}
- (void)viewDidLoad
{
    [super viewDidLoad];

    _loginBt.layer.cornerRadius = 5.0;
    _loginBt.backgroundColor = RGBColor(73, 185, 251);
    self.view.backgroundColor = COLOR(236, 244, 244, 1);

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    headerView.backgroundColor = RGBColor(73, 185, 251);
    [self.view addSubview:headerView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(8, 22, 20, 40);
    backBtn.layer.cornerRadius = 3;
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"ab_ic_back"] forState:UIControlStateNormal];
    [headerView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2-60, 20, 120, 44)];
    title.text = @"创建直播";
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:title];
//    
#if DEBUG
    [GLCore setDebugLogEnabled:YES];
#endif
    [GLCore registerWithAppKey:@"f26f2370069d4bac816fc73584e35088" accessSecret:@"049e345fd39f442cb20b7fb0c2cc5148" companyId:@"a2a1ed5eb8414c688fb3d060acf5dcd1"];
//    _userRoomId.text = self.roomID;
//    _userPassword.text = self.roomWord;
//    _userNickName.text = self.nickName;
    if (_fromQRScan) {
        _userRoomId.enabled = _userPassword.enabled = NO;
        [_userNickName becomeFirstResponder];
    }
    
    //点击空白处收回键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
//    _userRoomId.text = self.roomID;
//    _userPassword.text = self.roomWord;
//    _userNickName.text = @"主播";
}



// 导航栏点击事件
- (void)btnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}



- (IBAction)didEndOnExit:(id)sender
{
    if (sender == _userRoomId) {
        [_userPassword becomeFirstResponder];
    } else if (sender == _userPassword) {
        [_userNickName becomeFirstResponder];
    } else if (sender == _userNickName) {
        [self.view endEditing:YES];
    }
}
- (IBAction)didSelectLoginButton:(id)sender
{
    [self requestData];

    
}
- (void)loginGo{
#if DEBUG
    [GLCore setDebugLogEnabled:YES];
#endif
    [GLCore registerWithAppKey:@"f26f2370069d4bac816fc73584e35088" accessSecret:@"049e345fd39f442cb20b7fb0c2cc5148" companyId:@"a2a1ed5eb8414c688fb3d060acf5dcd1"];
    NSString *roomId = _roomID;
    NSString *pwd = _roomWord;
    NSString *nickname = @"主播";
    
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
        [GotyeLiveConfig config].nickname = @"咖喱给给";
        
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
                            viewController.hidesBottomBarWhenPushed = YES;
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
            viewController.isZhuBo = NO;
            viewController.isZhuBo = YES;
            viewController.publisher = _publisher;
            [strong_self.navigationController pushViewController:viewController animated:YES];
        }
        
    } failure:^(NSError *error) {
        @strongify(self);
        [strong_self hud:hud showError:error.localizedDescription];
    }];

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

- (void)keyboardWillChange:(NSNotification *)note
{
    UIView *viewToChange = _loginBt;
    CGFloat offset = 20;
    
    NSDictionary *userInfo = note.userInfo;
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect keyFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat moveY = keyFrame.origin.y - (viewToChange.frame.origin.y + viewToChange.frame.size.height + offset);
    if (moveY > 0 && [note.name isEqualToString:UIKeyboardWillShowNotification]) {
        return;
    }
    
    if ([note.name isEqualToString:UIKeyboardWillHideNotification]) {
        if (moveY < 0) {
            return;
        }
        moveY = MIN(moveY, -viewToChange.transform.ty);
    }
    
    [UIView animateWithDuration:duration animations:^{
        //        viewToChange.transform = CGAffineTransformTranslate(viewToChange.transform, 0, moveY);
//        [self.view setContentOffset:CGPointMake(0, -moveY)];
    } completion:nil];
}

#pragma mark 点击空白处收回键盘
-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [_userRoomId resignFirstResponder];
    [_userNickName resignFirstResponder];
    [_userPassword resignFirstResponder];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
-(void)requestData{
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
            if ([errorcode isEqualToString:@"4100"]||[errorcode isEqualToString:@"3100"])  {
                [MBProgressHUD showText:@"请重新登陆"];
                [self newLogin];
            }else{
                NSString *str = responseObject[@"result"][@"errorMsg"];
                [MBProgressHUD showText:str];
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

@end
