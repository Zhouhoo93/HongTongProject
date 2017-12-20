//
//  SelectYunWeiViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/11/16.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "SelectYunWeiViewController.h"
#import "SelectCollectionViewCell.h"
#import "SlectListViewController.h"
@interface SelectYunWeiViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation SelectYunWeiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"运维小组";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self SetCollection];
    // Do any additional setup after loading the view.
}
- (void)SetCollection{
    UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(25, 76, 12, 17)];
    leftImg.image = [UIImage imageNamed:@"定位"];
    [self.view addSubview:leftImg];
    
    UILabel *toplabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 74, 200, 24)];
    toplabel.text = @"分公司";
    [self.view addSubview:toplabel];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 1.设置列间距
    layout.minimumInteritemSpacing = 1;
    // 2.设置行间距
    layout.minimumLineSpacing = 1;
    // 3.设置每个item的大小
    layout.itemSize = CGSizeMake(KWidth/2-10, 200);
    // 4.设置Item的估计大小,用于动态设置item的大小，结合自动布局（self-sizing-cell）
    layout.estimatedItemSize = CGSizeMake(KWidth/2-10, 200);
    // 5.设置布局方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // 6.设置头视图尺寸大小
    layout.headerReferenceSize = CGSizeMake(0, 0);
    // 7.设置尾视图尺寸大小
    layout.footerReferenceSize = CGSizeMake(0, 0);
    // 8.设置分区(组)的EdgeInset（四边距）
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
    // 9.10.设置分区的头视图和尾视图是否始终固定在屏幕上边和下边
    layout.sectionFootersPinToVisibleBounds = YES;
    layout.sectionHeadersPinToVisibleBounds = YES;
    
    //2.初始化collectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,110, KWidth, KHeight-110) collectionViewLayout:layout];
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

//设置每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}

//设置返回每个item的属性必须实现）
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //在这里注册自定义的XIBcell否则会提示找不到标示符指定的cell
    UINib *nib = [UINib nibWithNibName:@"SelectCollectionViewCell"bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"selectFen"];
    SelectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"selectFen" forIndexPath:indexPath];
    cell.NameLabel.text = [NSString stringWithFormat:@"运维小组%ld",indexPath.row+1];
    cell.leftImg.image = [UIImage imageNamed:@"运维"];
    return cell;
}
//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SlectListViewController *vc = [[SlectListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
