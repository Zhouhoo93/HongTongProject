//
//  LiveViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/8/10.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "LiveViewController.h"
#import "GLCore.h"
#import "GLRoomPublisher.h"
#import "UseIdLoginController.h"
@interface LiveViewController ()<GLRoomPublisherDelegate>
@property (nonatomic,strong)GLRoomPublisher *publisher;
@end

@implementation LiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self CreatLive];
    UseIdLoginController *viewController = [[UseIdLoginController alloc] init];
//    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}
//- (void)CreatLive{
//    GLRoomSession *roomSession = [GLCore sessionWithType:GLRoomSessionTypeDefault
//                                                  roomId:@"2221262"
//                                                password:@"IYC8M7"
//                                                nickname:@"主播"
//                                             bindAccount:nil];
//
//    //创建后需要调用session的验证接口进行验证
//    [roomSession authOnSuccess:^(GLAuthToken *authToken) {
//        //验证成功
//        _publisher = [[GLRoomPublisher alloc]initWithSession:roomSession];
//        //设置回调
//        _publisher.delegate = self;
//        [_publisher startPreview:self.view success:^{
//            NSLog(@"preview success");
//            [_publisher loginWithForce:YES success:^{
//                //登录成功
//                NSLog(@"直播登陆成功");
//                [_publisher publish];
//            } failure:^(NSError *error) {
//                //登录失败
//            }];
//
//        } failure:^(NSError *error) {
//            //一般情况下只有用户禁止了app的相机权限才会导致摄像头打开失败
//            NSLog(@"preview failed. %@", error);
//        }];
//
//
//        
//            } failure:^(NSError *error) {
//        //验证失败
//    }];
//    }
//
//- (void)LoginOut{
////    [GLCore destroySession:roomSession];
//}

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
