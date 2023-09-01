//
//  UIDevice+HRAddress.h
//  ChatAIAPP
//
//  Created by 吴琼 on 2023/5/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (HRAddress)

+ (NSString *)getIPAddress:(BOOL)preferIPv4;

+ (NSString *)decryptKey;

@end

NS_ASSUME_NONNULL_END
