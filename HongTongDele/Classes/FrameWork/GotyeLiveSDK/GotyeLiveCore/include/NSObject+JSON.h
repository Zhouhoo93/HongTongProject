//
//  NSObject+JSON.h
//  Wowooh
//
//  Created by ouyang on 15/4/26.
//  Copyright (c) 2015年 Gotye. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GLJSONParser <NSObject>
@optional
- (id)parseJson:(id)obj forKey:(NSString *)key;
@end

@interface NSObject (JSON) <GLJSONParser>

- (NSString *)JSONRepresentation;
- (NSData *)JSONSerialization;
+ (instancetype)fromJSON:(NSDictionary *)jsonObject;

@end

@interface NSString (JSON)

- (id)JSONValue;

@end

@interface NSData (JSON)

- (id)JSONValue;

@end