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

@implementation LGTMainTableService
- (void)updateDataWithPage:(NSInteger)page success:(void (^)(BOOL))success failed:(void (^)(NSError *))failed{
    NSString *apiUrl = [[LGTalkManager defaultManager].apiUrl stringByAppendingString:@"//"];
    if (LGT_IsStrEmpty(LGTNet.apiUrl) || ![apiUrl containsString:LGTNet.apiUrl_Enter]) {
        [self loadTalkConfigWithPage:page success:success failed:failed];
    }else{
        [self loadTalkDataWithPage:page success:success failed:failed];
    }
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
            [weakSelf loadTalkDataWithPage:page success:success failed:failed];
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
                             @"resID":LGT_ApiParams([LGTalkManager defaultManager].resID),
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
@end
