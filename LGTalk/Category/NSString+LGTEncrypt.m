//
//  NSString+LGTEncrypt.m
//
//
//  Created by 刘亚军 on 2018/10/10.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "NSString+LGTEncrypt.h"
#import <CommonCrypto/CommonCrypto.h>
@implementation NSString (LGTEncrypt)
+ (NSString *)lgt_encryptWithKey:(NSString *)key encryptStr:(NSString *)encryptStr{
    //转化skey
    NSString *keyAfterMD5 = [self lgt_md5EncryptStr:key];
    NSData *keyData = [keyAfterMD5 dataUsingEncoding: NSUTF8StringEncoding];
    Byte *keyByte = (Byte *)[keyData bytes];
    Byte key_S = keyByte[keyData.length-1];//skey
    
    //转化加密字符串
    NSData *strData = [encryptStr dataUsingEncoding: NSUTF8StringEncoding];
    Byte *strByte = (Byte *)[strData bytes];
    //遍历数组并异或
    NSMutableString *strF = [NSMutableString stringWithCapacity:5];
    for(int i = 0;i < [strData length] ; i++){
        strByte[i] = strByte[i]^key_S;
        [strF appendFormat:@"%03d",strByte[i]];
    }
    //逆序输出
    NSString *reverseStrF = strF.lgt_reverse;
    return reverseStrF;
}
+ (NSString *)lgt_md5EncryptStr:(NSString *)encryptStr{
    const char *cStrValue = [encryptStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStrValue, (CC_LONG)strlen(cStrValue), result);
    NSMutableString *ciphertext = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSUInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ciphertext appendFormat:@"%02x", result[i]];
    }
    NSString *mdfiveString = [ciphertext lowercaseString];
    return mdfiveString;
}
+ (NSString *)lgt_encryptWithKey:(NSString *)key encryptDic:(NSDictionary *)encryptDic{
    NSData *jsData = [NSJSONSerialization dataWithJSONObject:encryptDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *codeString = [[NSString alloc] initWithData:jsData encoding:NSUTF8StringEncoding];
    return [self lgt_encryptWithKey:key encryptStr:codeString];
}

+ (NSString *)lgt_decryptWithKey:(NSString *)key decryptStr:(NSString *)decryptStr{
    //转化skey
    NSString *keyAfterMD5 = [self lgt_md5EncryptStr:key];
    NSData *keyData = [keyAfterMD5 dataUsingEncoding: NSUTF8StringEncoding];
    Byte *keyByte = (Byte *)[keyData bytes];
    Byte key_S = keyByte[keyData.length-1];//skey
    
    //字符串逆序
    int temp;
    NSMutableString *strRerverse = [NSMutableString stringWithCapacity:5];
    for(int i = (int)decryptStr.length-1 ; i>= 0; i--){
        temp = [decryptStr characterAtIndex:i];
        [strRerverse appendFormat:@"%c",temp];
    }
    //分割字符串
    Byte value[strRerverse.length/3];//定义字节数组
    
    for (int i=0, k=0; i<strRerverse.length; i+=3,k++) {
        NSRange range = NSMakeRange(i, 3);//i为开始点，3为取多少位
        temp = [[strRerverse substringWithRange:range]intValue];
        value[k] = temp ^ key_S;
    }
    NSData *adata = [[NSData alloc] initWithBytes:value length:strRerverse.length/3];
    NSString *strFin = [[NSString alloc] initWithData:adata encoding:NSUTF8StringEncoding];
    return strFin;
}

- (NSString *)lgt_reverse{
    NSMutableString *reverseString;
    NSInteger len = [self length];
    // 给字符串分配一块内存空间
    reverseString = [NSMutableString stringWithCapacity:len];
    // 对字符串进行反转
    while (len > 0) {
        [reverseString appendString:[NSString stringWithFormat:@"%c",[self characterAtIndex:--len]]];
    }
    return reverseString;
}
@end
