//
//  GLRoomPlayer+PeerConnection.h
//  GotyeLiveSDK
//
//  Created by Nick on 16/7/4.
//
//

#import "GLRoomPlayer.h"
#import "GLPeerConnectionProtocol.h"

typedef NS_ENUM(NSUInteger, GLRoomPlayerPCEvent) {
    GLRoomPlayerPCEventInvite = 101,
    GLRoomPlayerPCEventAccept = 102,
    GLRoomPlayerPCEventDeny = 103,
    GLRoomPlayerPCEventEnd = 104
};

@interface GLRoomPlayer (PeerConnection)

@property(nonatomic, readonly) NSString * currentUser;
@property(nonatomic, copy) void(^PCEventCallback)(NSString *userId, GLRoomPlayerPCEvent event);

/**
 *  接受视频互动邀请
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)acceptInvitationWithSuccess:(void(^)())success failure:(void(^)(NSError *error))failure;

/**
 *  拒绝视频互动邀请
 *
 */
- (void)denyInvitation;

/**
 *  结束视频互动
 */
- (void)endPeerConnection;

@end
