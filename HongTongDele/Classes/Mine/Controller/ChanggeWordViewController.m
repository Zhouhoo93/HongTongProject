//
//  ChanggeWordViewController.m
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/7/31.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "ChanggeWordViewController.h"
#import "AppDelegate.h"
#import "LoginOneViewController.h"
@interface ChanggeWordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *OldWordText;
@property (weak, nonatomic) IBOutlet UITextField *NewWordText;
@property (weak, nonatomic) IBOutlet UITextField *NewWordTextTwo;

@end

@implementation ChanggeWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)requestBtnClick:(id)sender {
    if([self.NewWordText.text isEqualToString:self.NewWordTextTwo.text]){
        [self requestPassWord];
    }else{
        [MBProgressHUD showText:@"两次输入的密码不同"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//验证账号密码
- (void)requestPassWord {
    NSString *URL = [NSString stringWithFormat:@"%@/user/edit_pwd",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    
    [parameters setValue:self.OldWordText.text forKey:@"old_pwd"];
    [parameters setValue:token forKey:@"token"];
    [parameters setValue:self.NewWordText.text forKey:@"new_pwd"];
    [parameters setValue:self.NewWordTextTwo.text forKey:@"repwd"];
    NSLog(@"修改密码参数:%@",parameters);
    [manager POST:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"修改密码正确%@",responseObject);
        if([responseObject[@"result"][@"success"] intValue] ==1){
//            [MBProgressHUD showText:@"设置成功"];
//            [self.navigationController popViewControllerAnimated:YES];
            [self newLogin];
        }else{
            [MBProgressHUD showText:[NSString stringWithFormat:@"%@",responseObject[@"result"][@"errorMsg"]]];
            NSLog(@"%@",responseObject[@"result"][@"errorMsg"]);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"失败%@",error);
    }];
}
- (void)newLogin{
    [MBProgressHUD showText:@"密码修改成功,请重新登录"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
