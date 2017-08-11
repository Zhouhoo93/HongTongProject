//
//  GLPlayerErrorCode.h
//  GotyeLiveSDK
//
//  Created by Nick on 15/12/31.
//
//

#ifndef GLPlayerErrorCode_h
#define GLPlayerErrorCode_h

typedef NS_ENUM(NSInteger, GLPlayerErrorCode) {
    /**
     *  验证失败
     */
    GLPlayerErrorCodeVerifyFailed =             401,
    /**
     *  获取直播状态失败
     */
    GLPlayerErrorCodeGetLiveStateFailed =       -101,
    /**
     *  网络断开
     */
    GLPlayerErrorCodeNetworkDisconnect =        -102,
    /**
     *  获取直播url失败
     */
    GLPlayerErrorCodeGetLiveUrlFailed =         -103,
    /**
     *  直播未开始
     */
    GLPlayerErrorCodeLiveNotStarttedYet =       -104,
};

#endif /* GLPlayerErrorCode_h */
