//
//  TripleDES.m
//  GotyeLiveApp
//
//  Created by Nick on 16/7/19.
//  Copyright © 2016年 Gotye. All rights reserved.
//

#import "TripleDES.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>

#define DESKEY @"B90F624F114E4324A7866BDF632DC083"  

static NSString * Crypt(CCOperation option, const void *vplainText, size_t plainTextBufferSize, BOOL base64)
{
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    const void *vkey = (const void *)[DESKEY UTF8String];
    // NSString *initVec = @"init Vec";
    //const void *vinitVec = (const void *) [initVec UTF8String];
    //  Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
    ccStatus = CCCrypt(option,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding | kCCOptionECBMode,
                       vkey,
                       kCCKeySize3DES,
                       nil,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    if (ccStatus != kCCSuccess) {
        NSLog(@"CCCrypt Failed. %d", ccStatus);
        free(bufferPtr);
        return nil;
    }
    
    /*else if (ccStatus == kCC ParamError) return @"PARAM ERROR";
     else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
     else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
     else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
     else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
     else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED"; */
    
    NSString *result;
    
    if (base64) {
        result = [[[NSData alloc]initWithBytes:bufferPtr length:bufferPtrSize]base64EncodedStringWithOptions:0];
    } else {
        result = [[NSString alloc]initWithBytes:bufferPtr length:bufferPtrSize encoding:NSUTF8StringEncoding];
    }
    
    free(bufferPtr);
    
    return result;
}

@implementation TripleDES

+ (NSString *)encrypt:(NSString *)plainText
{
    NSData *data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    return Crypt(kCCEncrypt, data.bytes, data.length, YES);
}

+ (NSString *)decrypt:(NSString *)encryptedText
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:encryptedText options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [Crypt(kCCDecrypt, data.bytes, data.length, NO)stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
}

@end
