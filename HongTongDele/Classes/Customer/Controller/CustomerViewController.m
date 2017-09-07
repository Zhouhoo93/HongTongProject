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
//#import "HSingleGlobalData.h"
@implementation CustomerViewController
- (void)viewDidLoad {
    //重写显示相关的接口，必须先调用super，否则会屏蔽SDK默认的处理
    [super viewDidLoad];
    [self requestMineData];
    [self requestListData];
    [self getGroupList];
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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:@"CreatNotification" object:nil];
    
}
- (void)InfoNotificationAction:(NSNotification *)notification{
    
    [self getGroupList];
    
}
-(void)creatBtnClick{
    CustomerListViewController *vc = [[CustomerListViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.selfTargetID = self.telNumber;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)requestMineData{
    NSString *URL = [NSString stringWithFormat:@"%@/agent/index",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取个人信息正确%@",responseObject);
        
        if ([responseObject[@"result"][@"success"] intValue] ==0) {
            NSNumber *code = responseObject[@"result"][@"errorCode"];
            NSString *errorcode = [NSString stringWithFormat:@"%@",code];
            if ([errorcode isEqualToString:@"4100"]||[errorcode isEqualToString:@"3100"])  {
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
            
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}


- (void)getAllMembersOfGroup:(NSString *)groupId
                      result:(void (^)(NSArray<NSString *> *userIdList))resultBlock{
    NSLog(@":%@",resultBlock);
    self.group = groupId;
    NSArray *array =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documents = [array lastObject];
    NSString *documentPath = [documents stringByAppendingPathComponent:@"arrayXML.xml"];
    //第六步：可对已经存储的数组进行查询等操作
    NSArray *resultArray = [NSArray arrayWithContentsOfFile:documentPath];
    NSLog(@"%@,%@", documentPath,resultArray);
    for (int i=0; i<_grouparr.count; i++) {
        NSString *groupna = [NSString stringWithFormat:@"%@",resultArray[i]];
        NSLog(@"groupna:%@",groupna);
        NSLog(@"groupID:%@",groupId);
        if ([groupna isEqualToString:groupId]) {
            NSArray *arr = _grouparr[i];
            NSLog(@"arr:%@",arr);
            NSMutableArray *arrName = [[NSMutableArray alloc] initWithCapacity:0];
            for (int k=0; k<arr.count; k++) {
                NSString *bid = arr[k][@"username"];
                [arrName addObject:bid];
            }
            NSLog(@"arrName:%@",arrName);
            resultBlock(arrName);
        }
    }
    
    
}

- (void)getGroupList{
    NSArray *array =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documents = [array lastObject];
    NSString *documentPath = [documents stringByAppendingPathComponent:@"arrayXML.xml"];
    //第六步：可对已经存储的数组进行查询等操作
    NSArray *resultArray = [NSArray arrayWithContentsOfFile:documentPath];
    NSLog(@"%@,%@", documentPath,resultArray);
    [self.grouparr removeAllObjects];
    for (int i=0; i<resultArray.count; i++) {
        NSString *URL = [NSString stringWithFormat:@"%@/queryUser/%@",kUrl,resultArray[i]];
                NSLog(@"%@请求group:%@",URL,resultArray[i]);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [userDefaults valueForKey:@"token"];
        //        NSLog(@"token:%@",token);
        [userDefaults synchronize];
        [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
        [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"获取群组列表%@",responseObject);
            
            if ([responseObject[@"result"][@"success"] intValue] ==0) {
                
            }else{
                NSArray *group1 =responseObject[@"content"][@"group"];
                [self.grouparr addObject:group1];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"获取群组列表失败%@",error);
            NSLog(@"那个群组%@",resultArray[i]);
            //        [MBProgressHUD showText:@"%@",error[@"error"]];
        }];
        
    }
}



-(void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion{
    NSLog(@"completion:%@",completion);
}

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    NSLog(@"userId:%@,completion:%@",userId,completion);
    if ([userId isEqualToString:self.telNumber]) {
        return completion([[RCUserInfo alloc] initWithUserId:userId name:self.nicheng portrait:self.touxiang]);
        
    }else
    {
        for (int i=0; i<self.dataArr.count; i++) {
            _model = self.dataArr[i];
            if ([userId isEqualToString:_model.ID]) {
                return completion([[RCUserInfo alloc] initWithUserId:userId name:_model.username portrait:_model.pic]);
            }else{
                return completion([[RCUserInfo alloc] initWithUserId:userId name:userId portrait:@""]);
            }
        }
        //设置对方的信息
        
    }
    
}

//重写RCConversationListViewController的onSelectedTableRow事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    //    conversationVC.title = model.objectName;
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
            if ([errorcode isEqualToString:@"4100"]||[errorcode isEqualToString:@"3100"])  {
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
