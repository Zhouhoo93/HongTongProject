//
//  GLChatObserver.h
//  GotyeLiveChat
//
//  Created by Nick on 15/11/3.
//  Copyright © 2015年 AiLiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GLChatMessage;
@class GLChatSession;

@protocol GLChatObserver <NSObject>

@optional

/**
 *  收到消息时的回调
 *
 *  @param chatSession   对应的聊天session
 *  @param msg           收到消息的具体内容
 */
- (void)chatClient:(GLChatSession *)chatSession didReceiveMessage:(GLChatMessage *)msg;

/**
 *  与服务器失去连接时的回调
 *  @param chatSession   对应的聊天session
 *
 */
- (void)chatClientDidDisconnected:(GLChatSession *)chatSession;

/**
 *  正在尝试重新连接服务器时的回调（当与服务器失去连接时，API会自动进行重连）。
 *  @param chatSession   对应的聊天session
 */
- (void)chatClientReconnecting:(GLChatSession *)chatSession;

/**
 *  重新登录成功时的回调
 *  @param chatSession   对应的聊天session
 */
- (void)chatClientReLoginSuccess:(GLChatSession *)chatSession;

/**
 *  重新登录失败时的回调（这种情况一般是由于密码错误或者token过期之类的原因，导致认证失败）。
 *
 *  @param chatSession   对应的聊天session
 *  @param error         重登失败的具体错误
 */
- (void)chatClient:(GLChatSession *)chatSession reLoginFailed:(NSError *)error;

/**
 *  账号在别处登录，   本地被强制踢下线的回调
 *  @param chatSession   对应的聊天session
 */
- (void)chatClientDidForceLogout:(GLChatSession *)chatSession;

- (void)chatClientDidKickedOut:(GLChatSession *)cahtSession;

@end
