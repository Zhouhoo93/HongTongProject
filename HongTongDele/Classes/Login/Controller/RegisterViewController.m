//
//  RegisterViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/8/10.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextfIELD;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTwoTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation RegisterViewController
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES ];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)sendBtnClick:(id)sender {
    [self requestData];
}
- (IBAction)changgeBtnClick:(id)sender {
    UIActionSheet *actionsheet03 = [[UIActionSheet alloc] initWithTitle:@"选择身份" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"小代", @"中代",@"区代",  nil];
    // 显示
    [actionsheet03 showInView:self.view];
}
// UIActionSheetDelegate实现代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex=%ld", buttonIndex);
    
    
    if (0 == buttonIndex)
    {
        NSLog(@"点击了小戴按钮");
        [_typeBtn setTitle:@"小代" forState:0];
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        [userDefaults setValue:@"学生" forKey:@"type"];
//        [userDefaults synchronize];
    }
    else if (1 == buttonIndex)
    {
        NSLog(@"点击了中带按钮");
        [_typeBtn setTitle:@"中代" forState:0];
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        [userDefaults setValue:@"家长" forKey:@"type"];
//        [userDefaults synchronize];
    }
    else if (2 == buttonIndex)
    {
        NSLog(@"点击了大袋按钮");
        [_typeBtn setTitle:@"区代" forState:0];
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        [userDefaults setValue:@"教师" forKey:@"type"];
//        [userDefaults synchronize];
    }else if (3 == buttonIndex)
    {
        NSLog(@"点击了取消按钮");
    }
    
}

- (IBAction)registerBtnClick:(id)sender {
    if([self.passWordTextField.text isEqualToString:self.passWordTwoTextField.text]){
        [self checkCode];
    }else{
        [MBProgressHUD showText:@"两次输入的密码不同"];
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
        self.sendBtn.enabled = NO;
        //创建定时器对象
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdownTime:) userInfo:nil repeats:YES];
        [self.codeTextfIELD becomeFirstResponder];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD showText:@"发送失败"];
    }];
    
    
    
}

//验证验证码
- (void)checkCode {
    NSString *URLstring = [NSString stringWithFormat:@"%@/login?tel=%@&code=%@",kUrl,self.phoneTextField.text,self.codeTextfIELD.text];
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
        
        [self requestPassWord];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //数据请求成功后，返回 responseObject 结果集
        NSLog(@"%@",responseObject);
        [self requestPassWord];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD showText:@"验证码错误"];
    }];
    
    
    
}

///定时器方法的实现, 倒计时开始
static NSInteger count = 0;
- (void)countdownTime:(NSTimer *)timer {
    count--;
    [self.sendBtn setTitle:[NSString stringWithFormat:@"(%ld)重新获取", (long)count] forState:UIControlStateNormal];
    //    _getCode.backgroundColor = [UIColor lightGrayColor];
    if (count == 0) {
        [self.timer invalidate];
        [_sendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _sendBtn.enabled = YES;
    }
}

//验证账号密码
- (void)requestPassWord {
    NSString *URL = [[NSString alloc] init];
    if ([self.typeBtn.titleLabel.text isEqualToString:@"小代"]) {
        URL = [NSString stringWithFormat:@"%@/login/small_agents",kUrl];
    }else if ([self.typeBtn.titleLabel.text isEqualToString:@"中代"]){
        URL = [NSString stringWithFormat:@"%@/login/middle_agents",kUrl];
    }else{
        URL = [NSString stringWithFormat:@"%@/login/area_agents",kUrl];
    }
//    NSString *URL = [NSString stringWithFormat:@"%@/login/small_agent",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    if ([self.selectbtn.titleLabel.text isEqualToString:@"学生"]) {
//        [parameters setValue:@"students" forKey:@"type"];
//    }else if([self.selectbtn.titleLabel.text isEqualToString:@"家长"]){
//        [parameters setValue:@"family" forKey:@"type"];
//    }else{
//        [parameters setValue:@"teacher" forKey:@"type"];
//    }
    [parameters setValue:self.userNameTextField.text forKey:@"username"];
    [parameters setValue:self.passWordTextField.text forKey:@"pwd"];
    [parameters setValue:self.phoneTextField.text forKey:@"tel"];
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *regis = [userDefaults valueForKey:@"registerid"];
//    [parameters setValue:regis forKey:@"register_id"];
    NSLog(@"登陆参数:%@",parameters);
    [manager PUT:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if([responseObject[@"result"][@"success"] intValue] ==1){
//            NSString *token = [NSString stringWithFormat:@"%@",responseObject[@"content"]];
//            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//            [userDefaults setValue:self.PassWordText.text forKey:@"password"];
//            [userDefaults setValue:self.PassNameText.text forKey:@"phone"];
//            [userDefaults setValue:token forKey:@"token"];
//            [userDefaults synchronize];
            
            [self.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD showText:@"请等待审核"];
        }else{
            [MBProgressHUD showText:[NSString stringWithFormat:@"%@",responseObject[@"result"][@"errorMsg"]]];
            NSLog(@"%@",responseObject[@"result"][@"errorMsg"]);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
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
