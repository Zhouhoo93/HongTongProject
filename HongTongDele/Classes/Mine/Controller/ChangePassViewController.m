//
//  ChangePassViewController.m
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/7/31.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "ChangePassViewController.h"

@interface ChangePassViewController ()

@property (weak, nonatomic) IBOutlet UITextField *PhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *PassCodeText;
@property (weak, nonatomic) IBOutlet UITextField *NewPassWprdText;
@property (weak, nonatomic) IBOutlet UIButton *SendButton;
@property (strong, nonatomic) NSTimer *timer;



@end

@implementation ChangePassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改手机";
    // Do any additional setup after loading the view from its nib.
}
///定时器方法的实现, 倒计时开始
static NSInteger count = 0;
- (void)countdownTime:(NSTimer *)timer {
    count--;
    [_SendButton setTitle:[NSString stringWithFormat:@"(%ld)重新获取", (long)count] forState:UIControlStateNormal];
    //    _getCode.backgroundColor = [UIColor lightGrayColor];
    if (count == 0) {
        [self.timer invalidate];
        [_SendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _SendButton.enabled = YES;
    }
}
- (IBAction)requestBtnClick:(id)sender {
    [self checkCode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendBtnClick:(id)sender {
    [self requestData];
}
#pragma mark - 请求数据
//请求数据,获取验证码
- (void)requestData {
    NSString *URLstring = [NSString stringWithFormat:@"%@/user/edit_tel",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //        manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/json", @"text/html",  @"text/json",@"text/JavaScript", nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.PhoneTextField.text forKey:@"tel"];
    [parameters setValue:token forKey:@"token"];
    [manager POST:URLstring parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //数据请求成功后，返回 responseObject 结果集
        NSLog(@"%@",responseObject);
        [self.timer invalidate];//在创建新的定时器之前,需要将之前的定时器置为无效
        count = 60;
        _SendButton.enabled = NO;
        //创建定时器对象
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdownTime:) userInfo:nil repeats:YES];
        [self.PassCodeText becomeFirstResponder];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD showText:@"请求失败"];
    }];
    
    
    
}
#pragma mark - 请求数据
//验证验证码
- (void)checkCode {
    NSString *URLstring = [NSString stringWithFormat:@"%@/login?tel=%@&code=%@",kUrl,self.PhoneTextField.text,self.PassCodeText.text];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //        manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/json", @"text/html",  @"text/json",@"text/JavaScript", nil];
    [manager GET:URLstring parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //数据请求成功后，返回 responseObject 结果集
        NSLog(@"验证验证码%@",responseObject);
        [self requestPassWord];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showText:@"验证码错误"];
    }];
    
    
    
}
#pragma mark - 验证账号密码
//验证账号密码
- (void)requestPassWord {
    NSString *URL = [NSString stringWithFormat:@"%@/agent/index/%@",kUrl,self.PhoneTextField.text];
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
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
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
