//
//  LGTResponseModel.h
//
//
//  Created by 刘亚军 on 2019/1/10.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGTResponseModel : NSObject

@property (nonatomic,copy) NSString *Code;

@property (nonatomic,copy) NSString *Msg;

@property (nonatomic,strong) id Data;
+ (LGTResponseModel *)responseModelWithData:(NSData *)data;
@end
