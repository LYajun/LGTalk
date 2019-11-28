//
//  LGTMutiFilterModel.h
//  LGTalkDemo
//
//  Created by 刘亚军 on 2019/11/27.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "LGTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN


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
@end

NS_ASSUME_NONNULL_END
