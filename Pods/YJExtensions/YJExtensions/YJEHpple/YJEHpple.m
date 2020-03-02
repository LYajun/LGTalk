//
//  Created by 刘亚军 on 2019/7/20.
//

#import "YJEHpple.h"
#import "XPathQuery.h"

@interface YJEHpple ()
{
    NSData * data;
    NSString * encoding;
    BOOL isXML;
}

@end


@implementation YJEHpple

@synthesize data;
@synthesize encoding;


- (id) initWithData:(NSData *)theData encoding:(NSString *)theEncoding isXML:(BOOL)isDataXML
{
  if (!(self = [super init])) {
    return nil;
  }

  data = theData;
  encoding = theEncoding;
  isXML = isDataXML;

  return self;
}

- (id) initWithData:(NSData *)theData isXML:(BOOL)isDataXML
{
    return [self initWithData:theData encoding:nil isXML:isDataXML];
}

- (id) initWithXMLData:(NSData *)theData encoding:(NSString *)theEncoding
{
  return [self initWithData:theData encoding:theEncoding isXML:YES];
}

- (id) initWithXMLData:(NSData *)theData
{
  return [self initWithData:theData encoding:nil isXML:YES];
}

- (id) initWithHTMLData:(NSData *)theData encoding:(NSString *)theEncoding
{
    return [self initWithData:theData encoding:theEncoding isXML:NO];
}

- (id) initWithHTMLData:(NSData *)theData
{
  return [self initWithData:theData encoding:nil isXML:NO];
}

+ (YJEHpple *) hppleWithData:(NSData *)theData encoding:(NSString *)theEncoding isXML:(BOOL)isDataXML {
  return [[[self class] alloc] initWithData:theData encoding:theEncoding isXML:isDataXML];
}

+ (YJEHpple *) hppleWithData:(NSData *)theData isXML:(BOOL)isDataXML {
  return [[self class] hppleWithData:theData encoding:nil isXML:isDataXML];
}

+ (YJEHpple *) hppleWithHTMLData:(NSData *)theData encoding:(NSString *)theEncoding {
  return [[self class] hppleWithData:theData encoding:theEncoding isXML:NO];
}

+ (YJEHpple *) hppleWithHTMLData:(NSData *)theData {
  return [[self class] hppleWithData:theData encoding:nil isXML:NO];
}

+ (YJEHpple *) hppleWithXMLData:(NSData *)theData encoding:(NSString *)theEncoding {
  return [[self class] hppleWithData:theData encoding:theEncoding isXML:YES];
}

+ (YJEHpple *) hppleWithXMLData:(NSData *)theData {
  return [[self class] hppleWithData:theData encoding:nil isXML:YES];
}

#pragma mark -

// Returns all elements at xPath.
- (NSArray *) searchWithXPathQuery:(NSString *)xPathOrCSS
{
  NSArray * detailNodes = nil;
  if (isXML) {
    detailNodes = PerformXMLXPathQueryWithEncoding(data, xPathOrCSS, encoding);
  } else {
    detailNodes = PerformHTMLXPathQueryWithEncoding(data, xPathOrCSS, encoding);
  }

  NSMutableArray * hppleElements = [NSMutableArray array];
  for (id node in detailNodes) {
    [hppleElements addObject:[YJEHppleElement hppleElementWithNode:node isXML:isXML withEncoding:encoding]];
  }
  return hppleElements;
}

// Returns first element at xPath
- (YJEHppleElement *) peekAtSearchWithXPathQuery:(NSString *)xPathOrCSS
{
  NSArray * elements = [self searchWithXPathQuery:xPathOrCSS];
  if ([elements count] >= 1) {
    return [elements objectAtIndex:0];
  }

  return nil;
}

@end
