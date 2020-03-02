//
//  Created by 刘亚军 on 2019/7/20.
//


#import "YJEHppleElement.h"
#import "XPathQuery.h"

static NSString * const YJEHppleNodeContentKey           = @"nodeContent";
static NSString * const YJEHppleNodeNameKey              = @"nodeName";
static NSString * const YJEHppleNodeChildrenKey          = @"nodeChildArray";
static NSString * const YJEHppleNodeAttributeArrayKey    = @"nodeAttributeArray";
static NSString * const YJEHppleNodeAttributeNameKey     = @"attributeName";

static NSString * const YJEHppleTextNodeName            = @"text";

@interface YJEHppleElement ()
{    
    NSDictionary * node;
    BOOL isXML;
    NSString *encoding;
    __unsafe_unretained YJEHppleElement *parent;
}

@property (nonatomic, unsafe_unretained, readwrite) YJEHppleElement *parent;

@end

@implementation YJEHppleElement
@synthesize parent;


- (id) initWithNode:(NSDictionary *) theNode isXML:(BOOL)isDataXML withEncoding:(NSString *)theEncoding
{
  if (!(self = [super init]))
    return nil;

    isXML = isDataXML;
    node = theNode;
    encoding = theEncoding;

  return self;
}

+ (YJEHppleElement *) hppleElementWithNode:(NSDictionary *) theNode isXML:(BOOL)isDataXML withEncoding:(NSString *)theEncoding
{
  return [[[self class] alloc] initWithNode:theNode isXML:isDataXML withEncoding:theEncoding];
}

#pragma mark -

- (NSString *)raw
{
    return [node objectForKey:@"raw"];
}

- (NSString *) content
{
  return [node objectForKey:YJEHppleNodeContentKey];
}


- (NSString *) tagName
{
  return [node objectForKey:YJEHppleNodeNameKey];
}

- (NSArray *) children
{
  NSMutableArray *children = [NSMutableArray array];
  for (NSDictionary *child in [node objectForKey:YJEHppleNodeChildrenKey]) {
      YJEHppleElement *element = [YJEHppleElement hppleElementWithNode:child isXML:isXML withEncoding:encoding];
      element.parent = self;
      [children addObject:element];
  }
  return children;
}

- (YJEHppleElement *) firstChild
{
  NSArray * children = self.children;
  if (children.count)
    return [children objectAtIndex:0];
  return nil;
}

- (NSArray *)attibuteArray{
    return [node objectForKey:YJEHppleNodeAttributeArrayKey];
}

- (NSDictionary *) attributes
{
  NSMutableDictionary * translatedAttributes = [NSMutableDictionary dictionary];
  for (NSDictionary * attributeDict in [node objectForKey:YJEHppleNodeAttributeArrayKey]) {
      if ([attributeDict objectForKey:YJEHppleNodeContentKey] && [attributeDict objectForKey:YJEHppleNodeAttributeNameKey]) {
          [translatedAttributes setObject:[attributeDict objectForKey:YJEHppleNodeContentKey]
                                   forKey:[attributeDict objectForKey:YJEHppleNodeAttributeNameKey]];
      }
  }
  return translatedAttributes;
}

- (NSString *) objectForKey:(NSString *) theKey
{
  return [[self attributes] objectForKey:theKey];
}

- (id) description
{
  return [node description];
}

- (BOOL)hasChildren
{
    if ([node objectForKey:YJEHppleNodeChildrenKey])
        return YES;
    else
        return NO;
}

- (BOOL)isTextNode
{
    // we must distinguish between real text nodes and standard nodes with tha name "text" (<text>)
    // real text nodes must have content
    if ([self.tagName isEqualToString:YJEHppleTextNodeName] && (self.content))
        return YES;
    else
        return NO;
}

- (NSArray*) childrenWithTagName:(NSString*)tagName
{
    NSMutableArray* matches = [NSMutableArray array];
    
    for (YJEHppleElement* child in self.children)
    {
        if ([child.tagName isEqualToString:tagName])
            [matches addObject:child];
    }
    
    return matches;
}

- (YJEHppleElement *) firstChildWithTagName:(NSString*)tagName
{
    for (YJEHppleElement* child in self.children)
    {
        if ([child.tagName isEqualToString:tagName])
            return child;
    }
    
    return nil;
}

- (NSArray*) childrenWithClassName:(NSString*)className
{
    NSMutableArray* matches = [NSMutableArray array];
    
    for (YJEHppleElement* child in self.children)
    {
        if ([[child objectForKey:@"class"] isEqualToString:className])
            [matches addObject:child];
    }
    
    return matches;
}

- (YJEHppleElement *) firstChildWithClassName:(NSString*)className
{
    for (YJEHppleElement* child in self.children)
    {
        if ([[child objectForKey:@"class"] isEqualToString:className])
            return child;
    }
    
    return nil;
}

- (YJEHppleElement *) firstTextChild
{
    for (YJEHppleElement* child in self.children)
    {
        if ([child isTextNode])
            return child;
    }
    
    return [self firstChildWithTagName:YJEHppleTextNodeName];
}

- (NSString *) text
{
    return self.firstTextChild.content;
}

// Returns all elements at xPath.
- (NSArray *) searchWithXPathQuery:(NSString *)xPathOrCSS
{
    
    NSData *data = [self.raw dataUsingEncoding:NSUTF8StringEncoding];

    NSArray * detailNodes = nil;
    if (isXML) {
        detailNodes = PerformXMLXPathQueryWithEncoding(data, xPathOrCSS, encoding);
    } else {
        detailNodes = PerformHTMLXPathQueryWithEncoding(data, xPathOrCSS, encoding);
    }
    
    NSMutableArray * hppleElements = [NSMutableArray array];
    for (id newNode in detailNodes) {
        [hppleElements addObject:[YJEHppleElement hppleElementWithNode:newNode isXML:isXML withEncoding:encoding]];
    }
    return hppleElements;
}

// Custom keyed subscripting
- (id)objectForKeyedSubscript:(id)key
{
    return [self objectForKey:key];
}

@end
