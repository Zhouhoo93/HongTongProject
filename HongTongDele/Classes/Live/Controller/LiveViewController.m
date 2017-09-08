//
//  LiveViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/8/10.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "LiveViewController.h"
#import "AppDelegate.h"
#import "LoginOneViewController.h"
#import "UseIdLoginController.h"
#import "LiveCollectionViewCell.h"
#import "liveListModel.h"
#import "LivePlayerViewController.h"
#import "GLCore.h"
#import "GLRoomPublisher.h"
#import "MBProgressHUD.h"
#import "QRCodeController.h"
#import "GotyeLiveConfig.h"
@interface LiveViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    GLAuthToken *_authToken;
    GLRoomPublisher *_publisher;
    GLRoomSession *_roomSession;
}
@property (nonatomic,copy)NSString *roomID;
@property (nonatomic,copy)NSString *roomWord;
@property (nonatomic,copy)NSString *NickName;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)liveListModel *model;
@property (nonatomic,strong)UIImageView *noDataIMG;
@end

@implementation LiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self kaiqizhibo];
    //规定按钮的位置
    
    //    [self CreatLive];
    //
    
    
}

-(void)creatBtnClick{
    //    UseIdLoginController *vc = [[UseIdLoginController alloc] init];
    //    vc.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:vc animated:YES];
    [self requestCreatLive];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}
- (void)setUI{
    UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 64)];
    topView.image = [UIImage imageNamed:@"top"];
    topView.userInteractionEnabled = YES;
    //    topView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:topView];
    UILabel *topLabel = [[UILabel alloc] initWithFrame: CGRectMake(KWidth/2-50, 22, 100, 20)];
    topLabel.text = @"直播列表";
    topLabel.textColor = [UIColor whiteColor];
    topLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:topLabel];
    
    UIButton *leftbutton=[[UIButton alloc]initWithFrame:CGRectMake(KWidth-80, 20, 80, 44)];
    
    //[leftbutton setBackgroundColor:[UIColor blackColor]];
    
    //    [leftbutton setTitle:@"创建" forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(creatBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [leftbutton setImage:[UIImage imageNamed:@"添加直播"] forState:UIControlStateNormal];
    [topView addSubview:leftbutton];
    
    
//    UIImageView *topImg = [[UIImageView alloc] initWithFrame: CGRectMake(20, 74, 20, 10)];
//    topImg.image = [UIImage imageNamed:@"zhibo"];
//    [self.view addSubview:topImg];
//    
//    UILabel *topimgLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 74, 50, 10)];
//    topimgLabel.text = @"直播列表";
//    topimgLabel.font = [UIFont systemFontOfSize:12];
//    topLabel.textColor = [UIColor whiteColor];
//    [self.view addSubview:topimgLabel];
    
    //创建一个layout布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //创建collectionView 通过一个布局策略layout来创建
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, KHeight-64) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.tag= 10001;
    //    _collectionView.backgroundColor =[UIColor whiteColor];
    //代理设置
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    //    header.stateLabel.hidden = YES;
    self.collectionView.mj_header = header;
    self.collectionView.mj_header.ignoredScrollViewContentInsetTop = self.collectionView.contentInset.top;
    _collectionView.bounces = YES;
    //注册item类型 这里使用系统的类型
    //    _collectionView.alwaysBounceVertical = YES;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"live"];
    [self.view addSubview:_collectionView];
    
    self.noDataIMG = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, KWidth, KHeight-64)];
    self.noDataIMG.image = [UIImage imageNamed:@"直播列表 - 空"];
    [self.collectionView addSubview:self.noDataIMG];
}

- (void)refresh
{
    //    [self requestCreatLive];
    [self kaiqizhibo];
    //    [_collectionView reloadData];
    
}

- (void)kaiqizhibo{
    NSString *URL = [NSString stringWithFormat:@"%@/live-t/get-room-list",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    [manager POST:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"获取直播正确%@",responseObject);
        
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
            [_dataArr removeAllObjects];
            for (NSMutableDictionary *dic in responseObject[@"content"]) {
                _model = [[liveListModel alloc] initWithDictionary:dic];
                [self.dataArr addObject:_model];
            }
            if (self.dataArr.count>0) {
                _noDataIMG.hidden = YES;
            }else{
                _noDataIMG.hidden = NO;
            }
            [_collectionView reloadData];
            if (_collectionView.mj_header.isRefreshing) {
                [_collectionView.mj_header endRefreshing];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
}
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(KWidth/2-5,KHeight/667*188);
}
//定义每个Section 的 margin
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArr.count;
    
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UINib *nib = [UINib nibWithNibName:@"LiveCollectionViewCell"bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"live"];
    LiveCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"live" forIndexPath:indexPath];
    _model = _dataArr[indexPath.row];
    cell.nameLabel.text = _model.creator;
    cell.typelabel.text = @"小代";
    cell.numbeiLabel.text = [NSString stringWithFormat:@"%@",_model.onlineNum];
    NSString *picURL = _model.pic;
    NSString *status = [NSString stringWithFormat:@"%@",_model.status];
    if([status isEqualToString:@"0"]){
        //        cell.StatusImage.backgroundColor = [UIColor redColor];
        cell.StatusImage.image = [UIImage imageNamed:@"图层-37-拷贝"];
    }else{
        //        cell.StatusImage.backgroundColor = [UIColor greenColor];
        cell.StatusImage.image = [UIImage imageNamed:@"图层-37"];
    }
    //然后就是添加照片语句，这次不是`imageWithName`了，是 imageWithData。
    if (![picURL.class isEqual:[NSNull class]]) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:picURL]];
        cell.headerimg.image = [UIImage imageWithData:data];
    }else{
        cell.headerimg.image = [UIImage imageNamed:@"moren"];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第%ld个",(long)indexPath.row+ 1);
    _model = _dataArr[indexPath.row];
    //    UseIdLoginController *viewController = [[UseIdLoginController alloc] init];
    //    viewController.roomID = _model.roomId;
    //    viewController.roomWord = _model.assistPwd;
    //    viewController.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:viewController animated:YES];
    [self CreatLive];
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

- (void)CreatLive{
#if DEBUG
    [GLCore setDebugLogEnabled:YES];
#endif
    [GLCore registerWithAppKey:@"f26f2370069d4bac816fc73584e35088" accessSecret:@"049e345fd39f442cb20b7fb0c2cc5148" companyId:@"a2a1ed5eb8414c688fb3d060acf5dcd1"];
    _roomID = _model.roomId;
    _roomWord = _model.userPwd;
    NSString *roomId = _roomID;
    NSString *pwd = _roomWord;
    NSString *nickname = @"asd";
    
    //    if (roomId.length == 0 || pwd.length == 0 || nickname.length == 0) {
    //        return;
    //    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _roomSession = [GLCore sessionWithType:GLRoomSessionTypeDefault roomId:roomId password:pwd nickname:nickname bindAccount:nil];
    
    @weakify(self);
    
    [_roomSession authOnSuccess:^(GLAuthToken *authToken) {
        
        @strongify(self);
        if (!strong_self) {
            return;
        }
        
        [GotyeLiveConfig config].roomId = strong_self->_roomID;
        [GotyeLiveConfig config].password = strong_self->_roomWord;
        [GotyeLiveConfig config].nickname = @"咖喱给给";
        
        strong_self->_authToken = authToken;
        if (strong_self->_authToken.role == GLAuthTokenRolePresenter) {
            [strong_self _loginPublisherWithForce:NO callback:^(NSError *error) {
                if (!error) {
                    [hud hide:YES];
                    LivePlayerViewController *viewController = [[LivePlayerViewController alloc] init];
                    viewController.hidesBottomBarWhenPushed = YES;
                    viewController.isLiveMode  = YES;
                    viewController.roomId = roomId;
                    viewController.publisher = _publisher;
                    [strong_self.navigationController pushViewController:viewController animated:YES];
                    return;
                }
                
                if (error.code == GLPublisherErrorCodeOccupied) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"当前直播间已经有人登录了，继续登录的话将会踢出当前用户的用户。是否继续？" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *goOn = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        @weakify(strong_self);
                        
                        [strong_self _loginPublisherWithForce:YES callback:^(NSError *error) {
                            
                            @strongify(strong_self);
                            
                            if (!strong_strong_self) {
                                return;
                            }
                            
                            if (error) {
                                [strong_strong_self hud:hud showError:error.localizedDescription];
                                return;
                            }
                            
                            [hud hide:YES];
                            LivePlayerViewController *viewController = [[LivePlayerViewController alloc] init];
                            viewController.hidesBottomBarWhenPushed = YES;
                            viewController.isLiveMode  = YES;
                            viewController.roomId = roomId;
                            viewController.isZhuBo = NO;
                            viewController.navigationController.navigationBar.hidden = YES;
                            viewController.publisher = _publisher;
                            [strong_strong_self.navigationController pushViewController:viewController animated:YES];
                        }];
                    }];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [hud hide:YES];
                        [strong_self.view endEditing:YES];
                    }];
                    [alert addAction:cancel];
                    [alert addAction:goOn];
                    
                    [strong_self presentViewController:alert animated:YES completion:nil];
                } else {
                    [strong_self hud:hud showError:error.localizedDescription];
                }
            }];
        } else {
            [hud hide:YES];
            LivePlayerViewController *viewController = [[LivePlayerViewController alloc] init];
            viewController.hidesBottomBarWhenPushed = YES;
            viewController.isLiveMode  = NO;
            viewController.navigationController.navigationBar.hidden = YES;
            viewController.roomId = roomId;
            viewController.isZhuBo = NO;
            viewController.publisher = _publisher;
            [strong_self.navigationController pushViewController:viewController animated:YES];
        }
        
    } failure:^(NSError *error) {
        @strongify(self);
        [strong_self hud:hud showError:error.localizedDescription];
    }];
    
}
- (void)_loginPublisherWithForce:(BOOL)force callback:(void(^)(NSError *error))callback
{
    _publisher = [[GLRoomPublisher alloc]initWithSession:_roomSession];
    [_publisher loginWithForce:force success:^{
        if (callback) {
            callback(nil);
        }
    } failure:^(NSError *error) {
        if (callback) {
            callback(error);
        }
    }];
}

- (void)hud:(MBProgressHUD *)hud showError:(NSString *)error
{
    hud.detailsLabelText = error;
    hud.mode = MBProgressHUDModeText;
    [hud hide:YES afterDelay:1];
}


//
//- (void)LoginOut{
////    [GLCore destroySession:roomSession];
//}

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

-(liveListModel *)model{
    if (!_model) {
        _model = [[liveListModel alloc] init];
    }
    return _model;
}

-(void)requestCreatLive{
    NSString *URL = [NSString stringWithFormat:@"%@/live-t/open-live",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    //    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    //    [parameters setValue:self.userRoomId.text forKey:@"room_name"];
    //    [parameters setValue:self.userPassword.text forKey:@"desc"];
    //    [parameters setValue:self.userNickName.text forKey:@"shareDesc"];
    [manager POST:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"创建直播正确%@",responseObject);
        
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
            
            self.roomID = responseObject[@"content"][@"roomId"];
            self.roomWord = responseObject[@"content"][@"anchorPwd"];
            [self loginGo];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}
- (void)loginGo{
#if DEBUG
    [GLCore setDebugLogEnabled:YES];
#endif
    [GLCore registerWithAppKey:@"f26f2370069d4bac816fc73584e35088" accessSecret:@"049e345fd39f442cb20b7fb0c2cc5148" companyId:@"a2a1ed5eb8414c688fb3d060acf5dcd1"];
    NSString *roomId = _roomID;
    NSString *pwd = _roomWord;
    NSString *nickname = @"主播";
    
    //    if (roomId.length == 0 || pwd.length == 0 || nickname.length == 0) {
    //        return;
    //    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _roomSession = [GLCore sessionWithType:GLRoomSessionTypeDefault roomId:roomId password:pwd nickname:nickname bindAccount:nil];
    
    @weakify(self);
    
    [_roomSession authOnSuccess:^(GLAuthToken *authToken) {
        
        @strongify(self);
        if (!strong_self) {
            return;
        }
        
        [GotyeLiveConfig config].roomId = strong_self->_roomID;
        [GotyeLiveConfig config].password = strong_self->_roomWord;
        [GotyeLiveConfig config].nickname = @"咖喱给给";
        
        strong_self->_authToken = authToken;
        if (strong_self->_authToken.role == GLAuthTokenRolePresenter) {
            [strong_self _loginPublisherWithForce:NO callback:^(NSError *error) {
                if (!error) {
                    [hud hide:YES];
                    LivePlayerViewController *viewController = [[LivePlayerViewController alloc] init];
                    viewController.hidesBottomBarWhenPushed = YES;
                    viewController.isLiveMode  = YES;
                    viewController.roomId = roomId;
                    viewController.isZhuBo = YES;
                    viewController.publisher = _publisher;
                    [strong_self.navigationController pushViewController:viewController animated:YES];
                    return;
                }
                
                if (error.code == GLPublisherErrorCodeOccupied) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"当前直播间已经有人登录了，继续登录的话将会踢出当前用户的用户。是否继续？" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *goOn = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        @weakify(strong_self);
                        
                        [strong_self _loginPublisherWithForce:YES callback:^(NSError *error) {
                            
                            @strongify(strong_self);
                            
                            if (!strong_strong_self) {
                                return;
                            }
                            
                            if (error) {
                                [strong_strong_self hud:hud showError:error.localizedDescription];
                                return;
                            }
                            
                            [hud hide:YES];
                            LivePlayerViewController *viewController = [[LivePlayerViewController alloc] init];
                            viewController.hidesBottomBarWhenPushed = YES;
                            viewController.isLiveMode  = YES;
                            viewController.roomId = roomId;
                            viewController.isZhuBo = NO;
                            viewController.isZhuBo = YES;
                            viewController.navigationController.navigationBar.hidden = YES;
                            viewController.publisher = _publisher;
                            [strong_strong_self.navigationController pushViewController:viewController animated:YES];
                        }];
                    }];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [hud hide:YES];
                        [strong_self.view endEditing:YES];
                    }];
                    [alert addAction:cancel];
                    [alert addAction:goOn];
                    
                    [strong_self presentViewController:alert animated:YES completion:nil];
                } else {
                    [strong_self hud:hud showError:error.localizedDescription];
                }
            }];
        } else {
            [hud hide:YES];
            LivePlayerViewController *viewController = [[LivePlayerViewController alloc] init];
            viewController.hidesBottomBarWhenPushed = YES;
            viewController.isLiveMode  = NO;
            viewController.navigationController.navigationBar.hidden = YES;
            viewController.roomId = roomId;
            //            viewController.isZhuBo = NO;
            viewController.isZhuBo = YES;
            viewController.publisher = _publisher;
            [strong_self.navigationController pushViewController:viewController animated:YES];
        }
        
    } failure:^(NSError *error) {
        @strongify(self);
        [strong_self hud:hud showError:error.localizedDescription];
    }];
    
}
//- (void)_loginPublisherWithForce:(BOOL)force callback:(void(^)(NSError *error))callback
//{
//    _publisher = [[GLRoomPublisher alloc]initWithSession:_roomSession];
//    [_publisher loginWithForce:force success:^{
//        if (callback) {
//            callback(nil);
//        }
//    } failure:^(NSError *error) {
//        if (callback) {
//            callback(error);
//        }
//    }];
//}
//
//- (void)hud:(MBProgressHUD *)hud showError:(NSString *)error
//{
//    hud.detailsLabelText = error;
//    hud.mode = MBProgressHUDModeText;
//    [hud hide:YES afterDelay:1];
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
