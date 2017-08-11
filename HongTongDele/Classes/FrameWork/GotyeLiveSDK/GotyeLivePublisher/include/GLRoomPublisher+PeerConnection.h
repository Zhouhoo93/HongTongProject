//
//  GLRoomPublisher+PeerConnection.h
//  GotyeLiveSDK
//
//  Created by Nick on 16/6/30.
//
//

#import "GLRoomPublisher.h"
#import "GLPeerConnectionProtocol.h"

typedef NS_ENUM(NSUInteger, GLRoomPublisherPCEvent) {
    GLRoomPublisherPCEventInvite = 101,
    GLRoomPublisherPCEventAccept = 102,
    GLRoomPublisherPCEventDeny = 103,
    GLRoomPublisherPCEventEnd = 104
};

@interface GLRoomPublisher (PeerConnection)

@property(nonatomic, readonly) NSString * currentUser;

/**
 *  邀请用户进行视频互动
 *
 *  @param userId  被邀请的用户id
 *  @param success 成功回调。accept为YES表示接受邀请，NO表示拒绝邀请
 *  @param failure 失败回调
 */
- (void)inviteUser:(NSString *)userId withCallback:(void(^)(GLRoomPublisherPCEvent event))callback failure:(void(^)(NSError *error))failure;

/**
 *  断开与某个用户的视频互动
 *
 *  @param userId  需要断开的用户id
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)uninviteUser:(NSString *)userId withSuccess:(void(^)())success failure:(void(^)(NSError *error))failure;

/**
 *  结束视频互动
 */
- (void)endPeerConnection;

@end
