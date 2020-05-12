//  Created by 刘亚军 on 2019/3/15.
//  Copyright © 2019 刘亚军. All rights reserved.


#import "YJEGumbo.h"

#pragma mark C Methods

#if !defined(NS_INLINE)
    #define NS_INLINE static inline
#endif

NS_INLINE GumboVector YJE_gumbo_get_children(GumboNode *node) {
    if (node->type == GUMBO_NODE_DOCUMENT) {
        return node->v.document.children;
    }
    if (node->type == GUMBO_NODE_ELEMENT) {
        return node->v.element.children;
    }
    return kGumboEmptyVector;
}

NS_INLINE int YJE_gumbo_get_child_cout(GumboNode *node) {
    return YJE_gumbo_get_children(node).length;
}

NS_INLINE GumboTag YJE_gumbo_get_tag(GumboNode *node) {
    return node->v.element.tag;
}

NS_INLINE const char *YJE_gumbo_get_tagname(GumboNode *node) {
    if (node->type == GUMBO_NODE_ELEMENT) {
        return gumbo_normalized_tagname(node->v.element.tag);
    }
    return NULL;
}

NS_INLINE const char *YJE_gumbo_get_attribute(GumboNode *node, const char *name) {
    if (node->type == GUMBO_NODE_ELEMENT) {
        GumboVector attributes = node->v.element.attributes;
        GumboAttribute *attribute = gumbo_get_attribute(&attributes, name);
        if (attribute) {
            return attribute->value;
        }
    }
    return NULL;
}

NS_INLINE int YJE_gumbo_get_attribute_count(GumboNode *node) {
    if (node->type == GUMBO_NODE_ELEMENT) {
        return node->v.element.attributes.length;
    }
    return 0;
}

NS_INLINE GumboNode *YJE_gumbo_get_child_at_index(GumboNode *node, int index) {
    return YJE_gumbo_get_children(node).data[index];
}

NS_INLINE GumboNode *YJE_gumbo_get_firstchild(GumboNode *node) {
    GumboVector children = YJE_gumbo_get_children(node);
    if (children.length) {
        return children.data[0];
    }
    return NULL;
}

NS_INLINE GumboNode *YJE_gumbo_get_first_element_by_tag(GumboNode *node, GumboTag tag) {
    GumboNode *root = node;
    int count = YJE_gumbo_get_child_cout(root);
    for (int i = 0; i < count; i++) {
        GumboNode *child = YJE_gumbo_get_child_at_index(root, i);
        if (child->type == GUMBO_NODE_ELEMENT) {
            if (YJE_gumbo_get_tag(child) == tag) {
                return child;
            } else {
                GumboNode *node = YJE_gumbo_get_first_element_by_tag(child, tag);
                if (node) {
                    return node;
                }
            }
        }
    }
    return NULL;
}


#pragma mark -
@implementation YJEGumboNode

- (id)initWithGumboNode:(GumboNode *)node {
    self = [super init];
    if (self) {
        _gumboNode = node;
    }
    return self;
}

+ (id)nodeWithGumboNode:(GumboNode *)node {
    Class cls;
    if (node->type == GUMBO_NODE_DOCUMENT) {
        cls = [YJEGumboDocument class];
    } else if (node->type == GUMBO_NODE_ELEMENT) {
        cls = [YJEGumboElement class];
    } else {
        cls = [YJEGumboText class];
    }
    return [[cls alloc] initWithGumboNode:node];
}

id YJEGumboNodeCast(GumboNode *node) {
    return [YJEGumboNode nodeWithGumboNode:node];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p %@>" ,[self class],self,
            self.nodeName ? self.nodeName : self.nodeValue];
}

- (BOOL)isEqual:(YJEGumboNode *)object {
    if (object && [object isKindOfClass:[YJEGumboNode class]]) {
        return _gumboNode == object->_gumboNode;
    }
    return NO;
}

#pragma mark - Properties
- (NSString *)nodeName {
    if (_gumboNode->type == GUMBO_NODE_DOCUMENT) {
        return @"#document";
    }
    if (_gumboNode->type == GUMBO_NODE_ELEMENT) {
        return @(YJE_gumbo_get_tagname(_gumboNode));
    }
    if (_gumboNode->type == GUMBO_NODE_TEXT) {
        return @"#text";
    }
    return nil;
}

- (NSString *)nodeValue {
    GumboNodeType type = _gumboNode->type;
    if (type != GUMBO_NODE_DOCUMENT &&
        type != GUMBO_NODE_ELEMENT) {
        return @(_gumboNode->v.text.text);
    }
    return nil;
}

- (GumboNodeType)nodeType {
    return _gumboNode->type;
}

- (NSArray *)childNodes {
    NSMutableArray *childNodes = [[NSMutableArray alloc] init];
    GumboVector children = YJE_gumbo_get_children(_gumboNode);
    for (int i = 0; i < children.length; i++) {
        GumboNode *child = children.data[i];
        [childNodes addObject:YJEGumboNodeCast(child)];
    }
    return childNodes;
}

- (YJEGumboNode *)parentNode {
    return YJEGumboNodeCast(_gumboNode->parent);
}

@end


#pragma mark -
@implementation YJEGumboElement

- (NSString *)tagName {
    return self.nodeName;
}

- (GumboTag)tag {
    return YJE_gumbo_get_tag(_gumboNode);
}

- (NSArray *)attributes {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    GumboVector attributes = _gumboNode->v.element.attributes;
    for (int i = 0; i < attributes.length; i++) {
        GumboAttribute *attribute = attributes.data[i];
        [result addObject:YJEGumboAttributeCast(attribute)];
    }
    return result;
}

- (BOOL)hasAttribute:(NSString *)name {
    return gumbo_get_attribute(&_gumboNode->v.element.attributes, [name UTF8String]) != NULL;
}

- (YJEGumboAttribute *)getAttributeNode:(NSString *)name {
    return YJEGumboAttributeCast(gumbo_get_attribute(&_gumboNode->v.element.attributes, [name UTF8String]));
}

- (NSString *)getAttribute:(NSString *)name {
    const char *text = YJE_gumbo_get_attribute(_gumboNode, [name UTF8String]);
    return text ? @(text) : nil;
}

@end

#pragma mark -
@implementation YJEGumboText

- (NSString *)data {
    return @(_gumboNode->v.text.text);
}

@end

#pragma mark -
@implementation YJEGumboDocument {
    GumboOutput *_gumboOutput;
}

- (void)dealloc {
    gumbo_destroy_output(&kGumboDefaultOptions, _gumboOutput);
}

- (instancetype)initWithHTMLString:(NSString *)htmlString {
    self = [super init];
    if (self) {
        _gumboOutput = gumbo_parse([htmlString UTF8String]);
        _gumboNode = _gumboOutput->document;
    }
    return self;
}

#pragma mark - Properties
- (NSString *)title {
    GumboNode *node = YJE_gumbo_get_first_element_by_tag(_gumboNode, GUMBO_TAG_TITLE);
    if (node && node->v.element.children.length) {
        GumboNode *text = node->v.element.children.data[0];
        if (text->type == GUMBO_NODE_TEXT) {
            return @(text->v.text.text);
        }
    }
    return nil;
}

- (BOOL)hasDoctype {
    return _gumboNode->v.document.has_doctype;
}

- (NSString *)publicID {
    return @(_gumboNode->v.document.public_identifier);
}

- (NSString *)systemID {
    return @(_gumboNode->v.document.system_identifier);
}

- (YJEGumboElement *)rootElement {
    return YJEGumboNodeCast(_gumboOutput->root);
}

- (YJEGumboElement *)head {
    GumboNode *node = YJE_gumbo_get_first_element_by_tag(_gumboNode, GUMBO_TAG_HEAD);
    return YJEGumboNodeCast(node);
}

- (YJEGumboElement *)body {
    GumboNode *node = YJE_gumbo_get_first_element_by_tag(_gumboNode, GUMBO_TAG_BODY);
    return YJEGumboNodeCast(node);
}

@end

#pragma mark -
@implementation YJEGumboAttribute {
    GumboAttribute *_gumboAttribute;
}

- (instancetype)initWithGumboAttribute:(GumboAttribute *)attribute {
    self = [super init];
    if (self) {
        _gumboAttribute = attribute;
    }
    return self;
}

+ (instancetype)attributeWithGumboAttribute:(GumboAttribute *)attribute {
    return [[YJEGumboAttribute alloc] initWithGumboAttribute:attribute];
}

id YJEGumboAttributeCast(GumboAttribute *attribute) {
    return [YJEGumboAttribute attributeWithGumboAttribute:attribute];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p %@=%@>", [self class], self, self.name, self.value];
}

#pragma mark - Properties
- (NSString *)name {
    return @(_gumboAttribute->name);
}

- (NSString *)value {
    return @(_gumboAttribute->value);
}

@end
