//
//  XiaoLvErrorViewController.m
//  HongTongDele
//
//  Created by 天下 on 2018/4/23.
//  Copyright © 2018年 xinyuntec. All rights reserved.
//

#import "XiaoLvErrorViewController.h"
#import "XiaoLvErrorTableViewCell.h"
#import "AppDelegate.h"
#import "LoginOneViewController.h"
#import "XiaoLvErrorModel.h"
#import "XiaoLvBaoJingModel.h"
#import "HuiZhiViewController.h"
#import "BaoJingXiangViewController.h"
@interface XiaoLvErrorViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blueToLeft;
@property (nonatomic,strong)UIScrollView *bgscrollerView;
@property (nonatomic,strong)UITableView *leftTableView;
@property (nonatomic,strong)UITableView *rightTableView;
@property (nonatomic,strong)XiaoLvErrorModel *model;
@property (nonatomic,strong)XiaoLvBaoJingModel *modelRight;
@property (nonatomic,strong)NSMutableArray *leftArr;
@property (nonatomic,strong)NSMutableArray *rightArr;
@property (nonatomic,assign)BOOL didEndDecelerating;
@end

@implementation XiaoLvErrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"效率异常电站列表";
    [self setUI];
    [self requestLeftList];
    [self requestRightList];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUI{
    self.bgscrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 108, KWidth, KHeight-108)];
    self.bgscrollerView.contentSize = CGSizeMake(KWidth*2, KHeight-108);
    self.bgscrollerView.delegate = self;
    self.bgscrollerView.pagingEnabled = YES;
    [self.view addSubview:self.bgscrollerView];
    
    self.leftTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0,KWidth,KHeight-108)style:UITableViewStylePlain];
    self.leftTableView.delegate=self;
    self.leftTableView.dataSource=self;
    self.leftTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.bgscrollerView addSubview:self.leftTableView];
    
    self.rightTableView=[[UITableView alloc]initWithFrame:CGRectMake(KWidth,0,KWidth,KHeight-108)style:UITableViewStylePlain];
    self.rightTableView.delegate=self;
    self.rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.rightTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.rightTableView.dataSource=self;
    [self.bgscrollerView addSubview:self.rightTableView];
}
- (IBAction)leftBtnClick:(id)sender {
//    [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.rightBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.blueToLeft.constant = 20;
    [self.bgscrollerView setContentOffset:CGPointMake(0,0) animated:YES];
}
- (IBAction)rightBtnClick:(id)sender {
//    [self.leftBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.blueToLeft.constant = KWidth/2+20;
    [self.bgscrollerView setContentOffset:CGPointMake(KWidth,0) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark tableView的代理
//tableView的分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}
//每组返回多少个cell
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_leftTableView) {
        return _leftArr.count;
    }else{
        return _rightArr.count;
    }
}
//设置cell的高度,默认高度64
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_leftTableView) {
        static NSString *NODE_CELL_ID = @"zhuanti_cell_id1";
        XiaoLvErrorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NODE_CELL_ID];
        if(!cell){//如果没有创建mycell的话
            //通过xib的方式加载单元格
            cell = [[[NSBundle mainBundle] loadNibNamed:@"XiaoLvErrorTableViewCell" owner:nil options:nil] firstObject];
            //把模型数据设置给单元格
            if (tableView==_leftTableView) {
                _model = _leftArr[indexPath.row];
            }else{
                _model = _rightArr[indexPath.row];
            }
            cell.xuhaoLabel.text = [NSString stringWithFormat:@"序号: %@",self.model.ID];
            cell.timeLabel.text = [NSString stringWithFormat:@"%@",self.model.created_at];
            cell.zhuangtaiLabel.text = [NSString stringWithFormat:@"%@",self.model.result];
            NSString *str = [NSString stringWithFormat:@"%@",self.model.type];
            if ([str isEqualToString:@"0"]) {
                cell.leixingLabel.text = [NSString stringWithFormat:@"类型:三天效率异常"];
            }else{
                cell.leixingLabel.text = [NSString stringWithFormat:@"报警"];
            }
            
        }
        return cell;
    }else{
        static NSString *NODE_CELL_ID = @"zhuanti_cell_id2";
        XiaoLvErrorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NODE_CELL_ID];
        if(!cell){//如果没有创建mycell的话
            //通过xib的方式加载单元格
            cell = [[[NSBundle mainBundle] loadNibNamed:@"XiaoLvErrorTableViewCell" owner:nil options:nil] firstObject];
            //把模型数据设置给单元格
            
                _modelRight = _rightArr[indexPath.row];
                cell.xuhaoLabel.text = [NSString stringWithFormat:@"序号: %@",self.modelRight.ID];
                cell.timeLabel.text = [NSString stringWithFormat:@"%@",self.modelRight.created_at];
//                cell.zhuangtaiLabel.text = [NSString stringWithFormat:@"%@",self.modelRight.result];
                NSString *str = [NSString stringWithFormat:@"%@",self.modelRight.type];
                if ([str isEqualToString:@"0"]) {
                    cell.leixingLabel.text = [NSString stringWithFormat:@"类型:三天效率异常"];
                }else{
                    cell.leixingLabel.text = [NSString stringWithFormat:@"报警"];
                }
            
            
            
        }
        return cell;
    }
    
    
        
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView==_leftTableView) {
        HuiZhiViewController *vc = [[HuiZhiViewController alloc] init];
        vc.model = self.leftArr[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        BaoJingXiangViewController *vc = [[BaoJingXiangViewController alloc] init];
        vc.model = self.rightArr[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat index = scrollView.contentOffset.x/KWidth;
    NSLog(@"%f",index);
    if (index>0.5) {
        self.blueToLeft.constant = KWidth/2+20;
    }else{
        self.blueToLeft.constant = 20;
    }
}
    -(void)requestLeftList{
        
        NSString *URL = [NSString stringWithFormat:@"%@/check/list",kUrl];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [userDefaults valueForKey:@"token"];
        NSLog(@"token:%@",token);
        [userDefaults synchronize];
        [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
        
        //    NSLog(@"parameters:%@",parameters);
        //type:值(handle 和  inhandle)
        [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"获取回执数据正确%@",responseObject);
            
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
                [_leftArr removeAllObjects];
                for (NSMutableDictionary *dic in responseObject[@"content"]) {
                    _model = [[XiaoLvErrorModel alloc] initWithDictionary:dic];
                    [self.leftArr addObject:_model];
                }
                //            [self setTabel];
                //            [self setLeftTable];
                [self.leftTableView reloadData];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"失败%@",error);
            //        [MBProgressHUD showText:@"%@",error[@"error"]];
        }];
        
        
    }
    -(void)requestRightList{
        
        NSString *URL = [NSString stringWithFormat:@"%@/check/alert",kUrl];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [userDefaults valueForKey:@"token"];
        NSLog(@"token:%@",token);
        [userDefaults synchronize];
        [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
        
        //    NSLog(@"parameters:%@",parameters);
        //type:值(handle 和  inhandle)
        [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
            
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
                [_rightArr removeAllObjects];
                
                for (NSMutableDictionary *dic in responseObject[@"content"]) {
                    self.modelRight = [[XiaoLvBaoJingModel alloc] initWithDictionary:dic];
                    [self.rightArr addObject:self.modelRight];
                }
                //            [self setTabel];
                //            [self setLeftTable];
                [self.rightTableView reloadData];
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
    -(NSMutableArray *)leftArr{
        if (!_leftArr) {
            _leftArr = [[NSMutableArray alloc] initWithCapacity:0];
        }
        return _leftArr;
    }
    -(NSMutableArray *)rightArr{
        if (!_rightArr) {
            _rightArr = [[NSMutableArray alloc] initWithCapacity:0];
        }
        return _rightArr;
    }
-(XiaoLvErrorModel *)model{
    if (!_model) {
        _model = [[XiaoLvErrorModel alloc] init];
    }
    return _model;
}
-(XiaoLvBaoJingModel *)modelRight{
    if (!_modelRight) {
        _modelRight = [[XiaoLvErrorModel alloc] init];
    }
    return _modelRight;
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
