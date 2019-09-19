//
//  RCTScrollViewManager+MJRefresh.m
//  ReactNativeMJRefresh
//
//  Created by jeff.Li on 2019/9/11.
//  Copyright © 2019 opu. All rights reserved.
//

#import "RCTScrollViewManager+MJRefresh.h"

@implementation RCTScrollViewManager (MJRefresh)

RCT_EXPORT_VIEW_PROPERTY(enableMJRefresh, BOOL)
RCT_EXPORT_VIEW_PROPERTY(mjRefreshing, BOOL)
RCT_EXPORT_VIEW_PROPERTY(mjHeaderStyle, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(onMJRefresh, RCTBubblingEventBlock)

RCT_EXPORT_VIEW_PROPERTY(enableMJLoadMore, BOOL)
RCT_EXPORT_VIEW_PROPERTY(mjLoadingMore, BOOL)
RCT_EXPORT_VIEW_PROPERTY(mjLoadAll, BOOL)
RCT_EXPORT_VIEW_PROPERTY(mjFooterStyle, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(onMJLoadMore, RCTBubblingEventBlock)

@end
