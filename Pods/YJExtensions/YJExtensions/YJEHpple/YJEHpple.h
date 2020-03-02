//
//  Created by 刘亚军 on 2019/7/20.
//


#import <Foundation/Foundation.h>

#import "YJEHppleElement.h"

@interface YJEHpple : NSObject

- (id) initWithData:(NSData *)theData encoding:(NSString *)encoding isXML:(BOOL)isDataXML;
- (id) initWithData:(NSData *)theData isXML:(BOOL)isDataXML;
- (id) initWithXMLData:(NSData *)theData encoding:(NSString *)encoding;
- (id) initWithXMLData:(NSData *)theData;
- (id) initWithHTMLData:(NSData *)theData encoding:(NSString *)encoding;
- (id) initWithHTMLData:(NSData *)theData;

+ (YJEHpple *) hppleWithData:(NSData *)theData encoding:(NSString *)encoding isXML:(BOOL)isDataXML;
+ (YJEHpple *) hppleWithData:(NSData *)theData isXML:(BOOL)isDataXML;
+ (YJEHpple *) hppleWithXMLData:(NSData *)theData encoding:(NSString *)encoding;
+ (YJEHpple *) hppleWithXMLData:(NSData *)theData;
+ (YJEHpple *) hppleWithHTMLData:(NSData *)theData encoding:(NSString *)encoding;
+ (YJEHpple *) hppleWithHTMLData:(NSData *)theData;

- (NSArray *) searchWithXPathQuery:(NSString *)xPathOrCSS;
- (YJEHppleElement *) peekAtSearchWithXPathQuery:(NSString *)xPathOrCSS;

@property (nonatomic, readonly) NSData * data;
@property (nonatomic, readonly) NSString * encoding;

@end
