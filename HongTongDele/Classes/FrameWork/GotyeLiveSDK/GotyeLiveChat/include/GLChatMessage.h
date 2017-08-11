//
//  GLChatMessage.h
//  GotyeLiveChat
//
//  Created by Nick on 15/11/3.
//  Copyright © 2015年 AiLiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, GLChatMessageStatus)
{
    /**
     *  默认状态。收到的消息以及本地创建的没有进行发送的消息都为该状态
     */
    GLChatMessageStatusDefault,
    /**
     *  正在发送中
     */
    GLChatMessageStatusSending,
    /**
     *  已发送
     */
    GLChatMessageStatusSent,
    /**
     *  发送失败
     */
    GLChatMessageStatusSendFailed
};

/**
 消息类型。由于服务器不对type进行判断，开发者可自行定义消息的枚举类型。
 */
typedef NS_ENUM(NSInteger, GLChatMessageType)
{
    GLChatMessageTypeText = 1,      //文本消息
    GLChatMessageTypeNotify = 3     //通知消息
};

@interface GLChatMessage : NSObject

/**
 *  接收者ID。当消息是聊天室消息时，该值为空
 */
@property (nonatomic, readonly) NSString * recvId;
/**
 *  接收者昵称。当消息是聊天室消息时，该值为空
 */
@property (nonatomic, readonly) NSString * recvName;
/**
 *  消息的具体内容
 */
@property (nonatomic, copy) NSString * text;
/**
 *  发送者ID
 */
@property (nonatomic, readonly) NSString * sendId;
/**
 *  发送者昵称
 */
@property (nonatomic, readonly) NSString * sendName;
/**
 *  消息额外字段
 */
@property (nonatomic, assign) NSString * extra;
/**
 *  消息类型
 */
@property (nonatomic, assign) NSInteger type;
/**
 *  消息状态
 */
@property (nonatomic, readonly) GLChatMessageStatus status;

@end
