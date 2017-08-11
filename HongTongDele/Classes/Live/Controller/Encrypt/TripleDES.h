//
//  TripleDES.h
//  GotyeLiveApp
//
//  Created by Nick on 16/7/19.
//  Copyright © 2016年 Gotye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TripleDES : NSObject

+ (NSString *)encrypt:(NSString *)plainText;
+ (NSString *)decrypt:(NSString *)encryptedText;

@end
