//
//  GLPeerConnectionProtocol.h
//  GotyeLiveSDK
//
//  Created by Nick on 16/6/30.
//
//

#import <Foundation/Foundation.h>

@protocol GLPeerConnectionProtocol <NSObject>

/**
 *  连接视频通话房间。
 *
 *  @param roomId 需要连接的房间ID，可以是任意字符串
 *  @param userId 当前连接的用户ID
 */
- (void)connectToRoom:(NSString *)roomId withUserId:(NSString *)userId;

/**
 *  断开与视频通话房间的连接，结束当前视频通话
 */
- (void)disconnect;

@end
