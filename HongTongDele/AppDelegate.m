//
//  AppDelegate.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/8/3.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "AppDelegate.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
#import "LoginOneViewController.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
#import <RongIMKit/RongIMKit.h>
#import "GLCore.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#define WX_APP           (@"wxe39a73e26dcf1b36")
#define Weibo_APP        (@"971559106")
@interface AppDelegate ()<JPUSHRegisterDelegate,WXApiDelegate, WeiboSDKDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"ad893abff6760d3afb6001ab"
                          channel:@"App Store"
                 apsForProduction:0
            advertisingIdentifier:advertisingId];
    
    //通知获取registerID
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    [defaultCenter addObserver:self selector:@selector(networkDidLogin:) name:kJPFNetworkDidLoginNotification object:nil];

    
    //----------融云------------
    [[RCIM sharedRCIM] initWithAppKey:@"x18ywvqfx6pzc"];
    [[RCIM sharedRCIM] connectWithToken:@"rH8F2mY6bQseChYtoaXlSbNJK6dFwzkHhynZo6/vk2LmBbDprU2SVTVcZKJGnLMjukFXLss8sVhoKUvRtrdZzA=="     success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%d", status);
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"token错误");
    }];
    
    //-------------亲加直播------------
    [GLCore registerWithAppKey:@"f26f2370069d4bac816fc73584e35088"
                  accessSecret:@"049e345fd39f442cb20b7fb0c2cc5148"
                     companyId:@"a2a1ed5eb8414c688fb3d060acf5dcd1"];
    [WXApi registerApp:WX_APP];
    [WeiboSDK registerApp:Weibo_APP];
    [WeiboSDK enableDebugMode:YES];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //判断是否登陆
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *passName = [userDefaults valueForKey:@"phone"];
    //    NSString *passWord =[userDefaults valueForKey:@"passWord"];
    
    if (passName.length>0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *baseNaviVC = [storyboard instantiateViewControllerWithIdentifier:@"Main"];
        self.window.rootViewController = baseNaviVC;
    }else{
        LoginOneViewController *loginViewController = [[LoginOneViewController alloc] initWithNibName:@"LoginOneViewController" bundle:nil];
        UINavigationController *navigationController =
        [[UINavigationController alloc] initWithRootViewController:loginViewController];
        
        self.window.rootViewController = navigationController;
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    NSMutableArray *attachments = [[NSMutableArray alloc] initWithCapacity:0];
    NSLog(@"%@,%@",notification,userInfo);

    
    // Required
//    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    NSString *str = [userInfo objectForKey:@"pushCause"];
    if(str.length>0){
        NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
    // Create a pointer to the Photo object
    NSString *str = [userInfo objectForKey:@"pushCause"];
    if(str.length>0){
        NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }

}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)networkDidLogin:(NSNotification *)notification {
    
    NSLog(@"已登录");
    if ([JPUSHService registrationID]) {
        
        //下面是我拿到registeID,发送给服务器的代码，可以根据你需求来处理
        NSString *registerid = [JPUSHService registrationID];
        NSLog(@"APPDelegate开始上传rgeisterID");
//        [HSingleGlobalData sharedInstance].registerid = registerid;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:registerid forKey:@"registerid"];
        [userDefaults synchronize];
        NSLog(@"*******get RegistrationID = %@ ",[JPUSHService registrationID]);
        //    }
        //设置jPUsh 别名
        //    NSString *userID = [HSingleGlobalData sharedInstance].passName;
        //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [JPUSHService setTags:nil alias:registerid fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            NSLog(@"%d----%@---",iResCode,iAlias);
            
        }];
        [JPUSHService setAlias:registerid callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:nil];
        //    });
        NSLog(@"设置别名:%@",registerid);
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:kJPFNetworkDidLoginNotification
                                                      object:nil];
    }
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
