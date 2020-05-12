//
//  LGTMutiFilterModel.h
//  LGTalkDemo
//
//  Created by 刘亚军 on 2019/11/27.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "LGTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LGTTraditionMaterialChapterTextModel : LGTBaseModel
/** 资料ID */
@property (nonatomic,copy) NSString *TextId;
/** 资料名 */
@property (nonatomic,copy) NSString *TextTitleName;
/** 资料类型 0-文本资料  1-声文资料 */
@property (nonatomic,assign) NSInteger Type;
@end

@interface LGTTraditionMaterialChapterModel : LGTBaseModel
/** 课程ID */
@property (nonatomic,copy) NSString *ChapterId;
/** 课程名 */
@property (nonatomic,copy) NSString *ChapterName;
/** 资料列表 */
@property (nonatomic,strong) NSArray<LGTTraditionMaterialChapterTextModel *> *textTitle;

/** 是否折叠 */
@property (nonatomic,assign) BOOL ChapterFold;
@end



@interface LGTMutiFilterSubModel : LGTBaseModel
@property (nonatomic,assign) NSInteger ClassNo;
@property (nonatomic,assign) NSInteger TotalWords;
@property (nonatomic,copy) NSString *MaterialID;
@property (nonatomic,copy) NSString *MaterialName;
@property (nonatomic,copy) NSString *MaterialPath;
@property (nonatomic,copy) NSString *MaterialType;
@property (nonatomic,copy) NSString *Knowledgepoint;

@property (nonatomic,copy) NSString *KnowledgeOtpoint;
@property (nonatomic,copy) NSString *SecDir;
@property (nonatomic,copy) NSString *PaperPath;
@property (nonatomic,copy) NSString *CoursePath;
@end

@interface LGTMutiFilterModel : LGTBaseModel
@property (nonatomic,copy) NSString *TeachMaterialID;
@property (nonatomic,copy) NSString *UserId;
@property (nonatomic,copy) NSString *UserName;
@property (nonatomic,copy) NSString *PublishTime;
@property (nonatomic,copy) NSString *TeachMaterialLibraryName;
@property (nonatomic,strong) NSArray<LGTMutiFilterSubModel *> *TeachMaterilaAllDatas;


/** 教材ID */
@property (nonatomic,copy) NSString *BookId;
/** 教材名 */
@property (nonatomic,copy) NSString *BookName;
/** 课程列表 */
@property (nonatomic,strong) NSArray<LGTTraditionMaterialChapterModel *> *chapterList;
@end

NS_ASSUME_NONNULL_END
