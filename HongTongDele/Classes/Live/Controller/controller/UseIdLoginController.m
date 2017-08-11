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

- (void)viewDidLoad
{
    [super viewDidLoad];

    _loginBt.layer.cornerRadius = 5.0;
    _loginBt.backgroundColor = MAIN_COLOR;
    self.view.backgroundColor = COLOR(236, 244, 244, 1);

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    headerView.backgroundColor = MAIN_COLOR;
    [self.view addSubview:headerView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(8, 22, 20, 40);
    backBtn.layer.cornerRadius = 3;
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"ab_ic_back"] forState:UIControlStateNormal];
    [headerView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2-60, 20, 120, 44)];
    title.text = @"登录";
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:title];
    
#if DEBUG
    [GLCore setDebugLogEnabled:YES];
#endif
    [GLCore registerWithAppKey:@"de8b955b8b634fe2826e13ce077b26e2" accessSecret:@"77d7262d8c7e4676a5e7b1b333169d29" companyId:@"a002ab3fda3544fbabfd839dc119776f"];
    _userRoomId.text = [GotyeLiveConfig config].roomId;
    _userPassword.text = [GotyeLiveConfig config].password;
    _userNickName.text = [GotyeLiveConfig config].nickname;
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
    _userRoomId.text = @"2221262";
    _userPassword.text = @"IYC8M7";
    _userNickName.text = @"主播";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

// 导航栏点击事件
- (void)btnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillHideNotification object:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

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
    if (_userRoomId.text.length < 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入房间ID" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
//        LivePlayerViewController *viewController = [[LivePlayerViewController alloc] init];
//        viewController.isLiveMode  = YES;
//        viewController.roomId = roomId;
//        viewController.publisher = _publisher;
//        [self.navigationController pushViewController:viewController animated:YES];
        return;
    }
    if (_userPassword.text.length < 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (_userNickName.text.length < 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入昵称" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
//    NSString *roomId = _userRoomId.text;
//    NSString *pwd = _userPassword.text;
//    NSString *nickname = _userNickName.text;
    
    NSString *roomId = @"2221262";
    NSString *pwd = @"IYC8M7";
    NSString *nickname = @"主播";
    
    if (roomId.length == 0 || pwd.length == 0 || nickname.length == 0) {
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _roomSession = [GLCore sessionWithType:GLRoomSessionTypeDefault roomId:roomId password:pwd nickname:nickname bindAccount:nil];
    
    @weakify(self);
    
    [_roomSession authOnSuccess:^(GLAuthToken *authToken) {
        
        @strongify(self);
        if (!strong_self) {
            return;
        }
        
        [GotyeLiveConfig config].roomId = strong_self->_userRoomId.text;
        [GotyeLiveConfig config].password = strong_self->_userPassword.text;
        [GotyeLiveConfig config].nickname = strong_self->_userNickName.text;
        
        strong_self->_authToken = authToken;
        if (strong_self->_authToken.role == GLAuthTokenRolePresenter) {
            [strong_self _loginPublisherWithForce:NO callback:^(NSError *error) {
                if (!error) {
                    [hud hide:YES];
                    LivePlayerViewController *viewController = [[LivePlayerViewController alloc] init];
                    viewController.hidesBottomBarWhenPushed = YES;
                    viewController.isLiveMode  = YES;
                    viewController.roomId = roomId;
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
            viewController.roomId = roomId;
            viewController.publisher = _publisher;
            [strong_self.navigationController pushViewController:viewController animated:YES];
        }
        
    } failure:^(NSError *error) {
        @strongify(self);
        [strong_self hud:hud showError:error.localizedDescription];
    }];

//    LivePlayerViewController *viewController = [[LivePlayerViewController alloc] init];
//    [self.navigationController pushViewController:viewController animated:YES];
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

@end
