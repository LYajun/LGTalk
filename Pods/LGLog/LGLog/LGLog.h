//
//  LGLog.h
//  LGLogDemo
//
//  Created by 刘亚军 on 2018/3/29.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGLogManager.h"

#define LGLogError(...) DDLogError(@"%@\n",__VA_ARGS__)
#define LGLogWarn(...)  DDLogWarn(@"%@\n",__VA_ARGS__)
#define LGLogInfo(...)  DDLogInfo(@"%@\n",__VA_ARGS__)
#define LGLogDebug(...) DDLogDebug(@"%@\n",__VA_ARGS__)
