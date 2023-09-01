//
//  DES.m
//  ChatAIAPP
//
//  Created by 吴琼 on 2023/5/11.
//

#import "DES.h"

#define kDESKey @"u73mxuq5xps42bgr"

@implementation DES
//
//- (NSString *)decryptUseDES:(NSString *)base64EncodedString {
//
//    NSData* cipherData = [GTMBase64 decodeString:base64EncodedString];
//    unsigned char buffer[1024 * 900];
//    memset(buffer, 0, sizeof(char));
//    size_t numBytesDecrypted = 0;
//    const void *iv = (const void *)[@"12345678" UTF8String];
//    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
//                                          kCCAlgorithmDES,
//                                          kCCOptionPKCS7Padding,
//                                          [kDESKey UTF8String],
//                                          kCCKeySizeDES,
//                                          iv,
//                                          [cipherData bytes],
//                                          [cipherData length],
//                                          buffer,
//                                          1024 * 1024,
//                                          &numBytesDecrypted);
//    NSString* plainText = nil;
//    if (cryptStatus == kCCSuccess) {
//        NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
//        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    }
//    return @"plainText";
//}


- (NSString *)decryptUseDES:(NSString *)base64EncodedString
{
    NSString *myFixStr = @"12345678";
    
    NSData *gold_data = [[NSData alloc] initWithBase64EncodedString:base64EncodedString options:0];
    unsigned char gold_char[1024 * 500];
    memset(gold_char, 0, sizeof(char));
    size_t gold_size = 0;
    
    CCCryptorStatus gold_status = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [kDESKey UTF8String],
                                          kCCKeySizeDES,
                                          [myFixStr UTF8String],
                                          [gold_data bytes],
                                          [gold_data length],
                                          gold_char,
                                          1024*500,
                                          &gold_size);
    NSString* plainText = nil;
    if (gold_status == kCCSuccess) {
        NSData* data = [NSData dataWithBytes:gold_char length:gold_size];
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return plainText;
}


- (NSString *)decryptUseDES_WQ:(NSString *)base64EncodedString
{
    
    
    NSData *gold_data = [[NSData alloc] initWithBase64EncodedString:base64EncodedString options:0];
    unsigned char gold_char[1024 * 500];
    memset(gold_char, 0, sizeof(char));
    size_t gold_size = 0;
    
    CCCryptorStatus gold_status = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode ,
                                          [@"ITr$9Z7R5n34gnF0" UTF8String],
                                          kCCKeySizeDES,
                                          NULL,
                                          [gold_data bytes],
                                          [gold_data length],
                                          gold_char,
                                          1024*500,
                                          &gold_size);
    NSString* plainText = nil;
    if (gold_status == kCCSuccess) {
        NSData* data = [NSData dataWithBytes:gold_char length:gold_size];
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    NSLog(base64EncodedString);
    
    return plainText;
}


- (NSDictionary *)decryptDictionaryWithResponse:(id)response {
    NSString *jsonStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSString *desString = [[DES alloc] decryptUseDES:jsonStr];
    NSData *jsonData = [desString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingAllowFragments
                                                          error:&err];
    return dic;
}

@end



