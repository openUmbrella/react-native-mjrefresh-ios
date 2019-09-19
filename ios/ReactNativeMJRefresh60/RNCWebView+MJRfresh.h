//
//  RCTWebView+MJRfresh.h
//  ReactNativeMJRefresh
//
//  Created by jeff.Li on 2019/9/11.
//  Copyright © 2019 opu. All rights reserved.
//


#if __has_include(<react-native-webview/RNCWebView.h>)
#import <react-native-webview/RNCWebView.h>
#elif __has_include("RNCWebView.h")
#import "RNCWebView.h"
#else
#import "react-native-webview/RNCWebView.h"
#endif



NS_ASSUME_NONNULL_BEGIN

@interface RNCWebView (MJRfresh)

// 下拉刷新
@property (nonatomic, assign) BOOL enableMJRefresh;

@property (nonatomic, assign) BOOL mjRefreshing;

@property (nonatomic, strong) NSDictionary *mjHeaderStyle;

@property (nonatomic, copy) RCTBubblingEventBlock onMJRefresh;


@end

NS_ASSUME_NONNULL_END
