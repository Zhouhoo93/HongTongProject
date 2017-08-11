//
//  GLChatErrorCode.h
//  GotyeLiveChat
//
//  Created by Nick on 15/11/3.
//  Copyright © 2015年 AiLiao. All rights reserved.
//

#ifndef GLChatErrorCode_h
#define GLChatErrorCode_h

typedef NS_ENUM(NSInteger, GLChatErrorCode)
{
    /**
     *  失败
     */
    GLChatErrorCodeFail = 300,
    /**
     *  无效token
     */
    GLChatErrorCodeInvalidToken = 401,
    /**
     *  无效角色,只有聊天室role可以登陆
     */
    GLChatErrorCodeInvalidRole = 403,
    /**
     *  系统异常
     */
    GLChatErrorCodeSystemError = 500,
    /**
     *  无操作权限
     */
    GLChatErrorCodePermissionDenied = 1001,
    /**
     *  已被禁言
     */
    GLChatErrorCodeDisableSpeak = 1003,
    /**
     *  消息内容和附加字段都为空
     */
    GLChatErrorCodeContentIsNull = 1005,
    /**
     *  无效TARGET_ID
     */
    GLChatErrorCodeInvalidTargetID = 1007,
    /**
     *  已经被禁止登陆
     */
    GLChatErrorCodeForbidden = 1009,
    
    /**
     *  数据解析出错
     */
    GLChatErrorCodeParseError = -101,
    /**
     *  网络错误
     */
    GLChatErrorCodeNetworkDisconnect = -102,
    /**
     *  当前没有登录
     */
    GLChatErrorCodeNotLogin = -103,
    /**
     *  已经登录
     */
    GLChatErrorCodeAlreadyLogin = -104,
    /**
     *  获取服务器地址失败
     */
    GLChatErrorCodeGetServerUrlFailed = -105,
    /**
     *  超时
     */
    GLChatErrorCodeTimeout = -106,
};

#endif /* GLChatErrorCode_h */
