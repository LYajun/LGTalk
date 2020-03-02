//
//  UIControl+YJ.m
//  YJExtensionsDemo
//
//  Created by 刘亚军 on 2019/10/15.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "UIControl+YJ.h"
#import <objc/runtime.h>


static char * const yj_eventIntervalKey = "yj_eventIntervalKey";
static char * const yj_eventUnavailableKey = "eventUnavailableKey";

@interface UIControl ()
@property (nonatomic, assign) BOOL eventUnavailable;
@end
@implementation UIControl (YJ)
+ (void)load{
    Method method = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method yj_method = class_getInstanceMethod(self, @selector(yj_sendAction:to:forEvent:));
    method_exchangeImplementations(method, yj_method);
}
- (void)yj_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    if (self.yj_eventInterval == 0) {
        [self yj_sendAction:action to:target forEvent:event];
    }else{
        if (self.eventUnavailable == NO) {
            self.eventUnavailable = YES;
            [self yj_sendAction:action to:target forEvent:event];
            [self performSelector:@selector(setEventUnavailable:) withObject:@(NO) afterDelay:self.yj_eventInterval];
        }
    }
}

- (NSTimeInterval)yj_eventInterval{
    return [objc_getAssociatedObject(self, yj_eventIntervalKey) doubleValue];
}
- (void)setYj_eventInterval:(NSTimeInterval)yj_eventInterval{
    objc_setAssociatedObject(self, yj_eventIntervalKey, @(yj_eventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)eventUnavailable{
    return [objc_getAssociatedObject(self, yj_eventUnavailableKey) boolValue];
}
- (void)setEventUnavailable:(BOOL)eventUnavailable{
     objc_setAssociatedObject(self, yj_eventUnavailableKey, @(eventUnavailable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
