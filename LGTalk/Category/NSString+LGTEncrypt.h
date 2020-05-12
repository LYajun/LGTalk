//
//  NSString+LGTEncrypt.h
//  
//
//  Created by 刘亚军 on 2018/10/10.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LGTEncrypt)

+ (NSString *)lgt_encryptWithKey:(NSString *)key encryptStr:(NSString *)encryptStr;
+ (NSString *)lgt_encryptWithKey:(NSString *)key encryptDic:(NSDictionary *)encryptDic;
+ (NSString *)lgt_md5EncryptStr:(NSString *)encryptStr;

+ (NSString *)lgt_decryptWithKey:(NSString *)key decryptStr:(NSString *)decryptStr;

- (NSString *)lgt_reverse;
@end
