//
//  GLRoomSession.h
//  GotyeLiveCore
//
//  Created by Nick on 15/10/30.
//  Copyright © 2015年 AiLiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GLAuthToken;
@class GLClientUrl;
@class GLLiveContext;


typedef enum {
    /**
     *  默认类型。使用亲加后台的聊天室ID进行登录
     */
    GLRoomSessionTypeDefault,
    /**
     *  自定义类型。使用自定义聊天室ID进行登录
     */
    GLRoomSessionTypeCustomRoomId
}GLRoomSessionType;

typedef enum {
    /**
     *  创建时的初始状态
     */
    GLRoomSessionStateDefault,
    /**
     *  验证通过
     */
    GLRoomSessionStateAuthed,
    /**
     *  token过期
     */
    GLRoomSessionStateExpired,
    /**
     *  正在请求token
     */
    GLRoomSessionStateRefreshing,
    /**
     *  请求token失败，一般是因为密码错误
     */
    GLRoomSessionStateError,
    /**
     *  已销毁
     */
    GLRoomSessionStateDestroyed      
}GLRoomSessionState;

@interface GLRoomSession : NSObject

@property (nonatomic, assign) GLRoomSessionType type;
@property (nonatomic, readonly) GLRoomSessionState state;
@property (nonatomic, copy) NSString * roomId;
@property (nonatomic, copy) NSString * password;
@property (nonatomic, copy) NSString * bindAccount;
@property (nonatomic, copy) NSString * nickname;
@property (nonatomic, strong, readonly) GLAuthToken * authToken;

/**
 *  创建新的session实例
 *
 *  @param type        session类型。默认ID或者自定义ID
 *  @param roomId      房间ID
 *  @param password    房间密码
 *  @param nickname    用户昵称
 *  @param bindAccount 绑定账号，绑定账号相同生成的token，在登录时会互踢。不绑定账号传nil
 *
 *  @return 初始状态的GLRoomSession实例，需要调用auth接口进行验证
 */
- (instancetype)initWithType:(GLRoomSessionType)type
                      roomId:(NSString *)roomId
                    password:(NSString *)password
                    nickname:(NSString *)nickname
                 bindAccount:(NSString *)bindAccount;

/**
 *  向服务器发起验证请求。只有验证通过session才是有效的才能调用其它接口
 *
 *  @param success 成功的回调
 *  @param failure 失败的回调
 */
- (void)authOnSuccess:(void(^)(GLAuthToken *authToken))success failure:(void(^)(NSError *error))failure;

/**
 *  销毁session
 */
- (void)destroy;

/**
 *  查询直播上下文信息
 *
 *  @param success  成功回调
 *  @param failure  失败回调
 */
- (void)getLiveContextOnSuccess:(void(^)(GLLiveContext *liveContext))success failure:(void(^)(NSError *error))failure;

/**
 *  获取客户端的网页播放地址等信息
 *
 *  @param success  成功回调
 *  @param failure  失败回调
 */
- (void)getClientUrlsOnSuccess:(void(^)(GLClientUrl *clientUrl))success failure:(void(^)(NSError *error))failure;

@end
