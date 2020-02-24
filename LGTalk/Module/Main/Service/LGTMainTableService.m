//
//  LGTMainTableService.m
//  LGTalkDemo
//
//  Created by 刘亚军 on 2019/3/6.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "LGTMainTableService.h"
#import "LGTNetworking.h"
#import "LGTConst.h"
#import "LGTalkManager.h"
#import "LGTTalkModel.h"
#import <XMLDictionary/XMLDictionary.h>
#import "LGTMutiFilterModel.h"

@interface LGTMainTableService ()

@property (nonatomic,strong) LGTMutiFilterModel *filterModel;
@end
@implementation LGTMainTableService
- (void)updateDataWithPage:(NSInteger)page success:(void (^)(BOOL))success failed:(void (^)(NSError *))failed{
    NSString *apiUrl = [[LGTalkManager defaultManager].apiUrl stringByAppendingString:@"//"];
    if (LGT_IsStrEmpty(LGTNet.apiUrl) || ![apiUrl containsString:LGTNet.apiUrl_Enter]) {
        [self loadTalkConfigWithPage:page success:success failed:failed];
    }else{
        if ([[LGTalkManager defaultManager].systemID isEqualToString:@"930"] && !self.filterModel) {
            [self loadMutiFilterInfoWithPage:page success:success failed:failed];
        }else{
            [self loadTalkDataWithPage:page success:success failed:failed];
        }
    }
}
- (void)loadMutiFilterInfoWithPage:(NSInteger)page success:(void (^)(BOOL))success failed:(void (^)(NSError *))failed{
    NSString *urlStr = [LGTalkManager defaultManager].mutiFilterUrl;
    __weak typeof(self) weakSelf = self; [LGTNet.setRequest(urlStr).setRequestType(LGTRequestTypeGET).setResponseType(LGTResponseTypeString) startRequestWithSuccess:^(id response) {
        NSDictionary *dic = [NSDictionary dictionaryWithXMLString:response];
        NSString *jsonStr = [dic objectForKey:@"__text"];
        if (!LGT_IsStrEmpty(jsonStr)){
            weakSelf.filterModel = [[LGTMutiFilterModel alloc] initWithJSONString:jsonStr];
            if (!LGT_IsArrEmpty(weakSelf.filterModel.TeachMaterilaAllDatas)) {
                [weakSelf loadTalkDataWithPage:page success:success failed:failed];
            }else{
               failed([NSError lgt_localErrorWithCode:LGTLocalErrorRequestFailed description:@"加载失败"]);
            }
        }else{
            failed([NSError lgt_localErrorWithCode:LGTLocalErrorRequestFailed description:@"加载失败"]);
        }
        
    } failure:^(NSError *error) {
        failed(error);
    }];
}
- (void)loadTalkConfigWithPage:(NSInteger)page success:(void (^)(BOOL))success failed:(void (^)(NSError *))failed{
    NSString *urlStr = [[LGTalkManager defaultManager].apiUrl stringByAppendingFormat:@"/Base/WS/Service_Basic.asmx/WS_G_GetSubSystemServerInfoForAllSubject?sysID=%@",@"629"];
    __weak typeof(self) weakSelf = self; [LGTNet.setRequest(urlStr).setRequestType(LGTRequestTypeGET).setResponseType(LGTResponseTypeString) startRequestWithSuccess:^(id response) {
        NSDictionary *dic = [NSDictionary dictionaryWithXMLString:response];
        NSArray<NSDictionary *> *sysInfoList = [dic arrayValueForKeyPath:@"anyType"];
        if (!LGT_IsArrEmpty(sysInfoList)) {
            NSDictionary *sysInfo = sysInfoList.firstObject;
            LGTNet.apiUrl_Enter = [LGTalkManager defaultManager].apiUrl;
            LGTNet.apiUrl = [sysInfo objectForKey:@"WsSvrAddr"];
            if ([[LGTalkManager defaultManager].systemID isEqualToString:@"930"]) {
                [weakSelf loadMutiFilterInfoWithPage:page success:success failed:failed];
            }else{
                [weakSelf loadTalkDataWithPage:page success:success failed:failed];
            }
        }else{
            failed([NSError lgt_localErrorWithCode:LGTLocalErrorRequestFailed description:@"系统配置信息为空"]);
        }
    } failure:^(NSError *error) {
        failed(error);
    }];
}
- (void)loadTalkDataWithPage:(NSInteger)page success:(void (^)(BOOL))success failed:(void (^)(NSError *))failed{
    NSString *urlStr = [LGTNet.apiUrl stringByAppendingString:@"/api/Tutor/GetTutorQuesThemeList"];
    NSDictionary *params = @{
                             @"context":@"CONTEXT04",
                             @"userID":LGT_ApiParams([LGTalkManager defaultManager].userID),
                             @"assignmentID":LGT_ApiParams([LGTalkManager defaultManager].assignmentID),
                             @"resID":LGT_ApiParams(self.resID),
                             @"topicIndex":@(-1),
                             @"pageIndex":@(self.currentPage),
                             @"pageSize":@(self.pageSize)
                             };
    __weak typeof(self) weakSelf = self; [LGTNet.setRequest(urlStr).setRequestType(LGTRequestTypeGET).setResponseType(LGTResponseTypeModel).setParameters(params) startRequestWithSuccess:^(LGTResponseModel *response) {
        if (response.Code.integerValue == 0) {
            [weakSelf handleResponseDataList:response.Data[@"List"] modelClass:[LGTTalkModel class] totalCount:[response.Data[@"TotalCount"] integerValue] success:success];
        }else{
            failed([NSError lgt_localErrorWithCode:LGTLocalErrorRequestFailed description:response.Msg]);
        }
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (NSArray *)mutiFilterTitleArray{
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@"全部来源"];
    for (int i = 0; i < self.filterModel.TeachMaterilaAllDatas.count; i++) {
        LGTMutiFilterSubModel *subModel = self.filterModel.TeachMaterilaAllDatas[i];
        [array addObject:[NSString stringWithFormat:@"第%i课 %@",i+1,subModel.MaterialName]];
    }
    return array;
}

- (NSArray *)mutiFilterNameArray{
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@""];
    for (LGTMutiFilterSubModel *subModel in self.filterModel.TeachMaterilaAllDatas) {
        [array addObject:subModel.MaterialName];
    }
    return array;
}

- (NSArray *)mutiFilterIDArray{
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@""];
    for (LGTMutiFilterSubModel *subModel in self.filterModel.TeachMaterilaAllDatas) {
         [array addObject:subModel.MaterialID];
    }
    return array;
}
@end
