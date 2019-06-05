# LGTalk
在线讨论模块方便学生和教师在作业前、中、后期都可就作业相关问题进行互动交流

<div align="left">
<img src="https://github.com/LYajun/LGTalk/blob/master/Assets/Shot1.png" width ="375" height ="812" >
<img src="https://github.com/LYajun/LGTalk/blob/master/Assets/Shot2.png" width ="375" height ="812" >
 </div>
 
## 使用方式

1、集成:

```
pod 'LGTalk'
```

2、配置

```objective-c

/** 服务器地址（登录的服务器设置地址） */
@property (nonatomic,copy) NSString *apiUrl;
/** 用户ID */
@property (nonatomic,copy) NSString *userID;
/** 用户名 */
@property (nonatomic,copy) NSString *userName;
/** 用户类型 */
@property (nonatomic,assign) NSInteger userType;
/** 用户头像路径 */
@property (nonatomic,copy) NSString *photoPath;
/** 学校ID */
@property (nonatomic,copy) NSString *schoolID;

/** 任务ID */
@property (nonatomic,copy) NSString *assignmentID;
/** 任务名 */
@property (nonatomic,copy) NSString *assignmentName;
/** 资料ID */
@property (nonatomic,copy) NSString *resID;
/** 资料名 */
@property (nonatomic,copy) NSString *resName;
/** 教师ID */
@property (nonatomic,copy) NSString *teacherID;
/** 教师名 */
@property (nonatomic,copy) NSString *teachertName;
/** 学科ID */
@property (nonatomic,copy) NSString *subjectID;
/** 学科名 */
@property (nonatomic,copy) NSString *subjectName;
/** 系统ID */
@property (nonatomic,copy) NSString *systemID;

```

3、使用

```objective-c

[LGTalkManager defaultManager].apiUrl = @"http://192.168.3.158:10103";    
[LGTalkManager defaultManager].userID = @"zxstu55";
[LGTalkManager defaultManager].userName = @"王玉宁";
[LGTalkManager defaultManager].userType = 2;
[LGTalkManager defaultManager].photoPath = @"http://192.168.129.130:10101/lgftp/UserInfo/Photo/Default/Nopic201.jpg";
[LGTalkManager defaultManager].schoolID = @"S0-0217-1FDC";
    
[LGTalkManager defaultManager].assignmentID = @"KHZYRW-zengruiyan1-0000000000000000000000000000006-8c569e92-4452-41f6-939c-3cfab41a559c";
[LGTalkManager defaultManager].resID = @"P20190305183838351968";
[LGTalkManager defaultManager].resName = @"测试作业";
    
[[LGTalkManager defaultManager] presentKnowledgeControllerBy:self];

```