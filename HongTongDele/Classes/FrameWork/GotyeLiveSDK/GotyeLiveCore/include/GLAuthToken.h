//
//  GLAuthToken.h
//  GotyeLiveCore
//
//  Created by Nick on 15/10/29.
//  Copyright © 2015年 AiLiao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 角色级别枚举
 */
typedef NS_ENUM(NSInteger, GLAuthTokenRole) {
    /**
     *  后台用户
     */
    GLAuthTokenRoleAPI = 1,
    /**
     *  主播用户
     */
    GLAuthTokenRolePresenter = 2,
    /**
     *  助理用户
     */
    GLAuthTokenRoleAssitant = 3,
    /**
     *  普通用户
     */
    GLAuthTokenRoleOrdinaryUser = 4,
};

@interface GLAuthToken : NSObject

/**
 * 认证token
 */
@property (nonatomic, copy) NSString * accessToken;
/**
 *  有效时间,单位（秒）
 */
@property (nonatomic, assign) NSInteger expiresIn;
/**
 *  当前用户级别
 */
@property (nonatomic, assign) GLAuthTokenRole role;
/**
 *  创建时间，本地维护
 */
@property (nonatomic, assign) NSInteger createTime;

@property (nonatomic, readonly, getter=isExpired) BOOL expired;
@property (nonatomic, assign) NSInteger userStatus;

@end
