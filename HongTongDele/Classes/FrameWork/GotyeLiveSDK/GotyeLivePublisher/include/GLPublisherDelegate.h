//
//  GLPublisherDelegate.h
//  GotyeLiveSDK
//
//  Created by Nick on 15/11/26.
//
//

#import <Foundation/Foundation.h>

@class GLPublisher;

/**
 *  视频发布状态回调
 */
@protocol GLPublisherDelegate <NSObject>
@optional
/**
 *  连接视频发布服务器成功，开始发布视频
 *
 *  @param publisher 对应的发布端实例
 */
- (void)publisherDidConnect:(GLPublisher *)publisher;
/**
 *  视频发布客户端被断开。一般情况下是由于程序退到了后台
 *
 *  @param publisher 对应的发布端实例
 */
- (void)publisherDidDisconnected:(GLPublisher *)publisher;
/**
 *  正在重连
 *
 *  @param publisher 对应的发布端实例
 */
- (void)publisherReconnecting:(GLPublisher *)publisher;
/**
 *  出现错误
 *
 *  @param error        错误的详细信息
 *  @param publisher    对应的发布端实例
 */
- (void)publisher:(GLPublisher *)publisher onError:(NSError *)error;

/**
 *  发布端状态更新的回调，1秒钟回调1次。包括bps、bufferSize属性的更新
 *
 *  @param publisher 对应的发布端实例
 */
- (void)publisherStatusDidUpdate:(GLPublisher *)publisher;

@end
