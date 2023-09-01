//
//  GTMBase64.h
//  ChatAIAPP
//
//  Created by 吴琼 on 2023/5/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTMBase64 : NSObject

+(NSData *)encodeData:(NSData *)data;

+(NSData *)decodeData:(NSData *)data;

+(NSData *)encodeBytes:(const void *)bytes length:(NSUInteger)length;

+(NSData *)decodeBytes:(const void *)bytes length:(NSUInteger)length;

+(NSString *)stringByEncodingData:(NSData *)data;

+(NSString *)stringByEncodingBytes:(const void *)bytes length:(NSUInteger)length;

+(NSData *)decodeString:(NSString *)string;

+(NSData *)webSafeEncodeData:(NSData *)data
                      padded:(BOOL)padded;

+(NSData *)webSafeDecodeData:(NSData *)data;

+(NSData *)webSafeEncodeBytes:(const void *)bytes
                       length:(NSUInteger)length
                       padded:(BOOL)padded;

+(NSData *)webSafeDecodeBytes:(const void *)bytes length:(NSUInteger)length;

+(NSString *)stringByWebSafeEncodingData:(NSData *)data
                                  padded:(BOOL)padded;

+(NSString *)stringByWebSafeEncodingBytes:(const void *)bytes
                                   length:(NSUInteger)length
                                   padded:(BOOL)padded;

+(NSData *)webSafeDecodeString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
