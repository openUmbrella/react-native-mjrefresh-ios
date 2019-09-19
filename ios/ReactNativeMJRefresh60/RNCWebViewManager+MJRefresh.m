//
//  RCTWebViewManager+MJRefresh.m
//  ReactNativeMJRefresh
//
//  Created by jeff.Li on 2019/9/11.
//  Copyright © 2019 opu. All rights reserved.
//

#import "RNCWebViewManager+MJRefresh.h"

@implementation RNCWebViewManager (MJRefresh)

#pragma mark - 新增暴露的属性

RCT_EXPORT_VIEW_PROPERTY(enableMJRefresh, BOOL)
RCT_EXPORT_VIEW_PROPERTY(mjRefreshing, BOOL)
RCT_EXPORT_VIEW_PROPERTY(mjHeaderStyle, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(onMJRefresh, RCTBubblingEventBlock)

@end
