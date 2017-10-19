//
//  ForgetViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/8/14.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "ForgetViewController.h"
#import "AppDelegate.h"
@interface ForgetViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@property (weak, nonatomic) IBOutlet UITextField *passTextField;
@property (weak, nonatomic) IBOutlet UITextField *passTwoTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation ForgetViewController
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES ];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_phoneTextField resignFirstResponder];
    [_codeTextField resignFirstResponder];
    [_passTextField resignFirstResponder];
    [_passTwoTextField resignFirstResponder];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)sendCodeBtnClick:(id)sender {
    [self requestData];
}
- (IBAction)LoginBtnClick:(id)sender {
    if ([self.passTextField.text isEqualToString:self.passTwoTextField.text]) {
        [MBProgressHUD showText:@"请稍候"];
        [self checkCode];
    }else{
        [MBProgressHUD showText:@"两次密码输入不一致"];
    }
}
///定时器方法的实现, 倒计时开始
static NSInteger count = 0;
- (void)countdownTime:(NSTimer *)timer {
    count--;
    [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"(%ld)重新获取", (long)count] forState:UIControlStateNormal];
    //    _getCode.backgroundColor = [UIColor lightGrayColor];
    if (count == 0) {
        [self.timer invalidate];
        [_sendCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _sendCodeBtn.enabled = YES;
    }
}
//请求数据,获取验证码
- (void)requestData {
    NSString *URLstring = [NSString stringWithFormat:@"%@/login/%@",kUrl,self.phoneTextField.text];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //        manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/json", @"text/html",  @"text/json",@"text/JavaScript", nil];
    [manager GET:URLstring parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //数据请求成功后，返回 responseObject 结果集
        NSLog(@"%@",responseObject);
        [self.timer invalidate];//在创建新的定时器之前,需要将之前的定时器置为无效
        count = 60;
        self.sendCodeBtn.enabled = NO;
        //创建定时器对象
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdownTime:) userInfo:nil repeats:YES];
        [self.codeTextField becomeFirstResponder];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD showText:@"发送失败"];
    }];
    
    
    
}
//验证验证码
- (void)checkCode {
    NSString *URLstring = [NSString stringWithFormat:@"%@/login?tel=%@&code=%@",kUrl,self.phoneTextField.text,self.codeTextField.text];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //        manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/json", @"text/html",  @"text/json",@"text/JavaScript", nil];
    //    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //    [parameters setValue:self.phoneNumText.text forKey:@"phone"];
    //    [parameters setValue:@"apppwd" forKey:@"type"];
    //    [parameters setValue:self.codeText.text forKey:@"code"];
    //post请求
    [manager GET:URLstring parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //数据请求成功后，返回 responseObject 结果集
        NSLog(@"%@",responseObject);
        [self requestPassWord];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD showText:@"验证码错误"];
    }];
    
    
    
}

//验证账号密码
- (void)requestPassWord {
    NSString *URL = [NSString stringWithFormat:@"%@/login/pwd",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.phoneTextField.text forKey:@"tel"];
    [parameters setValue:self.passTextField.text forKey:@"pwd"];
//    [parameters setValue:self.phoneTextField.text forKey:@"tel"];
    NSLog(@"忘记密码参数:%@",parameters);
    [manager PUT:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if([responseObject[@"result"][@"success"] intValue] ==1){
            [MBProgressHUD showText:@"修改完成"];
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
        NSLog(@"%@",error);
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
