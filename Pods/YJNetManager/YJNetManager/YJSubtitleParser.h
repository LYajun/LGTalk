//
//  YJSubtitleParser.h
//  YJNetManagerDemo
//
//  Created by 刘亚军 on 2019/3/18.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YJSubtitleParser : NSObject
+ (YJSubtitleParser *)parser;

- (NSDictionary *)parseLrc:(NSString *)lrc;

- (NSDictionary *)parseSrt:(NSString *)srt;
@end

NS_ASSUME_NONNULL_END
