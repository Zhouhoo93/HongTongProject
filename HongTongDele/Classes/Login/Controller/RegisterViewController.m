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
@property (weak, nonatomic) IBOutlet UIButton *AgreeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *SelectImage;
@property (weak, nonatomic) IBOutlet UITextField *yaoqingma;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation RegisterViewController
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES ];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_phoneTextField resignFirstResponder];
    [_passWordTextField resignFirstResponder];
    [_passWordTwoTextField resignFirstResponder];
    [_codeTextfIELD resignFirstResponder];
    [_yaoqingma resignFirstResponder];
    [_userNameTextField resignFirstResponder];
    
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
- (IBAction)AgreeBtnClick:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = NO;
        self.SelectImage.image = [UIImage imageNamed:@"矩形-6"];
    }else{
        sender.selected = YES;
        self.SelectImage.image = [UIImage imageNamed:@"打钩"];
    }
}
- (IBAction)registerBtnClick:(id)sender {
    if(self.AgreeBtn.selected){
        if([self.passWordTextField.text isEqualToString:self.passWordTwoTextField.text]){
//            [self checkCode];
            [self requestPassWord];
        }else{
            [MBProgressHUD showText:@"两次输入的密码不同"];
        }
    }else{
        [MBProgressHUD showText:@"请先同意协议"];
    }
}


//请求数据,获取验证码
- (void)requestData {
    NSString *URLstring = [NSString stringWithFormat:@"%@/user/gettelcode",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //        manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/json", @"text/html",  @"text/json",@"text/JavaScript", nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setValue:self.phoneTextField.text forKey:@"tel"];
    [manager POST:URLstring parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
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
    
    NSString *URL = [NSString stringWithFormat:@"%@/user/register",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    if ([self.selectbtn.titleLabel.text isEqualToString:@"学生"]) {
//        [parameters setValue:@"students" forKey:@"type"];
//    }else if([self.selectbtn.titleLabel.text isEqualToString:@"家长"]){
//        [parameters setValue:@"family" forKey:@"type"];
//    }else{
//        [parameters setValue:@"teacher" forKey:@"type"];
//    }
    [parameters setValue:self.userNameTextField.text forKey:@"nickname"];
    [parameters setValue:self.passWordTextField.text forKey:@"pwd"];
    [parameters setValue:self.passWordTwoTextField.text forKey:@"repwd"];
    [parameters setValue:self.phoneTextField.text forKey:@"tel"];
    [parameters setValue:self.codeTextfIELD.text forKey:@"code"];
    [parameters setValue:self.yaoqingma.text forKey:@"invite_code"];

    NSLog(@"注册参数:%@",parameters);
    [manager POST:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
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
