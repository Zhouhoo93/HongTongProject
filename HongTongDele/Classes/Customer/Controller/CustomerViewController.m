//
//  CustomerViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/8/9.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "CustomerViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "AppDelegate.h"
#import "LoginOneViewController.h"
#import "CustomerListViewController.h"
#import "GroupCusomerViewController.h"
//#import "HSingleGlobalData.h"
@implementation CustomerViewController

- (void)viewDidLoad {
    //重写显示相关的接口，必须先调用super，否则会屏蔽SDK默认的处理
    [super viewDidLoad];
    [self requestListData];
    [self requestMineData];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION)]];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"列表" style:UIBarButtonSystemItemAdd
                                                                     target:self action:@selector(creatBtnClick)];
    anotherButton.image = [UIImage imageNamed:@"通讯录"];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    if (self.conversationListTableView) {
        [self.conversationListTableView reloadData];
    }
}

-(void)creatBtnClick{
    CustomerListViewController *vc = [[CustomerListViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.selfTargetID = self.telNumber;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)requestMineData{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *phone = [userDefaults valueForKey:@"phone"];
    NSString *URL = [NSString stringWithFormat:@"%@/user/getuserinformation",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    
    [manager POST:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取个人信息正确%@",responseObject);
        
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
            [[RCIM sharedRCIM] setUserInfoDataSource:self];
            [[RCIM sharedRCIM] setGroupInfoDataSource:self];
            //            [[RCIM sharedRCIM] setGroupMemberDataSource:self];
            [RCIM sharedRCIM].groupMemberDataSource = self;
            // 设置消息体内是否携带用户信息
            [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
            self.nicheng  = responseObject[@"content"][@"username"];
            self.telNumber = responseObject[@"content"][@"tel"];
            self.touxiang = responseObject[@"content"][@"pic"];
            
            [RCIM sharedRCIM].currentUserInfo = [[RCUserInfo alloc] initWithUserId:self.telNumber name:self.nicheng portrait:self.touxiang];
            // 设置消息体内是否携带用户信息
            [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
            
         
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}


- (void)getAllMembersOfGroup:(NSString *)groupId
                      result:(void (^)(NSArray<NSString *> *userIdList))resultBlock{
    NSString *URL = [NSString stringWithFormat:@"%@/police/queryUser/%@",kUrl,groupId];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取群组列表%@",responseObject);
        
        if ([responseObject[@"result"][@"success"] intValue] ==0) {
            
        }else{
            NSMutableArray *arrName = [[NSMutableArray alloc] initWithCapacity:0];
            NSArray *group1 =responseObject[@"content"][@"group"];
            for (int k=0; k<group1.count; k++) {
                NSString *bid = group1[k][@"username"];
                [arrName addObject:bid];
            }
            resultBlock(arrName);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取群组列表失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];

    
}

-(void)didDeleteConversationCell:(RCConversationModel *)model{
    NSMutableArray *array =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documents = [array lastObject];
    NSString *documentPath = [documents stringByAppendingPathComponent:@"arrayXML.xml"];
    NSString *documentPath1 = [documents stringByAppendingPathComponent:@"arrayXML1.xml"];
    //第六步：可对已经存储的数组进行查询等操作
    NSMutableArray *resultArray = [NSMutableArray arrayWithContentsOfFile:documentPath];
    NSMutableArray *resultArray1 = [NSMutableArray arrayWithContentsOfFile:documentPath1];
    //第六步：可对已经存储的数组进行查询等操作
    NSLog(@"删除cell:%@",model.targetId);
    for (int i=0; i<resultArray.count; i++) {
        NSString *str = [NSString stringWithFormat:@"%@",resultArray[i]] ;
        if ([str isEqualToString:model.targetId]) {
            [resultArray removeObjectAtIndex:i];
            [resultArray1 removeObjectAtIndex:i];
        }
    }
    [resultArray writeToFile:documentPath atomically:YES];
    [resultArray1 writeToFile:documentPath1 atomically:YES];
}





-(void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion{
    
    NSString *URL = [NSString stringWithFormat:@"%@/police/getGroupName/%@",kUrl,groupId];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取groupName正确%@",responseObject);
       return completion([[RCGroup alloc] initWithGroupId:groupId groupName:responseObject[@"content"][@"groupName"] portraitUri:@""]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];

}

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    NSLog(@"userId:%@,userList:%@",userId,self.dataArr);
    if ([userId isEqualToString:self.telNumber]) {
        return completion([[RCUserInfo alloc] initWithUserId:userId name:self.nicheng portrait:self.touxiang]);
        
    }else
    {
        for (int i=0; i<self.dataArr.count; i++) {
            _model = self.dataArr[i];
            if ([userId isEqualToString:_model.bid]) {
                return completion([[RCUserInfo alloc] initWithUserId:userId name:_model.username portrait:_model.pic]);
            }else{
                
            }
        }
        //设置对方的信息
        return completion([[RCUserInfo alloc] initWithUserId:userId name:userId portrait:@""]);
    }
    
}

//重写RCConversationListViewController的onSelectedTableRow事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    GroupCusomerViewController *conversationVC = [[GroupCusomerViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.dataArr = self.dataArr;
    conversationVC.nicheng = self.nicheng;
    conversationVC.touxiang = self.touxiang;
    if (model.conversationType ==1) {
//        conversationVC.title = self.nicheng;
    }else{
//        conversationVC.title = self.groupNicheng;
    }
    conversationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:conversationVC animated:YES];
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

-(void)requestListData{
    NSString *URL = [NSString stringWithFormat:@"%@/getChatList",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取聊天列表正确%@",responseObject);
        
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
            
            for (NSMutableDictionary *dic in responseObject[@"content"]) {
                _model = [[CustomerListModel alloc] initWithDictionary:dic];
                [self.dataArr addObject:_model];
            }
            [self.conversationListTableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr;
}
-(CustomerListModel *)model {
    if (!_model) {
        _model = [[CustomerListModel alloc] init];
    }
    return _model;
}
-(NSMutableArray *)grouparr{
    if (!_grouparr) {
        _grouparr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _grouparr;
}
@end
