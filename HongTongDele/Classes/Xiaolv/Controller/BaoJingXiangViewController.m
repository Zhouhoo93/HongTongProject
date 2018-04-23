//
//  BaoJingXiangViewController.m
//  HongTongDele
//
//  Created by 天下 on 2018/4/23.
//  Copyright © 2018年 xinyuntec. All rights reserved.
//

#import "BaoJingXiangViewController.h"
#import "AppDelegate.h"
#import "LoginOneViewController.h"
@interface BaoJingXiangViewController ()

@end

@implementation BaoJingXiangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)requestData{
    NSString *URL = [NSString stringWithFormat:@"%@/check/alertInfo",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.model.ID forKey:@"id"];
    [parameters setValue:self.model.work_id forKey:@"work_id"];
    [parameters setValue:self.model.addr forKey:@"addr"];
    [parameters setValue:self.model.type forKey:@"type"];
    [parameters setValue:self.model.abnormal_id forKey:@"abnormal_id"];
    [parameters setValue:self.model.police_id forKey:@"police_id"];
    [parameters setValue:self.model.read forKey:@"read"];
    [parameters setValue:self.model.created_at forKey:@"created_at"];
    [parameters setValue:self.model.updated_at forKey:@"updated_at"];
    NSLog(@"parameters:%@",parameters);
    //type:值(handle 和  inhandle)
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取报警数据正确%@",responseObject);
        
        if ([responseObject[@"result"][@"success"] intValue] ==0) {
            NSNumber *code = responseObject[@"result"][@"errorCode"];
            NSString *errorcode = [NSString stringWithFormat:@"%@",code];
            if ([errorcode isEqualToString:@"3100"])  {
                [MBProgressHUD showText:@"请重新登陆"];
                [self newLogin];
            }else{
                NSString *str = responseObject[@"result"][@"errorMsg"];
                [MBProgressHUD showText:str];
            }
        }else{
            self.huhaoLabel.text = [NSString stringWithFormat:@"户号:%@",responseObject[@"content"][@"home"]];
            self.shebeibianhaoLabel.text = [NSString stringWithFormat:@"设备编号:%@",responseObject[@"content"][@"bid"]];
            self.baojingyuanyinLabel.text = [NSString stringWithFormat:@"报警原因:%@",responseObject[@"content"][@"cause"]];
            NSString *Str = [NSString stringWithFormat:@"%@",responseObject[@"content"][@"status"]];
            if ([Str isEqualToString:@"0"]) {
                self.chulizhuangtaiLabel.text = [NSString stringWithFormat:@"处理状态:未处理"];
            }else if ([Str isEqualToString:@"1"]) {
                self.chulizhuangtaiLabel.text = [NSString stringWithFormat:@"处理状态:处理中"];
            }else{
                self.chulizhuangtaiLabel.text = [NSString stringWithFormat:@"处理状态:已处理"];
            }
            
            self.dizhiLabel.text = [NSString stringWithFormat:@"地址:%@",responseObject[@"content"][@"addr"]];
            self.fashengshijianLabel.text = [NSString stringWithFormat:@"发生时间:%@",responseObject[@"content"][@"created_at"]];
            self.xiangyingshijianLabel.text = [NSString stringWithFormat:@"响应时间:%@",responseObject[@"content"][@"response"]];
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
-(XiaoLvBaoJingModel *)model{
    if (!_model) {
        _model = [[XiaoLvBaoJingModel alloc] init];
    }
    return _model;
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
