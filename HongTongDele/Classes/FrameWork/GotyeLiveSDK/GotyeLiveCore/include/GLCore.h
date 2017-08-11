//
//  GLCore.h
//  GotyeLiveCore
//
//  Created by Nick on 15/10/28.
//  Copyright © 2015年 AiLiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GLCoreErrorCode.h"
#import "GLRoomSession.h"
#import "GLAuthToken.h"
#import "GLClientUrl.h"
#import "GLLiveContext.h"

@interface GLCore : NSObject


/**
 *  初始化
 *
 *  @param appkey       后台管理中的appkey字符串
 *  @param accessSecret 密钥
 *  @param companyId    公司唯一标示
 */
+ (void)registerWithAppKey:(NSString *)appkey accessSecret:(NSString *)accessSecret companyId:(NSString *)companyId;

/**
 *  设置debug日志的开关
 *
 *  @param enabled YES表示打开debug日志，NO关闭。默认情况下日志是关闭的
 */
+ (void)setDebugLogEnabled:(BOOL)enabled;

/**
 *  创建一个新的GLRoomSession实例，如果没有的话。创建成功这个session加入缓存中并且更新currentSession的返回值为当前创建的session。
 *
 *  @param type        房间类型。区别是使用亲加后台的房间ID或者自定义的房间ID
 *  @param roomId      房间ID
 *  @param password    房间密码
 *  @param nickname    用户昵称
 *  @param bindAccount 绑定账号，绑定账号相同生成的token，在登录时会互踢。不绑定账号传nil
 *
 *  @return 初始状态的GLRoomSession实例，需要调用auth接口进行验证
 */
+ (GLRoomSession *)sessionWithType:(GLRoomSessionType)type roomId:(NSString *)roomId password:(NSString *)password nickname:(NSString *)nickname bindAccount:(NSString *)bindAccount;

/**
 *  返回当前的session
 *
 *  @return 当前session
 */
+ (GLRoomSession *)currentSession;

/**
 *  销毁某个GLRoomSession实例
 *
 *  @param session 需要销毁的session
 */
+ (void)destroySession:(GLRoomSession *)session;

@end