//
//  MineCenterViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/8/15.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "MineCenterViewController.h"
#import "ChanggeWordViewController.h"
#import "ChangePassViewController.h"
#import "SexViewController.h"
@interface MineCenterViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *PassWordLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLbale;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (nonatomic,assign) NSInteger indexSlect;
@property (nonatomic,copy) NSString *NewPhone;
@property (nonatomic,copy) NSString *NewAddress;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

@implementation MineCenterViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号中心";
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)ChangeNameBtnClick:(id)sender {
    self.indexSlect = 0;
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"设置" message:@"请输入您的昵称" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    alertview.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertview show];

}
- (IBAction)changgeSex:(id)sender {
    
    SexViewController *vc = [[SexViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)ChanggePassWordBtnClick:(id)sender {
    ChanggeWordViewController *vc = [[ChanggeWordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)ChanggePhoneBtnClick:(id)sender {
//    self.indexSlect = 2;
//    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"设置" message:@"请输入您的新手机号" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
//    alertview.alertViewStyle = UIAlertViewStylePlainTextInput;
//    [alertview show];
    ChangePassViewController *vc = [[ChangePassViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)ChanggeAddressBtnClick:(id)sender {
    self.indexSlect = 3;
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"设置" message:@"请输入您的新地址" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    alertview.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertview show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(self.indexSlect==0){
        if (buttonIndex==0) {
            UITextField *nameField = [alertView textFieldAtIndex:0];
            NSString *str = nameField.text;
            self.userNameLabel.text = str;
            self.userName = str;
            [self requestNewUserName];
        }
        
    }else if(self.indexSlect==2){
        if (buttonIndex==0) {
        UITextField *nameField = [alertView textFieldAtIndex:0];
        NSString *str = nameField.text;
        
        self.phoneNumLbale.text = str;
        self.NewPhone = str;
        [self requestNewPhone];
        }
    }else if(self.indexSlect==3){
        if (buttonIndex==0) {
        UITextField *nameField = [alertView textFieldAtIndex:0];
        NSString *str = nameField.text;
        self.addressLabel.text = str;
        self.NewAddress = str;
        [self requestNewAddress];
        }
    }
}

-(void)requestNewUserName{
    NSString *URL = [NSString stringWithFormat:@"%@/user/edit_nickname",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@ ,%@",token,URL);
   
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.userName forKey:@"nickname"];
    [parameters setValue:token forKey:@"token"];
    [userDefaults synchronize];
    [manager POST:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"修改username%@",responseObject);
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
            [MBProgressHUD showText:@"设置成功"];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
    }];
}

-(void)requestNewPhone{
    NSString *URL = [NSString stringWithFormat:@"%@/agent/index/%@",kUrl,self.NewPhone];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@   ,%@",token,URL);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
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
            [MBProgressHUD showText:@"设置成功"];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
    }];
}

-(void)requestNewAddress{
    NSString *URL = [NSString stringWithFormat:@"%@/user/edit_address",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.NewAddress forKey:@"address"];
    [parameters setValue:token forKey:@"token"];
    [manager POST:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
            [MBProgressHUD showText:@"设置成功"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
    }];
}

+ (BOOL)isChinaMobile:(NSString *)phoneNum
{
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:phoneNum];
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
