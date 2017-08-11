//
//  GLChatSession.h
//  GotyeLiveChat
//
//  Created by Nick on 15/11/3.
//  Copyright © 2015年 AiLiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLChatObserver.h"
#import "GLUser.h"
#import "GLChatMessage.h"
#import "GLChatErrorCode.h"

@class GLRoomSession;

@interface GLChatSession : NSObject

@property (nonatomic, readonly, strong) GLRoomSession * roomSession;
@property (nonatomic, readonly, strong) GLUser * currentLoginUser;

/**
 *  初始化聊天模块
 *
 *  @param roomSession 聊天室session
 */
- (instancetype)initWithSession:(GLRoomSession *)roomSession;

/**
 *  登录聊天室。需要验证roomSession
 *
 *  @param success 成功回调。account表示当前登录用户的唯一ID，nickname表示当前登录账户的昵称，该昵称与创建token时传入的昵称一致。
 *  @param failure 失败回调
 */
- (void)loginOnSuccess:(void(^)(NSString *account, NSString *nickname))success failure:(void(^)(NSError *error))failure;

/**
 *  退出聊天室登录，并断开连接，不再接收消息
 */
- (void)logout;

/**
 *  发送文本消息
 *
 *  @param text    发送的文本内容
 *  @param extra   消息附加字段
 *  @param success 成功回调
 *  @param failure 失败回调
 *
 *  @return 当前发送出去的消息对象，消息type为GLChatMessageTypeText
 */
- (GLChatMessage *)sendText:(NSString *)text extra:(NSString *)extra success:(void(^)())success failure:(void(^)(NSError *error))failure;

/**
 *  发送通知消息
 *
 *  @param notify  通知内容
 *  @param extra   消息附加字段
 *  @param success 成功回调
 *  @param failure 失败回调
 *
 *  @return 当前发送出去的消息对象，消息type为GLChatMessageTypeNotify，其中，text字段表示通知内容
 */
- (GLChatMessage *)sendNotify:(NSString *)notify extra:(NSString *)extra success:(void(^)())success failure:(void(^)(NSError *error))failure;

/**
 *  发送消息。服务器只对消息的具体发送内容（text，type，extra）进行透传，客户端可以自行定义消息的格式并进行解析。
 *
 *  @param msg     需要发送的消息对象
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)sendMessage:(GLChatMessage *)msg success:(void(^)())success failure:(void(^)(NSError *error))failure;

/**
 *  获取当前聊天室
 *
 *  @param success 成功回调。count表示总人数
 *  @param failure 失败回调
 */
- (void)getRoomMemberCountOnSuccess:(void(^)(NSInteger count))success failure:(void(^)(NSError *error))failure;

/**
 *  禁言用户。只有主播和助理账号有该权限
 *
 *  @param mute        禁言或者取消禁言
 *  @param userAccount 用户账号
 */
- (void)mute:(BOOL)mute user:(NSString *)userAccount success:(void(^)())success failure:(void(^)(NSError *error))failure;;

/**
 *  踢出用户。只有主播和助理账号有该权限
 *
 *  @param userAccount 用户账号
 */
- (void)kickUser:(NSString *)userAccount success:(void(^)())success failure:(void(^)(NSError *error))failure;;

/**
 *  添加观察者对象，监听客户端状态变化。
 *
 *  @param observer 需要添加的观察者
 */
- (void)addObserver:(id<GLChatObserver>)observer;

/**
 *  移除指定的观察者对象
 *
 *  @param observer 需要移除的观察者
 */
- (void)removeObserver:(id<GLChatObserver>)observer;

@end
