//
//  QRCodeController.m
//  LiveLinkAnchor
//
//  Created by Jim on 16/7/7.
//  Copyright © 2016年 yangchuanshuai. All rights reserved.
//

#import "QRCodeController.h"
#import "TripleDES.h"
#import "NSObject+JSON.h"
#import "GLCore.h"
#import "GotyeLiveConfig.h"
#import "UseIdLoginController.h"
#import "MBProgressHUD.h"

#import <AVFoundation/AVFoundation.h>

@interface QRCodeController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, AVCaptureMetadataOutputObjectsDelegate>
{
    dispatch_queue_t _decodeQueue;
}

@property (strong, nonatomic) AVCaptureDevice            *device;
@property (strong, nonatomic) AVCaptureDeviceInput       *input;
@property (strong, nonatomic) AVCaptureMetadataOutput    *output;
@property (strong, nonatomic) AVCaptureSession           *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;

@property (strong, nonatomic) UIView *scanView ;
@property (strong, nonatomic) UIImageView *scanLine;
@property (strong, nonatomic) UITextView *scanResult;


@end

@implementation QRCodeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _decodeQueue = dispatch_queue_create("com.gotye.gotyeliveapp.qrcode", 0);
    [self initScan];
    [self initNavigationBar];
    
    [self lineAnimation];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startScan];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopScan];
}


- (void)initNavigationBar
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 20, 40, 40);
    backBtn.layer.cornerRadius = 3;
    backBtn.tag = 1;
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"ab_ic_back"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *photoShop = [UIButton buttonWithType:UIButtonTypeCustom];
    photoShop.frame = CGRectMake(kScreenWidth/2-20, 20, 40, 40);
    photoShop.tag = 2;
    photoShop.backgroundColor = [UIColor clearColor];
    [photoShop setImage:[UIImage imageNamed:@"camera_on"] forState:UIControlStateNormal];
    [self.view addSubview:photoShop];
    [photoShop addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *light = [UIButton buttonWithType:UIButtonTypeCustom];
    light.frame = CGRectMake(kScreenWidth-60, 20, 40, 40);
    light.layer.cornerRadius = 3;
    light.tag = 3;
    light.backgroundColor = [UIColor clearColor];
    [light setImage:[UIImage imageNamed:@"icon_lamp_off"] forState:UIControlStateNormal];
    [light setImage:[UIImage imageNamed:@"icon_lamp_on"] forState:UIControlStateSelected];
    light.selected = NO;
    [self.view addSubview:light];
    [light addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark 点击事件
// 导航栏点击事件
- (void)btnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 1:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 2:
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:^{}];
            
        }
            break;
        case 3:
        {
            UIButton *btn = (UIButton *)sender;
            btn.selected = !btn.selected;
            [self enableTorch:btn.selected];
        }
            break;
    }
}



-(void)initScan
{
    dispatch_async(_decodeQueue, ^{
        self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
        
        self.output = [[AVCaptureMetadataOutput alloc]init];
        [self.output setMetadataObjectsDelegate:self queue:_decodeQueue];
        
        self.session = [[AVCaptureSession alloc]init];
        [self.session addInput:self.input];
        [self.session addOutput:self.output];
        self.output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode];
        
        self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.preview.frame = [UIScreen mainScreen].bounds;
        [self.view.layer insertSublayer:self.preview atIndex:0];
        
        //开始捕获
        [self.session startRunning];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
    
    [self initView];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES].labelText = @"正在加载";
}

-(void) initView
{
    self.view.backgroundColor = [UIColor blackColor];
    
    CGSize scanSize = CGSizeMake(kScreenWidth * 3 / 4, kScreenWidth * 3 / 4);
    CGRect scanRect = CGRectMake((kScreenWidth - scanSize.width) / 2, (kScreenHeight - scanSize.height) / 2, scanSize.width, scanSize.height);
    
    //计算rectOfInterest 注意x,y交换位置
    scanRect = CGRectMake(scanRect.origin.y / kScreenHeight, scanRect.origin.x / kScreenWidth, scanRect.size.height / kScreenHeight, scanRect.size.width / kScreenWidth);
    self.output.rectOfInterest = scanRect;
    
    self.scanView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scanSize.width, scanSize.height)];
    self.scanView.center = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), CGRectGetMidY([UIScreen mainScreen].bounds));
    self.scanView.backgroundColor = [UIColor clearColor];
    self.scanView.layer.borderWidth = 0.5f;
    self.scanView.layer.masksToBounds = YES;
    self.scanView.layer.borderColor = COLOR(158, 158, 158, 1).CGColor;
    self.scanView.clipsToBounds = NO;
    [self.view addSubview:self.scanView];

    CGRect scanViewFrame = self.scanView.frame;
    UIView *bgT = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, scanViewFrame.origin.y)];
    bgT.backgroundColor = COLOR(0, 0, 0, 0.5f);
    [self.view addSubview:bgT];
    
    UIView *bgL = [[UIView alloc] initWithFrame:CGRectMake(0, scanViewFrame.origin.y, scanViewFrame.origin.x, scanSize.height)];
    bgL.backgroundColor = COLOR(0, 0, 0, 0.5f);
    [self.view addSubview:bgL];
    
    UIView *bgR = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - scanViewFrame.origin.x, scanViewFrame.origin.y, scanViewFrame.origin.x, scanSize.height)];
    bgR.backgroundColor = COLOR(0, 0, 0, 0.5f);
    [self.view addSubview:bgR];
    
    UIView *bgB = [[UIView alloc] initWithFrame:CGRectMake(0, scanViewFrame.origin.y + scanSize.height, kScreenWidth, kScreenHeight - (scanViewFrame.origin.y + scanSize.height))];
    bgB.backgroundColor = COLOR(0, 0, 0, 0.5f);
    [self.view addSubview:bgB];
    
    UIView *line_1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kBorderWidth, kBorderHeight)];
    line_1.backgroundColor = kBorderColor;
    UIView *line_2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kBorderHeight, kBorderWidth)];
    line_2.backgroundColor = kBorderColor;
    UIView *line_3 = [[UIView alloc] initWithFrame:CGRectMake(scanSize.width - kBorderWidth, 0, kBorderWidth, kBorderHeight)];
    line_3.backgroundColor = kBorderColor;
    UIView *line_4 = [[UIView alloc] initWithFrame:CGRectMake(scanSize.width - kBorderHeight, 0, kBorderHeight, kBorderWidth)];
    line_4.backgroundColor = kBorderColor;
    
    UIView *line_5 = [[UIView alloc] initWithFrame:CGRectMake(0, scanSize.height - kBorderHeight, kBorderWidth, kBorderHeight)];
    line_5.backgroundColor = kBorderColor;
    UIView *line_6 = [[UIView alloc] initWithFrame:CGRectMake(0, scanSize.height - kBorderWidth, kBorderHeight, kBorderWidth)];
    line_6.backgroundColor = kBorderColor;
    UIView *line_7 = [[UIView alloc] initWithFrame:CGRectMake(scanSize.width - kBorderWidth, scanSize.height - kBorderHeight, kBorderWidth, kBorderHeight)];
    line_7.backgroundColor = kBorderColor;
    UIView *line_8 = [[UIView alloc] initWithFrame:CGRectMake(scanSize.width - kBorderHeight, scanSize.height - kBorderWidth, kBorderHeight, kBorderWidth)];
    line_8.backgroundColor = kBorderColor;
    
    [self.scanView addSubview:line_1];
    [self.scanView addSubview:line_2];
    [self.scanView addSubview:line_3];
    [self.scanView addSubview:line_4];
    
    [self.scanView addSubview:line_5];
    [self.scanView addSubview:line_6];
    [self.scanView addSubview:line_7];
    [self.scanView addSubview:line_8];
    
    _scanLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scanSize.width, 3)];
    _scanLine.image = [UIImage imageNamed:@"qrcode_scan_line"];
    [self.scanView addSubview:_scanLine];
    
    UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(scanViewFrame) +Size(24), kScreenWidth, 20)];
    message.text = @"将二维码放入框内，即可自动扫描";
    message.textColor = [UIColor whiteColor];
    message.textAlignment = NSTextAlignmentCenter;
    message.font = [UIFont systemFontOfSize:14.f];
    
    [self.view addSubview:message];
    
}

//设置可扫描区的scanCrop的方法
- (CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)rvBounds
{
    CGFloat x,y,width,height;
    x = rect.origin.y / rvBounds.size.height;
    y = 1 - (rect.origin.x + rect.size.width) / rvBounds.size.width;
    width = (rect.origin.y + rect.size.height) / rvBounds.size.height;
    height = 1 - rect.origin.x / rvBounds.size.width;
    return CGRectMake(x, y, width, height);
}

- (void)enableTorch:(BOOL)enable
{
    [self.session beginConfiguration];
    
    if(self.device.torchAvailable) {
        NSError* err = nil;
        if([self.device lockForConfiguration:&err]) {
            [self.device setTorchMode:( enable ? AVCaptureTorchModeOn : AVCaptureTorchModeOff ) ];
            [self.device unlockForConfiguration];
        } else {
            NSLog(@"Error while locking device for torch: %@", err);
        }
    } else {
        NSLog(@"Torch not available in current camera input");
    }
    
    [self.session commitConfiguration];
}

-(void) stopScan
{
    [self.session stopRunning];
    
    _scanLine.hidden = YES;
}

-(void) startScan
{
    [self.session startRunning];
    
    _scanLine.hidden = NO;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate method implementation

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    // Check if the metadataObjects array is not nil and it contains at least one object.
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        // Get the metadata object.
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            [self stopScan];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *result = [metadataObj stringValue];
                [self intentResult:result];
            });
        }
    }
    
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage * srcImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    dispatch_async(_decodeQueue, ^{
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
        CIImage *image = [[CIImage alloc] initWithImage:srcImage];
        NSArray *features = [detector featuresInImage:image];
        CIQRCodeFeature *feature = [features firstObject];
        
        NSString *result = feature.messageString;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self intentResult:result];
        });
    });
}

#pragma mark 初始化扫描界面
-(void)lineAnimation
{
    [UIView animateWithDuration:2.0f animations:^{
        _scanLine.transform = CGAffineTransformMakeTranslation(0, _scanView.frame.size.height - _scanLine.frame.size.height);
    } completion:^(BOOL finished) {
        _scanLine.transform = CGAffineTransformIdentity;
        [self lineAnimation];
    }];
}

#pragma mark 处理扫描结果

#define kAppkey     (@"appkey")
#define kAccessKey  (@"accessSecret")
#define kRoomId     (@"roomId")
#define kPassword   (@"password")

-(void) intentResult:(NSString *) result
{
    NSLog(@"---%@",result);
    NSDictionary *json = [result JSONValue];
    if (![self validateRootJSON:json]) {
        NSLog(@"parse json failed.\n%@", result);
        [self invalideCode];
        return;
    }
    
    NSString *decrypted = [[TripleDES decrypt:json[@"token"]]stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
    if (!decrypted) {
        NSLog(@"decrypt failed");
        [self invalideCode];
        return;
    }
    
    NSDictionary *token = [decrypted JSONValue];
    if (![self validateToken:token]) {
        NSLog(@"invalid token");
        [self invalideCode];
        return;
    }
    
    //TODO 检测过期时间
    [GotyeLiveConfig config].appkey = json[kAppkey];
    [GotyeLiveConfig config].accessSecret = token[kAccessKey];
    [GotyeLiveConfig config].roomId = [token[kRoomId]stringValue];
    [GotyeLiveConfig config].password = token[kPassword];

    //pop回主登录界面
//    [self.navigationController popViewControllerAnimated:NO];

    UseIdLoginController *controller = [[UseIdLoginController alloc]init];
    controller.fromQRScan = YES;
    
    NSMutableArray *viewControllersInStack = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [viewControllersInStack removeLastObject];
    [viewControllersInStack addObject:controller];
    [self.navigationController setViewControllers:viewControllersInStack animated:YES];
}

- (BOOL)validateRootJSON:(NSDictionary *)json
{
    return json && [json[kAppkey] isKindOfClass:[NSString class]];
}

- (BOOL)validateToken:(NSDictionary *)token
{
    return token
    && [token[kAccessKey] isKindOfClass:[NSString class]]
    && [token[kRoomId] isKindOfClass:[NSNumber class]]
    && [token[kPassword] isKindOfClass:[NSString class]];
}

- (void)invalideCode
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"无效的二维码" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self startScan];
    }];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
