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
    [LGTalkManager defaultManager].apiUrl = @"http://192.168.3.158:10103";
//    [LGTalkManager defaultManager].homeTitle = @"zaixain";
//    [LGTalkManager defaultManager].forbidAddTalk = YES;
    [LGTalkManager defaultManager].userID = @"zxstu55";
    [LGTalkManager defaultManager].userName = @"王玉宁";
    [LGTalkManager defaultManager].userType = 2;
    [LGTalkManager defaultManager].photoPath = @"http://192.168.129.130:10101/lgftp/UserInfo/Photo/Default/Nopic201.jpg";
    [LGTalkManager defaultManager].schoolID = @"S0-0217-1FDC";
    
    [LGTalkManager defaultManager].assignmentID = @"KHZYRW-zengruiyan1-0000000000000000000000000000006-8c569e92-4452-41f6-939c-3cfab41a559c";
    [LGTalkManager defaultManager].resID = @"P20190305183838351968";
    [LGTalkManager defaultManager].resName = @"测试作业";
    
    [[LGTalkManager defaultManager] presentKnowledgeControllerBy:self];
}

@end
