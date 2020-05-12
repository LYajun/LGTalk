//
//  YJNetMonitoring.m
//  YJNetManagerDemo
//
//  Created by 刘亚军 on 2019/3/18.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "YJNetMonitoring.h"
#import <Reachability/Reachability.h>


#define kYJNetMonitoringUrlToCheckNetStatus @"http://www.stkouyu.com/"
@interface YJNetMonitoring ()
@property (nonatomic) Reachability *hostReachability;
@end
@implementation YJNetMonitoring
+ (YJNetMonitoring *)shareMonitoring{
    static YJNetMonitoring * macro = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        macro = [[YJNetMonitoring alloc]init];
    });
    return macro;
}
- (void)startNetMonitoring{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.hostReachability = [Reachability reachabilityForInternetConnection];
    [self.hostReachability startNotifier];
    [self updateInterfaceWithReachability:self.hostReachability];
}
- (void)stopNetMonitoring{
    [self.hostReachability stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}
- (void) reachabilityChanged:(NSNotification *)note{
    Reachability* curReach = [note object];
    if (![curReach isKindOfClass:[Reachability class]]) {
        return;
    }
    [self updateInterfaceWithReachability:curReach];
}
- (void)updateInterfaceWithReachability:(Reachability *)reachability{
    if (reachability == self.hostReachability){
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
        switch (netStatus){
            case NotReachable: {
                self.netStatus = YJNetMonitoringStatusNotReachable;
                NSLog(@"没有网络！");
                break;
            }
            case ReachableViaWWAN: {
                self.netStatus = YJNetMonitoringStatusReachableViaWWAN;
                NSLog(@"4G/3G");
                break;
            }
            case ReachableViaWiFi: {
                self.netStatus = YJNetMonitoringStatusReachableViaWiFi;
                NSLog(@"WiFi");
                break;
            }
        }
    }
}
- (void)checkNetCanUseWithComplete:(void (^)(void))complete{
    NSString *urlString = kYJNetMonitoringUrlToCheckNetStatus;
    NSURL *requestUrl = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl];
    request.timeoutInterval = 8;
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self) weakSelf = self;
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            weakSelf.networkCanUseState = 0;
            if (complete) {
                complete();
            }
            NSLog(@"手机无法访问互联网");
        }else{
            NSString* result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            //解析html页面
            NSString *htmlString = [weakSelf filterHTML:result];
            //除掉换行符
            NSString *resultString = [htmlString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            if ([resultString containsString:@"声通"]) {
                weakSelf.networkCanUseState = 1;
                NSLog(@"手机所连接的网络是可以访问互联网的");
            }else {
                weakSelf.networkCanUseState = 2;
                NSLog(@"手机无法访问互联网");
            }
            if (complete) {
                complete();
            }
        }
    }] resume];
}

- (NSString *)filterHTML:(NSString *)html {
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:html];
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    return html;
}

@end
