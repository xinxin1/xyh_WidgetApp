//
//  DES.h
//  ChatAIAPP
//
//  Created by 吴琼 on 2023/5/11.
//

#import <Foundation/Foundation.h>
#import "GTMBase64.h"
#import <CommonCrypto/CommonCryptor.h>

@interface DES : NSObject

- (NSString *)decryptUseDES:(NSString *)base64EncodedString;

- (NSDictionary *)decryptDictionaryWithResponse:(id)response;

- (NSString *)decryptUseDES_WQ:(NSString *)base64EncodedString;

@end
