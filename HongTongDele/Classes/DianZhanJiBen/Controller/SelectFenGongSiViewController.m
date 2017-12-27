//
//  SelectFenGongSiViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/11/13.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "SelectFenGongSiViewController.h"
#import "SelectCollectionViewCell.h"
#import "SlectListViewController.h"
#import "SelectYunWeiViewController.h"
#import "AppDelegate.h"
#import "LoginOneViewController.h"
#import "FenGongSiListModelTwo.h"
@interface SelectFenGongSiViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) FenGongSiListModelTwo *model;
@property (nonatomic,strong) NSMutableArray *dataArr;
@end

@implementation SelectFenGongSiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分公司";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self SetCollection];
    [self requestData];
    // Do any additional setup after loading the view.
}

- (void)SetCollection{
//    UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(25, 76, 12, 17)];
//    leftImg.image = [UIImage imageNamed:@"定位"];
//    [self.view addSubview:leftImg];
//
//    UILabel *toplabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 74, 200, 24)];
//    toplabel.text = @"总公司";
//    [self.view addSubview:toplabel];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 1.设置列间距
    layout.minimumInteritemSpacing = 1;
    // 2.设置行间距
    layout.minimumLineSpacing = 1;
    // 3.设置每个item的大小
    layout.itemSize = CGSizeMake(170, 200);
    // 4.设置Item的估计大小,用于动态设置item的大小，结合自动布局（self-sizing-cell）
//    layout.estimatedItemSize = CGSizeMake(KWidth/2-10, 200);
    // 5.设置布局方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // 6.设置头视图尺寸大小
    layout.headerReferenceSize = CGSizeMake(0, 0);
    // 7.设置尾视图尺寸大小
    layout.footerReferenceSize = CGSizeMake(0, 0);
    // 8.设置分区(组)的EdgeInset（四边距）
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    // 9.10.设置分区的头视图和尾视图是否始终固定在屏幕上边和下边
    layout.sectionFootersPinToVisibleBounds = YES;
    layout.sectionHeadersPinToVisibleBounds = YES;
    
    //2.初始化collectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,76, KWidth, KHeight-70) collectionViewLayout:layout];
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [self.collectionView registerClass:[SelectCollectionViewCell class] forCellWithReuseIdentifier:@"selectFen"];
    //4.设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//设置分区数（必须实现）
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(170.0f, 200.0f);
}


//设置每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArr.count;
}

//设置返回每个item的属性必须实现）
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
 
    //在这里注册自定义的XIBcell否则会提示找不到标示符指定的cell
    UINib *nib = [UINib nibWithNibName:@"SelectCollectionViewCell"bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"selectFen"];
    SelectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"selectFen" forIndexPath:indexPath];
    _model = _dataArr[indexPath.row];
    cell.NameLabel.text = [NSString stringWithFormat:@"%@",_model.role];
    cell.leftImg.image = [UIImage imageNamed:@"分公司"];
    CGFloat install = [_model.total_install_base floatValue]/1000;
    cell.zhuangjirongliang.text = [NSString stringWithFormat:@"%@kW",@(install).description];
    cell.hushu.text = [NSString stringWithFormat:@"%@户",_model.total_number_households];
    cell.fadianliang.text = [NSString stringWithFormat:@"%@度",_model.total_gen_cap];
    cell.wanchenglv.text = [NSString stringWithFormat:@"%@%%",_model.completion_rate];
    return cell;
}
//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    SlectListViewController *vc = [[SlectListViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    _model = _dataArr[indexPath.row];
    SelectYunWeiViewController *vc = [[SelectYunWeiViewController alloc] init];
    vc.companyID = _model.ID;
    vc.selectName = _model.role;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)requestData{
    NSString *URL = [NSString stringWithFormat:@"%@/data/get-role-list",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:@"parent" forKey:@"role"];
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取分公司列表正确%@",responseObject);
        
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
                _model = [[FenGongSiListModelTwo alloc] initWithDictionary:dic];
                [self.dataArr addObject:_model];
            }
            [self.collectionView reloadData];
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
-(FenGongSiListModelTwo *)model{
    if (!_model) {
        _model = [[FenGongSiListModelTwo alloc] init];
    }
    return _model;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr;
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
