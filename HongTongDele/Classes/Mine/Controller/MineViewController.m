//
//  MineViewController.m
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/7/24.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "MineViewController.h"
#import "MineCenterViewController.h"
//#import "ReleaseViewController.h"
#import "LoginOneViewController.h"
//#import "StuMineCenterViewController.h"
#import "SettingViewController.h"
//#import "ZhanghaoViewController.h"
//#import "TeacherMineViewController.h"
//#import "LoginViewController.h"
#import "AppDelegate.h"
#import "AboutViewController.h"
@interface MineViewController ()
@property (nonatomic,strong) UIImageView *touImage;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *phoneLabel;
@property (nonatomic,strong) UIButton *nameBtn;
@property (nonatomic,copy)NSString *userName;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationController setNavigationBarHidden:YES];
    
    [self setHeaderView];
    [self setTable];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self requestData];
}

- (void)setHeaderView{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 220)];
//    imageView.backgroundColor = [UIColor grayColor];
    imageView.image = [UIImage imageNamed:@"图层-21"];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, KWidth,64 )];
    label.text = @"个人中心";
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:label];
    
    _touImage = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth/2-30, 82, 60, 60)];
    _touImage.backgroundColor = [UIColor lightGrayColor];
    _touImage.layer.masksToBounds = YES;
    _touImage.layer.cornerRadius = 30;
    _touImage.image = [UIImage imageNamed:@"图层-22"];

    UIButton *headerBtn = [[UIButton alloc] initWithFrame:CGRectMake(KWidth/2-30, 82, 60, 60)];
    [headerBtn addTarget:self action:@selector(headerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:headerBtn];
    
    
    [imageView addSubview:_touImage];
    
    self.nameBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 150, KWidth, 25)];
    [self.nameBtn setTitle:@"未设定昵称" forState:UIControlStateNormal];
    [self.nameBtn setImage:[UIImage imageNamed:@"个人中心编辑"] forState:UIControlStateNormal];
    [self.nameBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    CGFloat imageWidth = self.nameBtn.imageView.bounds.size.width;
    CGFloat labelWidth = self.nameBtn.titleLabel.bounds.size.width;
    self.nameBtn.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth, 0, -labelWidth);
    self.nameBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
    [self.nameBtn addTarget:self action:@selector(nameBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:self.nameBtn];
    //    UIImageView *location = [[UIImageView alloc] initWithFrame:CGRectMake(105, 90, 9, 13)];
    //    location.image = [UIImage imageNamed:@"center_location"];
    //    [self.view addSubview:location];
    //
    _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2-70, 180,140, 25)];
    _phoneLabel.numberOfLines = 0;
    _phoneLabel.text = @"手机:";
    _phoneLabel.textAlignment = NSTextAlignmentCenter;
    _phoneLabel.textColor = [UIColor whiteColor];
    _phoneLabel.font = [UIFont systemFontOfSize:13];
    [imageView addSubview:_phoneLabel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTable{
//    UIView *one = [[UIView alloc] initWithFrame:CGRectMake(0, 220, KWidth, 44)];
//    one.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:one];
//    
//    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 100, 24)];
//    textLabel.text = @"学校信息";
//    textLabel.textColor = [UIColor grayColor];
//    [one addSubview:textLabel];
//    UIImageView *tipImage = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-20, 16, 7, 12)];
//    tipImage.image = [UIImage imageNamed:@"个人中心三角"];
//    [one addSubview:tipImage];
//    UIButton *oneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, KWidth, 44)];
////    [oneBtn addTarget:self action:@selector(oneBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [one addSubview:oneBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 220, KWidth, 20)];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:lineView];
    
    for (int i=0; i<3; i++) {
        UIView *two = [[UIView alloc] initWithFrame:CGRectMake(0, 240+i*44, KWidth, 44)];
        two.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:two];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 43, KWidth-20, 1)];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [two addSubview:line];
        
        UILabel *textLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 100, 24)];
        textLabel2.textColor = [UIColor grayColor];
        [two addSubview:textLabel2];
        UIImageView *tipImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-20, 16, 7, 12)];
        tipImage2.image = [UIImage imageNamed:@"图层-20-拷贝"];
        [two addSubview:tipImage2];
        UIButton *oneBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(0,0, KWidth, 44)];
        [two addSubview:oneBtn2];
        if (i==0) {
            textLabel2.text = @"账号中心";
            [oneBtn2 addTarget:self action:@selector(twoBtnClick) forControlEvents:UIControlEventTouchUpInside];
        }else if (i==1){
            textLabel2.text = @"系统设置";
            [oneBtn2 addTarget:self action:@selector(threeBtnClick) forControlEvents:UIControlEventTouchUpInside];

        }else{
            textLabel2.text = @"关于我们";
            [oneBtn2 addTarget:self action:@selector(fourBtnClick) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    UIView *garyView = [[UIView alloc] initWithFrame:CGRectMake(0, 372, KWidth, KHeight-372)];
    garyView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:garyView];
    
    UIButton *outLoginBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, KWidth-40, 34)];
    [outLoginBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
    outLoginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [outLoginBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [outLoginBtn setBackgroundImage:[UIImage imageNamed:@"圆角矩形-1"] forState:UIControlStateNormal];
    [outLoginBtn addTarget:self action:@selector(logOutAction) forControlEvents:UIControlEventTouchUpInside];
    [garyView addSubview:outLoginBtn];
    
}
- (void)twoBtnClick{
    MineCenterViewController *vc = [[MineCenterViewController alloc] init];
    vc.userName = self.userName;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)headerBtnClick{
    //判断手机的系统,8.0以上使用UIAlertController,一下使用UIAlertView
    if (iOS8) {
        
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        alert.view.tintColor = [UIColor blackColor];
        //通过拍照上传图片
        UIAlertAction * takingPicAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                
                UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
            
        }];
        //从手机相册中选择上传图片
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
                UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
            
        }];
        
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:takingPicAction];
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }else{
        
        UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机相册选择", nil];
        [actionSheet showInView:self.view];
    }

}
- (void)nameBtnClick{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *type = [userDefaults valueForKey:@"type"];
//    if([type isEqualToString:@"学生"]){
//        StuMineCenterViewController *vc = [[StuMineCenterViewController alloc] initWithNibName:@"StuMineCenterViewController" bundle:nil];
//        [self.navigationController pushViewController:vc animated:YES];
//    }else if([type isEqualToString:@"家长"]){
//        MineCenterViewController *vc = [[MineCenterViewController alloc] initWithNibName:@"MineCenterViewController" bundle:nil];
//        [self.navigationController pushViewController:vc animated:YES];
//    }else{
//        TeacherMineViewController *vc = [[TeacherMineViewController alloc] initWithNibName:@"TeacherMineViewController" bundle:nil];
//        [self.navigationController pushViewController:vc animated:YES];
//        
//    }

}
- (void)threeBtnClick{
    SettingViewController *vc = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)fourBtnClick{
    AboutViewController *vc = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)logOutAction{
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确定退出登录吗" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
        [self clearLocalData];
        LoginOneViewController *VC =[[LoginOneViewController alloc] init];
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:sureAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)requestData{
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
            if ([errorcode isEqualToString:@"4100"])  {
                [MBProgressHUD showText:@"请重新登陆"];
                [self newLogin];
            }else{
            NSString *str = responseObject[@"result"][@"errorMsg"];
            [MBProgressHUD showText:str];
            }
        }else{
                self.userName = responseObject[@"content"][@"username"];
                NSString *nameText = responseObject[@"content"][@"username"];
                [self.nameBtn setTitle:nameText forState:UIControlStateNormal];
                NSString *tel = responseObject[@"content"][@"tel"];
                self.phoneLabel.text = [NSString stringWithFormat:@"手机:%@",tel];
                NSString *picURL = responseObject[@"content"][@"pic"];
                
                //然后就是添加照片语句，这次不是`imageWithName`了，是 imageWithData。
                if (![picURL.class isEqual:[NSNull class]]) {
                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:picURL]];
                    self.touImage.image = [UIImage imageWithData:data];
                }else{
                    self.touImage.image = [UIImage imageNamed:@"moren"];
                }

            
            
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
#pragma mark 调用系统相册及拍照功能实现方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage * chosenImage = info[UIImagePickerControllerEditedImage];
    UIImageView * picImageView = (UIImageView *)[self.view viewWithTag:500];
   
    chosenImage = [self imageWithImageSimple:chosenImage scaledToSize:CGSizeMake(60, 60)];
    dispatch_async(dispatch_get_main_queue(), ^{
        picImageView.image = chosenImage;
    });
    NSData * imageData = UIImageJPEGRepresentation(chosenImage, 0.5);
    //        [self saveImage:chosenImage withName:@"avatar.png"];
    //        NSURL * filePath = [NSURL fileURLWithPath:[self documentFolderPath]];
    
    //将图片上传到服务器
    //    --------------------------------------------------------
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/javascript",@"text/json", nil];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSString * urlString = [NSString stringWithFormat:@"%@/agent/index",kUrl];

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    //    [dic setValue:imageData forKey:@"upload_file"];
//    [dic setValue:@"app" forKey:@"pic"];
    [manager POST:urlString parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //通过post请求上传用户头像图片,name和fileName传的参数需要跟后台协商,看后台要传的参数名
        [formData appendPartWithFileData:imageData name:@"pic" fileName:@"pic" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析后台返回的结果,如果不做一下处理,打印结果可能是一些二进制流数据
        NSLog(@"上传头像:%@",responseObject);
        if ([responseObject[@"result"][@"success"] intValue] ==0) {
            [MBProgressHUD showText:@"上传头像失败"];
        }else{
            NSString *picURL = responseObject[@"content"];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:picURL]];
            //然后就是添加照片语句，这次不是`imageWithName`了，是 imageWithData。
            if (data.length > 0) {
                self.touImage.image = [UIImage imageWithData:data];
            }else{
                self.touImage.image = [UIImage imageNamed:@"moren"];
            }

//        [_tableView reloadData];
//        [_myDelegate genggai];
        NSLog(@"上传图片成功0---%@",responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传图片-- 失败  -%@",error);
    }];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    
}
//用户取消选取时调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
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