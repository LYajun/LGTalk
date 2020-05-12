# LGLog
基于CocoaLumberjack的日志管理工具，包含日志分类打印，保存及定期同步服务器

## 使用方式

1、集成:

```
pod 'LGLog'
```
2、配置

```
/** 开启日志文件系统, 默认日志文件刷新频率为1周 */
- (void)startFileLogSystem;

/**
 以指定日志文件保存路径开启日志文件系统

 @param direct 日志文件保存路径
 @param freshLogFrequency 日志刷新频率
 */
- (void)startFileLogSystemWithDirectory:(NSString *)direct
                      freshLogFrequency:(LGLogFrequency) freshLogFrequency;
```

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[LGLogManager shareInstence] startFileLogSystem];
    return YES;
}

```
3、使用

```objective-c
LGLogError(@"错误信息")
LGLogWarn(@"警告信息")
LGLogInfo(@"普通信息")
LGLogDebug(@"调试信息")

```
4、样例

```
[ [ERROR]-> 2018-03-30 14:06:16 ] 
位置: 
fileName:ViewController
function:-[ViewController viewDidLoad]
line:20 
信息:错误信息
[ [ERROR]->  2018-03-30 14:06:16 ]
```
```
[ [WARN]--> 2018-03-30 14:06:16 ] 
位置: 
fileName:ViewController
function:-[ViewController viewDidLoad]
line:21 
信息:警告信息
[ [WARN]-->  2018-03-30 14:06:16 ]
```