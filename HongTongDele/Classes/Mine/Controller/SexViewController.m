//
//  SexViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/12/5.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "SexViewController.h"

@interface SexViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *nanGou;
@property (weak, nonatomic) IBOutlet UIImageView *nvGou;
@property (nonatomic,copy) NSString *sex;

@end

@implementation SexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nanGou.hidden = YES;
    self.nvGou.hidden = YES;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)nanBtncLICK:(id)sender {
    self.nanGou.hidden = NO;
    self.nvGou.hidden = YES;
    self.sex = @"1";
    [self requestPassWord];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)NVbTNcLICK:(id)sender {
    self.nanGou.hidden = YES;
    self.nvGou.hidden = NO;
    self.sex = @"0";
    [self requestPassWord];
}

- (void)requestPassWord {
    NSString *URL = [NSString stringWithFormat:@"%@/user/edit_sex",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    
    [parameters setValue:self.sex forKey:@"sex"];
    [parameters setValue:token forKey:@"token"];

    NSLog(@"修改性别参数:%@",parameters);
    [manager POST:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"修改性别正确%@",responseObject);
        if([responseObject[@"result"][@"success"] intValue] ==1){
            //            [MBProgressHUD showText:@"设置成功"];
            //            [self.navigationController popViewControllerAnimated:YES];
//            [self newLogin];
        }else{
            [MBProgressHUD showText:[NSString stringWithFormat:@"%@",responseObject[@"result"][@"errorMsg"]]];
            NSLog(@"%@",responseObject[@"result"][@"errorMsg"]);
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
