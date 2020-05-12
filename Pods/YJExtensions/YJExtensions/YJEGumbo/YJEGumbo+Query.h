//  Created by 刘亚军 on 2019/3/15.
//  Copyright © 2019 刘亚军. All rights reserved.

#import "YJEGumbo.h"

@class  YJEQueryObject;
typedef YJEQueryObject * (^YJEGumboQueryBlockAS) (NSString *);
typedef NSString *      (^YJEGumboQueryBlockSS) (NSString *);
typedef NSString *      (^YJEGumboQueryBlockSV) (void);

@interface YJEGumboNode (Query)

/**
 *  Query children elements from current node by selector.
 *
 *  @param selector (NSString *) can be elementID | tagName | classSelector | tagName.classSelector | tagName#elementID.
 */
@property (nonatomic, weak, readonly) YJEGumboQueryBlockAS Query;

/**
 *  Get the attribute value of the element by attributeName.
 *
 *  @param attributeName (NSString *) the attribute name.
 */
@property (nonatomic, weak, readonly) YJEGumboQueryBlockSS attr;

/**
 *  Get the combined text contents of element.
 */
@property (nonatomic, weak, readonly) YJEGumboQueryBlockSV text;

/**
 *  Get the raw contents of element.
 */
@property (nonatomic, weak, readonly) YJEGumboQueryBlockSV html;

@end

#pragma mark -
typedef YJEGumboNode *   (^NSArrayQueryBlockNV) (void);
typedef YJEGumboNode *   (^NSArrayQueryBlockNI) (NSUInteger);
typedef BOOL            (^NSArrayQueryBlockBS) (NSString *);
typedef NSUInteger      (^NSArrayQueryBlockIN) (YJEGumboNode *);
typedef YJEQueryObject * (^NSArrayQueryBlockAS) (NSString *);
typedef YJEQueryObject * (^NSArrayQueryBlockSA) (void);
typedef NSString *      (^NSArrayQueryBlockSV) (void);

@interface YJEQueryObject : NSArray

/**
 *  Get the combined text contents of the collection.
 */
@property (nonatomic, weak, readonly) NSArrayQueryBlockSV text;

/**
 *  Get the combined text array of element.
 */
@property (nonatomic, weak, readonly) NSArrayQueryBlockSA textArray;

/**
 *  Get the first element of the current collection.
 */
@property (nonatomic, weak, readonly) NSArrayQueryBlockNV first;

/**
 *  Get the last element of the current collection.
 */
@property (nonatomic, weak, readonly) NSArrayQueryBlockNV last;

/**
 *  Get the element by index from current collection.
 *
 *  @param index (NSUInteger) the index of the element.
 */
@property (nonatomic, weak, readonly) NSArrayQueryBlockNI get;

/**
 *  Check if any elements in the collection have the specified class.
 */
@property (nonatomic, weak, readonly) NSArrayQueryBlockBS hasClass;

/**
 *  Get the position of an element in current collection.
 *
 *  @param element (YJEGumboNode *)
 */
@property (nonatomic, weak, readonly) NSArrayQueryBlockIN index;

/**
 *  Find elements that match the selector in the current collection.
 *
 *  @param selector (NSString *) can be elementID | tagName | classSelector | tagName.classSelector | tagName#elementID.
 */
@property (nonatomic, weak, readonly) NSArrayQueryBlockAS find;

/**
 *  Get immediate children of each element in the current collection matching the selector.
 *
 *  @param selector (NSString *) can be elementID | tagName | classSelector | tagName.classSelector | tagName#elementID.
 */
@property (nonatomic, weak, readonly) NSArrayQueryBlockAS children;

/**
 *  Get immediate parents of each element in the collection matching the selector.
 *
 *  @param selector (NSString *) can be elementID | tagName | classSelector | tagName.classSelector | tagName#elementID.
 */
@property (nonatomic, weak, readonly) NSArrayQueryBlockAS parent;

/**
 *  Get all ancestors of each element in the collection matching the selector.
 *
 *  @param selector (NSString *) can be elementID | tagName | classSelector | tagName.classSelector | tagName#elementID.
 */
@property (nonatomic, weak, readonly) NSArrayQueryBlockAS parents;

@end
