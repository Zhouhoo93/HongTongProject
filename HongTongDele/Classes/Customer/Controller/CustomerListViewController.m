//
//  CustomerListViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/9/1.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "CustomerListViewController.h"
#import "AppDelegate.h"
#import "LoginOneViewController.h"
#import "CustomerListModel.h"
#import "CustomerListTableViewCell.h"
#import <RongIMKit/RongIMKit.h>
@interface CustomerListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *listTableView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)CustomerListModel *model;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic,strong)UIBarButtonItem *anotherButton;
@end

@implementation CustomerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系列表";
    [self setUI];
    [self requestListData];
    self.anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"群组" style:UIBarButtonSystemItemAdd
                                                                     target:self action:@selector(qunzuBtnClick)];
    self.navigationItem.rightBarButtonItem = self.anotherButton;
    // Do any additional setup after loading the view.
}

- (void)qunzuBtnClick{
    if ([_anotherButton.title isEqualToString:@"群组"]){
        self.anotherButton.title = @"完成";
        [self.listTableView setEditing:YES animated:YES];
    }else{
        self.anotherButton.title = @"群组";
        [self.listTableView setEditing:NO animated:YES];
        [self requestCreat];
        NSLog(@"选中数组%@",self.selectArray);
    }
    

}

- (void)setUI{
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight) style:UITableViewStylePlain];
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    [self.view addSubview:self.listTableView];
}

-(void)requestListData{
    NSString *URL = [NSString stringWithFormat:@"%@/chat/get-relations",kUrl];
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
            [self.listTableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}

-(void)requestCreat{
    NSString *URL = [NSString stringWithFormat:@"%@/createGroup",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSString *userList = [NSString new];
    for (int i=0; i<self.selectArray.count; i++) {
        if (i==0) {
            userList = [NSString stringWithFormat:@"%@",self.selectArray[i]];
        }else{
           userList = [NSString stringWithFormat:@"%@,%@",userList,self.selectArray[i]];
        }
    }
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:@"群组" forKey:@"groupName"];
    [parameters setValue:userList forKey:@"user"];
    NSLog(@"列表 : %@",userList);
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"创建讨论组正确%@",responseObject);
        
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
//            RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
//            conversationVC.conversationType = 1;
//            conversationVC.targetId = [NSString stringWithFormat:@"%@",self.rongID];
//            conversationVC.title = @"客服代理";
//            conversationVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:conversationVC animated:YES];

        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString  *CellIdentiferId = @"CustomerListTableViewCell";
    CustomerListTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"CustomerListTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
        cell.backgroundColor = [UIColor whiteColor];
        _model = _dataArr[indexPath.row];
        cell.nameLabel.text = _model.nick;
        NSString *picURL = _model.headimgurl;
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:picURL]];
        cell.headerImg.image = [UIImage imageWithData:data];
        
        
    };
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}



- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_listTableView.editing) {
        _model = self.dataArr[indexPath.row];
        NSString *userID = _model.user_id;
        if ([self.selectArray containsObject:userID]) {
            [self.selectArray removeObject:userID];
        }
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_listTableView.editing) {
        _model = self.dataArr[indexPath.row];
        NSString *userID = _model.user_id;
        if (![self.selectArray containsObject:userID]) {
            [self.selectArray addObject:userID];
        }

    }else{
    
    _model = _dataArr[indexPath.row];
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.conversationType = 1;
    conversationVC.targetId = [NSString stringWithFormat:@"%@",_model.user_id];
    conversationVC.title = [NSString stringWithFormat:@"%@",_model.nick];
//    conversationVC.hidesBottomBarWhenPushed = YES;
//    [IQKeyboardManager sharedManager].enable = NO;
    [self.navigationController pushViewController:conversationVC animated:YES];
    }
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr;
}

-(NSMutableArray *)selectArray{
    if (!_selectArray) {
        _selectArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _selectArray;
}

-(CustomerListModel *)model {
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
