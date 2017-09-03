//
//  LivePlayerViewController.m
//  LiveLinkAnchor
//
//  Created by Jim on 16/7/8.
//  Copyright © 2016年 yangchuanshuai. All rights reserved.
//

#import "LivePlayerViewController.h"
#import "GLPlayer.h"
#import "GLCore.h"
#import "GLPublisher.h"
#import "GLPublisherDelegate.h"
#import "UIView+Extension.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import "GLClientUrl.h"
#import "WeiboSDK.h"
#import <MediaPlayer/MediaPlayer.h>
#import "GLChatObserver.h"
#import "GLChatSession.h"
#import "GLRoomPlayer.h"
#import "GLRoomPublisher.h"
#import "GLRoomPublisherDelegate.h"
#import "QRCodeController.h"
#import "MBProgressHUD.h"
#import "DragButton.h"
#import "MessageCell.h"
#import "CollectionViewCellRoomMember.h"
#import "GLAuthToken.h"
#import "UserListCell.h"
#import "GLUser.h"
#import "GLPeerClient.h"
#import "GLRoomPublisher+PeerConnection.h"
#import "GLRoomPlayer+PeerConnection.h"
#import "GotyeLiveConfig.h"
#import "GLAuthToken.h"
#import "VideoResolutionView.h"
#import "GotyeLiveConfig.h"

@interface LivePlayerViewController ()<GLRoomPlayerDelegate, GLChatObserver, GLRoomPublisherDelegate, UITextFieldDelegate,UIGestureRecognizerDelegate,UITableViewDataSource, UITableViewDelegate,GLPeerClientDelegate>
{
    DragButton *_dragButton;//悬浮按钮
    UITapGestureRecognizer *_tapGesture;
    GLSmoothSkinFilter *_smoothSkinFilter;

    UIView *_shareView;
    dispatch_source_t _timer;//定时获取了聊天室人数
    
    UIButton *_cameraBtn;
    UIButton *_shareBtn;
    UIButton *_landscapeBtn;
    UIButton *_torchOnBtn;
    UIButton *_filterBtn;
    UIButton *_closeBtn;
    
    BOOL isShowdragView;
    NSInteger userIndex;
    
    UIImageView *_userHeaderImg;
    
    BOOL isOrientationPortrait;
    
    BOOL isPublishing;
    BOOL isRecording;
    
    GLUser *_presenter;
    NSMutableArray<GLUser *> * _assitants;
    NSMutableArray<GLUser *> * _users;
    
    GLPublisherVideoPreset *_portraitPreset;
    GLPublisherVideoPreset *_landscapePreset;
    
    VideoResolutionView *_videoResolutionView;
    BOOL isResolutionButtonClick;
}

@property (strong, nonatomic) IBOutlet UILabel *onlineUserCount;//在线人数
//@property (strong, nonatomic) IBOutlet UILabel *anchorIncome;//主播收入
@property (strong, nonatomic) IBOutlet UIImageView *playViewbg;//
@property (strong, nonatomic) IBOutlet GLPlayerView *playView;//
@property (strong, nonatomic) IBOutlet UIButton *anchordetailBtn;//主播详情
@property (strong, nonatomic) IBOutlet UITableView *msgTableView;//
@property (strong, nonatomic) IBOutlet GLVideoRendererView *peerPlayView;//
@property (strong, nonatomic) IBOutlet UIButton *dashangBtn;//打赏
@property (strong, nonatomic) IBOutlet UIView *baseChatView;
@property (strong, nonatomic) IBOutlet UIButton *userListBtn;
@property (strong, nonatomic) UITableView *userHeaderTabView;
@property (strong, nonatomic) IBOutlet GLVideoRendererView *localPlayerView;
@property (strong, nonatomic) IBOutlet UIView *resolutionView;
@property (strong, nonatomic) IBOutlet UILabel *resolutionLabel;

@property (strong, nonatomic)  UITextField *inputField;//

@property (nonatomic,copy)GLRoomPlayer *player;

@property (nonatomic,copy)GLChatSession *chatKit;

@property (nonatomic,copy)GLRoomSession * roomSession;

@property (nonatomic,copy)GLPeerClient * peerClient;

@property (nonatomic, strong) NSMutableArray *messageArrays;

@property (nonatomic, strong) UIView *dragButView;

@property (nonatomic, strong) UIView *aleatView;

@property (nonatomic, strong) UIView *userHeaderView;

@property (nonatomic, strong) UIButton *alertBG;

@end

@implementation LivePlayerViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillhide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillshow:) name:UIKeyboardWillShowNotification object:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    isOrientationPortrait=YES;

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [self initGotyeLive];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"sourceApplication" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:[UIApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:[UIApplication sharedApplication]];
}


- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    [self endPeerConnection:NO];
    [_player stop];
}

- (void)applicationWillEnterForeground:(NSNotification *)notification
{
    if (self.isLiveMode) {
        [self setFrameOfDragBtn:YES];
        _closeBtn.enabled = YES;
        if (isPublishing) {
            [_publisher publish];
        }
    } else {
        [_player playWithView:_playView];
    }
}

- (void)notification:(NSNotification *)notification
{
    if (self.isLiveMode) {
        _closeBtn.selected = NO;
        _closeBtn.enabled = NO;
        [MBProgressHUD showHUDAddedTo:_baseChatView animated:YES];
        if (isPublishing) {
            [_publisher publish];
        }
//        [_dragButton setImage:[UIImage imageNamed:@"guanjiandian_publish"] forState:UIControlStateNormal];

    } else {

    }
    [self tapGestureClick];
}

- (void)initView
{
    self.view.clipsToBounds = YES;
    
    _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClick)];
    _tapGesture.delegate = self;
    [_baseChatView addGestureRecognizer:_tapGesture];
    
//    _anchorIncome.text = @"2551.00";
    _onlineUserCount.text = @"1";

    isShowdragView = YES;
    isPublishing = NO;
    
    _dragButton = [[DragButton alloc] initWithFrame:CGRectMake(0, 300,60, 60)];
    _dragButton.backgroundColor = [UIColor clearColor];
    _dragButton.tag = 0;
    [_dragButton setImage:[UIImage imageNamed:@"guanjiandian"] forState:UIControlStateNormal];
    _dragButton.layer.cornerRadius = 30;
    [_dragButton setDragEnable:YES];
    [_dragButton setAdsorbEnable:YES];
    [_baseChatView addSubview:_dragButton];
    [_dragButton addTarget:self action:@selector(showTag:) forControlEvents:UIControlEventTouchUpInside];
    _dragButton.hidden = isShowdragView;
    
    _dragButView = [[UIView alloc] initWithFrame:CGRectMake(-60, 240, 180, 180)];
    _dragButView.backgroundColor = [UIColor darkGrayColor];
    _dragButView.alpha = 0.6;
    [_baseChatView addSubview:_dragButView];
    _dragButView.layer.cornerRadius = 90;
    _dragButView.hidden = !isShowdragView;

    _cameraBtn = [[UIButton alloc] initWithFrame:CGRectMake(60, 10,40, 40)];
    _cameraBtn.backgroundColor = [UIColor clearColor];
    _cameraBtn.tag = 1;
    [_cameraBtn setImage:[UIImage imageNamed:@"lens_switch"] forState:UIControlStateNormal];
    [_cameraBtn setImage:[UIImage imageNamed:@"lens_switch"] forState:UIControlStateSelected];
    [_dragButView addSubview:_cameraBtn];
    [_cameraBtn addTarget:self action:@selector(showTag:) forControlEvents:UIControlEventTouchUpInside];
    
//    _shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(120, 20,40, 40)];
//    _shareBtn.backgroundColor = [UIColor clearColor];
//    _shareBtn.tag = 2;
//    [_shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
////    [_shareBtn setImage:[UIImage imageNamed:@"share_hover"] forState:UIControlStateSelected];
//    [_dragButView addSubview:_shareBtn];
//    [_shareBtn addTarget:self action:@selector(showTag:) forControlEvents:UIControlEventTouchUpInside];
    
    _landscapeBtn = [[UIButton alloc] initWithFrame:CGRectMake(120, 40,40, 40)];
    _landscapeBtn.backgroundColor = [UIColor clearColor];
    _landscapeBtn.tag = 3;
    [_landscapeBtn setImage:[UIImage imageNamed:@"hs_switch"] forState:UIControlStateNormal];
    [_landscapeBtn setImage:[UIImage imageNamed:@"hs_switch"] forState:UIControlStateSelected];
    [_dragButView addSubview:_landscapeBtn];
    [_landscapeBtn addTarget:self action:@selector(showTag:) forControlEvents:UIControlEventTouchUpInside];
    
    _torchOnBtn = [[UIButton alloc] initWithFrame:CGRectMake(120, 100,40, 40)];
    _torchOnBtn.backgroundColor = [UIColor clearColor];
    _torchOnBtn.tag = 4;
    [_torchOnBtn setImage:[UIImage imageNamed:@"flashLamp_on"] forState:UIControlStateNormal];
    [_torchOnBtn setImage:[UIImage imageNamed:@"flashLamp_off"] forState:UIControlStateSelected];
    [_dragButView addSubview:_torchOnBtn];
    [_torchOnBtn addTarget:self action:@selector(showTag:) forControlEvents:UIControlEventTouchUpInside];
    
    _filterBtn = [[UIButton alloc] initWithFrame:CGRectMake(60, 130,40, 40)];
    _filterBtn.backgroundColor = [UIColor clearColor];
    _filterBtn.tag = 5;
    [_filterBtn setImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
    [_filterBtn setImage:[UIImage imageNamed:@"filter_hover"] forState:UIControlStateSelected];
    [_dragButView addSubview:_filterBtn];
    [_filterBtn addTarget:self action:@selector(showTag:) forControlEvents:UIControlEventTouchUpInside];
    
    _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(60, 65,50, 50)];
    _closeBtn.backgroundColor = [UIColor clearColor];
    _closeBtn.tag = 6;
    [_closeBtn setImage:[UIImage imageNamed:@"weikaishi"] forState:UIControlStateNormal];
    [_closeBtn setImage:[UIImage imageNamed:@"kaishi"] forState:UIControlStateSelected];
    [_dragButView addSubview:_closeBtn];
    [_closeBtn addTarget:self action:@selector(showTag:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _msgTableView.dataSource = self;
    _msgTableView.backgroundColor = [UIColor clearColor];
    _msgTableView.delegate = self;
    _msgTableView.showsVerticalScrollIndicator = NO;
    _msgTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    _userHeaderView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, 100, 300)];
    _userHeaderView.backgroundColor = [UIColor clearColor];
    [_baseChatView addSubview:_userHeaderView];

    _userHeaderImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 300)];
    _userHeaderImg.backgroundColor = [UIColor clearColor];
    _userHeaderImg.image = [UIImage imageNamed:@"hpBg"];
    [_userHeaderView addSubview:_userHeaderImg];

    _userHeaderTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, 100, 290) style:UITableViewStylePlain];
//    _userHeaderTabView.alpha = 0.6;
    _userHeaderTabView.backgroundColor = [UIColor clearColor];
    _userHeaderTabView.dataSource = self;
    _userHeaderTabView.delegate = self;
    _userHeaderTabView.showsVerticalScrollIndicator = YES;
    _userHeaderTabView.separatorStyle = UITableViewCellSelectionStyleNone;
    [_userHeaderView addSubview:_userHeaderTabView];
    
    _inputField = [[UITextField alloc] initWithFrame:CGRectMake(16, -100, kScreenWidth-32, 40)];
    [_baseChatView addSubview:_inputField];
    _inputField.layer.cornerRadius = 5.0f;
    _inputField.backgroundColor = WHITE_COLOR;
    _inputField.returnKeyType = UIReturnKeySend;
    _inputField.delegate = self;
    _inputField.placeholder = @"说点什么吧";
    UIColor *color = [UIColor lightGrayColor];
    _inputField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_inputField.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    
    _videoResolutionView = [[VideoResolutionView alloc] init];
    _videoResolutionView.frame = CGRectMake(0, 35, 100, 1);
    [_resolutionView addSubview: _videoResolutionView];
    _videoResolutionView.hidden = YES;
    isResolutionButtonClick = NO;
    [self attachVideoResolutionEvent];
    
    if (!self.isLiveMode) {
        _resolutionView.hidden = YES;
    }
}

- (void)initGotyeLive
{
    _messageArrays = [[NSMutableArray alloc] init];
    _roomSession = [GLCore currentSession];
    _assitants = [NSMutableArray array];
    _users = [NSMutableArray array];
    
    if (self.isLiveMode) {
        _portraitPreset = [GLPublisherVideoPreset presetWithResolution:GLPublisherVideoResolutionCustom];
        _portraitPreset.videoSize = CGSizeMake(368, 640);
        _portraitPreset.fps = 24;
        _portraitPreset.bps = 640;
        
        _landscapePreset = [GLPublisherVideoPreset presetWithResolution:GLPublisherVideoResolutionCustom];
        _landscapePreset.videoSize = CGSizeMake(640, 368);
        _landscapePreset.fps = 24;
        _landscapePreset.bps = 640;
        
        _publisher.videoPreset = _portraitPreset;
        _publisher.delegate = self;
        _smoothSkinFilter = [GLSmoothSkinFilter new];
        _publisher.filter = _smoothSkinFilter;
        _filterBtn.selected = YES;
        
        [_publisher startPreview:_playView success:^{
            NSLog(@"preview success");
            //            [self hideIndicator];
            //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //                [_publisher publish];
            //            });
        } failure:^(NSError *error) {
            NSLog(@"preview failed. %@", error);
        }];
        
        
    } else {
        _player = [[GLRoomPlayer alloc]initWithRoomSession:_roomSession];
        @weakify(self);
        _player.PCEventCallback = ^(NSString *userId, GLRoomPlayerPCEvent event){
            @strongify(self);
            if (event == GLRoomPlayerPCEventInvite) {
                [strong_self showAleatView:2 index:0 enableBackgroundClick:NO];
            } else if (event == GLRoomPlayerPCEventEnd) {
                [strong_self.view makeToast:@"对方已挂断，通话结束"];
                [strong_self endPeerConnection:YES];
            }
        };
        
        _player.delegate = self;
        _playView.fillMode = GLPlayerViewFillModeAspectFill;
        [_player playWithView:_playView];
        
        _userListBtn.hidden = YES;
        _dragButton.hidden = YES;
        _dragButView.hidden = YES;
        
    }
    
    _chatKit = [[GLChatSession alloc]initWithSession:_roomSession];
    [_chatKit addObserver:self];
    [self _enterChatRoomWithcallback:nil];
}

- (void)creatShareView
{
    _shareView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth-300)/2, kScreenHeight/2-80, 300, 120)];
    _shareView.backgroundColor = [UIColor clearColor];
    [_baseChatView addSubview:_shareView];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 120)];
    img.backgroundColor = [UIColor clearColor];
    img.image = [UIImage imageNamed:@"ImageBg"];
    [_shareView addSubview:img];
    UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 300, 20)];
    shareLabel.text = @"将直播分享到";
    shareLabel.textColor = [UIColor whiteColor];
    shareLabel.textAlignment = NSTextAlignmentCenter;
    shareLabel.font = [UIFont systemFontOfSize:12.0];
    shareLabel.backgroundColor = [UIColor clearColor];
    [_shareView addSubview:shareLabel];
    
    for (int i = 0; i < 3; i++) {
        UIButton *function = [UIButton buttonWithType:UIButtonTypeCustom];
        function.frame = CGRectMake(i*100, 35, 100, 50);
        function.layer.cornerRadius = 3;
        function.tag = 1000+i;
        function.backgroundColor = [UIColor clearColor];
        [_shareView addSubview:function];
        [function addTarget:self action:@selector(functionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(i*100, 90, 100, 20)];
        titleLab.textColor = [UIColor whiteColor];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = [UIFont systemFontOfSize:12.0];
        titleLab.backgroundColor = [UIColor clearColor];
        [_shareView addSubview:titleLab];
        
        if (i == 0) {
            titleLab.text = @"微信朋友圈";
            [function setImage:[UIImage imageNamed:@"btn_peng_you_quan"] forState:UIControlStateNormal];
        }else if (i == 1) {
            titleLab.text = @"微信好友";
            [function setImage:[UIImage imageNamed:@"btn_weixin"] forState:UIControlStateNormal];
        }else {
            titleLab.text = @"新浪微博";
            [function setImage:[UIImage imageNamed:@"btn_sina_weibo"] forState:UIControlStateNormal];
        }
    }

}

- (void)tapGestureClick
{
     NSLog(@"*******tapGestureClick******");
    [_inputField resignFirstResponder];
    
    if (self.isLiveMode) {
        [self closeUserList];
        [self closeResolution];
        if (isShowdragView) {
            
            [self setFrameOfDragBtn:NO];
            
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        _shareView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [_shareView removeFromSuperview];
    }];
    
    [self hideAleatView];
}

- (void)hideAleatView
{
    if (_aleatView) {
        
        [UIView animateWithDuration:0.3 animations:^{
            _aleatView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        } completion:^(BOOL finished) {
            [_alertBG removeFromSuperview];
        }];
    }
}

- (void)closeUserList
{
    [UIView animateWithDuration:0.5 animations:^{
        _userHeaderView.frame = CGRectMake(kScreenWidth, 0, 100, _userHeaderView.height);
    } completion:^(BOOL finished) {
        if (self.isLiveMode) {
            _userListBtn.hidden = NO;
        }
    }];
}

- (IBAction)msgBtnClick:(id)sender
{
    [_inputField becomeFirstResponder];
}

- (IBAction)userInformationClick:(id)sender
{
    NSLog(@"*******userInformationClick******");
}

- (IBAction)didClickDuankailianmai:(id)sender
{
    NSLog(@"*******didClickDuankailianmai******");
    [self endPeerConnection:!self.isLiveMode];
}

- (IBAction)didCloseClick:(id)sender
{
    NSLog(@"*******didCloseClick******");
    if (self.isLiveMode) {
        [self showAleatView:0 index:0 enableBackgroundClick:YES];
    } else {
        [self closeClick:sender];
    }
}

- (IBAction)didClickUserList:(id)sender
{
    [self getUserList:GLAuthTokenRolePresenter index:0 total:5];
    [self getUserList:GLAuthTokenRoleAssitant index:0 total:20];
    [self getUserList:GLAuthTokenRoleOrdinaryUser index:0 total:100];
    
    [UIView animateWithDuration:0.5 animations:^{
        _userHeaderView.frame = CGRectMake(kScreenWidth-100, 0, 100, _userHeaderView.height);
        _userListBtn.hidden = YES;
    } completion:^(BOOL finished) {}];
}

- (void)getUserList:(NSInteger)role index:(NSUInteger)index total:(NSUInteger)total
{
    [_publisher queryUserListWithRole:role index:index total:total onSuccess:^(NSArray<GLUser *> *resp) {
        switch (role) {
            case GLAuthTokenRolePresenter:
                _presenter = resp.count > 0 ? resp[0] : nil;
                break;
            case GLAuthTokenRoleAssitant:
                [_assitants removeAllObjects];
                [_assitants addObjectsFromArray:resp];
                break;
            case GLAuthTokenRoleOrdinaryUser:
                [_users removeAllObjects];
                [_users addObjectsFromArray:resp];
                break;
            default:
                break;
        }
        [_userHeaderTabView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"queryUserListWithRole failed. %@", error);
    }];
}

- (GLUser *)getUserAtIndex:(NSUInteger)index
{
    if (index == 0) {
        return _presenter;
    }
    
    if (--index < _assitants.count) {
        return _assitants[index];
    }
    
    if ((index -= _assitants.count) < _users.count) {
        return _users[index];
    }
    
    return nil;
}

- (NSInteger)getUserLevelAtIndex:(NSUInteger)index
{
    if (index == 0) {
        return GLAuthTokenRolePresenter;
    }
    
    if (--index < _assitants.count) {
        return GLAuthTokenRoleAssitant;
    }
    
    if (index -= _assitants.count < _users.count) {
        return GLAuthTokenRoleOrdinaryUser;
    }
    
    return 0;
}

- (void)setFrameOfDragBtn:(BOOL)choose
{
    if (choose) {
        _dragButView.hidden = NO;
        _dragButton.hidden = YES;
        isShowdragView = YES;
        
        if (_dragButton.y < 90) {
            if (_dragButton.x > 90 && _dragButton.x < kScreenWidth-90) {
                _dragButView.frame = CGRectMake(_dragButton.x, 30, 0, 0);
            }else if (_dragButton.x > kScreenWidth-90) {
                _dragButView.frame = CGRectMake(kScreenWidth-120, 90, 0, 0);
            }else if (_dragButton.x < 90){
                _dragButView.frame = CGRectMake(60, 90, 0, 0);
            }else {
                
            }
        }else {
            _dragButView.frame = CGRectMake(60, _dragButton.y, 0, 0);
            if (kScreenHeight < _dragButView.y + 90) {
                if (_dragButton.x > 90 && _dragButton.x < kScreenWidth-90) {
                    _dragButView.frame = CGRectMake(_dragButton.x, kScreenHeight-120, 0, 0);
                }else if (_dragButton.x > kScreenWidth-90) {
                    _dragButView.frame = CGRectMake(kScreenWidth-120, _dragButView.y, 0, 0);
                }else if (_dragButton.x < 90){
                    _dragButView.frame = CGRectMake(60, kScreenHeight-90, 0, 0);
                }else {
                    
                }
            }
        }
        
        for (UIButton *button in [_dragButView subviews]) {
            button.frame = CGRectMake(90, 90, 0, 0);
        }
        
        
//        [UIView animateWithDuration:0 animations:^{
            if (_dragButton.y < 90) {
                if (_dragButton.x > 90 && _dragButton.x < kScreenWidth-90) {
                    _dragButView.frame = CGRectMake(_dragButton.x-90, -60, 180, 180);
                }else if (_dragButton.x > kScreenWidth-90) {
                    _dragButView.frame = CGRectMake(kScreenWidth-120, 0, 180, 180);
                }else if (_dragButton.x < 90){
                    _dragButView.frame = CGRectMake(-60, 0, 180, 180);
                }else {
                    
                }
            }else {
                if (kScreenHeight < _dragButton.y + 90) {
                    if (_dragButton.x > 90 && _dragButton.x < kScreenWidth-90) {
                        _dragButView.frame = CGRectMake(_dragButton.x-90, kScreenHeight-120, 180, 180);
                    }else if (_dragButton.x > kScreenWidth-90) {
                        _dragButView.frame = CGRectMake(kScreenWidth-120, kScreenHeight-180, 180, 180);
                    }else if (_dragButton.x < 90){
                        _dragButView.frame = CGRectMake(-60, kScreenHeight-180, 180, 180);
                    }else {
                        
                    }
                }else {
                    if (_dragButton.x > kScreenWidth/2) {
                        _dragButView.frame = CGRectMake(kScreenWidth-120, _dragButton.y-60, 180, 180);
                    }else {
                        _dragButView.frame = CGRectMake(-60, _dragButton.y-60, 180, 180);
                    }
                }
            }
//        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.6 animations:^{
                if (_dragButView.x == -60) {
                    _cameraBtn.frame = CGRectMake(60, 10,40, 40);
                    _shareBtn.frame = CGRectMake(120, 20,40, 40);
                    _landscapeBtn.frame = CGRectMake(130, 70,40, 40);
                    _torchOnBtn.frame = CGRectMake(120, 120,40, 40);
                    _filterBtn.frame = CGRectMake(60, 130,40, 40);
                    _closeBtn.frame = CGRectMake(60, 65,50, 50);
                }else if (_dragButView.x == kScreenWidth-120) {
                    _cameraBtn.frame = CGRectMake(70, 0,40, 40);
                    _shareBtn.frame = CGRectMake(20, 20,40, 40);
                    _landscapeBtn.frame = CGRectMake(0, 70,40, 40);
                    _torchOnBtn.frame = CGRectMake(20, 120,40, 40);
                    _filterBtn.frame = CGRectMake(70, 130,40, 40);
                    _closeBtn.frame = CGRectMake(70, 65,50, 50);
                }else {
                    if (_dragButView.y < 0) {
                        _cameraBtn.frame = CGRectMake(130, 60,40, 40);
                        _shareBtn.frame = CGRectMake(120, 120,40, 40);
                        _landscapeBtn.frame = CGRectMake(70, 130,40, 40);
                        _torchOnBtn.frame = CGRectMake(20, 120,40, 40);
                        _filterBtn.frame = CGRectMake(0, 60,40, 40);
                        _closeBtn.frame = CGRectMake(70, 65,50, 50);
                    }else {
                        _cameraBtn.frame = CGRectMake(0, 70,40, 40);
                        _shareBtn.frame = CGRectMake(20, 20,40, 40);
                        _landscapeBtn.frame = CGRectMake(70, 0,40, 40);
                        _torchOnBtn.frame = CGRectMake(120, 20,40, 40);
                        _filterBtn.frame = CGRectMake(130, 70,40, 40);
                        _closeBtn.frame = CGRectMake(60, 65,50, 50);
                    }
                }
            } completion:^(BOOL finished) {}];
//        }];

    }else {
        
        isShowdragView = NO;

        
        [UIView animateWithDuration:0.6 animations:^{
            for (UIButton *button in [_dragButView subviews]) {
                button.frame = CGRectMake(90, 90, 0, 0);
            }
            _dragButton.alpha = 0;
            _dragButton.hidden = NO;
            _dragButton.transform = CGAffineTransformIdentity;
            [UIView animateWithDuration:0.1 animations:^{_dragButton.alpha = 1.0;} completion:^(BOOL finished) {
                if (finished) {
                }
            }];
            
            CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            bounceAnimation.values = @[@0.01f, @1.1f, @0.8f, @1.0f];
            bounceAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
            bounceAnimation.duration = 0.4;
            [_dragButton.layer addAnimation:bounceAnimation forKey:@"bounce"];
        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0 animations:^{
//                _dragButView.frame = CGRectMake(60, _dragButton.y, 0, 0);
//
//            } completion:^(BOOL finished) {
//            }];
            _dragButView.hidden = YES;
        }];
    }
}

-(void)showTag:(UIButton *)sender
{
//    NSLog(@"button.tag >> %@",@(sender.tag));
    
    UIButton *button = sender;
    
//    if (button.selected) {
//        button.selected = NO;
//    }else{
//        button.selected = YES;
//    }
//    if(!self.isLiveMode) return;
    
    BOOL changeBtnState = YES;
    
    switch ([button tag]) {
        case 0:
        {
           
            [self setFrameOfDragBtn:YES];

        }
            break;
            
        case 1:
        {
            [self.publisher toggleCamera];
            if (self.publisher.cameraState == GLCameraStateFront) {
                
                _torchOnBtn.selected = NO;
            }else {
            }
        }
            break;
            
        case 2:
        {
//            _shareView.y = kScreenHeight/2-80;
//            _shareView.x = ((kScreenWidth-300)/2);
//            _shareView.frame = CGRectMake((kScreenWidth-300)/2, kScreenHeight/2-80, 300, 120);
            [self creatShareView];
            _shareView.alpha = 0;
            _shareView.transform = CGAffineTransformIdentity;
            [UIView animateWithDuration:0.1 animations:^{_shareView.alpha = 1.0;} completion:^(BOOL finished) {
                if (finished) {
                    [self setFrameOfDragBtn:NO];
                }
            }];

            CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            bounceAnimation.values = @[@0.01f, @1.1f, @0.8f, @1.0f];
            bounceAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
            bounceAnimation.duration = 0.4;
            [_shareView.layer addAnimation:bounceAnimation forKey:@"bounce"];

        }
            break;
            
        case 3:
        {
            if (button.selected) {
                [self setOrientation:UIInterfaceOrientationPortrait];

            }else{
                
                [self setOrientation:UIInterfaceOrientationLandscapeRight];
            }
        }
            break;
            
        case 4:
        {
            if (self.publisher.cameraState == GLCameraStateBack) {
                
                self.publisher.torchOn = !self.publisher.torchOn;
            }else {
                button.selected = YES;
            }
            
        }
            break;
            
        case 5:
        {
            if(self.publisher.filter){
                self.publisher.filter = nil;
            }else{
                self.publisher.filter = _smoothSkinFilter;
            }
        }
            break;
            
        case 6:
        {
            if (button.selected) {
                [_publisher unpublish];
                isPublishing = NO;
                [_dragButton setImage:[UIImage imageNamed:@"guanjiandian"] forState:UIControlStateNormal];
                [self endPeerConnection:NO];
            }else{
                _closeBtn.enabled = NO;
                changeBtnState = NO;
                [MBProgressHUD showHUDAddedTo:_baseChatView animated:YES];
                [_publisher publish];
                if (!isRecording) {
                    [_publisher beginRecording];
                    isRecording = YES;
                }
                isPublishing = YES;
//                [_dragButton setImage:[UIImage imageNamed:@"guanjiandian_publish"] forState:UIControlStateNormal];

            }
        }
            break;
            
        case 10:
        {
            
            [self hideAleatView];
            [self closeClick:sender];
        }
            break;
            
        case 11:
        {
            [self hideAleatView];
        }
            break;
            
        case 12:
        {
            GLUser *obj = [self getUserAtIndex:userIndex];
            [_chatKit kickUser:obj.account success:^{
                [self hideAleatView];
            } failure:^(NSError *error) {
                
            }];
        }
            break;
            
        case 13:
        {
            GLUser *obj = [self getUserAtIndex:userIndex];
            [_chatKit mute:YES user:obj.account success:^{
                [self hideAleatView];
            } failure:^(NSError *error) {
                
            }];
            
        }
            break;
            
        case 14:
        {
            [_player pause];
            [self hideAleatView];
            
            if (_peerClient != nil) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请先关闭当前连麦" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }
            
            _peerClient = [[GLPeerClient alloc] initWithPublisher:nil];
            _peerClient.delegate = self;
            _localPlayerView.hidden = NO;
            _localPlayerView.fillMode = GLVideoRendererViewFillModeAspectFill;
            _peerPlayView.fillMode = GLVideoRendererViewFillModeAspectFill;
            _peerClient.localVideoView = _localPlayerView;
            _peerClient.remoteVideoView = _peerPlayView;
            
            [_player acceptInvitationWithSuccess:^{
                _peerPlayView.superview.hidden = NO;
                [_peerClient connectToRoom:_roomSession.roomId withUserId:_player.currentUser];
            } failure:^(NSError *error) {
                [self endPeerConnection:YES];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"连接失败" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            }];
        }
            break;
            
        case 15:
        {
            [self hideAleatView];
            [_player denyInvitation];
        }
            break;
            
        case 16:
        {
            GLUser *obj = [self getUserAtIndex:userIndex];
            [self hideAleatView];
            
            if (_peerClient != nil) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请先关闭当前连麦" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }
            
            _localPlayerView.hidden = NO;
            _peerClient = [[GLPeerClient alloc] initWithPublisher:_publisher];
            _peerClient.remoteUserId = obj.account;
            _peerClient.delegate = self;
            _peerPlayView.fillMode = GLVideoRendererViewFillModeAspectFill;
            _localPlayerView.fillMode = GLVideoRendererViewFillModeAspectFill;
            _peerClient.localVideoView = _localPlayerView;
            _peerClient.remoteVideoView = _peerPlayView;
            _peerPlayView.superview.hidden = NO;

            [_publisher inviteUser:obj.account withCallback:^(GLRoomPublisherPCEvent event) {
                if (event == GLRoomPublisherPCEventAccept) {
                    [_peerClient connectToRoom:_roomSession.roomId withUserId:_publisher.currentUser];
                }else if (event == GLRoomPublisherPCEventDeny) {
                    [self.view makeToast:@"对方已拒绝"];
                    [self endPeerConnection:NO];
                }else if (event == GLRoomPublisherPCEventEnd){
                    if (_peerClient) {
                        [self.view makeToast:@"对方已挂断，通话结束"];
                    }
                    [self endPeerConnection:NO];
                }
            } failure:^(NSError *error) {
                [self endPeerConnection:NO];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"邀请失败" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            }];
        }
            break;
        default:
            break;
    }

    if (changeBtnState) {
        button.selected = !button.selected;
    }
}

- (void)endPeerConnection:(BOOL)resumePlayer
{
    if (self.isLiveMode) {
        [self.publisher endPeerConnection];
    } else {
        [self.player endPeerConnection];
        _localPlayerView.hidden = YES;
        if (resumePlayer) {
            [_player resume];
        }
    }
    
    if (_peerClient) {
        [_peerClient disconnect];
        _peerClient = nil;
    }
    _peerPlayView.superview.hidden = YES;
    [self hideAleatView];
}

- (void)showAleatView:(NSInteger)integer index:(NSInteger)index enableBackgroundClick:(BOOL)enable
{
    _alertBG = [[UIButton alloc]initWithFrame:self.view.bounds];
    [_alertBG setBackgroundColor:[UIColor clearColor]];
    if (enable) {
        [_alertBG addTarget:self action:@selector(hideAleatView) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.view addSubview:_alertBG];
    
    _aleatView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2-100, kScreenHeight, 200, 100)];
    _aleatView.backgroundColor = [UIColor clearColor];
    [_alertBG addSubview:_aleatView];
    
    UIImageView *imageBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    imageBg.image = [UIImage imageNamed:@"ImageBg"];
    imageBg.backgroundColor = [UIColor clearColor];
    [_aleatView addSubview:imageBg];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 200, 30)];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:14.0];
    title.textAlignment = NSTextAlignmentCenter;
    [_aleatView addSubview:title];
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(11, 60,69, 27)];
    leftBtn.backgroundColor = [UIColor clearColor];
    [_aleatView addSubview:leftBtn];
    [leftBtn addTarget:self action:@selector(showTag:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(120, 60,69, 27)];
    rightBtn.backgroundColor = [UIColor clearColor];
    [_aleatView addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(showTag:) forControlEvents:UIControlEventTouchUpInside];
    
    if (integer == 0) {
        title.text = @"确定要退出直播?";
        leftBtn.tag = 10;
        [leftBtn setImage:[UIImage imageNamed:@"sighOut-hover"] forState:UIControlStateNormal];
        rightBtn.tag = 11;
        [rightBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        
    }else if (integer == 1) {
        userIndex = index;
        GLUser *obj = [self getUserAtIndex:userIndex];
        title.text = obj.nickname;
        leftBtn.tag = 12;
        [leftBtn setImage:[UIImage imageNamed:@"tichu"] forState:UIControlStateNormal];
        rightBtn.tag = 13;
        [rightBtn setImage:[UIImage imageNamed:@"jinyan"] forState:UIControlStateNormal];
    }else if (integer == 2) {
        title.text = @"主播邀请您语音是否接受?";
        leftBtn.tag = 14;
        [leftBtn setImage:[UIImage imageNamed:@"jieshou"] forState:UIControlStateNormal];
        rightBtn.tag = 15;
        [rightBtn setImage:[UIImage imageNamed:@"jujue"] forState:UIControlStateNormal];
    }else if (integer == 3) {
        userIndex = index;
        GLUser *obj = [self getUserAtIndex:userIndex];
        title.text = obj.nickname;
        _aleatView.frame = CGRectMake(kScreenWidth/2-100, kScreenHeight, 200, 140);
        title.frame = CGRectMake(0, 60, 200, 20);
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(50, 15, 100, 42)];
        img.image = [UIImage imageNamed:@"interactive"];
        [_aleatView addSubview:img];
        leftBtn.y = 100;
        rightBtn.y = 100;
        imageBg.frame = CGRectMake(0, 0, 200, 140);
        imageBg.image = [UIImage imageNamed:@"hudong"];
        title.textColor = COLOR(158, 147, 87, 1);
        leftBtn.tag = 16;
        [leftBtn setImage:[UIImage imageNamed:@"yanqinghudong"] forState:UIControlStateNormal];
        rightBtn.tag = 13;
        [rightBtn setImage:[UIImage imageNamed:@"jinyan"] forState:UIControlStateNormal];
    }else {
        
    }
    
//    [UIView animateWithDuration:0.3 animations:^{
    
        _aleatView.frame = CGRectMake(kScreenWidth/2-100, kScreenHeight/2-100, 200, _aleatView.height);
//    } completion:nil];
    
    _aleatView.alpha = 0;
    _aleatView.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.1 animations:^{_aleatView.alpha = 1.0;} completion:^(BOOL finished) {
        if (finished) {
        }
    }];
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.values = @[@0.01f, @1.1f, @0.8f, @1.0f];
    bounceAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
    bounceAnimation.duration = 0.4;
    [_aleatView.layer addAnimation:bounceAnimation forKey:@"bounce"];
}

- (void)_loginPublisherWithForce:(BOOL)force callback:(void(^)(NSError *error))callback
{
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
    hud.detailsLabelText = @"网络异常";
    hud.mode = MBProgressHUDModeText;
    [hud hide:YES afterDelay:1];
}


- (void)_enterChatRoomWithcallback:(void(^)(NSError *error, NSString *account, NSString *nickname))callback
{
    [_chatKit loginOnSuccess:^(NSString *account, NSString *nickname) {
        
        [_chatKit sendNotify:@"enter" extra:nil success:nil failure:nil];
        
        double delayInSeconds = 20.0;
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
        dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC, 0.0);
        dispatch_source_set_event_handler(_timer, ^{
            
            [self updateRoomUserCount];
        });
        dispatch_resume(_timer);
        
        if (callback) {
            callback(nil, account, nickname);
        }
    } failure:^(NSError *error) {
        if (callback) {
            callback(error, nil, nil);
        }
    }];
}

- (void)keyboardWillshow:(NSNotification *)note
{
    NSDictionary *userInfo = note.userInfo;
    CGRect keyFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:0.3 animations:^{
//        _chatContentView.y = _chatConY - keyFrame.size.height;
        _inputField.y = kScreenHeight-keyFrame.size.height-40;
    } completion:nil];
}

- (void)keyboardWillhide:(NSNotification *)note
{
    [UIView animateWithDuration:0.3 animations:^{
//        _chatContentView.y = _chatConY;
        _inputField.y = -100;
    } completion:nil];
}

- (void)forceLogout:(NSString *)msg
{
    [self stopEverything];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self closeClick:nil];
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)functionBtnClick:(UIButton *)button
{
    [_roomSession getClientUrlsOnSuccess:^(GLClientUrl *clientUrl) {
        NSString *shareUrl = clientUrl.educVisitorUrl;
        
        switch (button.tag) {
            case 1000:
                [self shareToWeiXin:shareUrl inScene:WXSceneTimeline];
                break;
            case 1001:
                [self shareToWeiXin:shareUrl inScene:WXSceneSession];
                break;
            case 1002:
                [self shareToSinaWeibo:shareUrl];
                break;
            default:
                break;
        }
    } failure:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"获取分享url出错！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:1.0];
    }];
    
    
}

- (void)updateRoomUserCount
{
    [_chatKit.roomSession getLiveContextOnSuccess:^(GLLiveContext *liveContext) {
        if (_player.state == GLPlayerStateStarted || _publisher.state == GLPublisherStatePublished) {
            _onlineUserCount.text = [NSString stringWithFormat:@"%ld", (long)liveContext.playUserCount];
            [_userHeaderTabView reloadData];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"getLiveContext %@", error);
    }];
}

- (void)sendClick:(NSString *)text json:(NSString *)json
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
    [params setObject:@"1"  forKey:@"msgid"];
    [params setObject:[GotyeLiveConfig config].nickname  forKey:@"nickname"];
    [params setObject:text  forKey:@"msg"];
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *sssss = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [_messageArrays addObject:sssss];
    [_msgTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_messageArrays.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [_msgTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_messageArrays.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
    [_chatKit sendText:text extra:nil success:^{
        
    } failure:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发送失败" message:@"网络异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:1.0];
    }];
}

#pragma mark - textField代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    if (textField.text.length>0) {
        
        [self sendClick:textField.text json:nil];
    }else {
        
    }
    textField.text = @"";
    return  YES;
}


- (void)shareToWeiXin:(NSString *)url inScene:(enum WXScene)scene
{
    WXMediaMessage *message = [[WXMediaMessage alloc]init];
    message.title = @"亲加视频直播";
    message.description = @"这是一个直播";
    [message setThumbImage:[UIImage imageNamed:@"AppIcon60x60"]];
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = url;
    message.mediaObject = ext;
    
    SendMessageToWXReq *req = [SendMessageToWXReq new];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    [WXApi sendReq:req];
}

- (void)shareToSinaWeibo:(NSString *)url
{
    WBMessageObject *message = [WBMessageObject message];
    
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = @"identifier1";
    webpage.title = @"亲加视频直播";
    webpage.description = @"这是一个直播";
    webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AppIcon60x60@2x" ofType:@"png"]];
    webpage.webpageUrl = url;
    message.mediaObject = webpage;
    message.text = @"#亲加直播#";
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
    
    [WeiboSDK sendRequest:request];
}

- (void) dimissAlert:(UIAlertView *)alert
{
    if(alert) {
        
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}

- (void)closeResolution
{
    if(!_videoResolutionView || _videoResolutionView.hidden)return;
    
    _videoResolutionView.alpha = 1.f;
    beginAnimation(0, .2f, UIViewAnimationCurveEaseIn);
    [UIView setAnimationDelegate: self];
    [UIView setAnimationDidStopSelector:@selector(onAnimationSettingStop)];
    _videoResolutionView.alpha = 0.f;
    _videoResolutionView.frame = CGRectMake(0, 35, 100, 1);
    endAnimation;

}

- (void)onAnimationSettingStop
{
    _videoResolutionView.hidden = YES;
}

- (void)attachVideoResolutionEvent
{
    [_videoResolutionView.buttonDefault addTarget:self action:@selector(onButtonMenuClick:) forControlEvents:UIControlEventTouchUpInside];
    [_videoResolutionView.buttonHighDefinition addTarget:self action:@selector(onButtonMenuClick:) forControlEvents:UIControlEventTouchUpInside];
    [_videoResolutionView.buttonSuperHighDefinition addTarget:self action:@selector(onButtonMenuClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onButtonMenuClick:(id)sender
{
    UIButton *button = sender;
    if(isPublishing) return;
    
    switch ([button tag]) {
        case kTagDefault:
        {
            [_videoResolutionView.buttonDefault setTitleColor:COLOR(254, 84, 67, 1) forState:UIControlStateNormal];
            [_videoResolutionView.buttonHighDefinition setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
            [_videoResolutionView.buttonSuperHighDefinition setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
            
            _resolutionLabel.text = @"标清";
            _portraitPreset.bps = 500;
            _landscapePreset.bps = 500;
        }
            break;
            
        case kTagHighDefinition:
        {
            [_videoResolutionView.buttonDefault setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
            [_videoResolutionView.buttonHighDefinition setTitleColor:COLOR(254, 84, 67, 1) forState:UIControlStateNormal];
            [_videoResolutionView.buttonSuperHighDefinition setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
            
            _resolutionLabel.text = @"高清";
            _portraitPreset.bps = 640;
            _landscapePreset.bps = 640;
        }
            break;
            
        case kTagSuperHighDefinition:
        {
            [_videoResolutionView.buttonDefault setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
            [_videoResolutionView.buttonHighDefinition setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
            [_videoResolutionView.buttonSuperHighDefinition setTitleColor:COLOR(254, 84, 67, 1) forState:UIControlStateNormal];
            
            _resolutionLabel.text = @"超高清";
            _portraitPreset.bps = 800;
            _landscapePreset.bps = 800;
        }
            break;
            
        default:
            break;
    }
    [self closeResolution];
}


#pragma mark - 点击事件

- (void)stopEverything
{
    [self endPeerConnection:NO];
    if (_player) {
        [_player stop];
        _player = nil;
    }
    if (_publisher) {
        isRecording = NO;
        [_publisher endRecording:nil];
        [_publisher stop];
        _publisher = nil;
    }
    if (_chatKit) {
        [_chatKit logout];
        [_chatKit removeObserver:self];
        _chatKit = nil;
    }
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO] ;
    
//    if (!isOrientationPortrait) {
//        [self setOrientation:UIInterfaceOrientationPortrait];
//    }
}

- (void)closeClick:(id)sender
{
    [self stopEverything];
    if (self.isZhuBo) {
        [self closerequest];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)closerequest{
        NSString *URL = [NSString stringWithFormat:@"%@/live-t/close-live",kUrl];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [userDefaults valueForKey:@"token"];
        NSLog(@"token:%@",token);
        [userDefaults synchronize];
        [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
//        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
//        [parameters setValue:self.roomId forKey:@"room_id"];
        [manager POST:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"关闭直播间正确%@",responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"失败%@",error);
            //        [MBProgressHUD showText:@"%@",error[@"error"]];
        }];
        
        
    

}

- (void)showReport
{
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *report = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIAlertController *confirm = [UIAlertController alertControllerWithTitle:nil message:@"确定要举报该用户吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIAlertController *tip = [UIAlertController alertControllerWithTitle:nil message:@"感谢您的举报，我们会尽快核实处理" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *dismiss = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
            [tip addAction:dismiss];
            
            [self presentViewController:tip animated:YES completion:nil];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [confirm addAction:ok];
        [confirm addAction:cancel];
        
        [self presentViewController:confirm animated:YES completion:nil];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [sheet addAction:report];
    [sheet addAction:cancel];
    
    [self presentViewController:sheet animated:YES completion:nil];
}

- (IBAction)switchVideoView:(id)sender
{
    GLVideoRendererView *temp = _peerClient.localVideoView;
    _peerClient.localVideoView = _peerClient.remoteVideoView;
    _peerClient.remoteVideoView = temp;
}

- (IBAction)resolutionButtonClick:(id)sender
{
    if(isPublishing) return;
    if (!isResolutionButtonClick) {
        [_videoResolutionView.buttonHighDefinition setTitleColor:COLOR(254, 84, 67, 1) forState:UIControlStateNormal];
        isResolutionButtonClick = YES;
    }
    if(_videoResolutionView.hidden){
        _videoResolutionView.alpha = .0f;
        _videoResolutionView.hidden = NO;
        beginAnimation(0, .2f, UIViewAnimationCurveEaseOut);
        _videoResolutionView.alpha = 1.f;
        _videoResolutionView.frame = CGRectMake(0, 35, 100, 100);
        endAnimation;
        
    }else{
        [self closeResolution];
    }
}

#pragma mark - 聊天回调
- (void)chatClient:(GLChatSession *)chatSession didReceiveMessage:(GLChatMessage *)msg
{
    if (msg.type == GLChatMessageTypeNotify) {
        if([msg.text isEqualToString:@"enter"])
        {
            [self updateRoomUserCount];
        
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
            [params setObject:@"0"  forKey:@"msgid"];
            [params setObject:msg.sendName  forKey:@"nickname"];
            NSError *parseError = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&parseError];
            NSString *sssss = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [_messageArrays addObject:sssss];
            [_msgTableView reloadData];
            [_msgTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_messageArrays.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
        else
        {
            NSError *error;
            NSData * textData = [msg.text dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:textData options:NSJSONReadingAllowFragments error:&error];
            if (error) {
                NSLog(@"parse json failed!");
                return;
            }
            
            NSDictionary *dictionary = (NSDictionary *)jsonObject;
            NSString *giftName = [dictionary objectForKey:@"giftName"];
  
            if(giftName)
            {
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
                [params setObject:@"2"  forKey:@"msgid"];
                [params setObject:msg.sendName  forKey:@"nickname"];
                [params setObject:giftName  forKey:@"msg"];
            
                NSError *parseError = nil;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&parseError];
                NSString *sssss = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                [_messageArrays addObject:sssss];
                [_msgTableView reloadData];
                [_msgTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_messageArrays.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }

        }
    } else if(msg.type == GLChatMessageTypeText){
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
        [params setObject:@"1"  forKey:@"msgid"];
        [params setObject:msg.sendName  forKey:@"nickname"];
        [params setObject:msg.text  forKey:@"msg"];

        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&parseError];
        NSString *sssss = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [_messageArrays addObject:sssss];
        [_msgTableView reloadData];
        [_msgTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_messageArrays.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (void)chatClientDidForceLogout:(NSString *)roomId;
{
    [self forceLogout:@"你的账号在别处登录了！"];
}

- (void)chatClientDidKickedOut:(GLChatSession *)cahtSession
{
    [self forceLogout:@"你已被踢出房间"];
}

#pragma mark - 视频播放回调

- (void)playerDidConnect:(GLPlayer *)player;
{
    _player.playerView.backgroundColor = [UIColor blackColor];
//    [self hideIndicator];
//    [self setTip:nil];
    [self updateRoomUserCount];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES] ;
}

- (void)playerReconnecting:(GLPlayer *)player;
{
    NSLog(@"playerReconnecting");
//    [self setTip:@"重新连线中..."];
//    [self showIndicator];
}

- (void)playerDidDisconnected:(GLPlayer *)player
{
    NSLog(@"playerDidDisconnected");
//    [self setTip:@"直播已结束！"];
//    [self hideIndicator];
}

- (void)playerStatusDidUpdate:(GLPlayer *)player
{
    
}


- (void)player:(GLPlayer *)player onError:(NSError *)error;
{
    NSLog(@"playerOnError: %@ ", error);
    
//    [self hideIndicator];
//    [self setTip:error.localizedDescription];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO] ;
}

#pragma mark - 视频直播回调

- (void)publisherDidConnect:(GLPublisher *)publisher;
{
    [MBProgressHUD hideHUDForView:_baseChatView animated:YES];
    _closeBtn.enabled = YES;
    _closeBtn.selected = YES;
    [_dragButton setImage:[UIImage imageNamed:@"guanjiandian_publish"] forState:UIControlStateNormal];
//    _startRec.enabled = YES;
//    _startRec.selected = YES;
//    [_startRec setImage:[UIImage imageNamed:@"btn_stop"] forState:UIControlStateNormal];
//    _timeLabel.hidden = NO;
    
//    [_publisher beginRecording];
//    [self startPublishTimer];
//    [self hideIndicator];
//    [self setTip:nil];
    [self updateRoomUserCount];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES] ;
    
    
//    _pushLiveStreamTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(PushLiveStream) userInfo:nil repeats:YES];
//    [_pushLiveStreamTimer fire];
}

- (void)publisher:(GLPublisher *)publisher onError:(NSError *)error;
{
    [MBProgressHUD hideHUDForView:_baseChatView animated:YES];
    _closeBtn.enabled = YES;
    _closeBtn.selected = NO;
    [_dragButton setImage:[UIImage imageNamed:@"guanjiandian"] forState:UIControlStateNormal];
    [self endPeerConnection:NO];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO] ;
}

- (void)publisherReconnecting:(GLPublisher *)publisher;
{
    [MBProgressHUD showHUDAddedTo:_baseChatView animated:YES];
    [_dragButton setImage:[UIImage imageNamed:@"guanjiandian"] forState:UIControlStateNormal];
    
//    [self setTip:@"重新连线中..."];
//    [self showIndicator];
}

- (void)publisherDidForceLogout:(GLRoomPublisher *)publisher;
{
    [MBProgressHUD hideHUDForView:_baseChatView animated:YES];
//    [self publishDidStop];
    [self forceLogout:@"你的账号在别处登录了！"];
    [_dragButton setImage:[UIImage imageNamed:@"guanjiandian"] forState:UIControlStateNormal];

    [[UIApplication sharedApplication] setIdleTimerDisabled:NO] ;
}

- (void)publisherDidDisconnected:(GLPublisher *)publisher;
{
    [MBProgressHUD hideHUDForView:_baseChatView animated:YES];
//    [self publishDidStop];
//    [self setTip:nil];
    _closeBtn.selected = NO;
    [self endPeerConnection:NO];
    [_dragButton setImage:[UIImage imageNamed:@"guanjiandian"] forState:UIControlStateNormal];

    [[UIApplication sharedApplication] setIdleTimerDisabled:NO] ;
}

#pragma mark - 视频互动回调


- (void)peerClientDidReceiveLocalVideo:(GLPeerClient *)client
{
}

- (void)peerClient:(GLPeerClient *)client didConnectToRoom:(NSString *)roomId
{
}

- (void)peerClient:(GLPeerClient *)client didReceiveStreamFrom:(NSString *)userId
{
}

- (void)peerClient:(GLPeerClient *)client didReceiveHangUpFrom:(NSString *)userId
{
    if (_peerClient) {
        [self.view makeToast:@"对方已挂断，通话结束"];
    }
    
    [self endPeerConnection:!self.isLiveMode];
}

- (void)peerClient:(GLPeerClient *)client didOccurError:(NSError *)error
{
    [self.view makeToast:@"连接中断"];
    [self endPeerConnection:!self.isLiveMode];
}

- (void)peerClientDisconnected:(GLPeerClient *)client
{
    [self.view makeToast:@"连接中断"];
    [self endPeerConnection:!self.isLiveMode];
}

#pragma mark - UIGestureRecognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSLog(@"-----%@",touch.view.class);
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    if (touch.view.class == [UIButton class]) {
        return NO;
    }
    return YES;
}

- (void)dealloc
{
//    [_presentView removeFromSuperview];
    [_shareView removeFromSuperview];
    [_messageArrays removeAllObjects];
    [_msgTableView removeFromSuperview];
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 分组的数量
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 一个组的item的数量
    if (tableView == _userHeaderTabView) {
        return _assitants.count + _users.count + (_presenter ? 1 : 0);
    }
    return _messageArrays.count;
}

- (CGFloat)mesureCellHeight:(NSIndexPath*)indexPath
{
    id obj = _messageArrays[indexPath.row];
    NSString *text;
    NSData *da= [obj dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:da options:NSJSONReadingMutableContainers error:&error];
    if ([jsonObject isKindOfClass:[NSDictionary class]]){
        NSDictionary *dictionary = (NSDictionary *)jsonObject;
        NSString *msgid = [dictionary objectForKey:@"msgid"];
        NSString *nickName = [dictionary objectForKey:@"nickname"];
        
        if ([msgid intValue]==0) {
            text = [NSString stringWithFormat:@"%@:大家好!",nickName];
        }else if ([msgid intValue]==1) {
            NSString *msgText = [dictionary objectForKey:@"msg"];
            text = [NSString stringWithFormat:@"%@:%@",nickName,msgText];
        }else if ([msgid intValue]==2)
        {
            NSString *msgText = [dictionary objectForKey:@"msg"];
            text = [NSString stringWithFormat:@"%@送了%@",nickName,msgText];
        }else {
            
        }
    }
    CGSize size = [GotyeLiveConfig labelAutoCalculateRectWith:text FontSize:14.f MaxSize:CGSizeMake(_msgTableView.width, MAXFLOAT)];
    return MAX(size.height, kNormalHeight);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _userHeaderTabView) {
        return 30;
    }
    CGFloat height = [self mesureCellHeight: indexPath];
    //NSLog(@"actual height[%ld]: %f", (long)indexPath.row, height);
    return height;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //每个单元格的视图
    if (tableView == _userHeaderTabView) {
        static NSString *itemCell = @"userList";
        UserListCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCell];
        if (cell == nil) {
            cell = [[UserListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemCell];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell fillCellWithObject:[self getUserAtIndex:indexPath.row] level:[self getUserLevelAtIndex:indexPath.row]];
        cell.didSelectedButton = ^(UIButton *button){
          
            [self showAleatView:1 index:indexPath.row enableBackgroundClick:YES];
        };
        return cell;
    }
    static NSString *itemCell = @"MessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCell];
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemCell];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.messaheLable.layer.shadowOpacity = 0.75;
        cell.messaheLable.layer.shadowColor = [UIColor blackColor].CGColor;
        cell.messaheLable.layer.shadowRadius = .5f;
        cell.messaheLable.layer.shadowOffset = CGSizeMake(0, 1);
    }
    
    NSString *obj = _messageArrays[indexPath.row];
    [cell fillCellWithObject:obj Width:_msgTableView.width];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _userHeaderTabView) {
        if (indexPath.row == 0) {
            return;
        }
        GLUser *obj = [self getUserAtIndex:userIndex];

        NSLog(@"%@",obj.account);
        
        [self showAleatView:3 index:indexPath.row enableBackgroundClick:YES];
        [self closeUserList];
    } else if (tableView == _msgTableView) {
        [self showReport];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    // iOS7后,[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    // 已经不起作用了
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return (_publisher.state != GLPublisherStatePublished
    && _publisher.state != GLPublisherStateReconnecting
            && _publisher.state != GLPublisherStatePublishing)
    ? UIInterfaceOrientationMaskAllButUpsideDown
    : 1 << [[UIApplication sharedApplication]statusBarOrientation];
}

- (void)setOrientation:(NSInteger)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        NSInteger val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
        
//        if (orientation == UIInterfaceOrientationLandscapeRight) {
//            
//            _userHeaderView.frame = CGRectMake(kScreenWidth, 20, 100, 100);
//            _userHeaderImg.frame = CGRectMake(0, 0, 100, 100);
//            _userHeaderTabView.frame = CGRectMake(0, 0, 100, 100);
//            
//            _dragButton.frame = CGRectMake(0, 200, 60, 60);
//            _shareView.frame = CGRectMake(10, kScreenHeight, kScreenWidth-20, 120);
//
//            if (isShowdragView) {
//                [self setFrameOfDragBtn:NO];
//            }
//            
//            
//        }else {
//            _userHeaderView.frame = CGRectMake(kScreenWidth, 20, 100, 100);
//            _userHeaderImg.frame = CGRectMake(0, 0, 100, 100);
//            _userHeaderTabView.frame = CGRectMake(0, 0, 100, 100);
//            
//            _dragButton.frame = CGRectMake(0, 200, 60, 60);
//            
//            _shareView.frame = CGRectMake(10, kScreenHeight, kScreenWidth-20, 120);
//            if (isShowdragView) {
//                [self setFrameOfDragBtn:NO];
//            }
//        }
        
        
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [_inputField resignFirstResponder];
    _inputField.frame = CGRectMake(16, -100, kScreenWidth-32, 40);
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        
        isOrientationPortrait=YES;

        _userHeaderView.frame = CGRectMake(kScreenWidth, 0, 100, 300);
        _userHeaderImg.frame = CGRectMake(0, 0, 100, 300);
        _userHeaderTabView.frame = CGRectMake(0, 0, 100, 300);
        
        _dragButton.frame = CGRectMake(0, 300, 60, 60);
        _shareView.frame = CGRectMake((kScreenWidth-300)/2, kScreenHeight, 300, 120);

//        _shareView.frame = CGRectMake(10, kScreenHeight, kScreenWidth-20, 120);
        if (isShowdragView) {
            [self setFrameOfDragBtn:NO];
        }
        [self closeUserList];
        _publisher.videoPreset = _portraitPreset;
    }else {
        isOrientationPortrait=NO;

        _userHeaderView.frame = CGRectMake(kScreenWidth, 0, 100, 100);
        _userHeaderImg.frame = CGRectMake(0, 0, 100, 100);
        _userHeaderTabView.frame = CGRectMake(0, 0, 100, 100);
        _shareView.frame = CGRectMake((kScreenWidth-300)/2, kScreenHeight, 300, 120);

        _dragButton.frame = CGRectMake(0, 200, 60, 60);
//        _shareView.frame = CGRectMake(10, kScreenHeight, kScreenWidth-20, 120);
        
        if (isShowdragView) {
            [self setFrameOfDragBtn:NO];
        }
        [self closeUserList];
        _publisher.videoPreset = _landscapePreset;
    }
    if (!self.isLiveMode) {
        _userListBtn.hidden = YES;
        _dragButton.hidden = YES;
        _dragButView.hidden = YES;
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}


@end
