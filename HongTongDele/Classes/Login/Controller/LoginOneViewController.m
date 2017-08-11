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
@interface LoginOneViewController ()

@end

@implementation LoginOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES ];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (IBAction)ForgetBtnClick:(id)sender {
}
- (IBAction)LoginBtnClick:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *baseNaviVC = [storyboard instantiateViewControllerWithIdentifier:@"Main"];
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.window.rootViewController =baseNaviVC;
}
- (IBAction)RegisterBtnClick:(id)sender {
    RegisterViewController *vc = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
