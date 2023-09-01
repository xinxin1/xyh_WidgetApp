//
//  NSData+Algorithm.h
//  ChatAIAPP
//
//  Created by 吴琼 on 2023/5/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Algorithm)

- (NSData*)decrypto:(NSString*)type secretKey:(NSString*)secretKey;

@end

NS_ASSUME_NONNULL_END
