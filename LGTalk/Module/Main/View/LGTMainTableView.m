//
//  LGTMainTableView.m
//  LGTalkDemo
//
//  Created by 刘亚军 on 2019/3/6.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "LGTMainTableView.h"
#import "LGTTalkModel.h"
#import "LGTMainTableHeaderView.h"
#import "LGTMainTableFooterView.h"
#import "LGTMainTableReplyCell.h"
#import "LGTChatBox.h"
#import "LGTExtension.h"
#import "LGTalkManager.h"
#import <LGAlertHUD/LGAlertHUD.h>
#import "LGTTalkReplyModel.h"
#import "LGTNetworking.h"

@interface LGTMainTableView ()<LGTChatBoxDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign) BOOL isCommentSelf;
@property (nonatomic,assign) BOOL isKeyboardShow;
@property (nonatomic,strong) NSIndexPath *currentIndexPath;
@property (nonatomic,strong) LGTChatBox *chatBox;
@end
@implementation LGTMainTableView
- (void)setDefaultValue{
    [super setDefaultValue];
    self.estimatedRowHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
    
    self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self registerClass:[LGTMainTableReplyCell class] forCellReuseIdentifier:NSStringFromClass([LGTMainTableReplyCell class])];
    [self registerClass:[LGTMainTableHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([LGTMainTableHeaderView class])];
    [self registerClass:[LGTMainTableFooterView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([LGTMainTableFooterView class])];
    self.delegate = self;
    self.dataSource = self;
    [self installRefreshHeader:YES footer:YES];
}

#pragma mark - LGTChatBoxDelegate
- (void)LGTChatBoxDidRemoved{
    [self deselectRowAtIndexPath:self.currentIndexPath animated:YES];
    if (self.chatBox) {
        [self.chatBox removeFromSuperview];
        self.chatBox = nil;
    }
    self.isKeyboardShow = NO;
}
- (void)LGTChatBox:(LGTChatBox *)chatBox didChangeOffsetY:(CGFloat)offsetY{
    self.isKeyboardShow = YES;
}
- (void)LGTChatBox:(LGTChatBox *)chatBox didClickSend:(NSString *)sendContent{
    LGTTalkModel *model = self.service.models[self.currentIndexPath.section];
    LGTTalkReplyModel *replyModel = [[LGTTalkReplyModel alloc] init];
    replyModel.UserID = [LGTalkManager defaultManager].userID;
    replyModel.UserImg = [LGTalkManager defaultManager].photoPath;
    replyModel.UserName = [LGTalkManager defaultManager].userName;
    replyModel.IsComment = self.isCommentSelf;
    if (self.isCommentSelf) {
        if ([model.UserID isEqualToString:[LGTalkManager defaultManager].userID]) {
            replyModel.UserIDTo = [LGTalkManager defaultManager].userID;
            replyModel.UserNameTo = [LGTalkManager defaultManager].userName;
            replyModel.UserImgTo = [LGTalkManager defaultManager].photoPath;
        }else{
            replyModel.UserIDTo = model.UserID;
            replyModel.UserNameTo = model.UserName;
            replyModel.UserImgTo = model.UserImg;
        }
    }else{
        if (LGT_IsArrEmpty(model.CommentList)) {
            replyModel.UserIDTo = model.UserID;
            replyModel.UserNameTo = model.UserName;
            replyModel.UserImgTo = model.UserImg;
        }else{
            LGTTalkQuesModel *quesModel = model.CommentList[self.currentIndexPath.row];
            replyModel.UserIDTo = quesModel.UserID;
            replyModel.UserNameTo = quesModel.UserName;
            replyModel.UserImgTo = quesModel.UserImg;
        }
    }
    replyModel.Content = sendContent;
    replyModel.CreateTime = [NSDate date].lgt_string;
    replyModel.QuesThemeID = model.ID;
    replyModel.ImgUrlList = @[];
    [self replyWithReplyInfo:replyModel.lgt_JsonModel];
}
#pragma mark - Service
- (void)replyWithReplyInfo:(NSDictionary *) replyInfo{

    NSString *urlStr = [LGTNet.apiUrl stringByAppendingFormat:@"/api/Tutor/AddTutorCommentOrReply?context=%@&userID=%@",@"CONTEXT04",[LGTalkManager defaultManager].userID];

    WeakSelf;
    [LGAlert showIndeterminate];
    [LGTNet.setRequest(urlStr).setRequestType(LGTRequestTypePOST).setParameters(replyInfo).setResponseType(LGTResponseTypeModel) startRequestWithSuccess:^(LGTResponseModel *response) {
        if (response.Code.integerValue == 0) {
            [LGAlert hide];
            [selfWeak.service.ownController.view endEditing:YES];
            NSMutableDictionary *json = [NSMutableDictionary dictionaryWithDictionary:response.Data];
            [json setObject:[json objectForKey:@"CreateTime"] forKey:@"Time"];
            LGTTalkQuesModel *quesModel = [[LGTTalkQuesModel alloc] initWithDictionary:json];
            LGTTalkModel *model = selfWeak.service.models[selfWeak.currentIndexPath.section];
            NSMutableArray *arr = model.CommentList.mutableCopy;
            [arr addObject:quesModel];
            model.CommentList = arr;
            model.isFold = NO;
            [selfWeak reloadData];
        }else{
            [LGAlert showErrorWithStatus:response.Msg];
        }
    } failure:^(NSError *error) {
        [LGAlert showErrorWithError:error];
    }];
    
}
- (void)deleteTalkInfo{
    NSString *urlStr = [LGTNet.apiUrl stringByAppendingString:@"/api/Tutor/DeleteTutorQuesTheme"];
    WeakSelf;
    LGTTalkModel *model = self.service.models[self.currentIndexPath.section];
    NSDictionary *params = @{
                             @"userID":LGT_ApiParams([LGTalkManager defaultManager].userID),
                             @"id":LGT_ApiParams(model.ID),
                             @"schoolID":LGT_ApiParams([LGTalkManager defaultManager].schoolID),
                             @"context":@"CONTEXT04"};

    [LGAlert showIndeterminate];
[LGTNet.setRequest(urlStr).setRequestType(LGTRequestTypeGET).setResponseType(LGTResponseTypeModel).setParameters(params) startRequestWithSuccess:^(LGTResponseModel *response) {
        if (response.Code.integerValue == 0) {
            [selfWeak.service.ownController.view endEditing:YES];
            [LGAlert hide];
            [selfWeak.service.models removeObjectAtIndex:selfWeak.currentIndexPath.section];
            if (selfWeak.service.models.count == 0) {
                [selfWeak loadFirstPage];
            }else{
                [selfWeak reloadData];
            }
        }else{
            [LGAlert showErrorWithStatus:response.Msg];
        }
    } failure:^(NSError *error) {
       [LGAlert showErrorWithError:error];
    }];
}
- (void)deleteReplyInfo{
    NSString *urlStr = [LGTNet.apiUrl stringByAppendingString:@"/api/Tutor/DeleteTutorCommentOrReply"];
    WeakSelf;
    LGTTalkModel *model = self.service.models[self.currentIndexPath.section];
     LGTTalkQuesModel *quesModel = model.CommentList[self.currentIndexPath.row];
    NSDictionary *params = @{@"userID":LGT_ApiParams([LGTalkManager defaultManager].userID),
                             @"id":LGT_ApiParams(quesModel.ID),
                             @"schoolID":LGT_ApiParams([LGTalkManager defaultManager].schoolID),
                             @"context":@"CONTEXT04"};

    [LGAlert showIndeterminate];
    [LGTNet.setRequest(urlStr).setRequestType(LGTRequestTypeGET).setResponseType(LGTResponseTypeModel).setParameters(params) startRequestWithSuccess:^(LGTResponseModel *response) {
        if (response.Code.integerValue == 0) {
            [selfWeak.service.ownController.view endEditing:YES];
            [LGAlert hide];
            LGTTalkModel *model = selfWeak.service.models[selfWeak.currentIndexPath.section];
            NSMutableArray *arr = model.CommentList.mutableCopy;
            [arr removeObjectAtIndex:selfWeak.currentIndexPath.row];
            model.CommentList = arr;
            [selfWeak reloadData];
        }else{
            [LGAlert showErrorWithStatus:response.Msg];
        }
    } failure:^(NSError *error) {
        [LGAlert showErrorWithError:error];
    }];
    
}
- (void)setHeaderTop:(BOOL)top{
    NSString *urlStr = [LGTNet.apiUrl stringByAppendingString:@"/api/Tutor/SetOrCancelTutorThemeTop"];
    WeakSelf;
    NSString *isTopStr = @"true";
    if (top) {
        isTopStr = @"false";
    }
    LGTTalkModel *model = self.service.models[self.currentIndexPath.section];
    NSDictionary *params = @{@"userID":LGT_ApiParams([LGTalkManager defaultManager].userID),
                             @"id":LGT_ApiParams(model.ID),
                             @"userType":@([LGTalkManager defaultManager].userType),
                             @"context":@"CONTEXT04",
                             @"isTop":isTopStr};

    [LGAlert showIndeterminate];
    [LGTNet.setRequest(urlStr).setRequestType(LGTRequestTypeGET).setResponseType(LGTResponseTypeModel).setParameters(params) startRequestWithSuccess:^(LGTResponseModel *response) {
        if (response.Code.integerValue == 0) {
            [selfWeak.service.ownController.view endEditing:YES];
            [LGAlert hide];
            [selfWeak loadFirstPage];
        }else{
            [LGAlert showErrorWithStatus:response.Msg];
        }
    } failure:^(NSError *error) {
        [LGAlert showErrorWithError:error];
    }];
}
#pragma mark  dataSource & delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self LGTChatBoxDidRemoved];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.service.models.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    LGTTalkModel *model = self.service.models[section];
    if (model.isFold) {
        return 0;
    }
    return model.CommentList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LGTTalkModel *model = self.service.models[indexPath.section];
    if (LGT_IsArrEmpty(model.CommentList)) {
        return 0;
    }
    LGTTalkQuesModel *quesModel = model.CommentList[indexPath.row];
    return [quesModel tableCellHeight];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    LGTTalkModel *model = self.service.models[section];
    return model.tableHeaderHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LGTTalkModel *model = self.service.models[indexPath.section];
    LGTMainTableReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LGTMainTableReplyCell class]) forIndexPath:indexPath];
    if (model.CommentList.count == 1) {
        cell.rowNum = onlyOne;
    }else{
        if (indexPath.row == 0) {
            cell.rowNum = first;
        }else if (indexPath.row == model.CommentList.count-1){
            cell.rowNum = last;
        }else{
            cell.rowNum = middle;
        }
    }
    [cell configByQuesModel:model.CommentList[indexPath.row]];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    LGTMainTableHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([LGTMainTableHeaderView class])];
    LGTTalkModel *model = self.service.models[section];
    [headerView configByTalkModel:model];
    headerView.themeDeleteEnable = [model.UserID isEqualToString:[LGTalkManager defaultManager].userID];
    WeakSelf;
    headerView.ReplyBlock = ^{
        selfWeak.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        if (selfWeak.isKeyboardShow) {
            [selfWeak LGTChatBoxDidRemoved];
        }else{
            if (!selfWeak.chatBox) {
                selfWeak.chatBox = [[LGTChatBox alloc] initWithFrame:CGRectMake(0, selfWeak.service.ownController.view.height-HEIGHT_TABBAR, LGT_ScreenWidth, HEIGHT_TABBAR)];
                selfWeak.chatBox.maxVisibleLine = 3;
                selfWeak.chatBox.delegate = selfWeak;
                selfWeak.chatBox.placehold = @"";
                [selfWeak.service.ownController.view addSubview:selfWeak.chatBox];
            }
            selfWeak.isCommentSelf = YES;
            if ([model.UserID isEqualToString:[LGTalkManager defaultManager].userID]) {
                selfWeak.chatBox.placehold = @"";
            }else{
                self.chatBox.placehold = [NSString stringWithFormat:@"回复%@:",model.UserName];
            }
        }
    };
    headerView.ThemeDeleteBlock = ^{
        selfWeak.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        if (selfWeak.isKeyboardShow) {
            [selfWeak LGTChatBoxDidRemoved];
        }else{
            [LGAlert alertSheetWithTitle:nil message:nil canceTitle:@"取消" confirmTitle:@"删除" cancelBlock:^{} confirmBlock:^{
                 [selfWeak deleteTalkInfo];
            } atController:selfWeak.service.ownController];
        }
    };
    headerView.SetTopBlock = ^(BOOL isTop) {
        selfWeak.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        if (selfWeak.isKeyboardShow) {
            [selfWeak LGTChatBoxDidRemoved];
        }else{
            NSString *cancel = nil;
            NSString *sure = nil;
            cancel = @"否";
            if (isTop) {
                sure = @"取消置顶";
            }else{
                sure = @"置顶";
            }
            [LGAlert alertSheetWithTitle:nil message:nil canceTitle:cancel confirmTitle:sure cancelBlock:^{} confirmBlock:^{
                [selfWeak setHeaderTop:isTop];
            } atController:selfWeak.service.ownController];
        }
    };
    headerView.FoldBlock = ^{
        model.isFold = !model.isFold;
        [selfWeak reloadData];
    };
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    LGTMainTableFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([LGTMainTableFooterView class])];
    return footer;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LGTTalkModel *model = self.service.models[indexPath.section];
    self.currentIndexPath = indexPath;
    if (self.isKeyboardShow) {
        [self LGTChatBoxDidRemoved];
    }else{
        self.isCommentSelf = NO;
        LGTTalkQuesModel *quesModel = model.CommentList[indexPath.row];
        if (![quesModel.UserID isEqualToString:[LGTalkManager defaultManager].userID]) {
            if (!self.chatBox) {
                self.chatBox = [[LGTChatBox alloc] initWithFrame:CGRectMake(0, self.service.ownController.view.height-HEIGHT_TABBAR, LGT_ScreenWidth, HEIGHT_TABBAR)];
                self.chatBox.maxVisibleLine = 3;
                self.chatBox.delegate = self;
                [self.service.ownController.view addSubview: self.chatBox];
            }
            self.chatBox.placehold = [NSString stringWithFormat:@"回复%@:",quesModel.UserName];
        }else{
            WeakSelf;
            [LGAlert alertSheetWithTitle:nil message:nil canceTitle:@"取消" confirmTitle:@"删除" cancelBlock:^{
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            } confirmBlock:^{
                 [selfWeak deleteReplyInfo];
            } atController:selfWeak.service.ownController];
        }
        
    }
}
@end
