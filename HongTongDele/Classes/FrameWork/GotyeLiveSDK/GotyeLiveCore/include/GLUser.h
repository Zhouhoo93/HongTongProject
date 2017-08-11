//
//  GLUser.h
//  GotyeLiveSDK
//
//  Created by Nick on 16/7/4.
//
//

#import <Foundation/Foundation.h>

/**
 *  用户具体信息
 */
@interface GLUser : NSObject

/**
 *  用户账号，即唯一ID
 */
@property (nonatomic, copy) NSString * account;
/**
 *  用户昵称
 */
@property (nonatomic, copy) NSString * nickname;

/**
 *  通过账号与昵称创建一个GLChatUser实例
 *
 *  @param account  用户账号
 *  @param nickname 用户昵称
 *
 *  @return GLChatUser类的一个实例
 */
- (instancetype)initWithAccount:(NSString *)account nickname:(NSString *)nickname;

@end
