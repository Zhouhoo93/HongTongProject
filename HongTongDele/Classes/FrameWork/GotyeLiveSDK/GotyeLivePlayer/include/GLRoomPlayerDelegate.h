//
//  GLRoomPlayerDelegate.h
//  GotyeLiveSDK
//
//  Created by Nick on 16/3/18.
//
//

#import <Foundation/Foundation.h>
#import "GLPlayerDelegate.h"

@class GLRoomPlayer;

@protocol GLRoomPlayerDelegate <GLPlayerDelegate>
@optional
/**
 *  直播结束的回调。如果GLPlayer的autoPlay属性为YES，那么在收到这个回调的时候SDK底层会自动调用播放视频的接口尝试播放视频。如果为NO，那么需要开发者自行调用播放视频接口
 *
 *  @param player 对应的播放器实例
 */
- (void)onLiveStop:(GLRoomPlayer *)player;

/**
 *  直播开始的回调
 *
 *  @param player 对应的播放器实例
 */
- (void)onLiveStart:(GLRoomPlayer *)player;

@end
