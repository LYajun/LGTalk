//
//  ViewController.m
//  LGTalkDemo
//
//  Created by 刘亚军 on 2019/3/6.
//  Copyright © 2019 刘亚军. All rights reserved.
// 192.168.3.158:10178

#import "ViewController.h"
#import "LGTalkManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)talk:(UIButton *)sender {
    [LGTalkManager defaultManager].apiUrl = @"http://192.168.129.129:10102";
//    [LGTalkManager defaultManager].homeTitle = @"zaixain";
//    [LGTalkManager defaultManager].forbidAddTalk = YES;
    [LGTalkManager defaultManager].userID = @"bkstu34";
    [LGTalkManager defaultManager].userName = @"冯永杰";
    [LGTalkManager defaultManager].userType = 2;
    [LGTalkManager defaultManager].photoPath = @"http://192.168.129.8:10101/lgftp/UserInfo/Photo/Default/Nopic.jpg";
    [LGTalkManager defaultManager].schoolID = @"S15-410-3086";
    
    [LGTalkManager defaultManager].assignmentID = @"YXRW-tc001-000000000000000000000000000000000000004-803d2219-2908-49c3-bdec-41973e1adc41";
    [LGTalkManager defaultManager].assignmentName = @"教案1";
    [LGTalkManager defaultManager].resName = @"The Role of Government";
    [LGTalkManager defaultManager].resID = @"CFBE31191CIB100058e";
    
    [LGTalkManager defaultManager].systemID = @"510";
    [LGTalkManager defaultManager].subjectID = @"S2-English";
    [LGTalkManager defaultManager].subjectName = @"英语";
    [LGTalkManager defaultManager].teacherID = @"zengruiyan1";
    [LGTalkManager defaultManager].teachertName = @"曾老师";
    [LGTalkManager defaultManager].mutiFilterUrl =  @"http://192.168.129.129:10103/WS_TBookEditor/WebService.asmx/WS_Get_AllTeachMaterial?teachMaterialID=92b807b6-ec15-4b31-9fce-a4051829ed1e";
    
    [[LGTalkManager defaultManager] presentKnowledgeControllerBy:self];
}

@end
