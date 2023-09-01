//
//  NSData+Algorithm.m
//  ChatAIAPP
//
//  Created by 吴琼 on 2023/5/11.
//

#import "NSData+Algorithm.h"

#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (Algorithm)

static NSString * const ResultDefault = @"{\"msg\":\"检查.KEY.的截取?\", \"code\":201}";

- (NSData*)decrypto:(NSString*)type secretKey:(NSString*)key {
    if (key.length < 28){
        return [ResultDefault dataUsingEncoding:NSUTF8StringEncoding];
    }
    NSString* secretKey = [key substringWithRange:NSMakeRange(8, 16)];
    NSString* offset = [key substringWithRange:NSMakeRange(12, 16)];
    if ([self isJSONObject]) {
        return self;
    } else if ([@"DES" isEqualToString:type]) {
        return [self decryptoDES:secretKey withIV:offset];
    } else if ([@"AES" isEqualToString:type]) {
        return [self decryptoAES:secretKey withIV:offset];
    }
    return self;
}

- (BOOL)isJSONObject {
    @try {
        NSError *error;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingFragmentsAllowed error:&error];
        return (jsonObject && !error);
    } @catch (NSException *exception) {
        NSLog(@"%@", [exception reason]);
        return NO;
    }
}

- (NSData*)decryptoDES:(NSString*)secretKey withIV:(NSString*)iv {
    NSString * base64Text = [self stringWithDecodeBase64];
    NSData * cipherData = [self convertHexStrToData:base64Text];
    unsigned long length = cipherData.length;
    unsigned long buffer = 1024;
    unsigned long loc = 0;
    NSMutableData * resultData = [NSMutableData data];
    for (loc = 0; loc < (length/buffer); loc++) {
        NSData * subdata = [cipherData subdataWithRange:NSMakeRange((loc * buffer), buffer)];
        [resultData appendData:[subdata useDES:secretKey withIV:iv]];
    }
    if ((length % buffer) > 0) {
        NSData * subdata = [cipherData subdataWithRange:NSMakeRange((loc * buffer), (length % buffer))];
        [resultData appendData:[subdata useDES:secretKey withIV:iv]];
    }
    return resultData.copy;
}

- (NSData*)decryptoAES:(NSString*)secretKey withIV:(NSString*)iv {
    NSData * cipherData = [self dataWithDecodeBase64];
    return [cipherData useAES:secretKey withIV:iv];
}

- (NSData * __nullable)useAES:(NSString *)secretKey withIV:(NSString*)iv {
    unsigned long len = [self length];
    unsigned long buffer[len];
    memset(buffer, 0, sizeof(long));
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding,//|kCCOptionECBMode,
                                          [secretKey UTF8String],
                                          kCCKeySizeAES128,
                                          [iv UTF8String],
                                          [self bytes],
                                          len,
                                          buffer,
                                          len,
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
    }
    return nil;
}

- (NSData * __nullable)useDES:(NSString *)secretKey withIV:(NSString*)iv {
    // DES kCCOptionECBMode 对齐能分段解密
    unsigned long len = [self length];
    unsigned long buffer[len];
    memset(buffer, 0, sizeof(long));
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          [secretKey UTF8String],
                                          kCCKeySizeDES,
                                          NULL,
                                          [self bytes],
                                          len,
                                          buffer,
                                          len,
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
    }
    return nil;
}

- (NSString*)stringWithDecodeBase64 {
    return [[NSString alloc] initWithData:[self dataWithDecodeBase64] encoding:NSUTF8StringEncoding];
}

- (NSData*)dataWithDecodeBase64 {
    return [[NSData alloc] initWithBase64EncodedData:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
}

/*
 将16进制字符串转成NSData
 */
- (NSData*)convertHexStrToData:(NSString*)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}

@end
