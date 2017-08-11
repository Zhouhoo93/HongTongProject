//
//  GLPlayerDelegate.h
//  GotyeLiveSDK
//
//  Created by Nick on 15/11/26.
//
//

#import <Foundation/Foundation.h>

@class GLPlayer;

/**
 *  播放器的状态回调
 */
@protocol GLPlayerDelegate <NSObject>

@optional

/**
 *  开始播放的回调
 *
 *  @param player 对应的播放器实例
 */
- (void)playerDidConnect:(GLPlayer *)player;

/**
 *  停止播放的回调
 *
 *  @param player 对应的播放器实例
 */
- (void)playerDidDisconnected:(GLPlayer *)player;

/**
 *  播放出现错误时的回调
 *
 *  @param error  错误的详细信息
 *  @param player 对应的播放器实例
 */
- (void)player:(GLPlayer *)player onError:(NSError *)error;

/**
 *  播放器正在重新尝试连接服务器时的回调
 *
 *  @param player 对应的播放器实例
 */
- (void)playerReconnecting:(GLPlayer *)player;

/**
 *  开始缓冲的回调。这个回调表示当前没有数据可以进行播放，需要缓冲。
 *
 *  @param player 对应的播放器实例
 */
- (void)playerBuffering:(GLPlayer *)player;

/**
 *  缓冲结束的回调。缓冲结束，播放器自动开始播放
 *
 *  @param player 对应的播放器实例
 */
- (void)playerBufferCompleted:(GLPlayer *)player;

/**
 *  播放器状态更新的回调，1秒钟回调1次。包括bps、numOfVideoBuffer、numOfAudioBuffer和delay属性的更新
 *
 *  @param player 对应的播放器实例
 */
- (void)playerStatusDidUpdate:(GLPlayer *)player;

@end
