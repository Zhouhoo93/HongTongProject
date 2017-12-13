//
//  LoginOneViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/8/10.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "LoginOneViewController.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"
#import "ForgetViewController.h"
@interface LoginOneViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginOneViewController
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_phoneTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES ];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (IBAction)ForgetBtnClick:(id)sender {
    ForgetViewController *vc = [[ForgetViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)LoginBtnClick:(id)sender {
    [self requestPassWord];
}
- (IBAction)RegisterBtnClick:(id)sender {
    RegisterViewController *vc = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//验证账号密码
- (void)requestPassWord {
    NSString *URL = [NSString stringWithFormat:@"%@/user/login",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    if ([self.selectbtn.titleLabel.text isEqualToString:@"学生"]) {
//        [parameters setValue:@"students" forKey:@"type"];
//    }else if([self.selectbtn.titleLabel.text isEqualToString:@"家长"]){
//        [parameters setValue:@"family" forKey:@"type"];
//    }else{
//        [parameters setValue:@"teacher" forKey:@"type"];
//    }
    [parameters setValue:self.phoneTextField.text forKey:@"tel"];
    [parameters setValue:self.passwordTextField.text forKey:@"password"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *regis = [userDefaults valueForKey:@"registerid"];
    [parameters setValue:regis forKey:@"registration_id"];
    NSLog(@"登陆参数:%@",parameters);
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"正确%@",responseObject);
        //(parent  总公司  company    分公司  work 运维小组)
        if([responseObject[@"result"][@"success"] intValue] ==1){
            NSString *token = [NSString stringWithFormat:@"%@",responseObject[@"content"][@"token"]];
            NSString *type = [NSString stringWithFormat:@"%@",responseObject[@"content"][@"type"]];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:self.passwordTextField.text forKey:@"password"];
            [userDefaults setValue:self.passwordTextField.text forKey:@"phone"];
            [userDefaults setValue:token forKey:@"token"];
            [userDefaults setValue:type forKey:@"type"];
            [userDefaults synchronize];
            
            [self goHomeController];
            
        }else{
//            [MBProgressHUD showText:[NSString stringWithFormat:@"%@",responseObject[@"result"][@"errorMsg"]]];
//            NSLog(@"%@",responseObject[@"result"][@"errorMsg"]);
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text =responseObject[@"result"][@"errorMsg"];
            [hud hideAnimated:YES afterDelay:2.f];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
}

- (void)goHomeController{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *baseNaviVC = [storyboard instantiateViewControllerWithIdentifier:@"Main"];
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.window.rootViewController =baseNaviVC;

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
