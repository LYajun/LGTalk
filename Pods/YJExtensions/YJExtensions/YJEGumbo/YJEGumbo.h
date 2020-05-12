//  Created by 刘亚军 on 2019/3/15.
//  Copyright © 2019 刘亚军. All rights reserved.

#if !__has_feature(objc_arc)
    #error YJEGumbo must be built with ARC.
#endif

//please add gumbo(https://github.com/google/gumbo-parser/tree/master/src) sources or lib to the project.
#include "gumbo.h"
#import <Foundation/Foundation.h>

//for YJEGumbo+Query.
id YJEGumboNodeCast(GumboNode *node);
id YJEGumboAttributeCast(GumboAttribute *attribute);

#pragma mark -
@interface YJEGumboNode : NSObject {
  @public
    GumboNode *_gumboNode;  //public for YJEGumbo+Query.
}

@property (nonatomic, copy, readonly) NSString *nodeName;
@property (nonatomic, copy, readonly) NSString *nodeValue;
@property (nonatomic, readonly) GumboNodeType   nodeType;

@property (nonatomic, readonly) NSArray *childNodes;
@property (nonatomic, readonly) YJEGumboNode *parentNode;

@end

#pragma mark -
@class YJEGumboAttribute;
@interface YJEGumboElement : YJEGumboNode

@property (nonatomic, copy, readonly) NSString *tagName;
@property (nonatomic, readonly) GumboTag tag;

@property (nonatomic, readonly) NSArray *attributes;

- (BOOL)hasAttribute:(NSString *)name;
- (NSString *)getAttribute:(NSString *)name;
- (YJEGumboAttribute *)getAttributeNode:(NSString *)name;

@end

#pragma mark -
@interface YJEGumboText : YJEGumboNode

@property (nonatomic, copy, readonly) NSString *data;

@end

#pragma mark -
@interface YJEGumboDocument : YJEGumboNode

@property (nonatomic, copy, readonly) NSString *title;

@property (nonatomic, readonly) BOOL hasDoctype;
@property (nonatomic, copy, readonly) NSString *publicID;
@property (nonatomic, copy, readonly) NSString *systemID;

@property (nonatomic, readonly) YJEGumboElement *rootElement;
@property (nonatomic, readonly) YJEGumboElement *head;
@property (nonatomic, readonly) YJEGumboElement *body;

- (instancetype)initWithHTMLString:(NSString *)htmlString;

@end

#pragma mark -
@interface YJEGumboAttribute : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *value;

@end
