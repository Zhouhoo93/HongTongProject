//
//  GotyeLiveConfig.h
//  GotyeLiveApp
//
//  Created by Nick on 16/7/21.
//  Copyright © 2016年 Gotye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GotyeLiveConfig : NSObject

+ (instancetype)config;

@property (nonatomic, copy) NSString * appkey;
@property (nonatomic, copy) NSString * accessSecret;
@property (nonatomic, copy) NSString * roomId;
@property (nonatomic, copy) NSString * password;
@property (nonatomic, copy) NSString * nickname;

+ (CGSize)labelAutoCalculateRectWith:(NSString *)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize;

@end
