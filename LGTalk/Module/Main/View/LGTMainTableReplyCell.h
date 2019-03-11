//
//  LGTMainTableReplyCell.h
//  LGTalkDemo
//
//  Created by 刘亚军 on 2019/3/7.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "LGTBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@class LGTTalkQuesModel;

typedef NS_ENUM(NSInteger,LGTMainTableReplyCellRowNum){
    onlyOne,
    first,
    middle,
    last,
};

@interface LGTMainTableReplyCell : LGTBaseTableViewCell
@property (nonatomic,assign) LGTMainTableReplyCellRowNum rowNum;

- (void)configByQuesModel:(LGTTalkQuesModel *)quesModel;
@end

NS_ASSUME_NONNULL_END
