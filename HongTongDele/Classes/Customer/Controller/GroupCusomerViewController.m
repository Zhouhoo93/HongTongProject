//
//  GroupCusomerViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/9/6.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "GroupCusomerViewController.h"

@interface GroupCusomerViewController ()<RCIMGroupMemberDataSource,RCIMUserInfoDataSource>

@end

@implementation GroupCusomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getGroupList];
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    //            [[RCIM sharedRCIM] setGroupMemberDataSource:self];
    [RCIM sharedRCIM].groupMemberDataSource = self;
    // 设置消息体内是否携带用户信息
    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    
    // Do any additional setup after loading the view.
}
- (void)getAllMembersOfGroup:(NSString *)groupId
                      result:(void (^)(NSArray<NSString *> *userIdList))resultBlock{
    for (int i=0; i<_groupArr.count; i++) {
 
            NSDictionary *arr = _groupArr[i];
            NSLog(@"arr:%@",arr);
            NSMutableArray *arrName = [[NSMutableArray alloc] initWithCapacity:0];
 
                NSString *bid = arr[@"username"];
                [arrName addObject:bid];
        
            resultBlock(arrName);
        }
    

    
    
}

- (void)getGroupList{
    
        NSString *URL = [NSString stringWithFormat:@"%@/queryUser/%@",kUrl,self.targetId];
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
                self.groupArr =responseObject[@"content"][@"group"];
//                [self.grouparr addObject:group1];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"获取群组列表失败%@",error);
//            NSLog(@"那个群组%@",resultArray[i]);
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSMutableArray *)groupArr{
    if (!_groupArr) {
        _groupArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _groupArr;
}
-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr;
 }

-(CustomerListModel *)model{
    if (!_model) {
        _model = [[CustomerListModel alloc] init];
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
