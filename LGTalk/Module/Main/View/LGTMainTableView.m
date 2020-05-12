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
#import <LGAlertHUD/YJAnswerAlertView.h>

@interface LGTMainTableView ()<LGTChatBoxDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign) BOOL isCommentSelf;
@property (nonatomic,strong) NSIndexPath *currentIndexPath;
@property (nonatomic,strong) LGTChatBox *chatBox;
@property (nonatomic,strong) NSMutableDictionary *currentMsgDic;
@property (nonatomic,strong) NSMutableDictionary *currentImgsDic;
@property (nonatomic,copy) NSString *currentMsgKey;
@end
@implementation LGTMainTableView
- (void)setDefaultValue{
    [super setDefaultValue];
    self.estimatedRowHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
    self.currentMsgDic = [NSMutableDictionary dictionary];
    self.currentImgsDic = [NSMutableDictionary dictionary];
    self.currentMsgKey = @"*key*";
    self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self registerClass:[LGTMainTableReplyCell class] forCellReuseIdentifier:NSStringFromClass([LGTMainTableReplyCell class])];
    [self registerClass:[LGTMainTableHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([LGTMainTableHeaderView class])];
    [self registerClass:[LGTMainTableFooterView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([LGTMainTableFooterView class])];
    self.delegate = self;
    self.dataSource = self;
    [self installRefreshHeader:YES footer:YES];
}
- (void)removedChatBox{
    [self LGTChatBoxDidRemoved];
}
#pragma mark - LGTChatBoxDelegate
- (void)LGTChatBoxDidRemoved{
    [self deselectRowAtIndexPath:self.currentIndexPath animated:YES];
    if (self.chatBox) {
        [self.chatBox removeFromSuperview];
        self.chatBox = nil;
    }
}

- (void)LGTChatBox:(LGTChatBox *)chatBox didEndEditWithContent:(NSString *)content{
    if (LGT_IsStrEmpty(content)) {
        content = @"";
    }
    [self.currentMsgDic setObject:content forKey:self.currentMsgKey];
}
- (void)LGTChatBox:(LGTChatBox *)chatBox didSelectImgs:(NSArray *)imgs{
    if (LGT_IsArrEmpty(imgs)) {
        imgs = @[@""];
    }
    [self.currentImgsDic setObject:imgs forKey:self.currentMsgKey];
}
- (void)LGTChatBox:(LGTChatBox *)chatBox didClickSend:(NSString *)sendContent selectImgs:(NSArray *)imgs{
    [self LGTChatBoxDidRemoved];
    if (!LGT_IsArrEmpty(imgs)) {
        [self uploadImages:imgs sendContent:sendContent];
    }else{
        [self uploadTalkContentWithImageUrls:@[] sendContent:sendContent];
    }
}
- (void)uploadTalkContentWithImageUrls:(NSArray *)imagesUrls sendContent:(NSString *)sendContent{
    
    if (!LGT_IsStrEmpty(sendContent)) {
        sendContent = [NSString lgt_HTML:sendContent];
        sendContent = [sendContent stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    }
    LGTTalkModel *model = self.service.models[self.currentIndexPath.section];
    LGTTalkReplyModel *replyModel = [[LGTTalkReplyModel alloc] init];
    replyModel.ResID = self.service.resID;
    replyModel.UserID = [LGTalkManager defaultManager].userID;
    replyModel.UserImg = [LGTalkManager defaultManager].photoPath;
    replyModel.UserName = [LGTalkManager defaultManager].userName;
    replyModel.UserType = [NSString stringWithFormat:@"%li", [LGTalkManager defaultManager].userType];
    replyModel.TeacherID = [LGTalkManager defaultManager].teacherID;
//    replyModel.classID = [LGTalkManager defaultManager].classID;
    replyModel.IsComment = self.isCommentSelf;
    if (self.isCommentSelf) {
        if ([model.UserID isEqualToString:[LGTalkManager defaultManager].userID]) {
            replyModel.UserIDTo = [LGTalkManager defaultManager].userID;
            replyModel.UserNameTo = [LGTalkManager defaultManager].userName;
            replyModel.UserImgTo = [LGTalkManager defaultManager].photoPath;
            replyModel.UserTypeTo = [NSString stringWithFormat:@"%li", [LGTalkManager defaultManager].userType];
        }else{
            replyModel.UserIDTo = model.UserID;
            replyModel.UserNameTo = model.UserName;
            replyModel.UserImgTo = model.UserImg;
            replyModel.UserTypeTo = @"2";
        }
    }else{
        if (LGT_IsArrEmpty(model.CommentList)) {
            replyModel.UserIDTo = model.UserID;
            replyModel.UserNameTo = model.UserName;
            replyModel.UserImgTo = model.UserImg;
            replyModel.UserTypeTo = @"2";
        }else{
            LGTTalkQuesModel *quesModel = model.CommentList[self.currentIndexPath.row];
            replyModel.UserIDTo = quesModel.UserID;
            replyModel.UserNameTo = quesModel.UserName;
            replyModel.UserImgTo = quesModel.UserImg;
            replyModel.UserTypeTo = quesModel.UserType;
        }
    }
    replyModel.Content = sendContent;
    replyModel.CreateTime = [NSDate date].lgt_string;
    replyModel.QuesThemeID = model.ID;
    replyModel.ImgUrlList = imagesUrls;
    [self replyWithReplyInfo:replyModel.lgt_JsonModel];
}
#pragma mark - Service
- (void)uploadImages:(NSArray *)imgs sendContent:(NSString *)sendContent{
    LGTUploadModel *uploadModel = [[LGTUploadModel alloc] init];
    NSMutableArray *imageDatas = [NSMutableArray array];
    NSMutableArray *fileNames = [NSMutableArray array];
    for (UIImage *image in imgs) {
        [fileNames addObject:[NSString stringWithFormat:@"%.f-%li.png",[[NSDate date] timeIntervalSince1970],imageDatas.count]];
        [imageDatas addObject:UIImageJPEGRepresentation([UIImage lgt_fixOrientation:image], 0.5)];
    }
    uploadModel.uploadDatas = imageDatas;;
    uploadModel.name = @"file";
    uploadModel.fileNames = fileNames;
    uploadModel.fileType = @"image/png";
    NSString *url = [LGTNet.apiUrl stringByAppendingString:@"/api/Common/UploadImg"];
    WeakSelf;
    [LGAlert showIndeterminateWithStatus:@"上传图片..."];
    [LGTNet.setRequest(url).setRequestType(LGTRequestTypeUploadPhoto).setUploadModel(uploadModel) startRequestWithProgress:^(NSProgress *progress) {
        NSLog(@"%f",progress.fractionCompleted);
    } success:^(id response) {
        [selfWeak uploadTalkContentWithImageUrls:[response objectForKey:@"Data"] sendContent:sendContent];
    } failure:^(NSError *error) {
        [LGAlert showErrorWithError:error];
    }];
}
- (void)replyWithReplyInfo:(NSDictionary *) replyInfo{

    NSString *urlStr = [LGTNet.apiUrl stringByAppendingFormat:@"/api/Tutor/AddTutorCommentOrReply?context=%@&userID=%@",@"CONTEXT04",[LGTalkManager defaultManager].userID];

    WeakSelf;
    [LGAlert showIndeterminate];
    [LGTNet.setRequest(urlStr).setRequestType(LGTRequestTypePOST).setParameters(replyInfo).setResponseType(LGTResponseTypeModel) startRequestWithSuccess:^(LGTResponseModel *response) {
        if (response.Code.integerValue == 0) {
            selfWeak.currentMsgKey = @"*key*";
            [selfWeak.currentMsgDic removeAllObjects];
            [selfWeak.currentImgsDic removeAllObjects];
            
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
        if (!selfWeak.chatBox) {
            selfWeak.chatBox = [[LGTChatBox alloc] initWithFrame:CGRectMake(0, selfWeak.service.ownController.view.height-HEIGHT_TABBAR, LGT_ScreenWidth, HEIGHT_TABBAR)];
            selfWeak.chatBox.maxVisibleLine = 3;
            selfWeak.chatBox.delegate = selfWeak;
            selfWeak.chatBox.placehold = @"";
            selfWeak.chatBox.ownController = selfWeak.service.ownController;
            [selfWeak.service.ownController.view addSubview:selfWeak.chatBox];
        }
        selfWeak.isCommentSelf = YES;
        if ([model.UserID isEqualToString:[LGTalkManager defaultManager].userID]) {
            selfWeak.chatBox.placehold = @"";
        }else{
            selfWeak.chatBox.placehold = [NSString stringWithFormat:@"回复%@:",model.UserName];
        }
        selfWeak.currentMsgKey = [NSString stringWithFormat:@"%@-%@-%@",[LGTalkManager defaultManager].userID,model.UserID,model.CreateTime];
        selfWeak.chatBox.currentMsg = [selfWeak.currentMsgDic objectForKey:selfWeak.currentMsgKey];
        selfWeak.chatBox.currentImgs = [selfWeak.currentImgsDic objectForKey:selfWeak.currentMsgKey];
    };
    headerView.ThemeDeleteBlock = ^{
        selfWeak.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        [[YJAnswerAlertView alertWithTitle:@"提示" normalMsg:@"是否删除该组讨论？" highLightMsg:@"" cancelTitle:@"删除" destructiveTitle:@"我再想想" cancelBlock:^{
            [selfWeak deleteTalkInfo];
        } destructiveBlock:^{
        }] show] ;
    };
    headerView.SetTopBlock = ^(BOOL isTop) {
        selfWeak.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        NSString *sure;
        if (isTop) {
            sure = @"取消置顶";
        }else{
            sure = @"置顶";
        }
        
        [[YJAnswerAlertView alertWithTitle:@"提示" normalMsg:[NSString stringWithFormat:@"是否%@该组讨论？",sure] highLightMsg:@"" cancelTitle:sure destructiveTitle:@"我再想想" cancelBlock:^{
            [selfWeak setHeaderTop:isTop];
        } destructiveBlock:^{
        }] show] ;
    };
    headerView.FoldBlock = ^{
        if (selfWeak.chatBox) {
            [selfWeak LGTChatBoxDidRemoved];
        }else{
            model.isFold = !model.isFold;
            [selfWeak reloadData];
        }
    };
    headerView.MsgClickBlock = ^{
        if (selfWeak.chatBox) {
            [selfWeak LGTChatBoxDidRemoved];
        }
    };
    headerView.AllContentBlock = ^{
        model.isAllContent =  !model.isAllContent;
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
    if (self.chatBox) {
        [self LGTChatBoxDidRemoved];
    }else{
        self.isCommentSelf = NO;
        LGTTalkQuesModel *quesModel = model.CommentList[indexPath.row];
        if (![quesModel.UserID isEqualToString:[LGTalkManager defaultManager].userID]) {
            if (!self.chatBox) {
                self.chatBox = [[LGTChatBox alloc] initWithFrame:CGRectMake(0, self.service.ownController.view.height-HEIGHT_TABBAR, LGT_ScreenWidth, HEIGHT_TABBAR)];
                self.chatBox.maxVisibleLine = 3;
                self.chatBox.delegate = self;
                self.chatBox.ownController = self.service.ownController;
                [self.service.ownController.view addSubview: self.chatBox];
            }
             self.chatBox.currentMsg = [self.currentMsgDic objectForKey:[NSString stringWithFormat:@"%li-%li",self.currentIndexPath.section,self.currentIndexPath.row]];
            self.chatBox.placehold = [NSString stringWithFormat:@"回复%@:",quesModel.UserName];
            self.currentMsgKey = [NSString stringWithFormat:@"%@-%@-%@",[LGTalkManager defaultManager].userID,quesModel.UserID,quesModel.CreateTime];
            self.chatBox.currentMsg = [self.currentMsgDic objectForKey:self.currentMsgKey];
            self.chatBox.currentImgs = [self.currentImgsDic objectForKey:self.currentMsgKey];
        }else{
            WeakSelf;
            [[YJAnswerAlertView alertWithTitle:@"提示" normalMsg:@"是否删除该条回复？" highLightMsg:@"" cancelTitle:@"删除" destructiveTitle:@"我再想想" cancelBlock:^{
                [selfWeak deleteReplyInfo];
            } destructiveBlock:^{
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            }] show] ;
        }
        
    }
}
@end
