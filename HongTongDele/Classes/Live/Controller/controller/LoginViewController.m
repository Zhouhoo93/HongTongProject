//
//  LoginViewController.m
//  LiveLinkAnchor
//
//  Created by Jim on 16/7/8.
//  Copyright © 2016年 yangchuanshuai. All rights reserved.
//

#import "LoginViewController.h"
#import "QRCodeController.h"
#import "LivePlayerViewController.h"
#import "UseIdLoginController.h"
#import "GotyeLiveConfig.h"

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UIView *headerView;

@end


@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_COLOR;
    _loginButton.layer.cornerRadius = 15.0;
    _loginButton.layer.borderColor = COLOR(255, 255, 255, 1).CGColor;
    _loginButton.layer.borderWidth = 1.0;
    _loginButton.backgroundColor = MAIN_COLOR;
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    _loginButton.hidden = (![GotyeLiveConfig config].appkey || ![GotyeLiveConfig config].accessSecret);
}

- (IBAction)didSelectErweima:(id)sender
{
    QRCodeController *viewController = [[QRCodeController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)didSelectLogin:(id)sender
{
    UseIdLoginController *viewController = [[UseIdLoginController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
